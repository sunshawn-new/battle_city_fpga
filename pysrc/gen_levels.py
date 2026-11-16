# ============================================================================
#  gen_levels.py —— 多个关卡文件 -> levels.coe（关卡 ROM，存“块图”）
#
#  输入：pysrc/maps/level1.txt ... level4.txt（30 列 x 30 行，一个字符 = 一块）
#  输出：仓库根目录的 levels.coe             -> blk_mem_level（4096 x 4 的 ROM）
#        仓库根目录的 map.coe（默认，第 1 关）-> blk_mem_gen_0（地图 RAM 上电初值）
#
#  【为什么 Rom 里只存“块图”，不存展开后的 120x120 格】
#    每关展开后是 14400 格 x 4 位 = 57600 位，4 关就要 8 个 BRAM36；
#    而 30x30 块图只有 900 项 x 4 位 = 3600 位/关，4 关塞进 1 个 BRAM18 都用不完。
#    硬件上由 level_loader.v 做展开（每块 -> 4x4 格，'H' 块落在基地矩形里的是
#    5、其余补砖），一共 14400 次写，0.16ms —— 换关时整屏停一下完全看不出来。
#    展开规则必须和下面 expand_cells() / map_generator.expand() 完全一致，
#    否则“仿真里对、板上错”。本脚本会把两边都跑一遍并逐格比对，不一致就报错。
#
#  用法：
#    python pysrc\\gen_levels.py                 # 生成 levels.coe + map.coe（第 1 关）
#    python pysrc\\gen_levels.py --no-map        # 只生成 levels.coe
# ============================================================================
import argparse
import glob
import io
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
sys.path.insert(0, HERE)
import map_generator as mg          # 复用关卡格式检查 / 展开 / 约束校验

LEVEL_SLOT = 1024                   # 关卡 ROM 里每关占 1024 项（900 块 + 124 个填充）
MAX_LEVELS = 4                      # blk_mem_level 深度 4096 / 1024
HW_HQ = (mg.HQ_X0, mg.HQ_Y0, mg.HQ_W, mg.HQ_H)   # 和 level_loader.v 里的常数一致


def find_levels(explicit=None):
    """.\\pysrc\\maps\\levelN.txt 按 N 排序（N 从 1 开始，不能断号）"""
    if explicit:
        return explicit
    hits = []
    for p in glob.glob(os.path.join(HERE, 'maps', 'level*.txt')):
        m = re.search(r'level(\d+)\.txt$', os.path.basename(p))
        if m:
            hits.append((int(m.group(1)), p))
    hits.sort()
    paths = [p for _, p in hits]
    for i, p in enumerate(paths):
        if os.path.basename(p) != f'level{i + 1}.txt':
            sys.exit(f'关卡文件必须从 level1.txt 连续编号，缺少 level{i + 1}.txt（现在有 {paths}）')
    return paths


def expand_cells(blocks):
    """硬件展开规则的 Python 版（和 level_loader.v 逐格对应）：
       块 -> 4x4 格，tile_id 直接抄；'H' 块（5）里落在基地矩形内的格子是 5，
       矩形上/左/右是 1（砖，U 型堡垒的墙），矩形下方留空（0）——
       经典样式：鹰完整可见，不埋在整块砖里。"""
    hx, hy, hw, hh = HW_HQ
    cells = [[0] * mg.MAP_COLS for _ in range(mg.MAP_ROWS)]
    for by in range(mg.BROWS):
        for bx in range(mg.BCOLS):
            t = blocks[by * mg.BCOLS + bx]
            for cy in range(4):
                for cx in range(4):
                    gx, gy = bx * 4 + cx, by * 4 + cy
                    if t == 5:
                        inside = (hx <= gx < hx + hw) and (hy <= gy < hy + hh)
                        if inside:
                            cells[gy][gx] = 5
                        elif gy < hy + hh:        # 上/左/右：砖墙
                            cells[gy][gx] = 1
                        # gy >= hy + hh：正面敞开，留空
                    else:
                        cells[gy][gx] = t
    return cells


def write_rom_entries(path, entries, total, radix):
    """写 .coe：memory_initialization_radix + 向量（每行一项，最后一项用 ';'）"""
    with io.open(path, 'w') as f:
        f.write('memory_initialization_radix = %d;\n' % radix)
        f.write('memory_initialization_vector =\n')
        for i in range(total):
            v = entries[i] if i < len(entries) else 0
            f.write(('%X' if radix == 16 else '%d') % v)
            f.write(';\n' if i == total - 1 else ',\n')


def main():
    ap = argparse.ArgumentParser(description='关卡文件 -> levels.coe')
    ap.add_argument('--levels', nargs='*', default=None, help='显式指定关卡文件顺序')
    ap.add_argument('--out', default=os.path.join(ROOT, 'levels.coe'))
    ap.add_argument('--no-map', action='store_true', help='不重新生成 map.coe')
    args = ap.parse_args()

    paths = find_levels(args.levels)
    if not paths:
        sys.exit('找不到任何 pysrc/maps/levelN.txt')
    if len(paths) > MAX_LEVELS:
        sys.exit(f'关卡最多 {MAX_LEVELS} 个（blk_mem_level 深度 4096 / 每关 1024），实际 {len(paths)}')

    entries = []
    for i, p in enumerate(paths):
        rows = mg.load_level(p)
        mg.check_level(rows)
        print(f'[{i + 1}] {os.path.relpath(p, ROOT)}')
        mg.print_ascii(rows)

        # 1) 逻辑展开（金标准）+ 原有的一整套关卡约束校验
        cells = mg.expand(rows)
        errs, notes = mg.validate(cells)
        if errs:
            print('[ERROR] 关卡约束校验失败：')
            for e in errs:
                print('  - ' + e)
            sys.exit(1)
        for n in notes:
            print('    [INFO] ' + n)

        # 2) 硬件展开规则的 Python 版，必须和 expand() 逐格一致
        blocks = [mg.TILE_CHAR[ch] for row in rows for ch in row]
        hw = expand_cells(blocks)
        diff = [(x, y) for y in range(mg.MAP_ROWS) for x in range(mg.MAP_COLS)
                if hw[y][x] != cells[y][x]]
        if diff:
            x, y = diff[0]
            sys.exit(f'[ERROR] 硬件展开规则和 map_generator.expand() 不一致：'
                     f'格 ({x},{y}) 硬件={hw[y][x]} 金标准={cells[y][x]}')

        entries += blocks + [0] * (LEVEL_SLOT - len(blocks))
        if i == 0 and not args.no_map:
            mg.write_coe(cells, os.path.join(ROOT, 'map.coe'))
            print('    [OK] map.coe 已按第 1 关重新生成（blk_mem_gen_0 上电初值）')

    write_rom_entries(args.out, entries, MAX_LEVELS * LEVEL_SLOT, 16)
    print(f'[OK] {os.path.relpath(args.out, ROOT)} 生成完毕 '
          f'({len(paths)} 关 x {LEVEL_SLOT} 项 = {MAX_LEVELS * LEVEL_SLOT} 项，'
          f'每关 {mg.BCOLS}x{mg.BROWS} 块)')


if __name__ == '__main__':
    main()
