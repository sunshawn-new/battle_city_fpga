// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 13:17:18 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_tank_armor_sim_netlist.v
// Design      : blk_mem_tank_armor
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_armor,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_tank_armor.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_armor.mif" *) 
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
