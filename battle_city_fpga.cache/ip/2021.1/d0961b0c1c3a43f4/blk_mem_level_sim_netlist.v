// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 23:09:58 2026
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
