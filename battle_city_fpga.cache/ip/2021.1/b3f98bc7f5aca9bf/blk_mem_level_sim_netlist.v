// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sun Nov 15 20:00:57 2026
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
