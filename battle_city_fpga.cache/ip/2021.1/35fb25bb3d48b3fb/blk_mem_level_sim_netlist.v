// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Nov 16 15:20:34 2026
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
