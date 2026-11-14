// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 15:47:53 2026
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
H/dHzZYZri9VFTsT6kZS
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
