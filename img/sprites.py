# ============================================================================
#  sprites.py —— ASCII 画稿 -> 贴图 PNG（敌人兵种 / 基地 / 爆炸）
#
#  为什么用 ASCII 画稿，而不是直接画 png：
#    20x20 的小图手绘很难对齐；改成字符网格后“某一行少点一个点”一眼就能看出来，
#    而且脚本自带硬校验（行数 / 行宽 / 字符），画歪了直接报错，不会悄悄生成错位图。
#
#  和 imgconverter.py 的分工（和已有的 brick/tank/... 完全一致）：
#    sprites.py       只负责几何，写出“哑色画稿 png”（角色色 = 黑/深灰/浅灰）
#    imgconverter.py  的 RECOLOR 才是上色表：角色色 -> 最终 12 位色
#    所以同一份几何换一组 RECOLOR 就能变成另一个兵种，图案和配色互不影响。
#    本脚本会反过来检查 RECOLOR：漏 key 会报错（否则 .coe 里会露出哑色），
#    顺带检查最终色是不是 17 的倍数（12 位量化只有 17 的倍数不掉色）。
#
#  用法：
#    python img\sprites.py       # 写 img\*.png + img\sprites.png（8 倍总览 + 1:1 实拍）
#    python img\imgconverter.py  # 再生成 *.coe（和以前一样）
# ============================================================================
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

# 同一目录下的上色表（imgconverter.py 现在有 __main__ 守卫，import 不会触发转换）
from imgconverter import RECOLOR

IMG_DIR = Path(__file__).resolve().parent

# 所有贴图都是 20x20：vga.v 的包围盒/地址算法（399 - row - px 这种）按 20 写死，
# 改这里必须同步改 RTL，别动。
SIZE = 20

# 画稿角色色（字符 -> png 里的 RGB）。只是“哑色标记”，给 RECOLOR 当 key 用；
# 屏幕上看到的颜色由 RECOLOR 决定，和这里的值无关。
BLACK = (0, 0, 0)          # 描边 / 轮廓
DARK = (64, 64, 64)        # 暗部
LIGHT = (160, 160, 160)    # 亮部
YELLOW = (255, 239, 71)    # 火焰黄（爆炸帧的爆心外焰）
ORANGE = (200, 76, 12)     # 火焰橙

PAL_HQ = {'k': BLACK, 'G': LIGHT, 'S': DARK}          # 基地鹰：描边/金身/铜暗部
PAL_HQ_DEAD = {'W': LIGHT, 'P': DARK, 'D': BLACK}     # 白旗：旗面/旗杆/碎石
PAL_TANK = {'a': BLACK, 'b': DARK, 'c': LIGHT}        # 三种敌人坦克共用 a/b/c
PAL_BOOM = {'W': LIGHT, 'Y': YELLOW, 'O': ORANGE}     # 爆炸：爆心/焰身/焰边


def rows_of(art):
    """三引号画稿 -> 行列表（strip/splitlines 顺带吃掉 CRLF 的 \\r）"""
    return art.strip().splitlines()


# ----------------------------------------------------------------------------
#  基地（存活）：金鹰
#    · 结构（自上而下）：头颈（第 2~4 行）-> 水平展开的双翼（第 5~11 行，
#      外缘按阶梯往内收，缩到 VGA 上还是“展翅”的剪影）-> 胸羽暗部（第 12~13
#      行，一个小 V 形）-> 腿爪（第 16~18 行）。
#    · 暗部只放在胸口和翼羽上：翼上原来画过对称的两块暗斑，8 倍图里活像一双
#      眼睛，整只鹰变成“脸”，所以改成中间一个 V，别再加成对暗斑。
#    · 描边用 #553300 而不是近黑：这个精灵的背景是纯黑，黑描边等于没有。
# ----------------------------------------------------------------------------
ART_HQ = '''
....................
....................
..........kk........
.........kGGk.......
.........kGGk.......
..kkkkkkkkGGkkkkkk..
.kGGGGGGGGGGGGGGGGk.
kGGGGGGGGGGGGGGGGGGk
kGGGGGGGGGGGGGGGGGGk
.kkGGGGGGGGGGGGGGkk.
..kkkGGGGGGGGGGkkk..
....kkGGGGGGGGkk....
.....kGGGSSGGGk.....
......kGGSSGGk......
......kGGGGGGk......
......kGGGGGGk......
.....kkGGGGGGkk.....
....kGGkkkkkkGGk....
....kGGk....kGGk....
....kkkk....kkkk....
'''

# ----------------------------------------------------------------------------
#  基地（被摧毁）：白旗 + 断杆 + 碎石
#    · 原版被打爆后基地就变成一面白虎旗，比画“废墟”更好认。
#    · 杆子立到第 15 行左右，下面几行是炸碎的基地残骸（碎石 + 一圈瓦砾）。
# ----------------------------------------------------------------------------
ART_HQ_DEAD = '''
....................
.........PP.........
.........PP.........
.WWWWWWWWPP.........
WWWWWWWWWPP.........
WWWPPWWWWPP.........
.WWPPWWWWPP.........
..WWWWWWWPP.........
...WWWWWWPP.........
.........PP.........
.........PP.........
.........PP.........
.........PP.........
.........PP.........
.........PP.........
...DD....PP....DD...
..DDDD..DPPD..DDDD..
..DDDDD.DPPD.DDDDD..
.DDD.DDDDPPDDDD.DDD.
DDDDDDDDDPPDDDDDDDDD
'''


# ----------------------------------------------------------------------------
#  三种敌人坦克：直接从玩家坦克 img/tank.png 的角色图派生（同一套“楔形车体 +
#  暗色炮盾”语言），所以四种坦克在 20px 下是一个家族：
#    · 车体 x4..15 的楔形轮廓、x9..15 的暗色炮塔/炮盾、中部 3x3 黑舱口，全部照抄
#      玩家坦克；只按兵种改三件事：履带宽度、炮管、暗部厚度。
#    · 履带紧贴车体：快速 3px（x1..3）/ 火力 4px（x0..3，同玩家）/
#      装甲 5px（x0..4，车体被挤到 x5..14）。最内侧一列恒为 a（暗缝），
#      第 3/7/12/16 行整条 a（履带齿），和玩家坦克的节奏完全对齐。
#    · 炮口朝上（本工程所有坦克/子弹都朝上，转向靠 RTL 旋转贴图）。
#    · 教训：自己另画“对称正视图”（圆车体 + 居中大暗块）在 20px 下会看成机器人/
#      电视机；玩家坦克之所以像坦克，靠的是尖头楔形剪影 + 偏右的暗色炮盾。
#  角色色（a/b/c）三张图含义一致，imgconverter.py 的 RECOLOR 只负责换颜色：
#    c = 车身/履带面   b = 炮管/炮塔/暗部   a = 描边/履带齿/舱口线
#  兵种差异（越往下越重）：
# ----------------------------------------------------------------------------
#  快速坦克（fast）：1px 细炮管（第 0~2 行，和玩家同宽但更长）+ 3px 窄履带
#    + 暗色炮盾右缘收 1px，车体看着最窄最轻，不透明 265/400（玩家 299/400）。
# ----------------------------------------------------------------------------
ART_FAST = '''
.........b..........
.........b..........
.........b..........
.aaa....cbb.....aaa.
.cca...ccbbbb...acc.
.cca.ccccbbbbb..acc.
.ccacccccbbbbb..acc.
.aaacccccbbbbbbcaaa.
.ccacccccbbbbbbcacc.
.ccaccccaaabbbbcacc.
.ccaccccaaabbbbcacc.
.ccaccccaaabbbbcacc.
.aaaccccccbbbbbcaaa.
.ccaccccccbbbbbcacc.
.ccaccccccbbbbbcacc.
.ccaccccccbbbbb.acc.
.aaa.cccccbbbb..aaa.
.cca..ccccbbbb..acc.
.cca...cccbb....acc.
.cca....ccb.....acc.
'''

# ----------------------------------------------------------------------------
#  火力坦克（power）：2px 炮管 + 4px 炮口制退器（第 1~2 行）+ 4px 履带（同玩家）
#    + 把玩家的黑舱口填成暗部（暗色炮盾连成一整块），不透明 306/400。
# ----------------------------------------------------------------------------
ART_POWER = '''
.........bb.........
........bbbb........
........bbbb........
aaaa....cbb.....aaaa
ccca...ccbbbb...accc
ccca.ccccbbbbb..accc
cccacccccbbbbb..accc
aaaacccccbbbbbbbaaaa
cccacccccbbbbbbbaccc
cccaccccbbbbbbbbaccc
cccaccccbbbbbbbbaccc
cccaccccbbbbbbbbaccc
aaaaccccccbbbbbbaaaa
cccaccccccbbbbbbaccc
cccaccccccbbbbbbaccc
cccaccccccbbbbb.accc
aaaa.cccccbbbb..aaaa
ccca..ccccbbbb..accc
ccca...cccbb....accc
ccca....ccb.....accc
'''

# ----------------------------------------------------------------------------
#  装甲坦克（armor）：5px 宽厚履带（车体被挤到 x5..14）+ 2px 炮管 + 6px 炮口
#    制退器，暗色炮盾再往左加宽 2px 连成一片重甲，不透明 326/400——四台里最满。
# ----------------------------------------------------------------------------
ART_ARMOR = '''
.........bb.........
.......bbbbbb.......
.......bbbbbb.......
aaaaa...cbb....aaaaa
cccca..ccbbbb..acccc
ccccaccccbbbbb.acccc
ccccaccccbbbbb.acccc
aaaaaccccbbbbbbaaaaa
ccccacccbbbbbbbacccc
ccccacccbbbbbbbacccc
ccccacccbbbbbbbacccc
ccccacccbbbbbbbacccc
aaaaacccbbbbbbbaaaaa
ccccacccbbbbbbbacccc
ccccacccbbbbbbbacccc
ccccacccccbbbbbacccc
aaaaacccccbbbb.aaaaa
cccca.ccccbbbb.acccc
cccca..cccbb...acccc
cccca...ccb....acccc
'''


# ----------------------------------------------------------------------------
#  坦克爆炸 帧1：命中瞬间
#    · 白核 + 黄焰 + 橙边，四向尖刺（第 2~4 / 15~17 行的孤立 O 是飞出的火星）。
#    · 20x20 铺满，视觉上比坦克大一圈，“打爆了”很明确。
# ----------------------------------------------------------------------------
ART_DESTROYED1 = '''
.........OO.........
........OYYO........
.....O..OYYO..O.....
....OYO.OYYO.OYO....
....OYYOOYYOOYYO....
...OYYYYYYYYYYYYO...
...OYYWWWWWWWWYYO...
..OYYWWWWWWWWWWYYO..
.OYYYWWWWWWWWWWYYYO.
OOYYYWWWWWWWWWWYYYOO
.OYYYWWWWWWWWWWYYYO.
..OYYWWWWWWWWWWYYO..
...OYYWWWWWWWWYYO...
...OYYYYYYYYYYYYO...
....OYYOOYYOOYYO....
....OYO.OYYO.OYO....
.....O..OYYO..O.....
........OYYO........
.........OO.........
....................
'''

# ----------------------------------------------------------------------------
#  坦克爆炸 帧2：扩散的余烬环
#    · 帧1 是“实心爆”，帧2 是炸开后的环，两帧交替（或 帧1 x2 -> 帧2 x1）
#      就有一个廉价但够用的爆炸动画；只占一张额外的 512 深 ROM。
# ----------------------------------------------------------------------------
ART_DESTROYED2 = '''
....................
....................
.........OO.........
........O..O........
......O..OO..O......
.....O.OO..OO.O.....
....O.OO....OO.O....
...O.OO......OO.O...
...OO..........OO...
..OO............OO..
...OO..........OO...
...O.OO......OO.O...
....O.OO....OO.O....
.....O.OO..OO.O.....
......O..OO..O......
........O..O........
.........OO.........
....................
....................
....................
'''


# 名字 = png 文件名 = imgconverter.TILES 的 key（三者必须一致，check() 会校）
# 三种敌人坦克都在这张表里：vga.v 每个兵种各有一个 512x16 的 ROM，
# 按 enemy_ctrl 的 e_type 选图，不再需要“玩家贴图 + enemy_tint() 换灰”。
SPRITES = {
    'headquarters':           (PAL_HQ, ART_HQ),
    'headquarters_destroyed': (PAL_HQ_DEAD, ART_HQ_DEAD),
    'tank_fast':              (PAL_TANK, ART_FAST),
    'tank_power':             (PAL_TANK, ART_POWER),
    'tank_armor':             (PAL_TANK, ART_ARMOR),
    'tank_destroyed1':        (PAL_BOOM, ART_DESTROYED1),
    'tank_destroyed2':        (PAL_BOOM, ART_DESTROYED2),
}


def check(name, rows, pal):
    """4 条硬校验，任何一条不过就整体退出（不留半套图）"""
    errs = []
    if len(rows) != SIZE:
        errs.append('行数 {0} != {1}'.format(len(rows), SIZE))
    for y, row in enumerate(rows):
        if len(row) != SIZE:
            errs.append('第 {0} 行有 {1} 个字符（应为 {2}）'.format(y, len(row), SIZE))
        for x, ch in enumerate(row):
            if ch != '.' and ch not in pal:
                errs.append('第 {0} 行第 {1} 列字符 {2!r} 不在配色表 {3} 里'
                            .format(y, x, ch, ''.join(sorted(pal))))
                break
    table = RECOLOR.get(name)
    if table is None:
        # 漏了 RECOLOR，.coe 里就会保留哑色（黑/深灰/浅灰），上板一片灰
        errs.append('imgconverter.py 的 RECOLOR 里没有 {0!r}'.format(name))
    else:
        for ch, rgb in sorted(pal.items()):
            if rgb not in table:
                errs.append('角色 {0!r} 的哑色 {1} 在 RECOLOR[{2!r}] 里没有 key'
                            .format(ch, rgb, name))
        # 12 位色只有 17 的倍数才不掉色（4 位通道 x 17）
        for rgb in table.values():
            if any(c % 17 for c in rgb):
                errs.append('RECOLOR[{0!r}] 的 {1} 不是 17 的倍数，量化后会变色'
                            .format(name, rgb))
    if errs:
        raise SystemExit('{0}.png 画稿校验失败：\n  - {1}'.format(name, '\n  - '.join(errs)))


def write_png(name, rows, pal):
    """角色色画稿 -> img/<name>.png（'.' = 全透明）"""
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != '.':
                img.putpixel((x, y), pal[ch] + (255,))
    out = IMG_DIR / (name + '.png')
    img.save(out)
    return out


def final_pixels(rows, pal, name):
    """过一遍 RECOLOR 得到“最终上板色”，只给总览图用（和 .coe 同一张表）"""
    table = RECOLOR[name]
    px = {}
    for y, row in enumerate(rows):
        for x, ch in enumerate(row):
            if ch != '.':
                px[(x, y)] = table.get(pal[ch], pal[ch])
    return px


def load_player():
    """玩家坦克是手绘 png，这里只读进来一起摆，不改它"""
    img = Image.open(IMG_DIR / 'tank.png').convert('RGBA')
    table = RECOLOR['tank']
    px = {}
    for y in range(SIZE):
        for x in range(SIZE):
            r, g, b, a = img.getpixel((x, y))
            if a >= 128:
                px[(x, y)] = table.get((r, g, b), (r, g, b))
    return px


def build_overview(cells, out):
    """总览图：每个精灵放大 8 倍（透明处画棋盘格）+ 底部一条 1:1 实拍"""
    sc, pad, lab, cols = 8, 10, 14, 4
    grid_rows = (len(cells) + cols - 1) // cols
    cell_w = SIZE * sc
    cell_h = SIZE * sc + lab
    width = pad + cols * (cell_w + pad)
    height = pad + grid_rows * (cell_h + pad) + lab + SIZE + pad
    img = Image.new('RGB', (width, height), (10, 10, 10))
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.load_default(size=13)
    except TypeError:                     # Pillow < 10.1 没有 size 参数
        font = ImageFont.load_default()

    for i, (label, px) in enumerate(cells):
        ox = pad + (i % cols) * (cell_w + pad)
        oy = pad + (i // cols) * (cell_h + pad)
        draw.text((ox, oy), label, fill=(215, 215, 215), font=font)
        top = oy + lab
        # 透明像素画成棋盘格：一格 = 一个源像素，哪里是空的看得一清二楚
        for y in range(SIZE):
            for x in range(SIZE):
                base = (26, 26, 26) if (x + y) % 2 == 0 else (44, 44, 44)
                draw.rectangle([ox + x * sc, top + y * sc,
                                ox + x * sc + sc - 1, top + y * sc + sc - 1], fill=base)
        for (x, y), rgb in px.items():
            draw.rectangle([ox + x * sc, top + y * sc,
                            ox + x * sc + sc - 1, top + y * sc + sc - 1], fill=rgb)
        draw.rectangle([ox - 1, top - 1, ox + cell_w, top + cell_w], outline=(110, 110, 110))

    # 底部 1:1：VGA 上真实就 20x20 像素，用来判断“能不能一眼分清谁是谁”
    sy = pad + grid_rows * (cell_h + pad)
    draw.text((pad, sy), 'actual size on VGA (20x20, black bg):',
              fill=(215, 215, 215), font=font)
    sy += lab
    left = pad
    for _, px in cells:
        for (x, y), rgb in px.items():
            img.putpixel((left + x, sy + y), rgb)
        left += SIZE + 6
    img.save(out)


def main():
    # 先把 7 张全部校验完，再动磁盘：校验不过就不会留下“改了一半”的 png
    parsed = []
    for name, (pal, art) in SPRITES.items():
        rows = rows_of(art)
        check(name, rows, pal)
        parsed.append((name, pal, rows))

    cells = [('tank.png (player, 现有)', load_player())]
    for name, pal, rows in parsed:
        out = write_png(name, rows, pal)
        px = final_pixels(rows, pal, name)
        cells.append((name, px))
        print('{0:<26} 20x20  不透明 {1:3d}/{2}  角色 {3}'.format(
            out.name, len(px), SIZE * SIZE, ''.join(sorted(pal))))

    overview = IMG_DIR / 'sprites.png'
    build_overview(cells, overview)
    print('校验通过，总览图 -> {0}'.format(overview))


if __name__ == '__main__':
    main()
