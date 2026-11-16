// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 19:10:09 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               e:/college_studies/semester202609/battle_city_fpga/battle_city_fpga.gen/sources_1/ip/blk_mem_level/blk_mem_level_sim_netlist.v
// Design      : blk_mem_level
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_level,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module blk_mem_level
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [3:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [3:0]douta;
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
  wire [3:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     1.1848 mW" *) 
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
  (* C_INIT_FILE = "blk_mem_level.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_level.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "4" *) 
  (* C_READ_WIDTH_B = "4" *) 
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
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "4" *) 
  (* C_WRITE_WIDTH_B = "4" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_level_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[3:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[3:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17424)
`pragma protect data_block
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
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
