// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 13:17:18 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_tank_power_sim_netlist.v
// Design      : blk_mem_tank_power
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_power,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_tank_power.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_power.mif" *) 
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
