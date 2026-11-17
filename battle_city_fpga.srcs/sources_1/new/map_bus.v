`timescale 1ns / 1ps

module map_bus #(
    parameter N_PROBE = 1,   
    parameter AW      = 15,     // 地图地址位宽
    parameter DW      = 4       // 地形数据位宽
)(
    input                       clock,
    input                       reset,

    input      [N_PROBE-1:0]    p_req, // 查地形
    input      [N_PROBE*AW-1:0] p_addr,
    output     [N_PROBE-1:0]    p_gnt,

    input                       b_req, // 查炮弹
    input                       b_we,
    input      [AW-1:0]         b_addr,
    input      [DW-1:0]         b_din,
    output                      b_gnt,

    output     [AW-1:0]         ram_addra,
    output                      ram_wea,
    output     [DW-1:0]         ram_dina
);
    localparam OW_NONE = 8'd0;
    localparam OW_B    = N_PROBE + 1;   // owner 编码：1..N_PROBE = 查询客户端，N_PROBE+1 = 炮弹

    reg [7:0] owner = OW_NONE;
    wire      idle  = (owner == OW_NONE);

    // 空闲时编号最小的请求者优先使用
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
