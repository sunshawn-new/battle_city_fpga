# 项目文件说明 & 使用手册

> 项目：**Battle City FPGA**（Basys3 / Artix-7 `xc7a35tcpg236-1` / Vivado 2021.1）
> 玩法：VGA 800×600@60Hz 复刻 FC《坦克大战》——4 关循环、20 辆敌人/关、
> 三种敌方坦克、HUD 侧栏、GAME OVER 后按 BTNC 重开。
> 本文只讲“**每个文件干什么 / 怎么跑**”；每一轮改动的原因和踩坑记录在
> `sim/README.md`（第十五轮为止），实测数据在根目录 `优化总结报告.md`。

---

## 0. 三条上手路线（先看这个）

| 我想… | 命令（在项目根目录） | 产物 |
| --- | --- | --- |
| **只跑仿真**（不上板） | `cd sim; .\run_sim.ps1` | 28 组结果打在屏幕上，日志在 `sim\tb_*_latency_*.log` |
| **重建比特流**（要上板） | `C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace -source sim\build_all.tcl` | `battle_city_fpga.runs\impl_1\top.bit` + `sim\build_report.txt` |
| **改地图** | 改 `pysrc\maps\level*.txt` → `python pysrc\gen_levels.py` → 重建 bit | 新的 `levels.coe` / `map.coe`（IP 的 `.mif` 由构建脚本刷新） |

> 前置条件：Vivado 2021.1（本机在 `C:\Vivado\2021.1`）、Python 3（带 Pillow）、PowerShell。
> `run_sim.ps1` 会自己找 `xvlog.bat`（PATH → `%XILINX_VIVADO%` → `C:\Xilinx\Vivado` → `C:\Vivado`）。

---

## 1. 目录一览

```text
battle_city_fpga/
├─ battle_city_fpga.xpr          Vivado 工程（直接双击可开 GUI）
├─ *.coe                        工程根目录的数据文件（贴图/关卡/地图），见第 5 节
├─ battle_city_fpga.srcs/       RTL / 测试台 / 约束 / IP
│   ├─ sources_1/new/           ★ 13 个 Verilog 模块（第 2 节）
│   ├─ sources_1/ip/            ★ 15 个 IP（13 贴图 ROM + 关卡 ROM + 地图 RAM，第 3 节）
│   ├─ sim_1/new/               ★ 7 个测试台 + 1 个 BRAM 行为模型（第 4 节）
│   └─ constrs_1/new/constr.xdc 引脚 + 时钟约束（第 6 节）
├─ pysrc/                       地图 / 字库生成脚本（第 7 节）
│   └─ maps/level1..4.txt       30×30 块图（手工维护的真源）
├─ img/                         贴图 PNG、贴图→coe 脚本、离线画面预览（第 8 节）
├─ sim/                         仿真与构建脚本（第 9 节）
│   ├─ run_sim.ps1              一键跑 28 组仿真
│   ├─ build_all.tcl            一键重建比特流（含 IP 刷新/陈旧检查）
│   └─ README.md                每轮改动的原因/根因/验证记录（★ 出问题时先查这里）
├─ battle_city_fpga.runs/       Vivado 综合/实现产物；★ top.bit 在 impl_1/ 下
├─ battle_city_fpga.gen/        IP 的生成产物（★ 真正进比特流的 .mif 在这里）
├─ battle_city_fpga.cache/ .hw/ .sim/ .ip_user_files/ .Xil/   Vivado 自己用，别手改
├─ 优化总结报告.md               时序/资源/功耗的优化前后对比
├─ 实验报告3.docx / 数字逻辑荣誉课实验报告4.docx   课程报告
└─ top.v.bak                    旧版 top.v 备份（历史遗留，可删）
```

`battle_city_fpga.runs/`、`.gen/`、`.cache/` 随时可以由 `build_all.tcl` 重建，**不要**手工改里面的文件。

---

## 2. RTL 模块（`battle_city_fpga.srcs/sources_1/new/`）

| 文件 | 行数 | 作用 | 关键参数/常量 |
| --- | --- | --- | --- |
| `top.v` | ~510 | 顶层：接时钟/复位/按键/VGA，例化所有子模块，维护生命/分数/关卡/基地状态，仲裁地图 RAM 的写口 | `MOVE_DIV=4e6`（25Hz 移动拍，125px/s）、`N_ENEMY=3`、`LIVES_START=3`、`INVULN_CYCLES=2.5e8`（2.5s 无敌）、`FX_DIV=8e6`（80ms/相位）、`N_LEVELS=4`、`ENEMIES_PER_STAGE=20`、`SPAWN_CYCLES=3e8`（3s 补车）、`CLEAR_CYCLES=2e8`（2s 横幅） |
| `vga.v` | ~620 | 800×600@60 扫描（50MHz 像素时钟）、图层混合、所有贴图 ROM 的寻址 | 玩区 `PLAY_W=600`；基地精灵 `HQ_X0/HQ_Y0 = 290/580`；图层优先级 **HUD > 树林 > 爆炸 > 炮弹 > 坦克 > 地形** |
| `player.v` | ~150 | 玩家坦克：整格移动、四方向地形/互斥判定、复活与冻结 | `TILE=5`、出生 `(200,560)`、`MOVE_DIV` 决定移动节拍 |
| `enemy_ctrl.v` | ~520 | 3 辆敌方坦克的 SoA 对象池 + AI（曼哈顿贪心 + 轴向锁存 + 四方向试错 + 贴脸开火） | `TGT_X/TGT_Y = 300/590`（基地中心）、兵种速度/开火周期/血量见源码注释 |
| `bullet-ctrl.v` | ~740 | 4 槽炮弹池：飞行、网格原生命中、打砖 20×10、归属/弹对弹/冷却、`base_hit` | `SPEED_DIV=250000`（400Hz）、每发射者同屏 1 发 + 0.2s 冷却 |
| `fx_ctrl.v` | ~160 | 爆炸时间轴：4 个槽、6 个相位（亮爆团 3 + 星形环 3） | `N_FX=4`、`FX_DIV=8e6` |
| `stage_ctrl.v` | ~200 | 关卡流程：补车计时、兵种队列、STAGE CLEAR、换关、GAME OVER 后重开 | 三状态 `S_PLAY/S_CLEAR/S_LOAD` |
| `level_loader.v` | ~175 | 关卡「块图」→ 120×120 格的展开器，换关时整张地图重写 | `BCOLS/BROWS=30`、`LEVEL_SLOT=1024`、`HQ_X0/HQ_Y0=58/116`、等 ROM 3 拍再采样（见第 10 节） |
| `terrain_probe.v` | ~230 | 可复用的“前方地形”查询引擎（5 格 × 5 拍），结果取最硬地形 | `MAP_W=120`、`TILE=5`、`TANK_W/H=20` |
| `map_bus.v` | ~110 | 地图 RAM Port A 的读/写仲裁（5 个客户端：4 个 probe + 炮弹） | 玩家优先，编号小的敌人优先 |
| `tank_block.v` | ~70 | 坦克互斥：包围盒判定“下一个格子会不会撞到别的车” | `abs(dx) < 20 && abs(dy) < 20` 才算重叠（贴边 dx=20 放行） |
| `hud.v` | ~300 | 右侧 200px 侧栏：标题/关卡/剩余敌人/分数/生命/兵种图标/横幅 | 5×7 字库放大 2 倍、字距 16px；分数 `nn00`；无除法器 |
| `font5x7.v` | 68 | HUD 字模（**由 `pysrc/gen_font.py` 生成，别手改**） | 42 个字形，纯组合 case |

**数据流一句话**：`player/enemy_ctrl` 只要“能不能走”，`terrain_probe` 通过 `map_bus` 问地图 RAM；
`bullet-ctrl` 也走 `map_bus`（还要写 0 打砖）；`vga` 用 Port B 纯只读地读地图和贴图；
`stage_ctrl/level_loader` 在换关时整片重写地图；`hud` 只画右侧 200px。


---

## 3. IP（`battle_city_fpga.srcs/sources_1/ip/`）

全部是 `blk_mem_gen v8.4`，初始化文件都指向**工程根目录的 .coe**（`CONFIG.Coe_File = ../../../../xxx.coe`）。

| IP | 参数 | 内容 | 被谁用 |
| --- | --- | --- | --- |
| `blk_mem_gen_0` | 4bit × 32768（实际只用前 14400 格）**双口** | 地图 RAM：每格一个 tile_id（0 空 / 1 砖 / 2 钢 / 3 河 / 4 树 / 5 基地） | Port A＝`map_bus` 读写；Port B＝`vga` 只读 |
| `blk_mem_level` | 4bit × 4096 | 4 关的 30×30 **块图**（每关 1024 项） | `level_loader` |
| `blk_mem_brick` / `steel` / `river` / `woods` | 16bit × 400（20×20） | 四种地形贴图（tile 1/2/3/4） | `vga` |
| `blk_mem_player_tank` | 16bit × 400 | 玩家坦克（金黄色） | `vga` |
| `blk_mem_tank_fast` / `tank_power` / `tank_armor` | 16bit × 400 | 三种敌方坦克 | `vga`（也用于 HUD 图标） |
| `blk_mem_bullet` | 16bit × 100（10×10） | 炮弹（朝上） | `vga` |
| `blk_mem_headquarters` / `blk_mem_hq_destroyed` | 16bit × 400 | 基地：金鹰 / 被打爆的白旗废墟 | `vga` |
| `blk_mem_tank_destroyed1` / `tank_destroyed2` | 16bit × 400 | 爆炸两帧（亮爆团 / 星形环） | `vga` |

> **改贴图只改根目录的 `*_16bit.coe` 是不够的**：综合用的是 IP 目录里的 `.mif`。
> 必须让 IP 重新 `generate_target`（`build_all.tcl` 会做），改完用 `python pysrc\check_mif.py` 复核。

---

## 4. 仿真侧文件（`battle_city_fpga.srcs/sim_1/new/`）

| 文件 | 断言下限 | 覆盖什么 |
| --- | --- | --- |
| `tb_terrain.v` | **30** | 四方向移动、砖/钢/河/树/基地阻挡、切角、坐标永远在 5px 格点；**地图契约**（基地 4×4@(58,116) 贴底、2 格薄砖环、环外留空、出生点净空）；**T17 地图地址与鹰窗口必须重合**（force 扫描计数到像素 (295,585)，要求 `map_addr=14099`、`tile_id=5`、`hq_on=1`） |
| `tb_bullet.v` | 88 | 发射/冷却/飞行/命中/打砖 20×10/出界/对象池/总线仲裁/贴墙开火/敌人开火/打坦克/友军不误伤/弹对弹/每发射者同屏 1 发/打中基地/GAME OVER 冻结 |
| `tb_enemy.v` | 67 | 出生点与兵种/整格移动/三路 probe 不串台/撞墙循环转向/死胡同四方向试错/坦克互斥端口与包围盒边界/玩家挡车道/河岸渡河（E14）与角落脱困（E15） |
| `tb_combat.v` | 34 | 生命 3→0、复活回出生点、无敌 + 车身闪烁、分数 100/200/300、GAME OVER、爆炸开在**死亡位置** |
| `tb_hud.v` | 41 | x=600 边界、面板底色、字形放大后的亮/暗像素、分数/生命数字、敌人图标、`ENEMY nn`、横幅与 PRESS BTNC |
| `tb_fx.v` | 30 | 4 槽同拍多请求分配、坐标绑定、6 个相位的两帧切换、满池丢弃、放完释放/复用 |
| `tb_stage.v` | 67 | 开局排一屏 3 辆、补车计时、兵种队列、STAGE CLEAR 横幅、换关重写整张地图、GAME OVER 后重开、**最后一块的最后一个写周期** |
| `bram_stubs.v` | — | 所有 IP 的**行为模型**：地图 RAM / 关卡 ROM / 13 个贴图 ROM。地图 RAM 和关卡 ROM 的读延迟由 `BRAM_LATENCY` 宏控制（`xvlog -d BRAM_LATENCY_0/2/3`），贴图 ROM 固定返回 0（只测地址） |

**为什么 7 套 × 4 种延迟**：真实 BRAM IP 的读延迟不一定是 1 拍，扫描/命中/装载三条路径都写了“等几拍”，
必须证明逻辑与延迟无关。**28 组 = 7 套 × 延迟 0/1/2/3**。

---

## 5. 根目录的 `*.coe`（数据文件）

| 文件 | 由谁生成 | 说明 |
| --- | --- | --- |
| `map.coe` | `python pysrc\gen_levels.py` | 第 1 关展开后的 120×120 格（14400 项 + 补 0 到 19200），是地图 RAM 的**上电初值** |
| `levels.coe` | 同上 | 4 关的 30×30 块图（4×1024 项），换关时由 `level_loader` 展开 |
| `brick/steel/river/woods_16bit.coe` | `python img\imgconverter.py` | 20×20 地形贴图（16bit：最高位 alpha + RGB444） |
| `tank_16bit.coe` | 同上 | 玩家坦克 |
| `tank_fast/power/armor_16bit.coe` | 同上 | 三种敌方坦克 |
| `bullet_16bit.coe` | 同上 | 10×10 炮弹 |
| `headquarters_16bit.coe` / `headquarters_destroyed_16bit.coe` | 同上 | 基地金鹰 / 废墟 |
| `tank_destroyed1/2_16bit.coe` | 同上 | 爆炸两帧 |

颜色格式：`word[15]` = alpha（1 = 不透明），`word[11:0]` = `{R[3:0], G[3:0], B[3:0]}`。

---

## 6. 约束文件（`constrs_1/new/constr.xdc`）

* **引脚**：`clock=W5`（100MHz）、`reset`、`btn_up/down/left/right`、`btn_fire=U18`（BTNC）、
  `disp_RGB[11:0]`（Pmod VGA 的 RGB 各 4 位）、`hsync=P19`、`vsync=R19`；
* **位序**：`disp_RGB[11:8]=红 R3..R0`、`[7:4]=绿`、`[3:0]=蓝`，Pmod 每组引脚是“先 LSB 再 MSB”，
  **写反会让整屏变成“毒气黄绿”**（历史上踩过一次，见 `sim/README.md` 第三轮）；
* **时钟**：
  ```tcl
  create_clock -period 10.000 -name sys_clk_pin [get_ports clock]                 ;# 100MHz
  create_generated_clock -name vga_clk -source [get_ports clock] -divide_by 2 \
                         [get_nets vga_clk]                                        ;# 50MHz 像素时钟
  ```
  这两条缺了 Vivado 就**不做时序分析**，地形查询的长组合路径会抓错格子（表现为“空气墙”）。


---

## 7. 地图 / 字库工具（`pysrc/`）

| 脚本 | 用法 | 作用 |
| --- | --- | --- |
| `map_generator.py` | 被其它脚本 import | 地图核心库：`load_level()` 读 txt、`expand()` 块→格（'H' 块展开成“基地 4×4 + 2 格薄砖环”）、`validate()` 硬校验（基地契约 / 外壳是砖 / 出生点净空 / 全图连通 / 20×20 整车 BFS / 三个贴脸位置可达）、`print_ascii()` |
| `gen_levels.py` | `python pysrc\gen_levels.py` | **地图的入口**：读 `pysrc/maps/level*.txt` → 校验 4 关（任何一条不过就退出、不留半成品）→ 写 `levels.coe`（4×1024）和 `map.coe`（第 1 关的 120×120） |
| | `python pysrc\gen_levels.py --no-map` | 只更新 `levels.coe`（不动 `map.coe`） |
| `check_mif.py` | `python pysrc\check_mif.py` | 逐个 IP 比对 `.coe` 与 `.gen/.../<ip>.mif` 的**内容**（不是时间戳），并抽查基地外壳/出生点等关键格。输出 `RESULT: ALL MATCH` 才算过 |
| `_design_maps.py` | `python pysrc\_design_maps.py`（默认**只校验不写盘**） | 第十二轮的“砖墙迷宫”生成器；`--overwrite` 才会覆盖 `maps/level*.txt`（**会抹掉手工微调**，一般别用） |
| `font5x7.py` | 数据源 | HUD 的 42 个 5×7 字形（唯一真源） |
| `gen_font.py` | `python pysrc\gen_font.py` | 由 `font5x7.py` 生成 RTL 的 `sources_1/new/font5x7.v`（改字库只改 .py，再生成） |

**地图硬约束**（`gen_levels.py` 每次都会验，改地图时必须满足）：
1. 基地本体正好是格 `58~61 × 116~119`（= 20×20 金鹰包围盒），**贴着 600px 底边**；
2. 基地上/左/右各 2 格必须是砖/钢（薄砖环；下方是地图边界，不用墙）；
3. 玩家出生点 `(200,560)` 上下 ±60px、三个敌人出生点及其正下方 20px 必须空；
4. 全图 100% 可达、且 **20×20 车身整体 BFS** 能从出生点开到三个敌人出生点和基地三个“贴脸位置”；
5. 走廊 ≥2 块宽（40px），否则车身拐不进去、敌人 AI 会卡。

---

## 8. 贴图 / 预览工具（`img/`）

| 脚本 | 用法 | 作用 |
| --- | --- | --- |
| `sprites.py` | `python img\sprites.py` | 用 ASCII 画稿生成/修改各 sprite 的 PNG（敌人三兵种、基地、爆炸两帧等） |
| `imgconverter.py` | `python img\imgconverter.py` | 把 `img/*.png` 转成根目录的 `*_16bit.coe`（16bit：alpha + RGB444，含 FC 原版配色映射） |
| `preview.py` | `python img\preview.py` / `--level 2..4` / `--explosion` / `--hq-destroyed` / `--victory` / `--reversed` | **不上板看画面**：按 `map.coe`（或 `maps/levelN.txt`）+ 各贴图 coe + 字库离线渲染 800×600，输出 `img/preview*.png`（和板上同源数据，报告里的插图就是它） |

> `--reversed` 复现的是历史 bug（RGB 每组 4 位倒序 → 整屏黄绿），只用来对照。
> 改完地图/贴图/字库后建议跑一次 `preview.py`，比烧板快得多。

---

## 9. 仿真与构建脚本（`sim/`）+ **怎么跑 TB**

`sim/` 里只有 4 个文件（其余都是跑出来的中间产物，已被 `.gitignore` 忽略，可随时删）：

| 文件 | 作用 |
| --- | --- |
| `run_sim.ps1` | 一键跑仿真：`map.coe`/`levels.coe` → `map_mem.hex`/`levels_mem.hex`，再用 `BRAM_LATENCY = 0/1/2/3` 各编译运行 7 套用例，最后汇总并 `exit 1`（有任何一组没 PASS 时） |
| `build_all.tcl` | 一键重建比特流：补漏的源文件/IP → **重新 generate_target 所有 IP**（刷新 `.mif`）→ `.mif` vs `.coe` 时间戳铁律 → 清理/重跑陈旧 OOC → synth/impl/write_bitstream → 报告写 `sim/build_report.txt` |
| `README.md` | **变更史**（每一轮的现象/根因/修法/验证），出了问题先查这里 |
| `.gitignore` | 忽略 `xsim.dir/`、`*.log`、`*.wdb`、`*.hex`、`build_report.txt` 等 |

### 9.1 跑全部 28 组（最常用）

```powershell
cd sim
.\run_sim.ps1                 # 7 套 × 延迟 0/1/2/3，约 10~15 分钟
.\run_sim.ps1 -Latency 1      # 只跑“真实 IP 的 1 拍”这一轮（快 4 倍，改小东西时够用）
```

看什么：

* 屏幕上每组一行：`tb_terrain 1 30 0 PASS 30`（用例名 / 延迟 / 通过条数 / 失败条数 / 结果 / 下限）；
* 最后一行 **`ALL BRAM LATENCY CONFIGURATIONS PASSED`** 才算全绿；
* 每组的完整输出落在 `sim\tb_<名字>_latency_<n>.log`，`[FAIL]` 行会写清期望值和实际值；
* 任何一组 PASS 但条数小于下限也会被判失败（防止“整段用例被跳过”）。

### 9.2 只跑一套用例（调试用）

`run_sim.ps1` 没有“只跑一套”的开关，手动三步即可（**先确保 `sim\` 里有 `map_mem.hex` / `levels_mem.hex`**，
清理过 sim 目录后第一次要么先跑一次 `.\run_sim.ps1 -Latency 0`，要么用下面的片段转）：

```powershell
cd sim
# ① （可选）coe -> hex，bram_stubs 用 $readmemh 加载
function Convert-CoeToHex($coe, $hex) {
    $vals = @(); $in = $false
    foreach ($line in Get-Content -LiteralPath $coe) {
        if (-not $in) { if ($line -match 'memory_initialization_vector') { $in = $true }; continue }
        $vals += ($line -split '[,\s;]+' | Where-Object { $_ -ne '' })
    }
    Set-Content -LiteralPath $hex -Value $vals -Encoding ASCII
}
Convert-CoeToHex ..\map.coe map_mem.hex
Convert-CoeToHex ..\levels.coe levels_mem.hex

# ② 编译（13 个设计文件 + 桩 + 你选的那套 tb）
$src = '..\battle_city_fpga.srcs\sources_1\new'; $simsrc = '..\battle_city_fpga.srcs\sim_1\new'
$design = @('top.v','player.v','enemy_ctrl.v','vga.v','hud.v','font5x7.v','terrain_probe.v',
            'tank_block.v','map_bus.v','bullet-ctrl.v','fx_ctrl.v','stage_ctrl.v','level_loader.v') |
          ForEach-Object { Join-Path $src $_ }
$V = 'C:\Vivado\2021.1\bin'
& "$V\xvlog.bat" -d BRAM_LATENCY_2 @design (Join-Path $simsrc 'bram_stubs.v') (Join-Path $simsrc 'tb_terrain.v')

# ③ 精化 + 运行（-R 表示跑完就退出）
& "$V\xelab.bat" -debug typical tb_terrain -s sim_tb_terrain
& "$V\xsim.bat"  sim_tb_terrain -R
```

要点：

* `-d BRAM_LATENCY_2`（或 `_0` / `_3`；**不给就是 1 拍**）——改延迟必须**重新 xvlog**；
* 换用例只改最后两个文件名和 `xelab` 的顶层名（`tb_bullet` / `tb_enemy` / …）；
* 改了 RTL 之后必须重新 xvlog（`xsim.dir` 是增量目录，脚本会整目录删除；手动跑时自己清一下更保险）；
* `tb_terrain` 用 `force u_top.u_vga.hcount/vcount` 检查 VGA 坐标，别在别的 TB 里复用同名信号。

### 9.3 重建比特流

```powershell
C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace -source sim\build_all.tcl
```

* 产物：`battle_city_fpga.runs\impl_1\top.bit`（烧板用），报告：`sim\build_report.txt`（WNS/TNS/资源/功耗）；
* 脚本会先做 `.mif` 新鲜度检查：**任何 IP 的 `.mif` 比它的 `.coe` 旧就直接报错退出**（防“旧数据进比特流”）；
* 用 GUI 打开 `.xpr` 也能综合，但**不会**自动刷新 `.mif`、也不会做上面那条检查，改过贴图/地图时建议还是走这个脚本。

---

## 10. 六个必须知道的坑（都踩过，细节在 `sim/README.md`）

1. **`.coe` 不是比特流的数据源，`.mif` 才是**
   贴图/地图/关卡数据都在 `.coe` 里写，但综合时读的是 `battle_city_fpga.gen/sources_1/ip/<ip>/<ip>.mif`。
   只改 `.coe` 不重新 `generate_target` → 板上还是旧数据（历史上贴图、关卡 ROM 都中过招）。
   `build_all.tcl` 有“`.mif` 必须比 `.coe` 新”的铁律，`check_mif.py` 再查内容。

2. **`blk_mem_level` 的实际读延迟是 2 拍，而 `C_READ_LATENCY_A` 报 1**
   IP 的“原语输出寄存器”叠上 BRAM 自己的 `DOA` 寄存器就是 2 拍。`level_loader` 因此**等 3 拍再采样**
   （地址与 ROM 输出在等待期保持，0/1/2/3 拍延迟都成立）。以前只等 1 拍 → 每个块拿到上一块的数据
   → 整张地图右移 4 格、基地只剩半个 H 被展开。

3. **`bram_stubs.v` 的读延迟必须“跟 `BRAM_LATENCY` 走”**
   关卡 ROM 的桩曾经写死 1 拍，于是 28 组仿真**根本覆盖不到**上面那个 2 拍的坑。
   现在地图 RAM + 关卡 ROM 都受 `-d BRAM_LATENCY_n` 控制，改桩时别退回固定延迟。

4. **“基地契约”有五处实现/校验，改几何要一起动**
   `level_loader.v`、`pysrc/map_generator.expand()`、`pysrc/gen_levels.expand_cells()` 三份实现，
   加上 `map_generator.validate()` 和 `tb_terrain` T15/T17 两份校验。只改一半就会出现
   “预览是新的、板子是旧的”或者 `鹰`/`窗口` 对不上。

5. **`pysrc/maps/level*.txt` 是手工维护的真源**
   `_design_maps.py` 是旧版生成器（加了 `--overwrite` 守卫）。想改地图请直接编辑 txt，
   然后 `python pysrc\gen_levels.py` 让脚本校验并生成 coe。

6. **改地图会牵动几个位置敏感的用例**
   `tb_terrain` T06/T07（关卡 1 的河在块行 8~9、浅滩位置）、`tb_enemy` E14/E15（渡河）、
   `tb_stage` S01k（格 (1,33) 是河）/ S05e（关卡 2 格 (9,17) 是钢板）。
   改这些位置时要么保留，要么同步改测试台。

---

## 11. 坐标 / 尺寸速查

| 单位 | 大小 | 换算 |
| --- | --- | --- |
| 像素 | 800×600（左 600 玩区 + 右 200 HUD） | 坦克 20×20、贴图 20×20、炮弹 10×10 |
| 格（cell） | 120×120 | 1 格 = 5×5 像素；坦克 = 4×4 格；炮弹 = 2×2 格 |
| 块（block） | 30×30（= `maps/level*.txt` 一个字符） | 1 块 = 4×4 格 = 20×20 像素 |

常用常量：玩家出生 `(200,560)`＝格(40,112)、敌人出生 `(40,0)/(300,0)/(560,0)`、
基地本体 格 `58~61 × 116~119` = 像素 `290..309 × 580..599`（精灵 `HQ_X0/HQ_Y0 = 290/580`）、
敌人进攻目标 `(300,590)`、玩区底边 = 格行 120。

地形编号：`0` 空 / `1` 砖 / `2` 钢 / `3` 河 / `4` 树（可通行、遮挡）/ `5` 基地。

---

## 12. 改动 → 要跑什么（速查）

| 改了什么 | 必须跑 |
| --- | --- |
| RTL（`.v`） | `cd sim; .\run_sim.ps1` → `vivado -source sim\build_all.tcl` → 烧 `runs\impl_1\top.bit` |
| 测试台 / 桩 | `cd sim; .\run_sim.ps1`（改断言数后记得同步 `run_sim.ps1` 里的 `Min`） |
| 贴图 PNG | `python img\imgconverter.py` → `build_all.tcl` → `python pysrc\check_mif.py` → 烧板（可选 `preview.py`） |
| 地图 `maps/level*.txt` | `python pysrc\gen_levels.py` → `run_sim.ps1` → `build_all.tcl` → `check_mif.py` → 烧板（可选 `preview.py`） |
| 字库 `font5x7.py` | `python pysrc\gen_font.py` → `build_all.tcl` |
| 约束 `constr.xdc` | `build_all.tcl`，看 `sim\build_report.txt` 的 WNS/WHS 是否仍为正 |
| 只改参数（`top.v` 的 parameter） | 同 RTL |

---

## 13. 当前状态（2026-11-17 最后一轮实测）

| 指标 | 值 |
| --- | --- |
| 仿真 | 7 套 × 延迟 0/1/2/3 = **28/28 全绿**（tb_terrain 30 · bullet 88 · enemy 67 · combat 34 · hud 41 · fx 30 · stage 67） |
| 时序 | WNS **+0.275 ns**、WHS +0.029 ns、0 违例（`All user specified timing constraints are met`） |
| 资源 | LUT 5208（25.04%）、FF 1831（4.40%）、BRAM 11（22%）、DSP 34（37.78%）、IOB 21（19.81%） |
| 功耗 | 0.126 W（动态 0.054 / 静态 0.072），结温 25.6 ℃ |
| 比特流 | `battle_city_fpga.runs\impl_1\top.bit`（2026-11-17 10:01:15，2,192,111 字节） |
| 地图 | 4 关，砖+钢 22.6% / 25.0% / 16.7%(+树 9.9%) / 20.1%，下 1/3 都在 24~29%，四关 100% 可达 |
