// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 18:33:24 2026
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
