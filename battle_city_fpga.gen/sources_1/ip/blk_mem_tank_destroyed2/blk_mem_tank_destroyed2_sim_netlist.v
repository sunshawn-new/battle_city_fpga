// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 20:09:01 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/college_studies/semester202609/battle_city_fpga/battle_city_fpga.gen/sources_1/ip/blk_mem_tank_destroyed2/blk_mem_tank_destroyed2_sim_netlist.v
// Design      : blk_mem_tank_destroyed2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_destroyed2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module blk_mem_tank_destroyed2
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
  (* C_INIT_FILE = "blk_mem_tank_destroyed2.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_destroyed2.mif" *) 
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
  blk_mem_tank_destroyed2_blk_mem_gen_v8_4_4 U0
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
vFDk4/wZyV2hEhxLsQ==
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
