from PIL import Image

imglist = [
    'brick', 'river', 'headquarters', 'steel', 'tank', 'woods'
]
# 以坦克为例，尺寸 20x20
for i in imglist:
    img = Image.open('img\\{0}.png'.format(i)).convert('RGBA')
    WIDTH, HEIGHT = img.size

    with open('{0}_16bit.coe'.format(i), 'w') as f:
        f.write('memory_initialization_radix = 16;\n')
        f.write('memory_initialization_vector =\n')
        
        total = WIDTH * HEIGHT
        count = 0
        
        for y in range(HEIGHT):
            for x in range(WIDTH):
                r, g, b, a = img.getpixel((x, y))
                
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
    print("16-bit COE 生成完毕！")