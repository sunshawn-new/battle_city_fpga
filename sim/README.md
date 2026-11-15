# sim —— 仿真与构建脚本（xsim）

这里的东西**不参与综合**（不在工程的 sources 里），只用来在没有板子的情况下
验证坦克移动、地形碰撞和炮弹逻辑。

## 文件

| 文件 | 作用 |
| --- | --- |
| `tb_terrain.v` | 地形测试台：24 条断言，覆盖四方向移动、砖/钢/河/树林/基地/切角/河与浅滩、**坐标永远在 5px 格点上**、以及**地图契约**（基地本体 8x6 必须正好在格 (56,112)、出生点净空） |
| `tb_bullet.v` | 炮弹测试台：88 条断言，覆盖发射/冷却/飞行/命中/打砖洞（20x10）/出界/对象池/总线仲裁/贴墙开火/连续打洞/打中基地（`base_hit` 单拍），以及本轮新增的**敌人开火 / 打中坦克 / 友军不误伤 / 弹对弹同归于尽 / 每发射者同屏 1 发 / GAME OVER 冻结** |
| `tb_enemy.v` | 敌方坦克测试台：38 条断言，覆盖出生点/兵种（`e_type`）/整格移动/三个 probe 不串台/撞墙转向/4 客户端抢总线/长跑不压墙，以及**兵种速度（200/400/600 拍）、开火周期（6/4/8 节拍）、装甲挨两发、击毁脉冲、GAME OVER 冻结** |
| `tb_combat.v` | 关卡流程测试台：28 条断言，覆盖生命 3→0、复活回出生点、复活无敌、命耗尽/基地被打爆 -> GAME OVER、分数 100/200/300、**本关打完的 STAGE CLEAR 横幅一路接到 HUD**，以及**击毁 -> 爆炸开在坦克位置 / 6 个相位后自动释放**、**玩家中弹 -> 爆炸开在死亡位置（不是复活点）** |
| `tb_hud.v` | 侧栏测试台：38 条断言，覆盖 x=600 边界、面板底色/2px 分界线、标题/关卡/标签字形真的画出来、**字形 2 倍放大的亮/暗像素**、分数/生命数字随状态变化、敌人图标的位置/兵种、**`ENEMY nn` 剩余数两位十进制**、GAME OVER / STAGE CLEAR 横幅，以及**爆炸图层的包围盒/ROM 地址/帧选择**（H13） |
| `tb_fx.v` | 爆炸特效测试台：30 条断言，覆盖 4 个槽的**同拍多请求分配**（3 敌 + 玩家全死不丢帧）、坐标绑定、6 个相位的**两帧切换点**（相位 2/3 边界）、**满池丢弃**（不覆盖正在放的爆炸）、放完自动释放 + 复用、放到一半复位、两个槽相位互不干扰 |
| `tb_stage.v` | 关卡与波次测试台：43 条断言，覆盖**开局排一屏 3 辆（F/P/A）**、击毁后**等计时器到点才补车**、兵种队列、**本关打完 -> STAGE CLEAR 横幅 + 暂停**、**换关时把整张地图重写成第 2 关**（河道/钢板/基地台座/右下角最后一格逐格对照）、新关开局（玩家回出生点 + 敌人重新排屏）、**GAME OVER 后不再补车**、**打完第 4 关回到第 1 关** |
| `bram_stubs.v` | `blk_mem_gen_0`（地图）、`blk_mem_level`（关卡块图）和 12 个贴图 ROM（含 `blk_mem_bullet` / `blk_mem_headquarters` / 3 种兵种 / `blk_mem_hq_destroyed` / 爆炸两帧 `blk_mem_tank_destroyed1|2`）的行为级模型 |
| `run_sim.ps1` | 一键跑仿真：把 `map.coe` / `levels.coe` 转成 hex、用 4 种 BRAM 读延迟各编译运行全部 7 套用例 |
| `build_all.tcl` | 用工程流重新 synth + impl + 生成 bit，并把报告写到 `build_report.txt` |
| `add_bullet_ip.tcl` | 一次性脚本：把 `terrain_probe.v`/`map_bus.v` 和 `blk_mem_bullet` IP 并进工程 |
| `add_hq_ip.tcl` | 一次性脚本：新建 `blk_mem_headquarters` IP，并让坦克 ROM 重新读新的金色 coe |
| `add_enemy_ctrl.tcl` | 一次性脚本：把 `enemy_ctrl.v` 并进工程 |
| `add_tank_types_ip.tcl` | 一次性脚本：新建 4 个 ROM IP（`blk_mem_tank_fast/power/armor`、`blk_mem_hq_destroyed`）并挂进 `sources_1` |
| `_run_build.ps1` / `_run_one.ps1` / `_quick.ps1` | 临时：后台跑一次完整构建 / 单个测试台 / 转地图+单个测试台（命令行有 30s 超时，长任务只能这样跑） |
| `probe_ckpt.tcl` / `probe2_ckpt.tcl` | 排查用的一次性脚本（在已布线的 dcp 上查网表/时钟） |

## 炮弹系统（bullet_ctrl + map_bus + vga 图层）

```
                 ┌──────────────┐  req/addr/gnt
 top: player ───►│ terrain_probe│──────┐
                 └──────────────┘      │   ┌─────────┐        ┌──────────────┐
                 ┌──────────────┐      ├──►│ map_bus │───────►│ blk_mem_gen_0│ Port A
 btn_fire ──────►│ bullet_ctrl  │──────┘   └─────────┘        │  (地图 160x120)│
                 └──────┬───────┘  读命中 / 写砖块=0            └──────┬───────┘
                        │ b_valid/x/y/dir                             │ Port B
                        └────────────────► vga（树林 > 炮弹 > 坦克 > 地形）◄┘
```

* **对象池**：`act[]` 位图 + `free_mask & (~free_mask+1)` 取最低位空槽，
  分配/回收都只是置/清一位，没有任何搜索循环（`x/y/dir/last_cell` 是 SoA 数组）。
* **移动**：所有槽并行，每个 `SPEED_DIV`（板上 250000 → 400Hz，坦克 25Hz 的 16 倍）走 1 像素。
* **命中判定（网格原生）**：11 状态串行引擎时间复用 2 个 `div5`（DSP48E1）。
  `player.v` 保证坦克坐标永远是 `TILE=5` 的整数倍，炮口坐标因此也是，10x10 的
  炮弹正好压在 **2x2 格**上，所以判定 = 「弹体压着的 4 格里有任何一格是砖吗」，
  而不是只看弹心那一个像素所在的格。只有这 4 格的组合变了才去读 BRAM
  （`last_cell[]` 存 `{box_cx, box_cy}` 去重）。
  砖块 → 写 0 打掉 4 格宽 x 2 格深的洞；钢/河 → 消失；
  基地 → 消失 + 单拍 `base_hit` 脉冲（`top` 锁存后基地变废墟，见下面“基地”一节）；
  空地/树林 → 穿过。
* **生成当拍也立刻扫一次**：贴着砖墙开火时弹体的下半截就压在砖里（炮口坐标 =
  坦克上边 - 10），必须当拍判掉，否则子弹会从砖里“穿”出去。
* **打砖洞 = 20x10 像素，和坦克的脚下一格不差**：炮口在坦克正中的那条边上，
  `div5(炮口)` 正好是“坦克这条边往里第 1 格”，于是
  竖直飞清 列 `box_cx-1..box_cx+2`（= 坦克那 4 列）x 行 `box_cy,box_cy+1`（= 弹体那 2 行），
  水平飞清 行 `box_cy-1..box_cy+2`（= 坦克那 4 行）x 列 `box_cx,box_cx+1`（= 弹体那 2 列）。
  两种形状都是 8 格，逐格读回来只对砖写 0（钢墙原样保留），地址是当场算出来的、不做累加。
  因为洞正好是坦克的截面，坦克每发能往前推进 2 格（10 像素），不会剩一列残砖把它卡在洞口。
* **共享 Port A**：`map_bus` 是窗口式（非抢占）仲裁，地形查询优先；
  炮弹的读-判定-写砖都在同一个窗口内完成，所以 BRAM 读延迟 0~3 拍都不影响结果。

## 敌方坦克（enemy_ctrl + 每车一个 terrain_probe）

```
                          p_req[0]
 top: 玩家    ──► terrain_probe #0 ──┐
 top: enemy0  ──► terrain_probe #1 ──┤  p_req / p_addr       ┌─────────┐      ┌──────────────┐
 top: enemy1  ──► terrain_probe #2 ──┼──────────────────────►│ map_bus │─────►│ blk_mem_gen_0│ Port A
 top: enemy2  ──► terrain_probe #3 ──┤                       └─────────┘      └──────────────┘
 btn_fire     ──► bullet_ctrl     ──┘
 
 enemy_ctrl ◄── terrain_front[4N] / terrain_valid[N]   （每车一份）
      │ e_valid / e_x / e_y / e_dir / e_type
      └──────► vga（坦克图层 = 玩家 + N_E 个敌人，各自选自己的贴图 ROM）
```

* **和玩家同一条不变量**：每个移动节拍走一整格（TILE = 5 像素），坐标永远是
  5 的倍数。所以每辆车都能直接用 `terrain_probe`（不是复制一份状态机），
  以后“炮弹打坦克 / 坦克互斥”也只是两个 20x20 包围盒的比较，不用处理半格。
* **节拍**：`MOVE_DIV` 取玩家的 2 倍 → 12.5Hz（玩家 25Hz），三辆车相位错开
  `STEP/(4*N_E)`，不会同手同脚。`PHASE` 必须 ≤ `STEP-150`：第一次节拍发生在
  `STEP-PHASE` 拍之后，复位后得先留够一拍时间让 4 个 probe 各扫一遍。
* **AI（简单但不会失控）**：前面能走就直行；前面是墙就转 90°（左/右由 16 位
  LFSR 决定，另有 1/4 概率直接掉头 —— 掉头方向刚走过、一定通，这是
  “贴着墙来回滑出不来”的保底出口）；每 `TURN_TICKS` 拍再随机拐一下，
  看起来像在巡逻而不是一条直线机器人。
* **渲染**：坦克地址仍然只有一份（`tank_addr_mux`，重叠时玩家优先），但像素来自
  4 个 ROM —— `blk_mem_player_tank` + `blk_mem_tank_fast/power/armor`。
  兵种是 `enemy_ctrl` 的常量输出 `e_type`（每位 2 bit），`vga` 在“出像素”那层
  按 `tank_type_sel_d1` 选一张。旧的 `enemy_tint()` 三个换色常量已经删了。
* **还没做**（下一步）：坦克互斥、炮弹打敌人、敌人开火、被击毁/复活、分波次出生。
  兵种现在只差“贴图以外的差异”：三辆车共用同一套移动节拍/AI，速度和血量还没分开
  （要加的话从 `enemy_ctrl` 的 `MY_TYPE` 旁边再引一对 `e_speed/e_hp` 就行，VGA 不用动）。
  `e_valid` 已经是“每位一车”（`enemy_ctrl` 里的 `alive` 寄存器），
  以后被打中就把对应位清 0，VGA 立刻不画它、它的 probe 也不再抢总线。

## 兵种贴图 + 基地可被摧毁

### 三种敌人：`e_type` + 4 个贴图 ROM

```
 enemy_ctrl                       vga
  gi=0 -> T_FAST  (00) ──┐    ┌── blk_mem_tank_fast   (tank_fast_16bit.coe)
  gi=1 -> T_POWER (01) ──┼───►├── blk_mem_tank_power  (tank_power_16bit.coe)
  gi=2 -> T_ARMOR (10) ──┘    ├── blk_mem_tank_armor  (tank_armor_16bit.coe)
                              └── blk_mem_player_tank (tank_16bit.coe)
      e_type[N_E*2] ─────────────► tank_type_sel -> 打一拍 -> 选像素
```

* 兵种按**出生点**分配（左=快速 / 中=火力 / 右=装甲），不用随机数：
  三张图一上电就同屏可见，接没接对一眼就看出来（`tb_enemy` 的 E00h~j 也钉住了这点）。
* 4 个 ROM 共用同一条地址 `tank_addr_mux`（旋转/翻转规则完全一样），地址逻辑不增加；
  代价只是 4 份 512x16 单口 ROM（合起来 2 个 BRAM36）。
* **时序**：`tank_on` / `tank_is_enemy` / `tank_type_sel` 一起打一拍，再拿打拍后的
  兵种去 mux 本拍才从 `douta` 出来的像素 —— 正好对齐 ROM 的 1 拍读延迟，
  坦克边缘不会闪出“邻居兵种”的颜色。
* **CDC**：坐标/朝向/兵种这些信号都是 sys 域寄存器，vga 域只读。直接在 vga 域里
  用它们的话，sys 域寄存器会经减法器、比较器一路打到 4 个坦克 ROM 的地址口，
  时序报告里 `sys_clk_pin -> vga_clk` 那条最紧的路径（route 占 75%）就是它。
  现在 `vga.v` 里先把 `position_x/y`、`player_direction`、`enemy_x/y/dir/valid/type`、
  `bullet_x/y/dir/valid`、`hq_destroyed` 各打一拍（单级同步）再参与几何运算，
  跨域只剩“FF -> FF”的走线，地址由 vga 域寄存器驱动。
  这些量都是准静态的（位置 12.5~25Hz 更新、基地被打爆后永久不变），
  所以画面不延迟：坐标最多晚 1 个 vga_clk（20ns，远小于 1 像素）被看到。
* 新旧对比：以前是 `tank.png` + `enemy_tint()` 三个常量换灰（三辆车全灰，
  换一次玩家配色就得同步常量）。现在是独立贴图，`vga.v` 里没有任何颜色常量。
* `img/preview.py` 同步改了：敌人按 `ENEMIES` 里的兵种名取图，
  所以 `img/preview.png` 和板子上看到的一致。

### 基地：`base_hit` -> `base_alive` -> `hq_destroyed`

```
 bullet_ctrl: 读到 tile_id == 5 -> 炮弹消失 + base_hit（单拍）
                                          │
 top:  base_alive <= 1'b0（reset 置 1，打中后永久 0）  <- game-over 状态
                                          │
 vga:  hq_destroyed = ~base_alive -> 基地图层在两份 ROM 里二选一：
         blk_mem_headquarters   金鹰（headquarters_16bit.coe）
         blk_mem_hq_destroyed   白旗 + 断杆 + 碎石（headquarters_destroyed_16bit.coe）
```

* `base_hit` 做成**单拍脉冲**：手炮打中基地后炮弹当拍消失，但下一拍如果还有别的
  炮弹压在基地上（贴脸连射），也不会把状态机再触发一遍；`top` 里的 `base_alive`
  是唯一的系统状态，一次锁存到底（本工程没有“重开一局”）。
* `T_BASE` 从“和钢/河共用一个分支”里拆出来，单独一个分支：其他不可通行格子是
  “炮弹消失、地图不变”，基地是“炮弹消失、地图不变、`base_hit` 拉高一拍”。
* 为什么不继续用换色：废墟不是“金鹰变灰”，而是白旗 + 断杆 + 碎石，形状都变了。
  两张图都是 512x16、地址规则相同，所以 `vga.v` 里只是同一个 `hq_addr` 挂两个
  ROM、出像素时按 `hq_destroyed_q` 二选一（同样先打一拍再进 mux，和坦克一致）。
* 覆盖：`tb_bullet` 的 B19a~d（打中基地 → `base_hit` 恰好一拍、`b_valid` 清零、
  地图里 `tile_id == 5` 不被改写、之后的炮弹仍然能打砖）；
  `img/preview.py --hq-destroyed` 可以离线看废墟那一帧（`img/preview_destroyed.png`）。

## 地图：关卡文件 -> `map.coe` + `levels.coe`

地图是画出来的，不是手写的 19200 个数：

```
pysrc/maps/level1..4.txt   30 列 x 30 行 ASCII，一个字符 = 1 块
        │                  '.' 空  '#' 砖  'S' 钢  '~' 河  'T' 树  'H' 基地
        │  python pysrc\gen_levels.py
        ├──► map.coe       第 1 关展开后的 120x120 格 -> blk_mem_gen_0（地图 RAM 的上电初值）
        └──► levels.coe    4 关的 30x30 块图 -> blk_mem_level（换关时由 level_loader.v
                           展开成 14400 格写回地图 RAM，见“第九轮”）
```

坐标系（三套，别混）：

| 单位 | 大小 | 换算 |
| --- | --- | --- |
| 像素 | 800x600（左 600 是玩区、右 200 是 HUD） | 坦克 20x20、贴图 20x20 |
| 格 | 120x120 | 1 格 = 5x5 像素；坦克 = 4x4 格 |
| 块（关卡文件里一个字符） | 30x30 | 1 块 = 4x4 格 = 20x20 像素 |

块 `(bx, by)` 覆盖格 `x = 4bx..4bx+3`、`y = 4by..4by+3`，即像素 `(20bx, 20by)` 起的
20x20 方块 —— 墙厚正好一块，贴图不会被切断；炮弹打掉 20x10 刚好半块。

`gen_levels.py` 会对每一关跑完整的校验，不通过就退出、不留半成品：

1. 基地本体必须**正好**是格 `列 56~63 x 行 112~117`（8x6）。因为 `vga.v` 的
   `HQ_X0/HQ_Y0 = 290/565` 是按这个包围盒写死画精灵的；整张图不许有第二处 tile 5。
2. 玩家出生点 `(300,300)` 及上下各 60px 的通道必须空（否则一开局就“空气墙”）。
3. 三个敌人出生点 `(40,10)/(300,10)/(560,10)` 及其正下方 20px 必须空。
4. 从玩家出生点 BFS：三个敌人出生点、基地堡垒左上/右上/上方都要能走到
   （否则关卡是死的）。
5. 硬件展开规则（`level_loader.v` 那套“块 -> 4x4 格、'H' 块补砖”）必须和
   `map_generator.expand()` 逐格一致 —— 两边各算一遍再比对。

```powershell
python pysrc\gen_levels.py               # 校验 4 关 + 重写 levels.coe 和 map.coe（第 1 关）
python pysrc\map_generator.py --ascii     # 只在终端打印第 1 关，看对称/留白
python img\preview.py                     # 渲染 img/preview.png 看实际画面
```

> **测试台不再绑定地图内容。** `tb_terrain` 分成两类用例：
> 真地图契约（T15 基地 8x6 位置 + T16 出生点净空，改地图时依然必须成立）、
> 以及“先 `clear_map` 再 `poke` 地形”的碰撞用例（T08~T12：砖/钢/河/树怎么挡）。
> 改关卡只需要重跑 `run_sim.ps1`，不用改任何期望值。

## 跑仿真

```powershell
cd sim
.\run_sim.ps1          # 需要 xvlog/xelab/xsim 在 PATH 里，或装过 Vivado
```

脚本会做三件事：

1. 把工程根目录的 `map.coe` / `levels.coe` 转成 `map_mem.hex` / `levels_mem.hex`，
   `bram_stubs.v` 用 `$readmemh` 加载 —— 仿真的就是板子里那两张真表，所以地形/换关
   用例的期望值能和上板行为对上（`tb_bullet` 开始时会把整张地图清 0，自己 `poke`
   需要的格子，与 `map.coe` 无关）。
2. 用 `-d BRAM_LATENCY_0/2/3`（不加宏就是真 IP 的 1 拍）分别编译运行
   `tb_terrain` / `tb_bullet` / `tb_enemy` / `tb_combat` / `tb_hud` / `tb_fx` / `tb_stage`。
   这样能证明 `map_bus` + 扫描引擎不依赖 BRAM 的具体读延迟（`xvlog` 在这个版本里不支持
   `-d NAME=VALUE`，`=VALUE` 会被当成文件名，所以用宏名来选值）。
3. 打印 `PASSED/FAILED` 汇总；任何一个配置不是 24/88/38/28/38/30/43 全过就以退出码 1 结束。

仿真里参数都改小了以加速：`top` 的 `MOVE_DIV` = 200（板上 4_000_000）、
`SPEED_DIV` = 64、`COOLDOWN` = 200、`DB_MAX` = 4、`FX_DIV` = 8（板上 8_000_000，
爆炸每个相位 80ms）。`tb_fx` 更直接：直接实例化 `fx_ctrl`，`FX_DIV` = 8。
`tb_stage` 还把关卡参数压到 `ENEMIES_PER_STAGE` = 4、`SPAWN_CYCLES` = 400 拍、
`CLEAR_CYCLES` = 60 拍（板上 20 辆 / 3s / 2s），一套用例 34 万拍就能把
“开局 -> 补车 -> 全灭 -> STAGE CLEAR -> 装载下一关 -> 循环”跑完。
注意 `SPEED_DIV` 必须大于一次扫描的耗时（4 格 ≈ 28 拍），否则两次扫描会叠在
一起，“没换格就不读地图”的去重就测不准。
坦克仍然是【整格移动】：`tb_terrain` 的 `step_ticks(n)` 表示“走 n 像素”，
内部换算成 `n/5` 次节拍，所以断言里的像素级期望值不变。

## 重新构建 bit

```powershell
C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace -source sim\build_all.tcl
```

结果：`battle_city_fpga.runs/impl_1/top.bit`，报告在 `sim/build_report.txt`
（含 WNS/TNS/WHS、时序摘要、资源占用、以及扫描状态机那几条关键路径）。

### 改贴图 / 改颜色之后必须重新生成 IP

贴图内容不是 Verilog，而是 IP 的初始化文件（`.coe -> .mif`）。所以流程是：

```powershell
python img\imgconverter.py      # 1. png -> *_16bit.coe（RECOLOR 表在这里）
# 2. 用 vivado -mode batch 跑 sim\build_all.tcl（脚本开头会自动 reset_target +
#    generate_target 所有 IP，再 update_compile_order）
```

想先看颜色对不对、又不想每次烧板，可以离线渲染一帧（用同一批 `.coe`）：

```powershell
python img\preview.py            # -> img/preview.png
python img\preview.py --reversed # -> img/preview_reversed.png（复现旧位序的黄绿 bug）
```

`preview.py` 照抄 `vga.v` 的取样规则：5x5 一格、贴图 20x20 平铺、
树林/炮弹/坦克的图层顺序与 alpha 判断、基地鹰的 390/565 包围盒。
注意它渲染的是 **`.coe` 里的数据**，所以能区分“数据错（调色板/ROM）”
和“数据对但屏幕不对（引脚位序）”——后者要靠 `--reversed` 才能看见。

只用 GUI 重新综合是不够的：IP 目录里的 `.mif` 还是旧的，画面颜色不会变。
`build_all.tcl` 里为此踩过两个坑，脚本已经处理：

| 坑 | 现象 | 处理 |
| --- | --- | --- |
| `reset_target` 会把 IP 的输出产物从文件集里摘掉 | synth 报 `module 'blk_mem_xxx' not found` | 之后补 `update_compile_order -fileset sources_1` |
| `blk_mem_bullet` / `blk_mem_headquarters` 是 OOC IP，顶层用的是它们的 `.dcp` | 同上，而且 `update_compile_order` 也救不回来 | 把它们的 OOC 综合补跑（`reset_run/launch_runs <ip>_synth_1`），再把 `.dcp` 用 `add_files` 挂回 `sources_1` |

> XDC 的一个坑：**`set_property` 后面不能跟 `# 行尾注释`**。Tcl 只把“行首”或
> “`;` 之后”的 `#` 当注释，行尾的 `#` 会被当成多余参数 —— 综合时刷 12 条
> `CRITICAL WARNING: [Common 17-161] Invalid option value '#' specified for 'objects'`，
> 而且**整条引脚约束被丢弃**（引脚全变未约束，很可能出一个颜色/线序错位的 bit，
> 而不是报错）。注释要么单独写一行，要么写成 `; # 注释`。


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

修完之后（2026-11-13，xc7a35tcpg236-1），地形查询已经不再是关键路径。
再叠加炮弹系统、打砖洞、基地贴图之后，最后一次 impl 的结果
（2026-11-13 19:36，含 VGA 引脚位序修正 + 新调色板）：

```
WNS = +0.385 ns   TNS = 0.000   WHS = +0.144 ns   THS = 0.000    (0 条违例)

sys_clk_pin            : WNS +1.245 ns  (888 endpoints)   PW 4.500 ns
vga_clk (50 MHz, 2 分频) : WNS +6.612 ns  (396 endpoints)
sys_clk_pin -> vga_clk : WNS +0.385 ns  ( 34 endpoints)   ← 现在最紧的一条（坦克/炮弹坐标进 VGA）
vga_clk -> sys_clk_pin : WNS +8.228 ns  (  1 endpoint )

Slice LUT 956 / 20800 (4.6%)   FF 429 (1.0%)   BRAM 7.5 tile / 50   DSP 10 / 90
```

（换调色板不影响逻辑；引脚位序调整只是让布线换了个布局，`sys_clk_pin -> vga_clk`
从 +0.299 ns 变成 +0.385 ns。）

相对加炮弹之前的基线（LUT 537 / FF 178 / DSP 8 / BRAM 6.5 tile），这套东西大约
**+421 LUT、+251 FF、+2 DSP、+1 个 BRAM tile**（炮弹 ROM 512x16 和基地 ROM
512x16 各占 1 个 RAMB18），逻辑主要花在“每槽一组 10 位坐标 + 15 位 `last_cell`
+ 4 选 1 mux”、打砖洞的地址生成，以及 VGA 的四套旋转地址上。
（改成“按 4 格判定”之后只多了 19 个 LUT —— `div5` 的第二份乘法被 Vivado 合并到
同一批 DSP48E1 里了，DSP 数量没变。）

顺带一提：`div5()` 的乘法被 Vivado 映射成 `DSP48E1`，所以逻辑资源反而比最初
（1390 LUT、无 DSP）少了很多。

### 一个只有综合才会暴露的坑：`last_cell[]` 多驱动

第一版把 `last_cell[chk_idx] <= {cx_c, cy_c}` 直接写进扫描状态机，而 `last_cell[]`
的开机初值和发射赋值在对象池那个 `always` 块里 —— 同一个 reg 数组被两个
`always` 驱动。**xsim 里 27 条断言全过，但综合报 164 个 CRITICAL WARNING
（Synth 8-6858 / 8-6859 multi-driven）**，硬件上其中一路驱动会被直接丢掉，
`last_cell` 永远不更新，去重优化等于失效（功能还“对”，但总线流量翻几倍）。

改法：状态机只发单拍脉冲 `mark_pulse / mark_idx / mark_cell`，由对象池那一块
统一落盘（和 `kill_pulse` 一个套路）。改完综合 **0 error / 0 critical warning**。

> 经验：一个 reg 数组只能有一个 `always` 块在写；跨块传递状态就发脉冲。
> 而且“仿真通过”不等于“综合没问题”，`build_all.tcl` 里的 critical warning
> 数量要一起看。

## 上板后修掉的三个问题（2026-11-13）

上板实测暴露的三个现象，根因都不在仿真覆盖范围内（仿真里贴图 ROM 的桩恒输出 0，
速度参数又都改小了），所以都是“看画面 + 量时序”才发现的：

| 现象 | 根因 | 修法 |
| --- | --- | --- |
| 坦克是一块黑方块 | `vga.v` 合成坦克图层时只看 `tank_valid_d1`，没看贴图最高位（alpha），101 个透明像素被当成 `0x000` 画上去 | 加 `&& player_pixel[15]`（炮弹/树林两层本来就判了，只有坦克漏了） |
| 坦克、炮弹都太快（约 4 倍） | `MOVE_DIV=400_000`（250Hz）≈ 12.5 个车身/秒；原来以为“屏幕宽 800 像素所以慢”，但按**车身长度**算是原版的 4 倍 | `MOVE_DIV = 1_600_000`（62.5Hz ≈ 3.1 车身/秒）、`SPEED_DIV = 400_000`（250Hz，仍是坦克的 4 倍），整个画面一起放慢，比例不变 |
| 一发炮弹只打掉 1 格砖 | `C_DEC` 里只写当前格 | 改成 `C_CHOP/C_CHOPW/C_CHOPD` 循环，把正面 20x5（4 格）逐格读回来、只对砖写 0 |

> 经验：判断“快不快”要用**物体自身尺寸**做单位（车身/秒），不要用“横穿屏幕要几秒”；
> 这张图是 800x600 / 160x120 格，横向 40 个车身，天生比原版 13 格宽得多。

顺带把基地从“白色+黄色的格子拼贴”换成了 `headquarters.png` 的鹰：
`blk_mem_headquarters`（512x16）由 `img/imgconverter.py` 生成的
`headquarters_16bit.coe` 初始化，`vga.v` 里用固定 20x20 的包围盒居中画在基地
8x6 格（40x30 像素）区域中间，不透明像素才画（同样是 alpha 判断）。
玩家坦克同时换成黄色涂装（`imgconverter.py` 里的 `RECOLOR` 表，
`#A0A0A0 → #F8D030` / `#404040 → #A06800` / `#000000 → #381800`）。
当时归因于“原画三种灰在 4bit/通道 量化后太接近黑”，
其实真凶是下面“第三轮”的引脚位序 bug —— 它会把 `0x8` 打成 `0x1`，
比 4 位量化本身狠得多。

## 第二轮修复：炮弹穿砖 / 偏心洞口 / 打完砖坦克进不去（2026-11-13 晚）

上板后的四个现象，根源是同一个：**判定和打洞都是按“弹心那一个像素”算的**，
而坦克又停在非格点的坐标上（当时是 1 像素步进，x 可以是 403 这种值）。

| 现象 | 根因 | 修法 |
| --- | --- | --- |
| 贴着砖开火，炮弹直接穿过去 | 命中只采样弹心所在的 1 格；弹体侧面压着砖、中心线却从缝里过就一直不判定 | 改成判定**弹体压着的 2x2 格**（4 格逐格读），任何一格是砖就命中 |
| 洞口偏心 / 阶梯状缺口 | `chop_base = cy*160 + cx - 2` 用弹心反推，而弹心随坦克的非格点坐标每 5px 跳一格 | 坦克改成**整格移动**（坐标永远是 5 的倍数），洞直接按 `box_cx/box_cy` 算，不再反推 |
| 打完一发，坦克卡在洞口进不去 | 洞只有 1 格深（5px）、且横向差一列（清的是列 81..84，坦克占列 80..83，最左一列没清） | 洞改成 **4 格宽 x 2 格深 = 20x10**，横向正好是坦克那 4 列，坦克每发能前进 10px |
| 坦克太慢 | `MOVE_DIV = 1_600_000` → 62.5 像素/秒（只有 3 个车身/秒，原版约 6 个） | `MOVE_DIV = 4_000_000`，整格移动 → 125 像素/秒；炮弹同步提速 `SPEED_DIV = 250_000`（400Hz），冷却 0.2s |
| 砖墙/树林颜色不对 | 原画是纯红+纯白灰缝、荧光黄绿树林 | `imgconverter.py` 的 `RECOLOR` 整套往 FC 原版靠（见下表）；透明像素保持透明 |

> 关键教训：**像素级物理（1px 步进 + 按弹心取整）和格点地图天生不匹配**。
> 只要把“坦克永远站在格点上”做成不变量，命中、打洞、碰撞三处都能退化成
> “查那几个格子”，既没有半格误差，也没有阶梯状缺口。
> `tb_terrain` 的 T14 就是在守这个不变量。

顺带一提，`build_all.tcl` 现在会先 `reset_target/generate_target` 所有 IP，
因为贴图颜色是 IP 的 `.coe` 决定的 —— 只改 `coe` 不重新生成 IP，综合会用旧数据。

## 第三轮：整屏发“毒气黄绿” —— 每通道 4 位被接反了（2026-11-13 深夜）

现象：砖洞修好之后上板，画面整体泛黄绿 —— 砖墙/边框变成荧光黄绿、基地金鹰变成橙色，
可河流还是正常的蓝、树林还是深绿。看着像调色板选错了，实际是**引脚位序**。

根因：`vga.v` 输出的是 `disp_RGB = {R[3:0], G[3:0], B[3:0]}`，
即 bit11..bit8 = 红的 R3..R0（**bit11 是红的最高位**），bit0 = 蓝的最低位。
而 Pmod VGA 那 12 根引脚的顺序是“**每组先 LSB 再 MSB**”：

```
红: G19=R0  H19=R1  J19=R2  N19=R3
绿: J17=G0  H17=G1  G17=G2  D17=G3
蓝: N18=B0  L18=B1  K18=B2  J18=B3
```

原 `constr.xdc` 却写成了 `G19 ← disp_RGB[11]`、`N19 ← disp_RGB[8]`，
等于**每组 4 位整体倒序**：`0b1011` 打出去变成了 `0b1101`（12 位数据 `0xE72 → 0x7E4`）。

用 `.coe` 里的真值验算，和屏幕上的颜色一一对得上：

| 元素 | `.coe` 原值 | 本该是 | 位序反了以后 | 屏幕上 |
| --- | --- | --- | --- | --- |
| 砖缝 | `0x8E72` | (232,120,32) 橙 | `0x87E4` (112,224,64) | 荧光黄绿 ← 最扎眼 |
| 砖体 | `0x8B32` | (184,52,32) 砖红 | `0x8DC4` (208,192,64) | 橄榄黄 |
| 基地金鹰 | `0x8FE4` | (240,224,64) 金黄 | `0x8F72` (240,112,32) | 橙 |
| 坦克车体 | `0x8FE6` | (240,224,96) 金 | `0x8F76` (240,112,96) | 鲑红 |
| 坦克履带 | `0x8CA2` | (200,160,32) 深金 | `0x8354` (48,80,64) | 墨绿 |
| 钢铁 | `0x8CCC` | (204,204,204) 浅灰 | `0x8333` (48,48,48) | 近黑 |
| 河流 | `0x802F` | (0,38,240) 蓝 | `0x804F` (0,64,240) | 还是蓝，看不出 |
| 树林 | `0x80A0` | (0,160,0) 绿 | `0x8050` (0,80,0) | 只是偏暗的绿 |
| 炮弹 | `0x8AAA` | (170,170,170) 灰 | `0x8555` (80,80,80) | 深灰 |

> 为什么藏了这么久：**纯红 `0xF`、纯白 `0xF`、纯蓝 `0xF` 对“4 位倒序”是不动点**
> （1111 反过来还是 1111）。最早的调色板恰好是“纯红砖 + 白灰缝 + 灰白钢 + 蓝河”，
> 只有坦克/钢那点明暗差异受影响（还被误判成“4 位量化太暗”）。
> 一旦换成 `#C84C0C` 这种 R≠G≠B 的颜色，整屏立刻就露馅了。

修法：只改 `constr.xdc`，把每组 4 位的位号按 MSB→LSB 重新对位（等价于把原映射取反），
RTL 一行没动：

```tcl
set_property PACKAGE_PIN N19 [get_ports {disp_RGB[11]}]   # vgaRed[3]   R3
set_property PACKAGE_PIN J19 [get_ports {disp_RGB[10]}]   # vgaRed[2]   R2
set_property PACKAGE_PIN H19 [get_ports {disp_RGB[9]}]    # vgaRed[1]   R1
set_property PACKAGE_PIN G19 [get_ports {disp_RGB[8]}]    # vgaRed[0]   R0
...
```

同时按 FC 原版重配了整套调色板（`img/imgconverter.py` 的 `RECOLOR`），
量化成 12 位之后上板大概是这些颜色：

| 元素 | png 里的画稿 | `RECOLOR` | `.coe` 值 | 上板颜色 |
| --- | --- | --- | --- | --- |
| 砖体 | `#FF0000` | `#C84C0C` | `0x8C40` | `#CC4400` 砖红 |
| 灰缝 | `#FFFFFF` | `#300800` | `0x8300` | `#330000` 近黑（原版砖缝就是暗的） |
| 钢铁 | `#C0C0C0`/`#A0A0A0`/`#808080` | `#FCFCFC`/`#BCBCBC`/`#7C7C7C` | `0x8FFF`/`0x8BBB`/`0x8777` | 白高光 + 浅灰钢板 |
| 河流 | `#0026FF`/`#FFFFFF` | `#0058F8`/`#3CBCFC` | `0x805F`/`0x83BF` | 深蓝水 + 浅蓝浪 |
| 树林 | `#B6FF00` | `#00A800` | `0x80A0` | `#00AA00` 树叶绿 |
| 坦克车体 | `#A0A0A0` | `#F8D030` | `0x8FD3` | `#FFDD33` 黄 |
| 坦克炮管/暗部 | `#404040` | `#A06800` | `0x8A60` | `#AA6600` 深黄 |
| 坦克描边 | `#000000` | `#381800` | `0x8310` | 深棕 |
| 基地金鹰 | `#FFEF47` | `#FCD800` | `0x8FD0` | `#FFDD00` 金黄 |
| 炮弹 | `#A0A0A0` | `#FCFCFC` | `0x8FFF` | 白 |

> 教训：**颜色不对时先怀疑位序/通道，再怀疑调色板**。
> 只看“颜色变了”很容易往 `RECOLOR` 上找，但 `RECOLOR` 改的是数据，
> 数据对不对可以用 `.coe`（甚至 IP 目录里的 `.mif`）直接查 —— 数据对、屏幕不对，
> 那问题一定在“数据 → 引脚”这一段。

不上板的验色方法（本次就是靠它先排除了数据问题）：

| 命令 | 输出 | 应该看到 |
| --- | --- | --- |
| `python img\preview.py` | `img/preview.png` | 砖红墙 + 近黑砖缝、深蓝河 + 浅蓝浪花、深绿树冠、黄坦克（玩家）、**三辆不同颜色的敌人**（快速淡青 / 火力亮橙 / 装甲深灰，y=10 出生点）、金黄老鹰、白炮弹 |
| `python img\preview.py --hq-destroyed` | `img/preview_destroyed.png` | 同上，但基地换成白旗 + 断杆 + 碎石的废墟 |
| `python img\preview.py --reversed` | `img/preview_reversed.png` | 位序反了的样子：砖体变暗橄榄 `#332200`、砖缝变亮红 `#CC0000`、水面偏青 `#00AAFF` |

最终构建（2026-11-13 19:36）：WNS +0.385 ns / WHS +0.144 ns / TNS = THS = 0，
`battle_city_fpga.runs/impl_1/top.bit` 已重新生成；
`top_io_placed.rpt` 里可以逐条核对 `disp_RGB[11] -> N19 … disp_RGB[0] -> N18`。

## 第四轮：敌方坦克（2026-11-13 晚）

新增 `enemy_ctrl.v`（3 辆车，generate 展开的 SoA 对象池）：
每辆车一个 `terrain_probe`（地图总线上 `p_req[1..3]`，玩家仍是 0 号），
`vga.v` 的坦克图层从“一辆车”改成“玩家 + N_E 辆敌人共用一张 tank ROM + 地址 mux”。

调试中踩到的三个坑（都已修好，记下来免得重犯）：

| 现象 | 根因 | 修法 |
| --- | --- | --- |
| 复位后不等开走就先自己动了一格 | `PHASE` 是计数器**初值**，第一次节拍发生在 `STEP-PHASE` 拍之后 —— 相位越大反而越早 | `PHASE = STEP/(4N) * gi`（≤ `STEP-150`），复位后先留够一拍让 4 个 probe 各扫一遍 |
| 三辆车最后都贴着右墙上下滑，出不来 | 墙前转向只用了 `dir ^ 2'b10 / 2'b11`，这两个都是**垂直转向**：竖直 ↔ 水平，永远回不到“掉头” | 1/4 概率改用 `dir ^ 2'b01` 掉头 —— 掉头方向刚走过、一定通，是保底出口 |
| 敌人变回黄色 / 颜色对不上 | `enemy_tint()` 是拿 `0xFD3 / 0xA60 / 0x310` 三个 12 位常量做比较的，和 `tank_16bit.coe` 的调色板硬绑定 | **已删掉 `enemy_tint()`**，改成 3 个独立兵种 ROM（`tank_fast/power/armor_16bit.coe`），`vga.v` 里不再有颜色常量（见“兵种贴图 + 基地可被摧毁”） |

`tb_enemy`（33 条断言，4 种 BRAM 延迟各跑一遍）覆盖：
出生点/朝向/**兵种 `e_type`**、每拍走整格、**三个 probe 同时扫同一块地图但读到各自的格子**、
撞砖转身不进墙、玩家在 4 客户端抢总线时照常移动、连跑 60 拍后车身仍只压在可通行格上。

最终构建（2026-11-13 20:19）：WNS +0.366 ns / WHS +0.153 ns / TNS = THS = 0，
`battle_city_fpga.runs/impl_1/top.bit` 已重新生成。
资源相对第三轮：LUT 956 → 1830、FF 429 → 890、DSP 10 → 34（4 个 probe 各自 6 个
`div5` 乘法器）、BRAM 仍 7.5 tile。
`python img\preview.py` 现在也会画三辆不同颜色的敌人（出生点 `40/380/740, y=10`，朝下），
`--hq-destroyed` 还能看基地被打爆的那一帧，上板前可以先看构图。

## 第五轮：兵种贴图 + 基地可被摧毁 + CDC 同步（2026-11-14）

改动：`enemy_ctrl.v` 多一路 `e_type`（按出生点常量分配），`bullet-ctrl.v` 多一路单拍
`base_hit`（`T_BASE` 单独一个分支），`top.v` 用 `base_alive` 锁存、`vga.v` 把基地/敌人
贴图换成 4 个独立 ROM。三处连线：`enemy_ctrl -> top -> vga`（`enemy_type`）、
`bullet_ctrl -> top -> vga`（`hq_destroyed = ~base_alive`）。

**这次真正值得记的是时序**。加完 4 个坦克 ROM 之后第一次 impl：

```
WNS = +0.011 ns   (sys_clk_pin -> vga_clk)    ← 差点翻车
Destination: u_vga/tank_rom/.../ADDRARDADDR[11]
Data Path Delay: 12.006ns  (logic 2.965ns / route 9.041ns)
```

也就是“敌人的 y 坐标寄存器 → 减法器/比较器 → 4 个 ROM 的地址口”，一条
**跨时钟域的准静态路径**：源端 12.5~25Hz 才动一次，却被当成每个 vga_clk（20ns）
都要收敛的组合路径来修 —— 而它的走线占了 75%，布局稍微一动就会变负。

修法（`vga.v`）：几何信号进 vga 域前先各打一拍 ——
`position_x/y`、`player_direction`、`enemy_x/y/dir/valid/type`、
`bullet_x/y/dir/valid`、`hq_destroyed`，一共 +116 个 FF。
跨域变成“FF → FF”的纯走线，地址由 vga 域寄存器驱动；
因为这些量都是准静态的，画面上看不出任何延迟（最多晚 1 个 vga_clk = 20ns）。

```diff
+    reg [9:0]          position_x_q, position_y_q;
+    reg [N_E*10-1:0]   enemy_x_q, enemy_y_q;
+    ...
+    always @(posedge vga_clk) begin
+        position_x_q <= position_x;
+        enemy_y_q    <= enemy_y;
+        enemy_type_q <= enemy_type;
+        ...
+    end
```

最终构建（2026-11-14 14:35，`xc7a35tcpg236-1`）：

```
WNS = +1.528 ns   TNS = 0.000   WHS = +0.089 ns   THS = 0.000    (0 条违例)

sys_clk_pin            : WNS +1.528 ns  (1875 endpoints)   PW 4.500 ns
vga_clk (50 MHz, 2 分频) : WNS +6.097 ns  ( 322 endpoints)
sys_clk_pin -> vga_clk : WNS +7.315 ns  ( 112 endpoints)   ← 修完之后
vga_clk -> sys_clk_pin : WNS +8.228 ns  (  1 endpoint )

Slice LUT 1837 / 20800 (8.8%)   FF 1006 (2.4%)   BRAM 9.5 tile / 50   DSP 34 / 90
```

资源相对第四轮：LUT 1830 → 1837（+7，兵种 mux 只是 2 位选择）、
FF 890 → 1006（+116，就是上面那批同步寄存器）、
BRAM 7.5 → 9.5（4 份 512x16 坦克 ROM + 1 份废墟 ROM）、DSP 仍 34。

仿真：19/19、70/70、33/33，4 种 BRAM 读延迟（0/1/2/3 拍）全过，
`battle_city_fpga.xpr` 里确认已挂上 4 个新 IP
（`blk_mem_tank_fast/power/armor`、`blk_mem_hq_destroyed`，都有对应的 `*_synth_1`/`*_impl_1` run）。

## 第六轮：关卡重做 + 测试台与地图解耦（2026-11-14）

`pysrc/maps/level1.txt` 整张重画（仍然 40x30 块，左右镜像），
主题是**一条横贯东西的河 + 两处浅滩**：

| | 内容 |
| --- | --- |
| 河 | 第 8~9 块（像素 y=160~199），40px 宽，横贯整图 |
| 浅滩 | 第 8~11 块、第 28~31 块（每处 4 块 = 80px），是全图仅有的过河通道 |
| 主通道 | x=16~23 块（像素 320~479）从浅滩直通堡垒，正好罩住玩家出生点 (400,300) |
| 掩体/埋伏 | 河下方左右各一组钢板（第 9~10、29~30 块）；树林在第 12~13、26~27 块和两角第 1~3、36~38 块（可钻、盖坦克） |
| 堡垒 | 底部中央，顶盖 2 块高 + 两侧 1 块厚 + 2 行砖台座，正上方留 20x20 冲刺空间 |

为什么这个形状“打得起来”：三个敌人出生点都在河北岸，落下来必须先挤过两处浅滩，
玩家守在河南岸的纵深里；而浅滩两侧是钢板/砖房，所以关隘是**真关隘**，不是摆设。

### 测试台不再绑定地图

以前 `tb_terrain` 里写死了“第 (76,112) 格是砖”“第 (x,y) 格是河”，改一关就红一片。
现在分成两类用例：

| 用例 | 依赖地图？ | 做法 |
| --- | --- | --- |
| T06 河挡路 / T07 浅滩可过 / T13 基地屋顶挡路 | 是（故意） | 直接读 `map.coe` 的真值，验证“这张关卡真的能这么打” |
| T08~T12 砖/钢/河/树怎么挡 | 否 | 先 `clear_map` 把 19200 格清零，再 `poke` 出需要的那几格（地址 = `row*160+col`） |
| T15 基地本体 | 是（契约） | 基地必须**正好**是格 `列 76~83 x 行 112~117`（8x6），且全图只有这一处 `tile 5` |
| T16 出生点净空 | 是（契约） | 玩家 (400,300) ±60px 走廊、三个敌人出生框 +20px 内必须全空 |

```verilog
task clear_map;                       // 19200 格全写 0，之后地图内容不再影响用例
    begin
        for (a = 0; a < 19200; a = a + 1) poke(a, 4'd0);
    end
endtask
```

于是“改关卡”这件事的代价从“改一堆期望值”变成“重跑一次 `run_sim.ps1`”：
24/24、70/70、33/33 × 4 种 BRAM 读延迟（0/1/2/3 拍）全绿，`run_sim.ps1` 的
阈值也改成了 `tb_terrain Min=24`。

### 怎么证明“新地图真的进了比特流”

`.coe` 改了不等于板子变了，中间还有一跳：IP 目录里的 `.mif`（由 `build_all.tcl` 的
`generate_target` 重新生成），OOC 综合读的是它。所以加了个一次性校验脚本：

```powershell
python pysrc\check_mif.py
```

```
blk_mem_gen_0            coe=19200  mif=19200  mismatch=0
blk_mem_headquarters     coe=400    mif=400    mismatch=0
blk_mem_hq_destroyed     coe=400    mif=400    mismatch=0
blk_mem_brick            coe=400    mif=400    mismatch=0
cell(48,32)  = 3 (expect 3 river)
cell(80,60)  = 0 (expect 0 player spawn)
cell(76,112) = 5 (expect 5 base)
RESULT: ALL MATCH
```

时间戳链也对得上：`level1.txt`/`map.coe` 15:34 → `blk_mem_gen_0.mif` 15:46 →
`top.bit` 15:56，即比特流比地图数据新（后来 16:05 又把 `map.coe` 重生成过一次，
内容逐值相同，`check_mif.py` 依然 `ALL MATCH`，所以不需要重新出比特流）。

> 坑：Vivado 写出来的 `.mif` **没有文件头**，数据是 `RADIX=2` 的定宽 0/1 串
> （16 位 ROM 每行 16 个字符、4 位地图每行 4 个字符）。
> 当成十六进制读会得到一串假警报（砖墙 400 条**全部**“不一致”、地图 1680 条、
> 基地 202 条），第一反应容易误判成“IP 没重新生成、比特流是旧的”。
> 判定规则：整份文件全是 `0/1` → 二进制解析，出现 `2~F` 才是十六进制。

最终构建（2026-11-14 15:56，`xc7a35tcpg236-1`）：

```
WNS = +1.528 ns   TNS = 0.000   WHS = +0.089 ns   THS = 0.000    (0 条违例)
Slice LUT 1837 / 20800 (8.8%)   FF 1006 (2.4%)   BRAM 9.5 / 50   DSP 34 / 90
DRC: 0 条 Critical/Error，只剩 CFGBVS-1（1 条，板级电压属性没写）+ DPIP/DPOP（84 条，probe 里 div5 的流水线建议）
```

资源和战前一致（改的只是 `map.coe` 的**内容**，不是结构），DSP 34 仍是
4 个 `terrain_probe` 各自的 `div5`（像素 → 格），`tb_enemy` 那句老注释依然成立：
要省 DSP 得把 `/5` 换成查表。


## 第七轮：600x600 玩区 + 200px 信息栏 + 完整战斗（2026-11-14 晚）

这一轮做两件事：**画面上**把玩区缩成 600x600、右边 200px 做成 HUD 信息栏；
**玩法上**把“敌人开火 / 炮弹打坦克 / 兵种差异 / 生命与复活 / 胜负”补完。

### 几何：800x600 屏幕，左边 600x600 是地图

原来地图铺满 800x600（160x120 格），现在只有左边 600x600（120x120 格）：

| 常量 | 原来 | 现在 | 在哪 |
| --- | --- | --- | --- |
| 地图格数 | 160 x 120 | **120 x 120** | `top.v` 的 `MAP_W` / `MAP_H` |
| 地图地址 | `row*160 + col` | **`row*120 + col`** | `vga.v` / `terrain_probe.v` / `bullet-ctrl.v`（只有这三处） |
| 像素步进 | 128+32（`(r<<7)+(r<<5)`） | **128-8（`(r<<7)-(r<<3)`）** | 同上，比原来还少一级加法 |
| 基地精灵 | `HQ_X0=390` | **`HQ_X0=290`** | `vga.v`（`HQ_Y0=565` 不变，基地仍占格 56~63 x 112~117） |
| 玩家出生 | (400,300) | **(300,300)** | `player.v` 的 `WIDTH/HEIGHT`、`map_generator.py` |
| 敌人出生 | 40 / 380 / 740 | **40 / 300 / 560** | `enemy_ctrl.v`、`map_generator.py` |
| 关卡文件 | 40x30 块 | **30x30 块** | `pysrc/maps/level1.txt` |

**BRAM 的物理深度故意没改**（还是 19200 项、15 位地址）：逻辑上只需要
120x120 = 14400 格，最大地址 14399 < 16384，尾部 4800 格永远指不到。
好处是 `blk_mem_gen_0` 一行 IP 配置都不用动（不用重新生成 IP、不用改地址位宽、
`bram_stubs.v` 也不用改）；`map_generator.py` 只是在 14400 格有效数据后面补 0 到 19200，
让 coe 的项数等于深度。省下来的 2.4KB 在 9.5/50 个 BRAM36 的预算里不值一提，
README 里留作“以后再说”。

时序参数（800x600@60 的行场计数）**一个都没动** —— 只是把 `x >= 600` 的像素让给侧栏，
并在地图地址上加了 `img_x < PLAY_W ? ... : 0` 的门控（侧栏不读地图）。

### HUD：右侧 200px（`hud.v` + `font5x7.v`）

```
x=600 ┌─────────────────────────┐
      │ ██ BATTLE CITY          │  600..601 是 2px 分界线，602..799 是面板
      │    LEVEL 1              │
      │    ENEMY                │
      │    [快][火][甲]          │  20x20 图标，复用坦克 ROM（x=12+i*28, y=100）
      │    SCORE                │
      │    0600                 │
      │    LIVES                │
      │    3                    │
      │                         │
      │   ▓▓ GAME OVER ▓▓       │  y=300，闪烁 1.5Hz（板上会一明一暗）
      │                         │
      │   BTNC=FIRE             │
      └─────────────────────────┘
```

| 设计点 | 做法 | 原因 |
| --- | --- | --- |
| 字形 | 5x7 点阵，放大 2 倍（10x14），字距 16px | 字距取 16 是为了让“第几个字符 = (x-行首)>>4”变成一条移位，**不要除法器** |
| 字库 | `pysrc/font5x7.py`（唯一数据源）→ `pysrc/gen_font.py` 生成 `font5x7.v`（纯组合 case 表） | 只有 42 个字形，综合出来一百多个 LUT；不新建 BRAM IP，省掉 coe/stub/check_mif 一整套 |
| 颜色 | 标题黄 `FE0`、标签浅蓝 `ADF`、数值白 `FFF`、面板底 `113`、分界线 `8CF` | 12 位色，和 VGA 调色板一致 |
| 数字 | 分数显示 `nn00` 四位（分数永远是 100 的倍数） | 杀掉的是 100/200/300 分，所以只需要 score100 的十位/个位，**零除法器** |
| 图标 | 输出 `icon_on/icon_addr/icon_type`，由 `vga.v` 把 4 个坦克 ROM 的地址 mux 过去 | 图标和场上坦克长得一模一样，不用第 5 张图；图标区域不在玩区，不会和真坦克抢像素 |
| 对齐 | HUD 的坐标吃 `img_x_d1/img_y_d1`（延迟一拍） | map/贴图 ROM 都是 1 拍读延迟；HUD 是纯组合的，不打拍就整块左移 1 像素 |
| 闪烁 | `blink_cnt[24]`（50MHz / 2^25 ≈ 1.5Hz） | 横幅共用一路闪烁，不额外占逻辑 |

### 玩法：敌人开火 + 炮弹打坦克 + 兵种差异

`bullet_ctrl` 从“玩家专用”升级成“**两种归属共用一套对象池**”，靠 `own[]` 区分
（0 = 玩家，1..N_E = 第 i-1 辆敌人）：

| 能力 | 实现 |
| --- | --- |
| 敌人开火 | `enemy_ctrl` 每 `FIRE_PERIOD` 个自己的移动节拍发一个单拍 `e_fire[i]`；和玩家的 `fire_pulse` 一起进同一个仲裁器（玩家优先，然后编号小的敌人） |
| 炮口 | 先把“请求者”的坐标/朝向选出来（`src_x/src_y/src_d`），再套原来的四方向炮口公式 |
| 打中坦克 | 弹体 10x10 与坦克 20x20 做包围盒相交；玩家的弹只打敌人（`hit_enemy[i]`），敌人的弹只打玩家（`hit_player`） |
| 友军不误伤 | `e_hit_now` 只在 `own == 0` 时非零，`p_hit_now` 只在 `own != 0` 时非零 |
| 弹对弹 | 归属不同 + 10x10 包围盒相交 -> 两发同时回收（`kill2_pulse`） |
| 同屏 1 发 | 按 `own` 分组统计 `busy_p` / `busy_e[]`，**每个发射者**各自限 1 发（不是全局 1 发） |
| 配色 | `b_owner` 给 `vga.v`：敌人的弹绿通道减半（白 -> 品红），一眼能分出谁打谁 |

兵种差异（`enemy_ctrl` 里按出生点分配，`MOVE_DIV` = 玩家的 2 倍当“中间档”）：

| 兵种 | 位置 | 移动 | 开火周期 | 血量 | 分数 |
| --- | --- | --- | --- | --- | --- |
| 快速 `T_FAST` | 左 (40,10) | `MOVE_DIV/2`（和玩家同速） | 6 个节拍 | 1 | 100 |
| 火力 `T_POWER` | 中 (300,10) | `MOVE_DIV`（一半速度） | **4 个节拍**（弹幕最密） | 1 | 200 |
| 装甲 `T_ARMOR` | 右 (560,10) | `MOVE_DIV*3/2` | 8 个节拍 | **2**（吃两发） | 300 |

生命 / 胜负（`top.v` 的“打法状态机”）：

* 玩家被打中 -> 生命 -1、回出生点、1 秒无敌（`INVULN_CYCLES`，无敌期间不会被打中）；
* 生命耗尽 或 基地被打爆 -> `game_over` 锁存 -> `freeze=1`（玩家/敌人都不再动、不再开火）+ 侧栏 `GAME OVER`；
* 三辆敌人全部击毁 -> `victory` -> 侧栏 `VICTORY`（本工程只有一关，没有下一关）；
* 分数按兵种加分，侧栏显示 `nn00`。

> `ENEMY_FIRE` 是 `top` 的参数（板上默认 1）：地形/移动那几个老用例把它关掉，
> 结果才可复现（不然随机炮弹会把“坦克该走到哪”搅乱）。战斗本身在
> `tb_bullet` / `tb_combat` 里测。

> `hud.v` / `font5x7.v` 是新加的源文件，老 `.xpr` 里没有。`sim/build_all.tcl`
> 开头会检查并 `add_files`（幂等），所以直接跑构建脚本就行，不用再单独跑
> `add_*.tcl`。

### 时序：新玩法把 100MHz 吃穿了，靠“开火流水线”救回来

第一版（把命中判定和两种归属直接塞进 `bullet_ctrl`）综合出来
**WNS = -0.81ns**，最差路径是：

```
u_bullet_ctrl/own_reg[3][1] ──► own[] -> busy_e[] (变量下标) -> enemy_ok
    -> req_owner (优先级 mux) -> (n-1)*10 乘法 + 30 选 1 桶形移位 (炮口)
    -> muzzle_y -> alloc_idx 4 选 1 -> y_reg[*][9]/D       共 14 级逻辑
```

也就是说“谁的弹在飞 → 谁能开火 → 选谁的炮口 → 写进对象池”这一整串在同一个
10ns 里跑完了。修法是把这条链在“受理请求”和“算炮口/入池”之间切开：

| 改动 | 效果 |
| --- | --- |
| `req_owner / spawn_req` 打一拍变成 `own_sel / spawn` | 链路从 14 级降到 ~7 级；开火请求本来就 5Hz 级别，多等一拍看不出来 |
| `spawn` 还是高位时不接新请求 | 避免连续两拍各受理一个请求、算出同一个空槽（后一个覆盖前一个） |
| 炮口选择改成 one-hot + 常量下标拼位 | 去掉 `(n-1)*10` 乘法 + 桶形移位（少两级） |
| **弹对弹**改成“预先算好的 4x4 相撞矩阵”（`pair_now`） | 32 个“距离 <10px”的减法比较从扫描状态机里挪到寄存器前面，深度从 10.1ns 降到 3 级 |
| HUD 的状态输入（分数/生命/胜负）先打一拍再进 `hud` | `game_over` 经 13 级组合链打到 `final_color_d1` 是 **sys -> vga 跨时钟路径**（-0.825ns，12 个端点）；打一拍就变回 FF -> FF |

> 顺带：`freeze` 也接进了 `bullet_ctrl`（GAME OVER 时 `bullet_tick` 恒 0），
> 炮弹会停在原地，而不是继续飞完最后一段。

1. **HUD 整块不显示**：`hud.v` 里 `rel = px - lx0`，而 `px` 已经是“面板内坐标”
   （减过 600），`lx0` 却是绝对坐标（612）——减出负数回绕成大数，`in_text` 永远为 0。
   改成 `rel = x - lx0`（用绝对 x）。`tb_hud` 的 H05~H07 直接数“文字色像素个数”，
   一条用例就把这种“整块空白”钉死。
2. **贴脸打不中坦克**：坦克命中判定原来放在 `C_DEC`（读地图那个状态），而
   “弹体压着的格组没变就跳过地图读”的去重会把整个 `C_DEC` 跳过。坦克 20x20 比
   弹体大，弹体完全可能整整一个格组都压在坦克身上却一次都不读地图 —— 命中就漏了。
   现在命中判定放在 `C_CMP` 的第一格（每个节拍都判、不需要地图数据），
   去重只影响“要不要读地图”，不再影响“有没有打到坦克”。
3. **用例之间互相污染**：`tb_bullet` 里上一条用例打剩的砖会挡住下一条用例的弹道
   （B24“弹对弹”就是被 B18 留下的 行 55 那排砖挡掉的，表现为“玩家的弹半路消失”）。
   现在 `do_reset` 顺手 `clear_map`，每条用例都从干净地图开始。

### 验证

```text
tb_terrain 24/24  tb_bullet 88/88  tb_enemy 38/38  tb_combat 20/20  tb_hud 27/27
（x 4 种 BRAM 读延迟 0/1/2/3 拍 = 20 次全绿）

python pysrc\check_mif.py
blk_mem_gen_0        coe=19200  mif=19200  mismatch=0
cell(56,112) = 5 (base)   cell(119,119) = 0 (last valid cell)   padding = 0
RESULT: ALL MATCH

完整构建（synth + impl + bit）：
  WNS = +0.674 ns   WHS = +0.051 ns   0 failing endpoints
  Slice LUTs 3443 (16.55%)   Slice Registers 1308 (3.14%)
  Block RAM 9.5 (19.00%)     DSP 34 (37.78%)
```

资源对比（这一轮之前 -> 之后）：LUT 1837 (8.83%) -> 3443 (16.55%)，
FF 1006 -> 1308，BRAM 9.5 -> **9.5（没变）**，DSP 34 -> 34。
LUT 的增量主要是这些：HUD 字库/排版（约 300）、弹对弹的 4x4 相撞矩阵（约 400）、
两种炮弹的归属/命中判定（约 300）、兵种各自的节拍/血量/开火计数器（约 200）、
以及打拍引入的寄存器和 HUD 的 CDC 同步。BRAM 一点没多 —— 字库是用 LUT 做的。


## 第八轮：敌人爆炸动画（2026-11-14 晚）

上一轮留下了唯一一个“知道怎么做、但没做”的东西：坦克被击毁时直接消失，没有爆炸。
这一轮补上：**4 个爆炸槽 + 2 帧贴图 + 6 个相位**，敌人和玩家共用同一套。
（贴图 `tank_destroyed1/2_16bit.coe` 早就在工程根目录里，只是没有 ROM 去读它。）

### 结构：状态和像素分开

```
top: enemy_ctrl.e_kill[i] ──┐
     b_hit_player            ├──► fx_ctrl ──(fx_valid/x/y/frame)──► vga: 爆炸图层
                             ┘      4 槽 × (x,y,相位,拍数)         ├ blk_mem_tank_destroyed1 (亮爆团)
                                                                   └ blk_mem_tank_destroyed2 (星形环)
```

* `fx_ctrl.v` 只管**时间**：谁死了、开在哪个槽、现在是哪个相位。
* `vga.v` 只管**像素**：命中 20x20 包围盒 -> 算 `row*20+col` -> 读两张 ROM -> 按帧号 mux。
* 和坦克一样，跨到 `vga_clk` 域时先打一拍（`fx_*_q`），地址由 vga 域的寄存器驱动。

### 三个容易踩的点

1. **位置必须在“死亡那一拍”采样。**
   玩家挨打后 `top` 立刻拉 `respawn_pulse`，下一拍 `player.v` 就把坐标跳回 (300,300)。
   如果爆炸晚一拍采坐标，火球就跑到画面正中。`fx_ctrl` 和 `player.v` 因此接同一个
   `clock`、在同一个沿采样 —— 那时还是死亡位置。`tb_combat` 的 C10c/d 专门钉住这条。
2. **同拍多死不能丢。**
   最坏情况是 3 辆敌人 + 玩家在同一拍全死（两发炮弹同拍命中，或弹对弹的同时另一发打中坦克）。
   所以做 4 个槽，并且用**纯组合分配**：同一拍把 4 个请求各写进一个空闲槽，
   不需要排队、也不会有“晚几拍才炸”的抖动。
   分配顺序是确定的：请求从高到低（玩家最高）、每人占当前最靠后的空闲槽。
3. **满池就丢，不覆盖。**
   4 个槽都占着时再来的请求直接丢弃。宁可少一个火球，也不能把正在放的那个重置
   （会把“同一处的爆炸”变成永远炸不完的循环）。`tb_fx` 的 X08 钉住这条。

### 动画参数

| 参数 | 板上值 | 含义 |
| --- | --- | --- |
| `FX_DIV` | 8_000_000 | 每个相位 80ms（100MHz） |
| `FX_PHASES` | 6 | 3 个相位放亮爆团 + 3 个相位放星形环 = **480ms** |
| `N_FX` | 4 | 爆炸槽数（3 敌 + 玩家） |

`FX_DIV` 是 `top` 的 parameter，仿真里缩到 8 拍，一个用例几十拍就够，不用等 800 万拍。

### 两个新 ROM IP

`blk_mem_tank_destroyed1/2` 和 `blk_mem_tank_*` 的参数完全一致（512x16 单口 ROM、
1 拍读延迟、coe 指向工程根目录），所以 `vga.v` 里就是复制一个实例、改个名字。
`build_all.tcl` 开头现在会**自动创建**这两个 IP（`create_ip` + `set_property CONFIG.*`，
幂等），换台机器打开工程也不会缺 IP。

> 这张图能在不上板的情况下看：`python img\preview.py --explosion` -> `img/preview_explosion.png`
> （中间那辆火力坦克刚被击毁，画的是第 1 帧亮爆团；被击毁的车不再画，HUD 的敌人图标同步少一个）。

### 验证

```text
tb_terrain 24/24  tb_bullet 88/88  tb_enemy 38/38  tb_combat 28/28
tb_hud 34/34      tb_fx 30/30
（x 4 种 BRAM 读延迟 0/1/2/3 拍 = 24 次全绿，共 242 条断言/轮）

python pysrc\check_mif.py
blk_mem_tank_destroyed1  coe=400  mif=400  mismatch=0
blk_mem_tank_destroyed2  coe=400  mif=400  mismatch=0
RESULT: ALL MATCH

完整构建（synth + impl + bit，0 errors / 0 critical warnings / 0 warnings）：
  WNS = +1.135 ns   WHS = +0.047 ns   0 failing endpoints
  Slice LUTs 3768 (18.12%)   Slice Registers 1594 (3.83%)
  Block RAM 10.5 (21.00%)    DSP 34 (37.78%)
```

资源对比（上一轮 -> 这一轮）：LUT 3443 (16.55%) -> 3768 (18.12%)，FF 1308 -> 1594，
**BRAM 9.5 -> 10.5**（+1 个 BRAM36 = 两张 512x16 的爆炸贴图），DSP 34 -> 34。
LUT 的 325 增量是：4 个爆炸槽的分配/相位计数器（约 180）、vga 的包围盒比较 + 地址 mux
（约 90）、跨到 vga 域的打拍寄存器（约 55）。
时序反而更松了（+0.674 -> +1.135）：新增的路径全是"寄存器 -> 小组合 -> 寄存器"，
没有插到原来那条 sys_clk -> vga_clk 的 ROM 地址链上。

> 写测试台时的坑：在 `@(posedge clock)` 的同一时间点 `$display` 信号，读到的是
> **打拍之前**的值（NBAs 还没生效），整个用例会差一拍。`tb_fx` 的 `wait_clk` 一律在
> negedge 返回，相位边界才数得准（相位 2 -> 3 正好是第 24 拍）。


## 第九轮：关卡切换 + 敌人波次（2026-11-15）

前八轮做完之后，游戏有一个很直白的死结：**打赢三辆敌人之后就没东西可打了**
（`victory` 是锁存的一次性信号），而“一关只有三辆车”也不像 Battle City。
这一轮补上两块：

* **关卡切换**：4 张关卡地图、`STAGE CLEAR` 横幅、换关时把整张地图重写一遍、
  打完第 4 关回到第 1 关（无限循环，分数和生命都不清零）；
* **敌人波次**：每关 20 辆，开局先排一屏 3 辆，之后每 3 秒补一辆，
  兵种按关卡队列出（前一关轻、后一关重）。

### 结构：谁管什么

```
top
 ├─ stage_ctrl     关卡号 / 剩余队列 / 补车计时 / STAGE CLEAR -> 换关
 │    ├─ spawn[i] + spawn_type[i]  ──► enemy_ctrl（第 i 槽按兵种“上车”）
 │    ├─ paused  ──► 冻结玩家/敌人/炮弹 + 复位 terrain_probe
 │    └─ load_start / load_level ──► level_loader
 ├─ level_loader   块图 -> 地图 RAM（14400 次写，0.16ms）
 │    └─ blk_mem_level（4096x4 = 4 关 x 1024 项）
 └─ hud            LEVEL n / ENEMY nn / STAGE CLEAR
```

`enemy_ctrl` 从“复位后固定 3 辆、兵种写死在 generate 里”改成
“复位后所有槽都是空的，等 `spawn` 派车”。兵种不再是 `localparam`，而是每个槽的
寄存器（`my_type / step / fire_period / hp_max`），`spawn` 那一拍按队列写进去
—— 同一个槽前后可以是不同兵种，这正是“波次换车”需要的。

### 为什么 ROM 里存“块图”而不是整张地图

| 方案 | 容量 | BRAM36 |
| --- | --- | --- |
| 每关存 120x120 格（14400 x 4 位） | 57600 位/关 | 4 关约 8 个 |
| 每关存 30x30 块（900 x 4 位） | 3600 位/关 | 4 关 **不到 1 个 BRAM18** |

展开规则只有一条：一块 -> 4x4 格，`'H'` 块里落在基地矩形（格 56..63 x 112..117）
的格子是 5、其余补砖（基地坐在砖砌台座上）。硬件上一次 14400 次写 ≈ 0.16 ms，
比一次屏幕刷新还短，换关时玩区连闪一下都看不出来。
`level_loader.v` 每块花 18 拍：1 拍送地址 + 1 拍收 1 拍读延迟的数据 + 16 拍写。

> **三道保险**：`gen_levels.py` 用 Python 把“硬件展开规则”和
> `map_generator.expand()` 逐格比对；`tb_stage` 再把换关后地图 RAM 里的真实内容
> 按坐标抽查（河道消失 / 钢板出现 / 基地台座是砖 / 基地本体是 5）；`check_mif.py`
> 再确认 `levels.coe` 真的进了 IP 的 `.mif`。

### 关卡流程（stage_ctrl 的三个状态）

| 状态 | 做什么 | 什么时候走 |
| --- | --- | --- |
| `S_PLAY` | 补车 / 判胜负 | 队列空 **且** 场上一辆不剩 -> `S_CLEAR` |
| `S_CLEAR` | 出 `STAGE CLEAR` 横幅，`paused=1` 冻结全场 | 等 `CLEAR_CYCLES`（2s）-> `S_LOAD` |
| `S_LOAD` | 等 `level_loader.done` | 装载完成 -> `level` 换新、队列重置、玩家回出生点 -> `S_PLAY` |

补车规则（`spawn_now`）：本关前 3 辆**立刻**排满一屏（开局就是 3 辆，和以前一致），
之后必须等 `spawn_timer` 到 0 才补 —— 所以是“**按时间顺序**刷新出更多敌人”，
而不是“死了立刻重生”的无尽打地鼠。

兵种队列（`type_of`）：前 3 辆固定 快速/火力/装甲（让玩家先看清三种车，
也正好等于旧版“左快 / 中火 / 右装”），后面 17 辆按关卡配比出：

| 关卡 | 快速 | 火力 | 装甲 | 地图风格 |
| --- | --- | --- | --- | --- |
| 1 | 10 | 5 | 2 | 一条横贯东西的河 + 两处浅滩（原始地图） |
| 2 | 6 | 7 | 4 | 中央宽河、两个口袋，逼近距离交战 |
| 3 | 3 | 6 | 8 | 2 块高的砖墙网格迷宫，奖励“堵口” |
| 4 | 1 | 4 | 12 | 钢板多、掩体少的开阔地，重装为主 |

### 三个容易踩的点

1. **`e_valid` 比 `spawn` 晚一拍。**
   `spawn` 是寄存器输出，槽里的坦克要到下一个时钟沿才出现在 `e_valid` 上。
   所以挑空槽必须用 `slot_busy = e_valid | spawn`，否则“开局排一屏”会连着两拍
   派给同一个槽（第一版就是这么错的：只有 2 辆出场、兵种整体错位）。
   同理，“本关打完”也要用 `slot_busy` —— 不然最后一辆刚派出去的那一拍
   `e_valid` 还是 0，会被误判成全灭、直接跳到 STAGE CLEAR。
   > 同类坑还有一个（`level_loader` 里）：最后一块的最后一个写周期如果顺手把
   > `wr_we` 清 0，右下角那一格就永远写不进去 —— 默认用例里它是空地，看不出来，
   > 所以 `tb_stage` 的 S04e/S05h 专门先把它改成“河”，装载后要求它变回空地。
2. **装载地图时必须真的没人查地图。**
   `paused` 期间 `top` 把 `terrain_probe` 和 `bullet_ctrl` 全部复位：probe 的窗口
   一旦开着就会被 loader 的写口打断；炮弹的命中引擎也可能读到半个新地图
   （读到 tile 5 就误判“基地被打爆”）。loader 自己也会先看一眼总线是否空闲再动手。
3. **地图 RAM 的写口要仲裁。**
   `map_bus` 原来只有“炮弹打砖”一个写者，现在多了 loader。装载期间整条总线是停的，
   所以 `top` 里就是一个二选一：`ldr_we ? 地图装载 : map_bus`。

### 参数

| 参数 | 板上值 | 含义 |
| --- | --- | --- |
| `N_LEVELS` | 4 | 一共几关（`levels.coe` 里几关就填几） |
| `ENEMIES_PER_STAGE` | 20 | 每关要打多少辆 |
| `SPAWN_CYCLES` | 300_000_000 | 补车间隔 3s @100MHz |
| `CLEAR_CYCLES` | 200_000_000 | STAGE CLEAR 横幅停留 2s |
| `LEVEL_SLOT` | 1024 | 关卡 ROM 里每关占多少项（900 块取整到 1024） |

仿真里 `ENEMIES_PER_STAGE` / `SPAWN_CYCLES` / `CLEAR_CYCLES` 都调小（4 辆 / 400 拍 /
60 拍），一套用例几十万拍就能把“开局 -> 补车 -> 全灭 -> 换关 -> 循环”跑完一遍。

### HUD 的两处变化

* `LEVEL n` 不再写死 `3'd1`，接的是 `stage_ctrl.level`；
* `ENEMY` 后面多两位十进制：`ENEMY nn` 是本关剩余敌人（含场上活着的），
  用“比较链 + 乘 10”算十位/个位，同样没有除法器；
* 结算横幅的 `VICTORY` 换成 `STAGE CLEAR`（11 个字符 = 176px，正好占满 200px 侧栏）。

### 验证

```text
tb_terrain 24/24   tb_bullet 88/88   tb_enemy 38/38   tb_combat 28/28
tb_hud 38/38       tb_fx 30/30       tb_stage 43/43
（x 4 种 BRAM 读延迟 0/1/2/3 拍 = 28 次全绿，共 289 条断言/轮）

python pysrc\check_mif.py
blk_mem_level            coe=4096  mif=4096  mismatch=0
levels entries = 4096 (expect 4096 = 4 levels x 1024)
L1 blk(14,28)  = 5 (expect 5 base block)
L2 blk(14,28)  = 5 (expect 5 base block)
RESULT: ALL MATCH

完整构建（synth + impl + bit，0 errors / 0 critical warnings）：
  WNS = +0.546 ns   WHS = +0.050 ns   0 failing endpoints
  Slice LUTs 4073 (19.58%)   Slice Registers 1792 (4.31%)
  Block RAM 11 (22.00%)      DSP 34 (37.78%)
```

资源对比（上一轮 -> 这一轮）：LUT 3768 -> 4073（+305），FF 1594 -> 1792（+198），
**BRAM 10.5 -> 11**（+0.5 = 关卡 ROM 4096x4），DSP 34 -> 34。
LUT 增量主要花在：`stage_ctrl` 的队列/计时/比较（约 120）、`level_loader` 的
地址换算与状态机（约 90）、HUD 的两位十进制（约 20）、`enemy_ctrl` 的兵种寄存器
（4 个寄存器位宽都不大，约 40）、`top` 的写口 mux 与新增连线（约 40）。
时序从 +1.135 掉到 +0.546 但离 10ns 还很远（0 failing endpoints）：新加的路径是
“32 位计时器比较 -> 少量组合 -> 寄存器”，没有插进那条
`sys_clk -> vga_clk` 的 ROM 地址链；而且这几次重跑之间 WNS 在 +0.55 ~ +0.95 之间
来回跳，说明余量主要是被布局布线（每次 seed 不同）吃掉的，不是新增逻辑吃掉的。

> `blk_mem_level` 需要重新做 OOC 综合时，synth 会多一条 warning：它按默认 20ns 周期
> 估算（这块 ROM 的 `clka` 实际接 10ns 的 `clock`；其它 ROM 都挂在 20ns 的 `vga_clk` 上，
> 所以以前不会有这条）。IP 的 OOC 结果一旦缓存命中就不会再出现，这次全量构建的
> synth 就是 0 error / 0 critical warning / 0 warning。它只是一个 BRAM 原语的综合估算，
> 布线/时序以顶层约束为准。
> impl 阶段另有 85 条提示（34 `DPIP-1` + 16 `DPOP-1` + 34 `DPOP-2`，都是 DSP48
> 流水寄存器的建议，前几轮就有；以及 1 条 `CFGBVS-1` bank 电压配置），都不是 critical。

