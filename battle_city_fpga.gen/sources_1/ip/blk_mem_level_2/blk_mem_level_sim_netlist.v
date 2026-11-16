// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 23:09:58 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top blk_mem_level -prefix
//               blk_mem_level_ blk_mem_level_sim_netlist.v
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17136)
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
