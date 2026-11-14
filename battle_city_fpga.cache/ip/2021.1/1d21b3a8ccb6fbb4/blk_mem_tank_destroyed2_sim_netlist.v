// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 20:09:00 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_tank_destroyed2_sim_netlist.v
// Design      : blk_mem_tank_destroyed2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_destroyed2,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_tank_destroyed2.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_destroyed2.mif" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19712)
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
