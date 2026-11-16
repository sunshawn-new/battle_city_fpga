// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 17:06:05 2026
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
