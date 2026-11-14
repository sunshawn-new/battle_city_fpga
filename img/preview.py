# ============================================================================
#  preview.py —— 不上板也能看画面：把 VGA 会显示的内容离线渲染成 PNG
#
#  数据来源和上板完全一致：
#    map.coe            160x120 个格子的地形编号（tile_id）
#    *_16bit.coe        各图层的贴图 ROM（imgconverter.py 生成）
#  渲染逻辑照抄 vga.v：
#    · 每格 5x5 像素；背景贴图是“20x20 的图样平铺”，所以取 img_x % 20 / img_y % 20
#    · tile_id 1/2/3 -> 砖/钢/河，4 -> 树林（最高层，只有不透明像素才盖住上层），
#      5 -> 基地，只在该 20x20 的鹰包围盒里（vga.v 的 HQ_X0/HQ_Y0 = 390/565）画不透明像素
#    · 图层优先级：树林 > 炮弹 > 坦克 > 地形
#    · 12 位色 word[11:0] = {R,G,B}，最高位是 alpha
#    · 坦克：玩家在原色、敌人在出生点用 enemy_tint() 换成灰色（和 vga.v 一致）
#
#  用法：
#    python img\preview.py              # -> img/preview.png（当前的正确位序）
#    python img\preview.py --reversed   # -> img/preview_reversed.png
#                                       #    用旧 XDC 的“每组 4 位倒序”渲染，
#                                       #    复现“整屏黄绿”的那个 bug，方便对照
# ============================================================================
import os
import re
import sys

from PIL import Image

MAP_W, MAP_H, TILE = 160, 120, 5
W, H = MAP_W * TILE, MAP_H * TILE        # 800 x 600
HQ_X0, HQ_Y0 = 390, 565                  # 和 vga.v 的 localparam 保持一致
PLAYER_X, PLAYER_Y = 400, 300            # player.v 复位值 = WIDTH/2 HEIGHT/2
BULLET_X, BULLET_Y = 405, 260            # 演示用：坦克正上方一发

# 敌方坦克：和 enemy_ctrl.v 的出生点/初始朝向一致（都在第 2~5 行，朝下 = dir 1）
ENEMIES = ((40, 10, 1), (380, 10, 1), (740, 10, 1))

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
    """照抄 vga.v 的 enemy_tint：黄坦克 -> 灰坦克（只改低 12 位，保留 alpha）"""
    tints = {0xFD3: 0xCCC, 0xA60: 0x777, 0x310: 0x310}
    return (word & 0xF000) | tints.get(word & 0xFFF, word & 0xFFF)


def main():
    reversed_bits = '--reversed' in sys.argv

    tile_map = read_coe('map.coe')
    assert len(tile_map) == MAP_W * MAP_H, 'map.coe 尺寸不对'
    names = ('brick', 'steel', 'river', 'woods', 'tank', 'headquarters', 'bullet')
    tex = {n: read_coe(n + '_16bit.coe') for n in names}
    bg_tex = {1: 'brick', 2: 'steel', 3: 'river'}

    # 敌人坦克 = tank 贴图换色（照抄 vga.v 的 enemy_tint）。
    # 必须在“4 位倒序”之前做：换色是对逻辑颜色做的，位序倒序发生在引脚上。
    tex['enemy_tank'] = [enemy_tint(w) for w in tex['tank']]

    if reversed_bits:
        tex = {n: [nibbles_reversed(w) for w in v] for n, v in tex.items()}

    img = Image.new('RGB', (W, H))
    pixels = img.load()
    used = {}

    for y in range(H):
        row_base = (y // TILE) * MAP_W
        tex_row = (y % 20) * 20
        for x in range(W):
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
                    w = tex['headquarters'][dy * 20 + dx]
                    bg = rgb_of(w) if (w & 0x8000) else (0, 0, 0)
                else:
                    bg = (0, 0, 0)
            else:
                bg = (0, 0, 0)

            # 树林最高层：只有不透明的叶子才盖住下面的图层
            if tile_id == 4 and (tex['woods'][tex_idx] & 0x8000):
                color = bg
            elif BULLET_X <= x < BULLET_X + 10 and BULLET_Y <= y < BULLET_Y + 10:
                w = tex['bullet'][(y - BULLET_Y) * 10 + (x - BULLET_X)]
                color = rgb_of(w) if (w & 0x8000) else bg
            elif PLAYER_X <= x < PLAYER_X + 20 and PLAYER_Y <= y < PLAYER_Y + 20:
                w = tex['tank'][(y - PLAYER_Y) * 20 + (x - PLAYER_X)]
                color = rgb_of(w) if (w & 0x8000) else bg
            else:
                # 敌人坦克（灰色）：玩家优先画，所以放在玩家之后判断
                color = bg
                for ex, ey, ed in ENEMIES:
                    if ex <= x < ex + 20 and ey <= y < ey + 20:
                        w = tex['enemy_tank'][tank_addr(x - ex, y - ey, ed)]
                        color = rgb_of(w) if (w & 0x8000) else bg
                        break

            pixels[x, y] = color
            used[color] = used.get(color, 0) + 1

    out = os.path.join(IMG_DIR, 'preview_reversed.png' if reversed_bits else 'preview.png')
    img.save(out)

    mode = 'OLD pin order (4-bit groups reversed -> the yellow-green bug)' \
        if reversed_bits else 'current pin order'
    print('preview (%s) -> %s' % (mode, out))
    print('color area top8 (actual colors after 12-bit quantization):')
    for color, area in sorted(used.items(), key=lambda kv: -kv[1])[:8]:
        print('  #%02X%02X%02X  %6d px' % (color[0], color[1], color[2], area))


if __name__ == '__main__':
    main()
