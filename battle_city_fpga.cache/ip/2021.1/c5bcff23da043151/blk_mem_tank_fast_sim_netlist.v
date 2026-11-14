// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 13:17:18 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_tank_fast_sim_netlist.v
// Design      : blk_mem_tank_fast
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_fast,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  (* C_INIT_FILE = "blk_mem_tank_fast.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_fast.mif" *) 
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19696)
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
