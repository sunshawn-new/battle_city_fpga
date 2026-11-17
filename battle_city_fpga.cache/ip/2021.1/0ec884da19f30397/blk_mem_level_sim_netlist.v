// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 22:18:05 2026
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
