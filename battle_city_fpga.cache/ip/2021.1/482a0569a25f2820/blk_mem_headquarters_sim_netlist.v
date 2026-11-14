// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 15:49:36 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_headquarters_sim_netlist.v
// Design      : blk_mem_headquarters
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_headquarters,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_headquarters.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_headquarters.mif" *) 
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
