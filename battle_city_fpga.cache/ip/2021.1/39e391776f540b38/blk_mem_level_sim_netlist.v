// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 14:16:46 2026
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
