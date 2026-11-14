// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 20:09:01 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/college_studies/semester202609/battle_city_fpga/battle_city_fpga.gen/sources_1/ip/blk_mem_tank_destroyed1/blk_mem_tank_destroyed1_sim_netlist.v
// Design      : blk_mem_tank_destroyed1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_destroyed1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module blk_mem_tank_destroyed1
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;

  wire [8:0]addra;
  wire clka;
  wire [15:0]douta;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [15:0]NLW_U0_doutb_UNCONNECTED;
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.7096 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_tank_destroyed1.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_destroyed1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_tank_destroyed1_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[15:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(1'b0),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbNGmomEbP78s1hfxgX3P1Jo01EKJk0i0C7iGpF+Yibr9EK0s4mcIifHDN/ag4jpPwW3bPllMHvn
U8AEY3mO8hCXVVoilrcRuCaEna/98GycCzy4G7FnYMfowsJb5k9ifRdE2jnurzeTLFbupUSpDF0H
Rl3Ci3DTGeExAZZ9UQE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zZZZoIprBFYfDWmCCcduELBM7HU98/+rvP9g8+y1mYyD3r3HEDm4ZwehwZvPoYWqoGXYoFqWZh3h
utt0abIfUW9/oF2vJ9hXn7nArtcm/Eui18rPYqp3aj/AItPNVXojk9zp7uFZLPTqcyig5v3Jtenl
qPnLi1Z84ZCW7NIRw6Y0bgmw6z26E8VPbYrZHs+0YW8Sztjo6CdIrQeEL5WBDolA0aHoKHWRZyFs
l5eRDmBAolj2uF07t/3eY3J7cYJmEDaoZ0TR1qcz25VFNu0OlcrEJ19IT+QdAxTah4jqJtknGZrT
6lUMwDZ7dBQwF1EuaE6p90gGNERhGAsbHLdvaw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
KUbz0Iu2faeWqD6HFeuGLtSOAlqZmpKCCJfzym8tkcWUUNgNMn2mYvx6PTM7j4tyig8JdUG3uZYs
NfPgAsNXQtTI7b19u9CkMks9jR+oEzX1rW7QtTvSj/nHZLg2smoFwuB5Ieb7/B8IIs1NTUrIz6Rc
itLQVG+L+GMziamsrx4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G7XYdRx9VGclyxTEtwMG+rjJHV8bfBxEGdkcN82UL3koN3Dt0M5AWkzEvHcskt1W0hTOjyYgmvYj
/p70w1nz96tlg226+e4UubpRmBH9QXBBX6UmqIwSiHj9H+XI1yNfTIdlwBKGQvfzwCAMwBwrrrGL
/804k5Ux3RhWRvwezZB4+sj9DFm4akREVXmNpfeqjI2X02LU/MxWMUbKxvjJnD9YxikAAO6ccTd6
8DKv76V76MEFVyXc7E2FeQDToW3lqkRTa6MTpIXbYSekRihQC+qPVuhPUneA4kepvQDfgFYE8/Ir
gu5gK+s/qNfuXhJUAqyLjslrUcY4+XD9ckpSvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YXkYRXpUPv/tETnwnThdQ46UaPmI23lN9vrxHQjIOhq3WNJCuz7TYZK9hyzSdo6k0U6QE9ihQy2L
rYZg68RGbrK8bzlcnQ41r18LZb4GYlAn9PH7IrF1B+aHm3578doOZHf8wzUE2s+d1aHQIn6VIZjL
14pCTAjErJfMO13fgX6h8sgxb4GFC3eIORmkrq2J/fB9HALyh/qdGiLi7DejMfmdsssbOcPQTZUh
6Belf7fHTkIEr9B44rFZgMyrMVx4N9p0XpXD3JPe7Xeg6a3jxdqxHATaMuLdIa4s+ZiAz1TRx0EO
FFihCnLLb7weBBITQyTIncRL817BrF/ZXZD8Yw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7FbNw1ywd4TBNHq8OmK/4zoKI/t7vKmyT8R8SeiyUtKywhn0/7DZ/lV0Lf4IhY8X5MYsKtOQ5l6
DIl3fxtOhxpi8NHn9Nw3Nfb8NnS38Zuy6DSpwOL0f/GSmUSf2/YdB5Ben6xibQT0Oy//oBl5/1kR
pV5fWjj8WRgI6cnmfyj3g1MxepxPu1A/UHxlm1/i9yUHHi114N/hEQ0iujjrn6GxfZSiJUVF+r6c
rnxD//eOAl/YaxhdU/KhUkfsMn+MxtA5m6hTYYE0bnze8rpmEU5UGYKyY0p8KUs+MgsdTe+m/7gV
HSf6puBqQmEa1qksRfl742aL9B9y169or7Jp9Q==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kd1A2zIphLxXB0RyfHIqLkHXfWl0n38vROERuDghYrhK0ItcWGEP0XBrri6k1VZCSPYwiSu//pM6
83BfcPKbk09/A+ksvDIa3xS8Tg7DJK2AS+0pdnzBSjVWh+QD+glA3Hjk6LG9OMbjXyqD3hnMKacA
VRMwxKktV+KT5NXj5a7fMxXjo9exc0xM+woUJiSYs8onoUSwfBeH5/xhUy+iu+w0/OOydQE2LXZ0
1y+RObiz5C22dD4GGCfuvUCGAthYpUf633ZxRYN45mmAn5PxPsH4o+l2GhH/50Gu/VPVoAWDhgXQ
e93oPri++HinkK2uvDhDl4PI9HtRkq11Ky3uXQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gDrrFgXHVyBo+Cn0bYn+SOSOCXPg7besukY6l0JmA/nu4gap105Wxbg11c7TJZ9ctHVLc5DXAxr+
EIvFpAIepoZBREtMjTlaIdNJ8k1nUpwAv2jaQeseq1TudTjugV1jtOYYk0RKd88z/6SJ8t9urDW0
yKqsfEWU3PwGcUGHOWtTn2hfAceNznmEIFWLmFmzSQJ1hQNdsIQn3jHnfMVYu8cAz5xvPVQWYyJW
pMHXhNYk6GyAjIshh991slb1g01K1ilR2tKD1EmxH5WGrX9BEUqBjHQo6uluC/d3mvcEQ5nJ1v+P
hIlj4qzUQT1wXjpk6d/BvNx7LyWmj5iq35dzNm+cdhfGwaFGG//vgmB6D/dFfs2BYSjHsa6VlpVM
7e2OgoFenuG9p1SVPI6gAs2MuFtnDKfxW7jS3RGhvsquS3tg1iFCDH/OU7E5aWfY7twF3yyN6G10
l72RZw62DfNoCdyUMG9sA8nc4qf6dEhyrr5S6XxpJhoBDJvkeq0TCUQZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XR7vRF1m+9DS2Pv4r/O4uHwmvtXkChnKbsJCYczn1dvkZbcZSbBm/2UH78dXUaNorOh9XAuCvSjb
ER73y7e0anAfaIf1tJ9Y9pIb8EuNxGS/Pqdvg36cWarwGac9tsscdv/HWfb5Z+qWEk0/uFcLI7pH
CZO7fF2/ONQjA0NtUFBjW4idlx8WrySIuJgDs4jyGkMhbHR3U/ghF1YhMhwgwsbbcptfC1XLrIqQ
OecZnZu8E2hyc5eK/ccYdKcHnXoL55z1p5amI6Fuvz0wKTz2QQ/mwXodfGjEC1ZRWwTn7zCFM91M
qrA1Is49i6pSa7/VICjgn8ULMT1oKGfJLPm7hg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19792)
`pragma protect data_block
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
uv6kZ0lw8lJX/A3Tdw==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
