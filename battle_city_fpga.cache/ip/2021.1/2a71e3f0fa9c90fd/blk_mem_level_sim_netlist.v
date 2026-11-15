// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 10:35:50 2026
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
