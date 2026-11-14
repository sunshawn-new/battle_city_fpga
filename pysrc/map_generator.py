# ============================================================================
#  map_generator.py —— 关卡文件 -> map.coe（Block Memory 的初始化内容）
#
#  输入：pysrc/maps/level1.txt
#        30 列 x 30 行，一个字符 = 一个“块” = 4x4 格 = 20x20 像素
#        '.' 空地(0)  '#' 砖(1)  'S' 钢(2)  '~' 河(3)  'T' 树(4)  'H' 基地(5)
#  输出：仓库根目录的 map.coe（120x120 = 14400 格有效数据）
#        这个文件被 blk_mem_gen_0 IP 引用，vga.v 每 5x5 像素读一次。
#
#  【600x600 玩区 + 200px 侧栏】
#    画面仍是 800x600，但地图只占左边 600x600（30x30 块 = 120x120 格），
#    右边 200px 是 HUD 信息栏（vga.v / hud.v 负责画，不读地图）。
#    所以逻辑尺寸是 120x120，而 blk_mem_gen_0 的物理深度仍然是 19200
#    （15 位地址，IP 不用重新生成）：最大地址 = 119*120+119 = 14399 < 16384，
#    尾部 4800 个地址永远没人访问，这里补 0 只是为了满足 IP 的“深度 = 项数”。
#    这也是 gen 把 coe 写成 19200 项的原因（多出来的 4800 个 0）。
#
#  为什么以“块”为单位：坦克 20x20、砖/钢/河/树的贴图也都是 20x20，
#  墙厚取 1 块（20px = 4 格）才不会被贴图切断。炮弹打掉 20x10，正好半块。
#
#  写完会做一遍约束校验（不通过就报错退出，不会留下半成品 map.coe）：
#    1. 基地本体必须正好是 列 56~63 x 行 112~117 的 8x6 格，
#       因为 vga.v 的 HQ_X0/HQ_Y0 = 290/565 是按这个位置写死的；
#       整张地图不许有第二处 tile_id = 5。
#    2. 玩家出生点 (300,300) 及上下通路、三个敌人的出生点必须空。
#    3. 从玩家出生点 BFS：三个敌人出生点 + 基地堡垒左上/右上/上方都要能走到。
#
#  用法：
#    python pysrc\map_generator.py                     # 默认关卡 1
#    python pysrc\map_generator.py --ascii             # 只打印关卡
#    python pysrc\map_generator.py --level pysrc\maps\level1.txt --out map.coe
#    python img\preview.py                             # 生成 img/preview.png 看画面
# ============================================================================
import argparse
import os
import sys

MAP_COLS, MAP_ROWS = 120, 120        # 格数（vga.v：每格 5x5 像素 -> 600x600 玩区）
BLOCK = 4                            # 1 块 = 4x4 格
BCOLS, BROWS = MAP_COLS // BLOCK, MAP_ROWS // BLOCK      # 30 x 30

# BRAM 的物理深度（blk_mem_gen_0 的 Write_Depth_A = 19200，15 位地址）。
# 逻辑上只有 14400 格，多出来的位置补 0 —— 地址永远不会指到那儿，
# 但 IP 要求 coe 的项数等于深度，所以 write_coe 会把剩下的补满。
PHYS_DEPTH = 19200

TILE_CHAR = {'.': 0, '#': 1, 'S': 2, '~': 3, 'T': 4, 'H': 5}
TILE_NAME = {0: '空地', 1: '砖', 2: '钢', 3: '河', 4: '树', 5: '基地'}
PASSABLE = (0, 4)                    # 坦克能过的地形（树林只是盖住坦克）

# 基地本体：和 vga.v 的 HQ_X0/HQ_Y0 = 290/565 的 20x20 精灵一致（格坐标）
#   精灵画在 290..309 / 565..584，方块中心 = 格 56..63 x 112..117
HQ_X0, HQ_Y0, HQ_W, HQ_H = 56, 112, 8, 6
# 出生点（像素）
PLAYER_SPAWN = (300, 300)
ENEMY_SPAWNS = ((40, 10), (300, 10), (560, 10))

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DEFAULT_LEVEL = os.path.join(ROOT, 'pysrc', 'maps', 'level1.txt')
DEFAULT_OUT = os.path.join(ROOT, 'map.coe')


def load_level(path):
    """读关卡文件：';' 开头是注释，空行忽略"""
    rows = []
    with open(path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\r\n')
            if not line.strip() or line.lstrip().startswith(';'):
                continue
            rows.append(line)
    return rows


def check_level(rows):
    """关卡文件自身的格式检查（行列数、字符集）"""
    errs = []
    if len(rows) != BROWS:
        errs.append(f'关卡必须有 {BROWS} 行，实际 {len(rows)} 行')
    for i, row in enumerate(rows):
        if len(row) != BCOLS:
            errs.append(f'第 {i} 行应有 {BCOLS} 列，实际 {len(row)} 列')
        for ch in row:
            if ch not in TILE_CHAR:
                errs.append(f'第 {i} 行出现非法字符 {ch!r}')
                break
    if errs:
        sys.exit('关卡文件有问题：\n  ' + '\n  '.join(errs))

def expand(rows):
    """块 -> 格。'H' 块里落在基地矩形内的格子是 5，其余补砖（基地的台座）"""
    cells = [[0] * MAP_COLS for _ in range(MAP_ROWS)]
    for by in range(BROWS):
        for bx in range(BCOLS):
            ch = rows[by][bx]
            if ch == '.':
                continue
            for gy in range(by * BLOCK, by * BLOCK + BLOCK):
                for gx in range(bx * BLOCK, bx * BLOCK + BLOCK):
                    if ch == 'H':
                        in_hq = (HQ_X0 <= gx < HQ_X0 + HQ_W and
                                 HQ_Y0 <= gy < HQ_Y0 + HQ_H)
                        cells[gy][gx] = 5 if in_hq else 1
                    else:
                        cells[gy][gx] = TILE_CHAR[ch]
    return cells


def rect_free(cells, px, py, size=20):
    """(px,py) 开始的 size x size 像素区域是否全部可通行"""
    x0, y0 = px // 5, py // 5
    for y in range(y0, y0 + size // 5):
        for x in range(x0, x0 + size // 5):
            if cells[y][x] not in PASSABLE:
                return False
    return True


def bfs_reach(cells, start):
    """从 start（格坐标）出发，在可通行格上做 BFS，返回可达标记表"""
    from collections import deque
    h, w = len(cells), len(cells[0])
    seen = [[False] * w for _ in range(h)]
    sx, sy = start
    seen[sy][sx] = True
    q = deque([(sx, sy)])
    while q:
        x, y = q.popleft()
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if 0 <= nx < w and 0 <= ny < h and not seen[ny][nx] \
                    and cells[ny][nx] in PASSABLE:
                seen[ny][nx] = True
                q.append((nx, ny))
    return seen

def nearest_open(cells, start, fixed, step, axis='x'):
    """从 start 沿 step 方向找第一格可通行的格子并返回坐标值（找不到就返回 start）。
       axis='x'：沿列方向扫（fixed 是行号）；axis='y'：沿行方向扫（fixed 是列号）"""
    limit = MAP_COLS if axis == 'x' else MAP_ROWS
    v = start
    while 0 <= v < limit:
        cell = cells[fixed][v] if axis == 'x' else cells[v][fixed]
        if cell in PASSABLE:
            return v
        v += step
    return start


def validate(cells):
    """返回 (错误列表, 提示列表)"""
    errs, notes = [], []

    # --- 1. 基地本体必须和 vga.v 的常量对齐 ---
    hq = [(x, y) for y in range(HQ_Y0, HQ_Y0 + HQ_H)
          for x in range(HQ_X0, HQ_X0 + HQ_W)]
    bad = [(x, y) for (x, y) in hq if cells[y][x] != 5]
    if bad:
        errs.append(f'基地矩形 {HQ_W}x{HQ_H}@({HQ_X0},{HQ_Y0}) 里有 {len(bad)} 格不是 '
                    f'tile 5，例如 {bad[0]}')
    stray = [(x, y) for y in range(MAP_ROWS) for x in range(MAP_COLS)
             if cells[y][x] == 5 and not (HQ_X0 <= x < HQ_X0 + HQ_W
                                          and HQ_Y0 <= y < HQ_Y0 + HQ_H)]
    if stray:
        errs.append(f'基地矩形之外还有 {len(stray)} 格 tile 5，例如 {stray[0]}')

    # --- 2. 出生点净空 ---
    px, py = PLAYER_SPAWN
    if not rect_free(cells, px, py):
        errs.append(f'玩家出生点 {PLAYER_SPAWN} 的 20x20 车身压在墙上')
    for dy in (60, -60):
        if not rect_free(cells, px, py + dy):
            errs.append(f'玩家出生点上下 ±{abs(dy)}px 必须空（坦克要能起步）')
    for (ex, ey) in ENEMY_SPAWNS:
        if not rect_free(cells, ex, ey):
            errs.append(f'敌人出生点 ({ex},{ey}) 的 20x20 车身压在墙上')
        if not rect_free(cells, ex, ey + 20):
            errs.append(f'敌人出生点 ({ex},{ey}) 正下方 20px 被挡住，出生就动不了')

    # --- 3. 连通性 ---
    start = (px // 5, py // 5)
    seen = bfs_reach(cells, start)
    targets = [(ex // 5, ey // 5, f'敌人出生点({ex},{ey})') for (ex, ey) in ENEMY_SPAWNS]
    # 基地堡垒周围：从堡垒砖墙往外找第一格可通行的格子（墙厚随关卡不同，所以不能写死偏移）
    targets += [(nearest_open(cells, HQ_X0 - 1, HQ_Y0 + 2, -1), HQ_Y0 + 2, '基地堡垒左侧'),
                (nearest_open(cells, HQ_X0 + HQ_W, HQ_Y0 + 2, +1), HQ_Y0 + 2, '基地堡垒右侧'),
                (HQ_X0 + HQ_W // 2, nearest_open(cells, HQ_Y0 - 1, HQ_X0 + HQ_W // 2, -1, 'y'),
                 '基地堡垒上方')]
    for (tx, ty, name) in targets:
        if not seen[ty][tx]:
            errs.append(f'{name} (格 {tx},{ty}) 从玩家出生点走不到')

    total_open = sum(1 for y in range(MAP_ROWS) for x in range(MAP_COLS)
                     if cells[y][x] in PASSABLE)
    reached = sum(1 for y in range(MAP_ROWS) for x in range(MAP_COLS) if seen[y][x])
    notes.append(f'可通行格 {total_open}，玩家可达 {reached} '
                 f'({100.0 * reached / total_open:.1f}%)')
    if reached < total_open:
        notes.append(f'注意：有 {total_open - reached} 格可通行区域玩家走不到（孤岛）')

    hist = {}
    for y in range(MAP_ROWS):
        for x in range(MAP_COLS):
            hist[cells[y][x]] = hist.get(cells[y][x], 0) + 1
    notes.append('格子统计: ' +
                 ', '.join(f'{TILE_NAME[k]}={hist.get(k, 0)}' for k in sorted(TILE_NAME)))
    return errs, notes


def write_coe(cells, path):
    """写 coe：先 14400 格有效数据，再补 0 到 BRAM 的物理深度 19200。
       补 0 不影响任何逻辑（地址最大 14399），但没有这 4800 项，
       blk_mem_gen_0 会认为初始化文件长度不够。"""
    total = MAP_COLS * MAP_ROWS
    with open(path, 'w') as f:
        f.write('memory_initialization_radix = 16;\n')
        f.write('memory_initialization_vector =\n')
        count = 0
        for y in range(MAP_ROWS):
            for x in range(MAP_COLS):
                f.write(f'{cells[y][x]:X}')
                count += 1
                f.write(';\n' if count == PHYS_DEPTH else ',\n')
        while count < PHYS_DEPTH:
            f.write('0')
            count += 1
            f.write(';\n' if count == PHYS_DEPTH else ',\n')


def print_ascii(rows):
    print('    ' + ''.join(str((i // 10) % 10) for i in range(BCOLS)))
    print('    ' + ''.join(str(i % 10) for i in range(BCOLS)))
    for i, row in enumerate(rows):
        print(f'{i:2d}  {row}')


def main():
    ap = argparse.ArgumentParser(description='关卡文件 -> map.coe')
    ap.add_argument('--level', default=DEFAULT_LEVEL)
    ap.add_argument('--out', default=DEFAULT_OUT)
    ap.add_argument('--ascii', action='store_true', help='只打印关卡，不生成 coe')
    args = ap.parse_args()

    rows = load_level(args.level)
    check_level(rows)
    print_ascii(rows)
    if args.ascii:
        return

    cells = expand(rows)
    errs, notes = validate(cells)
    for n in notes:
        print('[INFO] ' + n)
    if errs:
        print('[ERROR] 关卡约束校验失败：')
        for e in errs:
            print('  - ' + e)
        sys.exit(1)

    write_coe(cells, args.out)
    print(f'[OK] {os.path.relpath(args.out, ROOT)} 生成完毕 '
          f'({MAP_COLS}x{MAP_ROWS} 格 = {BCOLS}x{BROWS} 块)')


if __name__ == '__main__':
    main()