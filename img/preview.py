# ============================================================================
#  preview.py —— 不上板也能看画面：把 VGA 会显示的内容离线渲染成 PNG
#
#  数据来源和上板完全一致：
#    map.coe            120x120 个格子的地形编号（tile_id）
#    *_16bit.coe        各图层的贴图 ROM（imgconverter.py 生成）
#    pysrc/font5x7.py   HUD 字库（和 RTL 的 font5x7.v 同一份数据）
#  渲染逻辑照抄 vga.v + hud.v：
#    · 左边 600x600 是玩区（120x120 格 x 5px），右边 200x200 是 HUD
#    · 每格 5x5 像素；背景贴图是“20x20 的图样平铺”，所以取 img_x % 20 / img_y % 20
#    · tile_id 1/2/3 -> 砖/钢/河，4 -> 树林（最高层，只有不透明像素才盖住上层），
#      5 -> 基地，只在该 20x20 的鹰包围盒里（vga.v 的 HQ_X0/HQ_Y0 = 290/565）画不透明像素
#    · 图层优先级：HUD > 树林 > 爆炸 > 炮弹 > 坦克 > 地形
#    · 12 位色 word[11:0] = {R,G,B}，最高位是 alpha
#    · 坦克：玩家用 tank，三个敌人按兵种用 tank_fast / tank_power / tank_armor
#    · HUD：面板底色 / 2px 分界线 / 5x7 字体放大 2 倍（字距 16px）/ 敌人图标用坦克贴图
#      （坐标和 hud.v 里的行表一一对应；改排版时两边一起改）
#
#  用法：
#    python img\preview.py              # -> img/preview.png（当前的正确位序）
#    python img\preview.py --reversed   # -> img/preview_reversed.png
#                                       #    用旧 XDC 的“每组 4 位倒序”渲染，
#                                       #    复现“整屏黄绿”的那个 bug，方便对照
#    python img\preview.py --hq-destroyed   # -> img/preview_destroyed.png
#                                       #    基地被炮弹打爆后的画面（白旗 + GAME OVER）
#    python img\preview.py --victory        # -> img/preview_victory.png
#                                       #    敌人全灭的结算画面
#    python img\preview.py --explosion      # -> img/preview_explosion.png
#                                       #    中间那辆敌人刚被击毁（第 1 帧亮爆团）
# ============================================================================
import os
import re
import sys

from PIL import Image

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'pysrc'))
from font5x7 import glyph_rows            # noqa: E402  HUD 字库的唯一数据源

MAP_W, MAP_H, TILE = 120, 120, 5
PANEL_X = 600                             # 侧栏起点（hud.v 的 X0）
W, H = 800, 600                           # 整个画面
PLAY_W, PLAY_H = MAP_W * TILE, MAP_H * TILE   # 600 x 600 玩区
HQ_X0, HQ_Y0 = 290, 565                   # 和 vga.v 的 localparam 保持一致
PLAYER_X, PLAYER_Y = 300, 300             # player.v 复位值 = WIDTH/2 HEIGHT/2
BULLET_X, BULLET_Y = 305, 260             # 演示用：坦克正上方一发

# 敌方坦克：和 enemy_ctrl.v 的出生点/初始朝向/兵种一致（都在第 0~1 块，朝下 = dir 1）
#   (x, y, dir, 贴图名)：左边快速 / 中间火力 / 右边装甲
ENEMIES = ((40,  10, 1, 'tank_fast'),
           (300, 10, 1, 'tank_power'),
           (560, 10, 1, 'tank_armor'))

# 爆炸演示：中间那辆（火力）刚被击毁 -> 在它的 20x20 位置画第 1 帧（亮爆团）
BOOM_X, BOOM_Y = 300, 10

# ---------------- HUD（和 hud.v 的行表一一对应）----------------
HUD_BG    = 0x113
HUD_DIV   = 0x8CF
HUD_TITLE = 0xFE0
HUD_LABEL = 0xADF
HUD_VALUE = 0xFFF
HUD_HINT  = 0x789
HUD_OVER  = 0xB11
HUD_WIN   = 0x1B1

IMG_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(IMG_DIR)


def read_coe(name):
    """读出 .coe 里的 memory_initialization_vector"""
    with open(os.path.join(ROOT, name), 'r') as f:
        text = f.read()
    vector = text.split('vector')[1]
    return [int(v, 16) for v in re.findall(r'([0-9A-Fa-f]+)\s*[,;]', vector)]


def nibbles_reversed(word):
    """模拟旧 constr.xdc：每个通道的 4 位整体倒序（0b1011 -> 0b1101）"""
    def rev4(n):
        return ((n & 1) << 3) | ((n & 2) << 1) | ((n & 4) >> 1) | ((n & 8) >> 3)

    return (word & 0x8000) | (rev4((word >> 8) & 0xF) << 8) \
           | (rev4((word >> 4) & 0xF) << 4) | rev4(word & 0xF)


def rgb_of(word):
    return ((word >> 8) & 0xF) * 17, ((word >> 4) & 0xF) * 17, (word & 0xF) * 17


def rgb12(v):
    """12 位色 0xRGB -> 8 位 RGB（和 vga.v 的 {R,G,B} 一致）"""
    return (((v >> 8) & 0xF) * 17, ((v >> 4) & 0xF) * 17, (v & 0xF) * 17)


def draw_text(pixels, x0, y0, text, color):
    """照抄 hud.v 的文字排版：字模 5x7 放大 2 倍、字距 16px、行高 14px"""
    c = rgb12(color)
    for ci, ch in enumerate(text):
        rows = glyph_rows(ch)
        for gy in range(7):
            for gx in range(5):
                if rows[gy] & (1 << (4 - gx)):
                    for sy in range(2):
                        for sx in range(2):
                            xx = x0 + ci * 16 + gx * 2 + sx
                            yy = y0 + gy * 2 + sy
                            if 0 <= xx < W and 0 <= yy < H:
                                pixels[xx, yy] = c


def draw_tank(pixels, tex, name, x0, y0, d):
    """把一个 20x20 的坦克贴图按朝向画到画面上（透明的像素不画）"""
    for dy in range(20):
        for dx in range(20):
            w = tex[name][tank_addr(dx, dy, d)]
            if w & 0x8000:
                xx, yy = x0 + dx, y0 + dy
                if 0 <= xx < W and 0 <= yy < H:
                    pixels[xx, yy] = rgb_of(w)


def tank_addr(px, py, d):
    """照抄 vga.v 的 tank_addr：源图 20x20 朝上，按朝向旋转取点"""
    row, col = py * 20, px * 20
    if d == 0:
        return row + px              # 上：原图
    if d == 1:
        return 399 - row - px        # 下：旋转 180°
    if d == 2:
        return col + py              # 左：逆时针 90°
    return 380 - col + py            # 右：顺时针 90°


def enemy_tint(word):
    """（已废弃）旧版把黄坦克换成灰坦克的规则，保留只是为了让老脚本能 import"""
    tints = {0xFD3: 0xCCC, 0xA60: 0x777, 0x310: 0x310}
    return (word & 0xF000) | tints.get(word & 0xFFF, word & 0xFFF)


def main():
    reversed_bits = '--reversed' in sys.argv
    hq_destroyed  = '--hq-destroyed' in sys.argv
    victory       = '--victory' in sys.argv
    explosion     = '--explosion' in sys.argv
    game_over     = hq_destroyed            # 基地没了就是 GAME OVER，HUD 一起画

    tile_map = read_coe('map.coe')
    # map.coe 是 14400 格有效数据 + 补齐到 BRAM 深度 19200 个 0
    assert len(tile_map) == 19200, 'map.coe 尺寸不对（应为 19200 = 14400 + 填充）'
    names = ('brick', 'steel', 'river', 'woods', 'tank', 'bullet',
             'headquarters', 'headquarters_destroyed',
             'tank_fast', 'tank_power', 'tank_armor',
             'tank_destroyed1', 'tank_destroyed2')
    tex = {n: read_coe(n + '_16bit.coe') for n in names}
    bg_tex = {1: 'brick', 2: 'steel', 3: 'river'}

    # 爆炸演示：被击毁那辆车不再画（alive=0），位置上换成爆炸贴图的第 1 帧
    enemies = tuple(e for e in ENEMIES if not (explosion and e[0] == BOOM_X))
    boom = explosion

    # 基地在“金鹰 / 白旗”之间二选一（照抄 vga.v 的 hq_destroyed mux）
    hq_tex = 'headquarters_destroyed' if hq_destroyed else 'headquarters'

    if reversed_bits:
        tex = {n: [nibbles_reversed(w) for w in v] for n, v in tex.items()}

    img = Image.new('RGB', (W, H))
    pixels = img.load()
    used = {}

    for y in range(H):
        row_base = (y // TILE) * MAP_W
        tex_row = (y % 20) * 20
        for x in range(PLAY_W):
            tile_id = tile_map[row_base + x // TILE]
            tex_idx = tex_row + (x % 20)

            if tile_id in bg_tex:
                bg = rgb_of(tex[bg_tex[tile_id]][tex_idx])
            elif tile_id == 4:
                # vga.v 里 4 号格的 bg_color 就是 woods_pixel[11:0]
                # （透明像素 word = 0x0000，自然就是黑）
                bg = rgb_of(tex['woods'][tex_idx])
            elif tile_id == 5:
                dx, dy = x - HQ_X0, y - HQ_Y0
                if 0 <= dx < 20 and 0 <= dy < 20:
                    w = tex[hq_tex][dy * 20 + dx]
                    bg = rgb_of(w) if (w & 0x8000) else (0, 0, 0)
                else:
                    bg = (0, 0, 0)
            else:
                bg = (0, 0, 0)

            # 树林最高层：只有不透明的叶子才盖住下面的图层
            if tile_id == 4 and (tex['woods'][tex_idx] & 0x8000):
                color = bg
            elif boom and BOOM_X <= x < BOOM_X + 20 and BOOM_Y <= y < BOOM_Y + 20:
                # 爆炸压在炮弹和坦克上面（vga.v 的图层顺序一样），不旋转
                w = tex['tank_destroyed1'][(y - BOOM_Y) * 20 + (x - BOOM_X)]
                color = rgb_of(w) if (w & 0x8000) else bg
            elif BULLET_X <= x < BULLET_X + 10 and BULLET_Y <= y < BULLET_Y + 10:
                w = tex['bullet'][(y - BULLET_Y) * 10 + (x - BULLET_X)]
                color = rgb_of(w) if (w & 0x8000) else bg
            elif PLAYER_X <= x < PLAYER_X + 20 and PLAYER_Y <= y < PLAYER_Y + 20:
                w = tex['tank'][(y - PLAYER_Y) * 20 + (x - PLAYER_X)]
                color = rgb_of(w) if (w & 0x8000) else bg
            else:
                # 敌人坦克：玩家优先画，所以放在玩家之后判断
                color = bg
                for ex, ey, ed, tn in enemies:
                    if ex <= x < ex + 20 and ey <= y < ey + 20:
                        w = tex[tn][tank_addr(x - ex, y - ey, ed)]
                        color = rgb_of(w) if (w & 0x8000) else bg
                        break

            pixels[x, y] = color
            used[color] = used.get(color, 0) + 1

    # ---------------- HUD：右侧 200px 信息栏（和 hud.v 逐行对应）----------------
    # 演示状态：击杀两辆（600 分）、还剩 3 条命、关卡 1
    # 爆炸图：中间那辆被击毁（+200），左右两辆还在
    score100    = 3 if victory else 6
    lives       = 3
    enemies_on  = [False, False, False] if victory else [True, True, True]
    if explosion:
        score100   = 2
        enemies_on = [True, False, True]

    for y in range(H):
        for x in range(PANEL_X, W):
            pixels[x, y] = rgb12(HUD_BG)
    for y in range(H):                       # 左侧 2px 分界线
        for x in range(PANEL_X, PANEL_X + 2):
            pixels[x, y] = rgb12(HUD_DIV)

    def hud_text(y0, text, color, x_off=12):
        draw_text(pixels, PANEL_X + x_off, y0, text, color)

    hud_text(16,  'BATTLE CITY', HUD_TITLE)
    hud_text(44,  'LEVEL 1',     HUD_LABEL)
    hud_text(76,  'ENEMY',       HUD_LABEL)
    # 敌人图标：位置/兵种和 hud.v 的 g_icon 一致（x = 12 + i*28, y = 100）
    icon_names = ('tank_fast', 'tank_power', 'tank_armor')
    for i, tn in enumerate(icon_names):
        if enemies_on[i]:
            draw_tank(pixels, tex, tn, PANEL_X + 12 + i * 28, 100, 1)
    hud_text(132, 'SCORE',       HUD_LABEL)
    hud_text(160, '%d%d00' % (score100 // 10, score100 % 10), HUD_VALUE)
    hud_text(192, 'LIVES',       HUD_LABEL)
    hud_text(220, str(lives),    HUD_VALUE)
    hud_text(556, 'BTNC=FIRE',   HUD_HINT)

    if game_over or victory:
        for y in range(300, 314):            # 横幅底色（板上会闪，这里画“亮”的那一帧）
            for x in range(PANEL_X + 2, W):
                pixels[x, y] = rgb12(HUD_OVER if game_over else HUD_WIN)
        if game_over:
            hud_text(300, 'GAME OVER', HUD_VALUE, 28)
        else:
            hud_text(300, 'VICTORY', HUD_VALUE, 40)

    for y in range(H):
        for x in range(W):
            c = pixels[x, y]
            used[c] = used.get(c, 0) + 1

    if hq_destroyed:
        name = 'preview_destroyed.png'
    elif victory:
        name = 'preview_victory.png'
    elif explosion:
        name = 'preview_explosion.png'
    elif reversed_bits:
        name = 'preview_reversed.png'
    else:
        name = 'preview.png'
    out = os.path.join(IMG_DIR, name)
    img.save(out)

    mode = 'OLD pin order (4-bit groups reversed -> the yellow-green bug)' \
        if reversed_bits else 'current pin order'
    if hq_destroyed:
        mode += ', HQ destroyed (white flag + GAME OVER)'
    if victory:
        mode += ', victory banner'
    if explosion:
        mode += ', tank explosion (frame 1 of 2)'
    print('preview (%s) -> %s' % (mode, out))
    print('playfield %dx%d + %dpx HUD panel' % (PLAY_W, PLAY_H, W - PANEL_X))
    print('color area top8 (actual colors after 12-bit quantization):')
    for color, area in sorted(used.items(), key=lambda kv: -kv[1])[:8]:
        print('  #%02X%02X%02X  %6d px' % (color[0], color[1], color[2], area))


if __name__ == '__main__':
    main()
