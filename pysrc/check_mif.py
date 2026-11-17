# 一次性校验：.coe 里的内容是否已经进了 IP 生成的 .mif（= 会不会进比特流）
# 用法：python pysrc\check_mif.py
import glob
import io
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def read_coe(path):
    text = io.open(path, encoding='utf-8').read()
    body = text.split('memory_initialization_vector')[1]
    body = body.split('=', 1)[1] if '=' in body else body
    return [int(t, 16) for t in re.split(r'[,;\s]+', body) if re.fullmatch(r'[0-9A-Fa-f]+', t)]


def read_mif(path):
    """读 Vivado 生成的 .mif。这里没有 RADIX 文件头，数据是定宽的 0/1 串
    （16 位 ROM 每行 16 个字符，4 位地图每行 4 个字符），所以要按“全是 0/1”
    判定成二进制；只有出现 2~F 才当十六进制。"""
    lines = []
    for raw in io.open(path, encoding='ascii', errors='ignore').read().splitlines():
        line = raw.split('--')[0].strip()
        if not line:
            continue
        if re.fullmatch(r'[0-9A-Fa-f]+\s*:\s*[0-9A-Fa-f]+', line):      # addr : data
            line = line.split(':', 1)[1].strip()
        if re.fullmatch(r'[0-9A-Fa-f]+', line):
            lines.append(line)
    binary = bool(lines) and all(re.fullmatch(r'[01]+', s) for s in lines)
    radix = 2 if binary else 16
    return [int(s, radix) for s in lines]


def find_mif(name):
    """.gen/ 和 .srcs/ 两处都可能生成 IP 的 .mif，按需找。

    注意：Vivado 遇到重名 IP 会另起一个目录（xxx_1）。本工程换关卡 ROM 时
    就出现过这种情况 —— 磁盘上同时留着旧的 ip/blk_mem_level/ 和工程真正
    在用的 ip/blk_mem_level_1/，旧目录里那份 .mif 是过期的。
    所以先读工程文件，看这个 IP 到底挂在哪个目录；找不到再退回按名字猜。
    """
    xpr = os.path.join(ROOT, 'battle_city_fpga.xpr')
    if os.path.exists(xpr):
        text = io.open(xpr, encoding='utf-8', errors='ignore').read()
        pat = r'\$PSRCDIR/sources_1/ip/([^/"]+)/' + re.escape(name) + r'\.xci'
        for m in re.finditer(pat, text):
            for base in ('battle_city_fpga.gen', 'battle_city_fpga.srcs'):
                hits = glob.glob(os.path.join(ROOT, base, 'sources_1', 'ip',
                                              m.group(1), '*.mif'))
                if hits:
                    return hits[0]
    for base in ('battle_city_fpga.gen', 'battle_city_fpga.srcs'):
        hits = glob.glob(os.path.join(ROOT, base, 'sources_1', 'ip', name, '*.mif'))
        if hits:
            return hits[0]
    return None


def compare(name, coe_path):
    mif_path = find_mif(name)
    if mif_path is None:
        print('%-24s MIF NOT FOUND（这个 IP 还没 generate_target）' % name)
        return False
    coe = read_coe(coe_path)
    mif = read_mif(mif_path)
    n = min(len(coe), len(mif))
    bad = [a for a in range(n) if mif[a] != coe[a]]
    print('%-24s coe=%d  mif=%d  mismatch=%d %s'
          % (name, len(coe), len(mif), len(bad), bad[:5]))
    return not bad and len(mif) == len(coe)


ok = True
ok &= compare('blk_mem_gen_0', os.path.join(ROOT, 'map.coe'))
ok &= compare('blk_mem_level', os.path.join(ROOT, 'levels.coe'))
ok &= compare('blk_mem_headquarters', os.path.join(ROOT, 'headquarters_16bit.coe'))
ok &= compare('blk_mem_hq_destroyed', os.path.join(ROOT, 'headquarters_destroyed_16bit.coe'))
ok &= compare('blk_mem_brick', os.path.join(ROOT, 'brick_16bit.coe'))
ok &= compare('blk_mem_tank_destroyed1', os.path.join(ROOT, 'tank_destroyed1_16bit.coe'))
ok &= compare('blk_mem_tank_destroyed2', os.path.join(ROOT, 'tank_destroyed2_16bit.coe'))

# 抽查几格：地图宽 120 格（600x600 玩区），地址 = 行*120 + 列
MAP_W = 120
coe = read_coe(os.path.join(ROOT, 'map.coe'))
print('coe entries  =', len(coe), '(expect 19200 = 14400 cells + padding)')
print('cell(20,32)  =', coe[32 * MAP_W + 20], '(expect 0 river ford)')
print('cell(0,32)   =', coe[32 * MAP_W + 0],  '(expect 3 river)')
print('cell(40,112) =', coe[112 * MAP_W + 40], '(expect 0 player spawn: 200,560)')
print('cell(8,0)    =', coe[0 * MAP_W + 8],    '(expect 0 enemy spawn: 40,0)')
print('cell(60,0)   =', coe[0 * MAP_W + 60],   '(expect 0 enemy spawn: 300,0)')
print('cell(112,0)  =', coe[0 * MAP_W + 112],  '(expect 0 enemy spawn: 560,0)')
print('cell(8,4)    =', coe[4 * MAP_W + 8],    '(expect 0 below enemy spawn: 出生就能往下开)')
print('cell(58,116) =', coe[116 * MAP_W + 58], '(expect 5 base: 4x4 = 鹰的包围盒，贴底)')
print('cell(56,114) =', coe[114 * MAP_W + 56], '(expect 1 brick: 薄砖环的外角)')
print('cell(56,112) =', coe[112 * MAP_W + 56], '(expect 0: 环外面（鹰正上方）留空)')
print('cell(119,119)=', coe[119 * MAP_W + 119], '(expect 0, last valid cell)')
print('cell padding =', coe[14400], '(expect 0, first padded entry)')

# 关卡 ROM：4096 项 = 4 关 x 1024，第 i 关的块图从 (i-1)*1024 开始，块地址 = 行*30 + 列
lvl = read_coe(os.path.join(ROOT, 'levels.coe'))
print('levels entries =', len(lvl), '(expect 4096 = 4 levels x 1024)')
print('L1 blk(14,28)  =', lvl[28 * 30 + 14], '(expect 5 base block)')
print('L2 blk(14,28)  =', lvl[1024 + 28 * 30 + 14], '(expect 5 base block)')
print('L1 blk(2,0)    =', lvl[0 * 30 + 2], '(expect 0 empty spawn block)')
print('RESULT:', 'ALL MATCH' if ok else 'MISMATCH')
sys.exit(0 if ok else 1)

