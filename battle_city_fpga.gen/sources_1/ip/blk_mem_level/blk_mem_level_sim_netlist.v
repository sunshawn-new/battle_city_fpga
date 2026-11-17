// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Tue Nov 17 09:51:00 2026
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
