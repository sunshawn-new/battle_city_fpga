`timescale 1ns / 1ps

// ============================================================================
//  map_bus —— 地图 BRAM Port A 的「窗口式」仲裁器
//
//  Port A 原来是单客户端（地形查询）独占的，加炮弹之后变成多客户端：
//    1) N_PROBE 个地形查询引擎（玩家 1 个；敌方坦克以后往 p_req 上多加一位）
//    2) 1 个炮弹命中判定引擎（要读地图判断撞墙，还要把砖块改写成空地）
//
//  为什么是“窗口”而不是“每次读一拍一仲裁”：
//    客户端不知道 BRAM 的读延迟（IP 配置 0~3 拍都可能），它们靠“地址保持
//    若干拍 + 固定拍数采样”工作。如果每拍重新仲裁，地址中途被切走就会采到
//    别人的数据。所以约定：
//      · 客户端用 req 电平表示“我要一段连续的独占窗口”，窗口内 req 保持为 1
//      · 仲裁器只在忙/闲切换时决策，窗口内绝不抢占（非抢占式）
//      · 客户端等 gnt 有效后才真正开始自己的事务
//    代价只有窗口切换时的 1 拍周转；空闲时 gnt 是组合给出的（0 额外延迟），
//    所以单客户端时代的行为与直接连地址完全一致。
//
//  优先级：编号小的 probe 优先（固定优先级 + 非抢占）。当前场景下查询是
//  62.5Hz 触发的长窗口（约 30 拍），炮弹是 250Hz 触发的短窗口（约 6 拍；
//  打一整条砖时约 30 拍），两者都在微秒级，优先级只影响谁先拿到，不会造成饥饿。
// ============================================================================
module map_bus #(
    parameter N_PROBE = 1,      // 地形查询客户端个数
    parameter AW      = 15,     // 地图地址位宽
    parameter DW      = 4       // 地形数据位宽
)(
    input                       clock,
    input                       reset,

    // ---------------- 地形查询客户端（扁平打包：第 i 个占 p_req[i] / p_addr[i*AW +: AW]）
    input      [N_PROBE-1:0]    p_req,
    input      [N_PROBE*AW-1:0] p_addr,
    output     [N_PROBE-1:0]    p_gnt,

    // ---------------- 炮弹客户端（读命中 + 写砖块）
    input                       b_req,
    input                       b_we,
    input      [AW-1:0]         b_addr,
    input      [DW-1:0]         b_din,
    output                      b_gnt,

    // ---------------- 地图 BRAM Port A
    output     [AW-1:0]         ram_addra,
    output                      ram_wea,
    output     [DW-1:0]         ram_dina
);
    localparam OW_NONE = 8'd0;
    localparam OW_B    = N_PROBE + 1;   // owner 编码：1..N_PROBE = 查询客户端，N_PROBE+1 = 炮弹

    reg [7:0] owner = OW_NONE;
    wire      idle  = (owner == OW_NONE);

    // 空闲时编号最小的请求者（优先级编码：倒序覆盖，最后写进去的是最小的 i）
    reg [7:0] p_first;
    integer i;
    always @(*) begin
        p_first = 8'd0;
        for (i = N_PROBE - 1; i >= 0; i = i - 1)
            if (p_req[i]) p_first = i[7:0] + 8'd1;
    end

    // 组合授权：空闲 -> 按优先级；忙 -> 只认当前 owner（非抢占）
    reg [N_PROBE-1:0] p_gnt_r;
    reg               b_gnt_r;
    always @(*) begin
        p_gnt_r = {N_PROBE{1'b0}};
        b_gnt_r = 1'b0;
        if (idle) begin
            if (p_first != 8'd0)      p_gnt_r[p_first - 8'd1] = 1'b1;
            else if (b_req)           b_gnt_r = 1'b1;
        end else if (owner <= N_PROBE) begin
            p_gnt_r[owner - 8'd1] = 1'b1;
        end else begin
            b_gnt_r = 1'b1;
        end
    end

    assign p_gnt = p_gnt_r;
    assign b_gnt = b_gnt_r;

    // owner 锁存：拿到窗口的客户端一直占着，直到它撤销 req
    always @(posedge clock) begin
        if (reset) begin
            owner <= OW_NONE;
        end else if (idle) begin
            if (p_first != 8'd0) owner <= p_first;
            else if (b_req)      owner <= OW_B;
        end else if (owner <= N_PROBE) begin
            if (!p_req[owner - 8'd1]) owner <= OW_NONE;
        end else begin
            if (!b_req) owner <= OW_NONE;
        end
    end

    // 地址 / 数据多路选择：窗口内只有一路 gnt 有效
    reg [AW-1:0] addr_mux;
    integer j;
    always @(*) begin
        addr_mux = {AW{1'b0}};
        for (j = 0; j < N_PROBE; j = j + 1)
            if (p_gnt_r[j]) addr_mux = p_addr[j*AW +: AW];
    end

    assign ram_addra = b_gnt_r ? b_addr : addr_mux;
    assign ram_wea   = b_gnt_r && b_we;      // 只有炮弹会写地图（打掉砖块）
    assign ram_dina  = b_din;

endmodule
