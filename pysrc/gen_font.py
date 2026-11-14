# ============================================================================
#  gen_font.py —— 由 pysrc/font5x7.py 生成 RTL 侧的 font5x7.v
#
#  为什么用“生成”而不是直接手写 Verilog：
#    字形表要同时被 RTL（板上）和 img/preview.py（离线预览）使用。
#    两份手抄的表迟早会走形（改一个字母漏改一处，预览图就和板子不一致），
#    所以只保留 pysrc/font5x7.py 这一份数据，Verilog 由脚本生成。
#
#  用法：python pysrc\gen_font.py
#  生成：battle_city_fpga.srcs/sources_1/new/font5x7.v（别手改，改 font5x7.py）
# ============================================================================
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from font5x7 import GLYPHS, glyph_packed       # noqa: E402

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, 'battle_city_fpga.srcs', 'sources_1', 'new', 'font5x7.v')

HEADER = """`timescale 1ns / 1ps
// ============================================================================
//  font5x7 —— HUD 用的 5x7 点阵字库（纯组合，一个字符查一次）
//
//  【本文件由 pysrc/gen_font.py 生成，不要手改】
//    字形数据在 pysrc/font5x7.py（唯一数据源，img/preview.py 也 import 它），
//    改完字形跑一遍：python pysrc\\gen_font.py
//
//  为什么不做成 BRAM ROM：
//    只有 {n} 个字形，用 case 表综合出来约一百多个 LUT（本设计 LUT 用量 <10%），
//    却省掉了“新建 IP + 生成 coe + 仿真桩 + check_mif 期望值”一整套东西。
//    HUD 是纯静态文字，没有任何带宽需求，用 BRAM 反而是浪费。
//
//  接口：ch 是 ASCII 码，row 是 0..6（上 -> 下），
//        bits[4] 是最左边那一列，bits[0] 是最右边那一列。
// ============================================================================
module font5x7 (
    input      [7:0] ch,
    input      [2:0] row,
    output reg [4:0] bits
);
    reg [34:0] g;          // 7 行 x 5 位，行 i 占 bit[5i +: 5]

    always @(*) begin
        case (ch)
"""

TAIL = """            default: g = 35'd0;
        endcase
    end

    // 变量下标的位选（Verilog-2001 的 +: 语法），综合成 3 级 mux
    always @(*) bits = g[row*5 +: 5];

endmodule
"""


def main():
    chars = sorted(GLYPHS.keys())
    body = []
    for ch in chars:
        code = ord(ch)
        body.append("            8'h%02X: g = 35'h%09X;   // %s\n"
                    % (code, glyph_packed(ch), 'space' if ch == ' ' else ch))
    with open(OUT, 'w', encoding='utf-8', newline='\n') as f:
        f.write(HEADER.replace('{n}', str(len(chars))))
        f.write(''.join(body))
        f.write(TAIL)
    print('%d glyphs -> %s' % (len(chars), os.path.relpath(OUT, ROOT)))


if __name__ == '__main__':
    main()
