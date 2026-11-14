from pathlib import Path

from PIL import Image

# png 所在的 img/ 目录（用脚本自身位置定位，不依赖当前工作目录）
IMG_DIR = Path(__file__).resolve().parent
# 工程根目录：coe 输出位置，和 blk_mem_*.xci 里的 ../../../../xxx_16bit.coe 对齐
OUT_DIR = IMG_DIR.parent

# png 文件名 -> coe 文件名前缀
#   bullet1 是后加的 10x10 炮弹贴图（朝上），coe 仍然叫 bullet_16bit.coe
TILES = {
    'brick': 'brick',
    'river': 'river',
    'headquarters': 'headquarters',
    'steel': 'steel',
    'tank': 'tank',
    'woods': 'woods',
    'bullet1': 'bullet',
}
# 逐贴图调色板重映射
#   配色统一往 FC 原版 Battle City 靠：砖=砖红块 + 近黑灰缝、钢=浅灰钢板、
#   河=深蓝水 + 浅蓝浪、树林=深绿树冠、玩家坦克=黄车身、基地=金鹰、炮弹=白。
#   这里只换颜色、不动图案；png 是“灰度/纯色画稿 + 透明底”，每个灰度值
#   对应一个角色（车体/炮管/描边…），靠下面这张表上色。
#   表里没有的颜色（以及所有透明像素）原样保留。
RECOLOR = {
    # 玩家坦克：png 里 (160,160,160)=车体与履带面，(64,64,64)=炮管与暗部，
    # (0,0,0)=履带分段线与描边。原版玩家坦克是黄车身 + 深黄暗部 + 黑描边。
    'tank': {
        (160, 160, 160): (248, 208, 48),   # 车体 #F8D030
        (64, 64, 64):    (160, 104, 0),    # 炮管/暗部 #A06800
        (0, 0, 0):       (56, 24, 0),      # 描边/履带分段线 #381800
    },
    # 砖墙：png 的图案是“砖块 + 每 4px 一道十字灰缝”。原版灰缝是近黑的，
    # 连成一大片才像砖墙；之前用 #E87820 橙缝，4 位量化后偏亮偏黄，
    # 整屏会发橙发黄（再叠上 VGA 通道位序 bug 就变成荧光黄绿了）。
    'brick': {
        (255, 0, 0):     (200, 76, 12),    # 砖体 #C84C0C（NES 砖红）
        (255, 255, 255): (48, 8, 0),       # 灰缝 #300800（近黑，留一点暖色）
    },
    # 树林：原图是荧光黄绿 #B6FF00，看着像一堵“发光的墙”（而且树林是可穿透的，
    # 更容易被误认为障碍物）。换成树叶深绿 #00A800；透明像素保持透明，
    # 这样坦克/炮弹会从叶子的缝隙里露出来（和原版一致）。
    'woods': {
        (182, 255, 0): (0, 168, 0),
    },
    # 钢墙：png 是“中心亮、外面两层灰”的凸起钢板，原版是浅灰板 + 白高光。
    'steel': {
        (192, 192, 192): (252, 252, 252),  # 中心高光 #FCFCFC
        (160, 160, 160): (188, 188, 188),  # 板面 #BCBCBC
        (128, 128, 128): (124, 124, 124),  # 边缘 #7C7C7C
    },
    # 河流：png 是“深蓝底 + 纯白浪花”。原版水是深蓝 + 浅蓝浪花，
    # 纯白浪在黑底上太扎眼，压成 #3CBCFC。
    'river': {
        (0, 38, 255):    (0, 88, 248),     # 水面 #0058F8
        (255, 255, 255): (60, 188, 252),   # 浪花 #3CBCFC
    },
    # 基地：png 是单色金鹰剪影，压成原版的金黄 #FCD800。
    'headquarters': {
        (255, 239, 71): (252, 216, 0),
    },
    # 炮弹：png 是中灰圆头弹。黑底上中灰量化后发暗，提成白色最清楚（原版也是白弹）。
    # 注意 key 用 png 名 bullet1（TILES 里 bullet1 -> bullet_16bit.coe）。
    'bullet1': {
        (160, 160, 160): (252, 252, 252),  # #FCFCFC
    },
}

# 坦克 / 砖块 20x20，炮弹 10x10；脚本对尺寸不敏感
for i in TILES:
    img = Image.open(IMG_DIR / '{0}.png'.format(i)).convert('RGBA')
    WIDTH, HEIGHT = img.size

    with (OUT_DIR / '{0}_16bit.coe'.format(TILES[i])).open('w') as f:
        f.write('memory_initialization_radix = 16;\n')
        f.write('memory_initialization_vector =\n')
        
        total = WIDTH * HEIGHT
        count = 0
        
        for y in range(HEIGHT):
            for x in range(WIDTH):
                r, g, b, a = img.getpixel((x, y))

                # 先按原画颜色查重映射表（透明像素不动，保持最高位 0）
                if a >= 128 and i in RECOLOR:
                    r, g, b = RECOLOR[i].get((r, g, b), (r, g, b))
                
                # 提取高 4 位 (除以 16)
                r4 = r >> 4
                g4 = g >> 4
                b4 = b >> 4
                
                # 判断是否透明 (Alpha < 128 视为透明)
                if a < 128:
                    # 透明：最高位设为 0，后面全 0
                    val = 0x0000
                else:
                    # 不透明：最高位设为 1 (0x8000)，拼接 12 位色彩
                    # 格式: 1000_RRRR_GGGG_BBBB
                    val = 0x8000 | (r4 << 8) | (g4 << 4) | b4
                
                f.write(f'{val:04X}')
                count += 1
                if count == total:
                    f.write(';\n')
                else:
                    f.write(',\n')
    print('{0}.png ({1}x{2}) -> {3}_16bit.coe，共 {4} 项'.format(
        i, WIDTH, HEIGHT, TILES[i], total))

print('16-bit COE 生成完毕！')