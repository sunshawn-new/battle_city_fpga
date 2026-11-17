// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Tue Nov 17 09:50:59 2026
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
