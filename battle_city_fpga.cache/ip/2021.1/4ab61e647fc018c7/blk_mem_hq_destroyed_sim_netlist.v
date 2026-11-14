// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 13:17:18 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_hq_destroyed_sim_netlist.v
// Design      : blk_mem_hq_destroyed
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_hq_destroyed,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_hq_destroyed.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_hq_destroyed.mif" *) 
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
