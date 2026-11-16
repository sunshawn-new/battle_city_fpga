// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 19:10:09 2026
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
