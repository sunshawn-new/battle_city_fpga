MAP_COLS, MAP_ROWS = 160, 120

# 初始化全为 0（空地）
map_data = [[0] * MAP_COLS for _ in range(MAP_ROWS)]

# 1. 画外墙 (1=砖墙)
for x in range(MAP_COLS):
    map_data[0][x] = 1
    map_data[MAP_ROWS-1][x] = 1
for y in range(MAP_ROWS):
    map_data[y][0] = 1
    map_data[y][MAP_COLS-1] = 1

# 2. 画基地 (5=基地)，假设在底部中间 (x: 76~84, y: 110~118)
# 基地周围用砖墙包围
for y in range(101, 119):
    for x in range(75, 88):
        map_data[y][x] = 1
for y in range(112, 118):
    for x in range(76, 84):
        map_data[y][x] = 5 # 基地本身

# 3. 画河流 (3=河流)，假设在中间横穿
for y in range(60, 66):
    for x in range(20, 140):
        if x < 70 or x > 90: # 中间留个缺口，让坦克能过
            map_data[y][x] = 3

# 4. 画草地 (4=草地)，假设在右上角
for y in range(20, 40):
    for x in range(120, 150):
        map_data[y][x] = 4

# 5. 画一片常规砖墙用于测试打墙
for y in range(40, 55):
    for x in range(30, 50):
        map_data[y][x] = 1

# --- 导出为 COE 文件 ---
with open('map.coe', 'w') as f:
    f.write('memory_initialization_radix = 16;\n')
    f.write('memory_initialization_vector =\n')
    total = MAP_COLS * MAP_ROWS
    count = 0
    for y in range(MAP_ROWS):
        for x in range(MAP_COLS):
            f.write(f'{map_data[y][x]:X}')
            count += 1
            if count == total:
                f.write(';\n')
            else:
                f.write(',\n')
print("map.coe 生成完毕！")