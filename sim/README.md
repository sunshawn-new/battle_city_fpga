# sim —— 地形碰撞仿真（xsim）

这里的东西**不参与综合**（不在工程的 sources 里），只用来在没有板子的情况下
验证坦克的碰撞逻辑。

## 文件

| 文件 | 作用 |
| --- | --- |
| `tb_terrain.v` | 测试台：15 条断言，覆盖四方向移动、砖/钢/河/树林/基地/切角/桥 |
| `bram_stubs.v` | `blk_mem_gen_0`（地图）和 5 个贴图 ROM 的行为级模型 |
| `run_sim.ps1` | 一键跑仿真：转换地图、用 4 种 BRAM 读延迟各编译运行一遍 |
| `build_all.tcl` | 用工程流重新 synth + impl + 生成 bit，并把报告写到 `build_report.txt` |
| `probe_ckpt.tcl` / `probe2_ckpt.tcl` | 排查用的一次性脚本（在已布线的 dcp 上查网表/时钟） |

## 跑仿真

```powershell
cd sim
.\run_sim.ps1          # 需要 xvlog/xelab/xsim 在 PATH 里，或装过 Vivado
```

脚本会做三件事：

1. 把工程根目录的 `map.coe` 转成 `map_mem.hex`，`bram_stubs.v` 用 `$readmemh`
   加载 —— 仿真的就是板子里那张真地图，所以每条期望值都能和上板行为对上。
2. 用 `-d BRAM_LATENCY_0/2/3`（不加宏就是真 IP 的 1 拍）分别编译运行
   `tb_terrain`。这样能证明 `top.v` 的地形扫描不依赖 BRAM 的具体读延迟
   （`xvlog` 在这个版本里不支持 `-d NAME=VALUE`，`=VALUE` 会被当成文件名，
   所以用宏名来选值）。
3. 打印 `PASSED/FAILED` 汇总；任何一个配置不是 15/15 全过就以退出码 1 结束。

仿真里 `top` 的 `MOVE_DIV` 被改成 200（板上是 400000），所以一个移动节拍只有
200 个时钟，测试跑得很快；坦克仍然是**每拍走 1 像素**。

## 重新构建 bit

```powershell
C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace -source sim\build_all.tcl
```

结果：`battle_city_fpga.runs/impl_1/top.bit`，报告在 `sim/build_report.txt`
（含 WNS/TNS/WHS、时序摘要、资源占用、以及扫描状态机那几条关键路径）。

### 时序相关的两处关键改动（“空气墙”的真正原因）

旧版本 `constr.xdc` 没有时钟约束，Vivado 既不分析也不为地形查询做优化，
100MHz 下这条链根本跑不动 —— BRAM 抓到的是错地址，屏幕上的表现就是
“四个方向都撞墙”。建好约束后暴露出来的两条超时路径，都在 `top.v`：

| 路径 | 原来 | 处理 |
| --- | --- | --- |
| `snap_x -> g_front_*`（除 5） | 17.03ns（14 级 CARRY4）| 改用 `div5()`：`(v*205)>>10`，对 v ≤ 1023 精确等价，综合成几层移位加法 |
| `scan_cell -> BRAM 地址` | 7.97ns（7 级逻辑 + 长走线）| 地址多打一拍进 `scan_addr_r`，S_SCAN 每格周期从 4 拍改成 5 拍 |

Vivado 综合 `v / 5` 时会生成“移位-减法”除法器（而不是乘倒数），这是最容易
踩的坑：**在可综合代码里对变量做常量除法，先量一下时序**。

修完之后（2026-11-13，xc7a35tcpg236-1）：

```
WNS = +1.126 ns   TNS = 0.000   WHS = +0.037 ns   THS = 0.000    (0 条违例)
Slice LUT 537 / 20800 (2.6%)   FF 178   DSP48 8 / 90 (8.9%)   BRAM 6.5 / 50 (13%)

sys_clk_pin : 100 MHz (WNS +1.142)      vga_clk : 50 MHz 生成时钟 (WNS +6.78)
```

顺带一提：8 个 `div5()` 的乘法被 Vivado 映射成了 8 个 DSP48E1，所以逻辑资源
反而比原来（1390 LUT、无 DSP）少了很多。现在全设计最紧的一条是
`player_x -> snap_x/CE`（`query_changed` 的 10 位比较，8.36ns，余量 1.14ns），
已经和地形查询无关了。

## 左上角调试色块

`vga.v` 里 `DBG_OVERLAY = 1'b1`：画面左上角有一块 12x12 的方块，直接显示
“前方地形查询”的状态，不接逻辑分析仪也能看出问题：

* 红 = 查询结果无效 / 正在扫描（这一拍坦克一定不动）
* 绿 = 前方可通行（空地或树林）
* 黄 = 前方被挡住（砖 / 钢 / 河流 / 基地）

不需要时把 `DBG_OVERLAY` 改成 `1'b0` 即可。
