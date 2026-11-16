// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 16:29:13 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_level_sim_netlist.v
// Design      : blk_mem_level
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_level,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 17440)
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
