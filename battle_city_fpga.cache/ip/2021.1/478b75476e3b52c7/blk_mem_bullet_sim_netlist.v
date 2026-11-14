// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Nov 13 16:36:40 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_bullet_sim_netlist.v
// Design      : blk_mem_bullet
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_bullet,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_bullet.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_bullet.mif" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19680)
`pragma protect data_block
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
nFf7YAH9DZJBCxxAbTVq
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
