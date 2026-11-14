// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Sat Nov 14 20:09:00 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_tank_destroyed1_sim_netlist.v
// Design      : blk_mem_tank_destroyed1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_tank_destroyed1,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    addra,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [8:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [15:0]douta;

  wire [8:0]addra;
  wire clka;
  wire [15:0]douta;
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
  wire [15:0]NLW_U0_doutb_UNCONNECTED;
  wire [8:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [8:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [15:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "9" *) 
  (* C_ADDRB_WIDTH = "9" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.7096 mW" *) 
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
  (* C_INIT_FILE = "blk_mem_tank_destroyed1.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_tank_destroyed1.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "3" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "512" *) 
  (* C_READ_DEPTH_B = "512" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "16" *) 
  (* C_READ_WIDTH_B = "16" *) 
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
  (* C_WRITE_DEPTH_A = "512" *) 
  (* C_WRITE_DEPTH_B = "512" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "16" *) 
  (* C_WRITE_WIDTH_B = "16" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[15:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[8:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[8:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[15:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19712)
`pragma protect data_block
eGME78JmwFhe6Op7n0yiDHMTfMRXDITvhiOEOff2LpH/wAZ4kWe0tb1ztl+kMesDdPvKtNAwTrky
RlzQj8iuwt/5BDKwldRXdax9OItw40hcEtoPks9yWM0JYtLKC3uWchOrq1zhHcHLk/P2fb/uH7Yf
JjQ52ZyCnnwTKCc0frxQvhSHJA1pSHlmoYpBYK1dt0i8BAcMrPOh+uLIsPcYEN1swyznk2+sWVvY
QyZmp6wbGaWkZMtUNmiGLdZMJW4GO/RqRj5PT/KVbbsxxOtLGDAPX1hj/M38brVLuH2oaIQkpPAE
gzFm/bGESTnI3zrqyAzuCvGuj4YXuIye53Xko0otaY1KMzjJXm99r8zvwd4odlA6MGZfBW2asKjE
dRCfjW06rs/ccTLvV1uS+t9WVQUtqcAnPqbM6pmsZ3JtfWpoUWRsKP5DMq8qTh2vAGfJuOFTte8R
jdI5WGnP1UsaL8+Psbt3VolKryao5QZwT7h0cv5DnlMR/wj8RNXeYuIlq8rh3K/HxjnnmEdm0KMt
bRA16qOHYOIyXHfK0TKLqzMp931QRZqewM5mFYsU/U48CbpGil+Hmivtc6JnloCLg2fzopTvghaQ
5YvSFAXtK/IUbGoAg+k1jyBHm7M+sNOPKiRQoNic7cSk2RlH0oUOwG4aCFfAhQl4wQzx0FSZSff4
zs8Gh3P+SEf5MuYLFJppUqg4NiKqZZLGQuYfhj065GhbPF2O/hc6AX6WQ5Lu1QnVcoMxnIvkYrxZ
Ziz9faBBG5STgRiOQrTGZ1shHORQI6xuIVPlapQLRTWvJ2YDrnZji+wjCDqFqJWm/ddG/U6gbXWe
InmJYl72cVxiuJhp0xut41m2dlFlQhEPU3be/NyA0QK0XkYtnAIclvHWUk6Q7Bbq6pglZkM0QWDD
EEv2C9LS8VG2JI9YCTyHeEpl/tDAcQuiR/5+koWPDRBF4psGCBpb1WDd+yMbaq5O93Ej2xvhggbb
U6ZbIge42nU3FpPVzRq8HLtf9AgWDUHdTyihvC5Jd89Q3qXoC609Me13SovW1hjGhUGbAFHfECd1
nrYqE/qtki/FgcnDfSXimJ49HfjsnwTt9jdE1WDmEqvFm8poCt4TC7pB7Jpx94vqYnFx5EIobb/X
AhiXRzjqTykpUdZUwsMcLZCzp7m0K5y42mlykzBFVhs6O6rvN5EX5RUs1DtHLdAsmSts99Co6Gw2
E9JO6gA+QR3MGkI0wUjablKNCJ7z/JjtW+uUrNFFpEJq8x6vlzKRoLDyy3jnvP+7Y9BoeFPS0RIo
UBCXYgknM3KEiZvJfq59KA/vdHkl563z+y/JTSDGFeD0Ne0IOl2tVZJZpirfHTaS9JuhNATEswNL
1gLrIxW5NlIqgkthidWInjoive4OxMGkGKYabAlAcMfAjQQFGBHxec6XBt7fwDxV772MKSxIOTtN
SDe2jGjsQgHvJlvLtexVmHEC2NhMO8rWImzARwm0ORJOp3O06MGSNwOGVJ3Pc3V4iLfGG5AZs2Av
+a+BtrCuJbOayOoaJKqw/l46vgH2yr9ZOopIL6WUQ22yXuXuShlYcPcVL2fH9mrzuNXNxWGnmiFW
xWBlQ88MV5bR0a7dysJmAN5GCS9Ght0k7abHumVJvYPYGCwy+lmVl5j2aISZq+jf4+5S31KLHgxS
08blfJ7OLPahR/yxtDxyPE7VDB40kT/2oNAqw6CvhfRGnP0EeG2bZkVp79gsqTmzZNKYtORm+ANi
k1i/ezVUHeD6mZIkHMbGA/7Ipq58tzOv8sOcwtaxLA5OL1m6wTnaxqMvy2Rpx+UFvC/SGpv2W72R
JAWzoLSLRKUD5Kb32iRVva6LXm6ZDS/C6MfU+w28K5HHo2tsThgD94NPQ31uE9aBkDnS2qYvt6Mb
0Ho6Ur5cClWbIXINGoi4fpRS/5qmkwdJ86P06/vBdTzP02DIX9EvYDkHjVxqNtu7XuQ/ON/2PMhJ
h/UCUl9JRSkxvjwKWFJvxcwkhuu13KplI+2NQGF7RK79eDVhSzJImkPUHg9z+pkXtkqHytHDQ3Fz
exexImGPqHUtfyRQVIIEsHZ4pAlYJJ1YB1efpYC1KRBxs/0r+fTmD8WdA/wuWNzUx+Q+BWLTPN9l
mpFdprJicVqLcdAixXEyj+wanABPUrY5K7c8lDwv6RdZskpyB0InzC+RPLajkSWzE1S0AUViFH3y
L0+wI9kK5L516WSumTrJGUiniEGXJdj12XWRq1VeSKIC+9FFomExxLFarKvtbqRu0xAwz029vm8u
ist5nPKpjVTnwcn7rll2Oq17wPF6n0FVh8HqaiWaHQkFCn9ZBxHL8pGQ4bnGH4iXZuCHWgJfUAnL
O2x36fCiZVcxXQ+M/ebWD7ZCPkwHJjjsuqS6Uk+5PN24I3RUWIgtW2N/Q/9v4mcPdKMpWJFVOXYt
T7naR/5o07Qjwja8VKzwHSU4tHc8YpjSq3Rpl3zlCbz88/kPhniph8pKIGJvY75yRNPRqJIe85i2
1mvXVDDp6eHRTiX5NQmrGqS4uDbSpUBRMdkTK8e2LrAQaT70/WWXY6Ohtneh+n+ibtURbaanULxQ
uZ82tL5jV+xioo6oDbZC8iVb7MtKpBnpuHp/GKdhyM9ruNMmEuCYqrnacoz+w+tmBmHjwHP4N0Of
IEYV6LwAyLhnQaH0uWMZBUwGQh/Ik6CZ5jtjPZ9kcYbMsHCLoHd1NO4G7x4lCN9RzuvTx+59i+YU
T1MxuR0slSTuTA8v79xQCjaw/ZnIMGRopPKDciaGI7/Tflyg7Pej9B+1xSt/Cu9QjSDZlgT2hYuB
1Idr5XYSraL83P1YMWR1yjJGGzL9reVsp36oJJrjsRg1VLG5d4poDR5QdJYt2LocQbMxDHhqnDEo
UeLi0x9P0uB+uPv3fmNNOfPvBhe4ZIrzvEuiDrtJ91OBKr/Q7PY9h0JOhzBam2ge+G0kOCtBTZFo
itsgVurpjnueG8X1Eb+QRxwP7vbruxs459aG9hew8tPHKUvIwkMZ8/KYQ2wo63RHllEGFJL+SWGd
Jzp+GZdCfq6LxoPEF2WBe10Yn7CxCajDo/BYcql922KKeceJACBLipKi96PmdqBjYACSQju3JF27
w73aYVcOxpHa6OXjzAebimrSXWM06BSeci37kF2rc8D3XfACE7/cVV8/G/lrYHrhpDzpONqcqt1H
3dIgQWesbKonIZPk3I7DtXMOIJNJUtL1YaULilR0yoCRKy/7HyGdj777lba0jjCBWE3lhzB5T5PV
TDA5pRuPKW9zfcdS7Lo5M8RqaC2Q9E2cV2pZEbwQL3z8lEvTMbdT3wHRtlfq5rNWxIKtdmpnY3Hz
22Pb93dJsiD5vSp2QEAkc3gXd+qCXi24+pAyO2k9vI0kpommEgAsUCkbrYgSgSFbFIBFNMHlH+7A
QPRZjc8KAV/znJHrFLSqn81ymEXU3rkZYg5ESGb2/eNoaqhR1JR7bIsP7WkWooeDDxCark+qtSyN
CUYUtBQ1Mn8EomuqhvGCc7vrlSNTToFEwNcNVbeoXidBE5QKDiCrcafPMB+zgRQd/1dF5wuiQ7TG
AXr6j/biXy65+u4FT6VBH8M+6BfgWvLVhAw7ZqoRaGoUf5wN55uJOksarYLaifxYU6viHPL3aLoy
T0586s98Xkjiuk/mhtnNrWZeZ9BXu4wBPxd5uLt8tKK+qawWmrr5D3Pz3SDztdAb87a9klpXL/rG
njWdtkiX70iXnSMzCielsSTa8VkoN9y80MEeDO6P7OtPpy42OQq+zTfxObImfTGWN8vkoBRdkS2M
gN9e0uo3jsVWbVoG2vr3RzsnQl3jI8grVYWuRdJ3ZQ8STdjaXRsN36N7ZeIRfX9MwdA1qxbAMJIN
cSy6XfbfGfrg7si0m3JRwPz23ObdCLTCFAQ6DAcCLweCjM4Dz+H0/nz6ixHUCV+0uDqwqUAyl8Hm
y5pulJ7X0Wp+DmEb5BWZXO0uobXFc49DLPUw/h7TP9cgSucNTkO3nfre1LhGSZCPW2BnjjiNXY93
ZMcJNNaGxSQEczv8v468X38BOIUP39aTlSahG9QDj35k90ZZQyn99rBcLdyAyHDPINOjhJ8dG3xj
endHRoHbhIuDAWQAftEOMnaJiQybauVhSAMKfEaN0QecbdXaylQAeIMbY+DmFPoLo9duwzpkymya
dsRo/4q9a2jz7dhNZzE2zHRban2aANkuKrLc17rBw8hqZzAhP4pydbPH0CZPCLyl0C9XcLRobuKG
tO0l1iNP+bveGLjvKvejlAqz1SOwkNBGxFZAkz43ZKQ5Q7c+pSsFHDqXnoY96nLS/k04+4naRHyc
VxyPR2krJIjCQMX5QrmDVg0gfSrACzzj5Skat/9tYc//t2epFMxR8qz8w8yUKpSoY6QX4du9yLLO
4y4IhecT3ujviVEIEej/v6QV5KAMm+POeFEnCDtGXtwKlL537wlU0LeFFTGnnGLgmSq6yYAVPJ1I
iNDfbZ/JNwYku/4Mz1hNQ8KpMbq/84z4wjOmUceIwDFmrMSGimKnuaI7Lij5wptzMuFE8V4Bwp9B
0QT8xj90dfCeMuMxVitp53nzVF4SC2O95OMrmyuMUCpByKB3QW/Obu3Yeld2RTsaKc4bWCPito2A
IKLTmiqg0U4i+0JIM6AWs1NknbgTSXHkE1CDRm3Lq5/IAmEXeH3DtiBq5qwpkYPBEmrqwQ5NIm9/
IRyHFfATTYmpC88+CFSZz61nKEQwKFIfh1H7cMjt9lpKc+xfsaXajdbPTuxAAYcZXRSprn0FMQeK
ADjRsB2umbUR2UGM/66jB55YzGTT8wphJf0D2RByqVIrr61mHQhdk+g4dHGfOjF0M1EJaNEw2axP
4mgpPYtyYMBZYA5VvEAkEJiRjXi2oXrrfB0C6PvZo8egMATl68bsgLRcU1sUvEOqfi5w6UmcgQ+H
geQGFjpwbY0oAxnC6EuYEA1ePufyRCF4SXFTf6r5IuZz1I4dfrANzDOyY65oX9/Q/hQniRYfD2T9
77dNdw+PmxFqfqe9IbR1PvKOFplkPelEpwaoI0bLMy5lu5Kr0wIR7CcCV1/rMizwLnZBUrNfSpHZ
7njFDo3oTe1muSAhBoYQ1HpNyeJ+UMD+/P+2a4LMzCNxEcJG88Dov03lFBhl8nQlub4u4ydK2/zu
tiDghi5WKOEC6KJxl6zI+D7wDj1KlVQbnKc4NkbS3I//JgBfoJXJbaLDHfTSug6nAnblF79iHswD
ot/m7Yt1THw9M+Hlh2MXgpLJV7oN54Lh+9lgDQexTMtS/QcKJe3tm0zfdH1krkOSYQbq1WbqZNIQ
sGcQk75uplfoNAFZ2bIG8RP+xpPq4kVJLCa6tkdITViDJO0dBUx6ZvXjC/arfqTue7GP+GvtgkfI
AVIQo5HZhUfNqCu/mLh+XgFaouNdDt7SDVTt1zlcdjiMAu5lyMnjfQdgVKli0Ztk4jTs7J1kdqm4
vxUCARtEKQAep7YdkNOZCoh4rBMqw4SWvf2JwhfyPBkOWMc1wNko9E7S05Z/xbCzDHM+xTU4/H/V
yrPEMWZyIVBjW3wW3qgCKQ3GGtYaxZfr21+bkKLq/AiIkOF+XzDaYHMliSvOsC0/6zabxvuaZAZk
K5yGrVN0yY4iLXsndOcBLx8isbKcuNu9wrHs329s8GboP/XC17/mOGXr/FMJ3XsauyDYMcjLyjur
Fh/p4zhrnGmdgv+NkT75EZ2YpFGV9PG2TNX/OKD+BrV7ae4ZxlJQ2cH+xcPZnlZ5GS/DYO7hsb73
cQGyBxGgri/e/IJiDzoQHmJ3EYJYGoRQ27Qk55iM1jqs4xsLzaDCMElq54JUTPIFrDGYQZaiu+tK
lSz8nRYYR5cZ1hVLFxorhFCD+02S3haL4yyIE68XMT21C6H6pwp0+uNLsUodDbScnaL5iZ0lnvAN
aDSF/+pCWZxlFgL8+iv8g5irIWvxDd7dEWX0vtzyUKPPHvRvXXzSFnl/W1YA9HYYJ2rZ/IoY5isO
k3TfUnMX2+W9j3zRQN9JeOjam5OXlx6FNUFAq4ECRaFTFeVQF2JfjuAlMm52FLnX23Gvh44H1XZt
UlR/02BMCYLI5OCrOBYTuc0/lbooxjWrb7GzaVFNx7qeDz9qLWXrjEEpPIlMttgzdcaK6z36+BZp
rrT6DUjKew8cv9EYj91OrTL9/DWXJvqtAAAdVqZ5BXbDGyDS+0OrxPGhtev+D09hp0M8Ip0P7/4P
nWTMKgyLqFChQGkttbVRHS5AwP5wwZEd9KKDsDQ9MfgmWWTS/HICsY539Zxom6wseaINuyW1CB7t
HTRIktjirHJWVhvaKna/5BvdyJiI+6qXfeuDIA66uvams+IY/PR46xz00X51YwaPKrdf0tm1rexz
cMjcwsacaSeNZxsGo2N10juI4ZiZwlc+ohi4dU2G4XdiYeUVjn1WKewrcB8pyZN6RRqX7O6jbJIt
aQMAxqwNlX5pxx0ZjtloxDF7MVXoLiG81J5BqX6CrS/hrTA+ICI7VsEqiQOeWOzVd71ngUlfg1Tj
S+iIjCnNd3OZJcHqHqpuRK+VbbDV/b0OsFR6radUQy7qhGkXoV1XMUjPj9RHG5Ddw9GNH7FaBiqS
idsCfNkfwjDsA+cbpkKWRcmEaj1SFeudVeqVaXWpl/sjw35H6uD+RmsMgwPi2Lsl1VplXZOnip5T
octQ9Je9Hge9urmvDbSfSVcVXuxjJvFD8eRrg+RPZRga4u1zz2B3xz0TpSdsnmvqfwGQ+HbSJToz
+RZT6RKDaJpNg3kViZssYOKX9WcpH76ASe+Fr05hUfEQEbp/BmYmH8bQlVD9ACuf1eTlijeKSmTV
zCSLyZr2h4Jay9lADCqAcS5kPbGtNidupvroweU3XS3kd3sE728sbXgzXdJD7QBMqMBUWHgwjTe3
cdFlDiRJhSTJ65Nv4sCVJPGWB7jct85S+vJ3by/spbXkg2UGMBe4l7g/DzgDDu/Gb09swQphuEeQ
2aHgb03bb1PTurxvSO+XEBwEfaPXjsDfkww8i/UG4CmQOBGd3UQ5RvkOEi9Bjq1FNhR40Epr7pFk
PR1c15cYaWHcHIIsowRJSFwOSRJkPOPYrIeGlfPTVIylwLSiYlp1ORUy1k0pRLoYorsrWFTkCY9O
RG75Fyjyx9+agvIWBGbBd1cni0rgsTB04aj3Z4OsplH9vtyrDpU7SmVWTYM/RYq2W44FRSLNchm8
YbjKNQHhuh3OoMPW9Nht3Nri+jsmeGxhHDLlsUGxIIXtAF70FY6d4LnDoq1mli+f/Ueegg7TUGKp
6/4gGY1GFRygW3Ja54/4gGlwyO4AelL/jC0Pv8EaCt/oVfSQQajMSR3Exb5teeYTQlzq45vAmq+M
pJ9icZogEsqFf/q+j2qBw50sGGOABywZRD3CWhl2mpZ7lm3b4uNB08ODf0ySpHEKBUO39xGw1rtC
iojFMZAbqyH2cYC2HngBad/pF3R5tR2o0vwR05R8UMQAdu4baeyw4+/s2lwtTSExO5zPpbtmoUHf
lYU9t3umj8i8Mn87jMM5vgPJVEBX1VTMyBIJckdxkjQR0SX6pVuTsx55U9jgcSGieM39t9ZjoxlN
DLRLB5bqRBdhnabzwPQanIrhS/Yxm2sNd32SXGzjx341dtKeGvtdiUFEtJ9VRCx/kyjh06HydiHc
91HVZlGhYQOrYkq2F04g0zl9YYgahIf7z4IBx9CIJj0fQP5ztLDEphrLtEihMUlGoiIvX3R1Zdsm
kCfzCqmEr8tsitzCqXHUeDt655ACxaB2upOvih3vF2R2f2+bhkliVp1YsNr2LO/bRjQHTDWU1QEE
gPjk84j/zoNsqbrsMvlsI8cEL7TVI139MY4WPoflDAB4Ze/jqMz7XgBXmDwgj4QOInn8MnUWBNWU
A0v2/9feAdzHteoXcUcOaytr1fkuPGjZ7ctITRyjfE+D7EUzy5oK5R9NMcPOaKuw2IS7wjVtKODb
tjRHMOgtrSCH15Ysj3UgvPlzj+D1dKqSulFa1WaD0ZDZfoA+OH3fnOOd1m13fdy9+kDR0Rk7Xuno
xoEw/XJuWOeENCovdIeVgMHX+IAwVEfwK0B4NwPZJcJKAHKpf4BetLlb+K5N/BK1Lj1JAufxxwoo
JAFo+4OknmNseb+haiSRz4lqfwH8WTAyf2IIFPFJxGXdD7Zy9kJCcEpcce96JcXqOOkTgnSBVZ7C
8kB3o83EsElxCVu8K51y4M8UclOh+Zo82ENfBgW/leHNCFzQxLpMeP00DAyuawJq8xuq1p1Pkz1F
33aOBa0p3e73shL892eJ7nUbgN5rzwVt3c9vycIvRgMZq1/arpP6nWHicl7eKGCisuWDBfJhAVdM
fU3VEYgDcmHC5kat/vxPUaZOSuxoE80bZaaGLoEuXoL0cK1iSq5FPt2gnslGbIrzL2Qs769Ri/Ae
ioqAjXvaQPaUslQi81ACsUGv9FvPUSTtQkyVrkai032rTSv/bNjN8GNScVMzlKn2/jQ5DbOk42B/
bEY/Rl5/rTBYHBGHo1Yjz3EajRVdyr10jqPl1KCtWHMwfefenWicJaNG9KuLTnkuGJBBbc9E8DF7
Fb79Fz/Kn2e+fSJS55h30QGoqTzUB26N9CAxHCznAJFfIZXbN/X4wDcMWnfK8YYEYlHsrSIylgJa
3GGDpm8YzB1SYKGR9PoluEejBjuTJMV/61U8Ngi2H3KEKcWibSEiWBV0oEXkO90mVGQj5QGUtVr3
ukd+LARtblQUxsOh9SqFmIIyk/ExM/MZLwjH9hbxvJm9Us0MnBZgcbb3MT5NFkMNIsNLCItFiYrf
lVC+Je/0FitGEBZbX6gxmtbrsmg38WMJlxqi8MunFCCE+ZjyvxClb90gdtjhwWtwDF4+YmbdkEdh
k1thU16CtVmnTlTf3xCtipotRpczL4y7oz+MACtwxFXBoSL+jHUR37AE/wnJjbSLbeFUkIFpcA+q
mo1kvGUJQQyHJXtHjTH6rLDvM9SIBbHLDJ0qBqCN0J1lKH0MA7pTGVvd9oV8y0tsOBEDpVK6VCm7
5I1EAa2oJyeo2MOEA934ow7JBNmmbrP9noI0p7LZ1cCXnGVuSGjNLA73ypksvAupaWT2MJa1TisD
mT9fm9QjpOyKOYG5a40UhK8tlDKBEmqncgi5r02s3WrR+XTlUW+Xbm2z99Nyubce4Nc2+cOZ/w07
vtnnEcusRpR89HLIkqfFOeABUf5M6d6JIGBomfDm89vLZoO7YFxZilVKaaOVdG4FVEy8v0bz6SUt
/1dqd4vZakIetw+o331I5JZCJ23vKcbnNdaZzJEHhCPKWC5NPMrrY5YGek/IpqAT1ZzK9cJYOLIz
CXgglCUoNFNk0mtPjKOIKUFqigiPYd6K5du1ZziHm2iLPMpQVeDZqGRC1nOQ3BpfDT23E9RkO6F1
BrSPaonZ/vdUnMN0drNRKPFqEpUW+Uhu5F5JwOai7QwiHrBXp/BPMIwRhwnGUzFNSv5mSwdHQVyu
D87eJZqYN8+7TsQ5YfAQr0QugOQh0PjTdtQvYUIjS86PN/j85DwAW2cVR6EiaLawQLpf/8rR7Osd
N08cjtIL3xBLw6DoRiqLPY45eYN31dFk7SvdVSyVMd9Lz5J/u3dUkmtRNYfxz1sMvnBg63H81ePl
CoYtECAoDE6ur54s2GymYK1/wBggiCBsHhTee/+plxNGX+VTUIx0X0fJXYr2wBWPZ+MhTCTJf7o/
KNmL5ieJTin6UKF2X+UE8QD2ymv2y59CRVNCqYbNgaAM3eQPV7siq4cDJp4BTBbv57bkjEBtPgPv
jx7iNDcM/TPj0Zd2YaLRYtwcC7Zz+nrNNmMTqSxvM2oPzD4856ktY/ek80gzubf2mSXjcQU3jXy5
KbKlh1ciJvCyU9rRSpG9hiESHglKk+brphBr9p7Ymq/8wc0r59LmP9cZOKMxP+H1EfYrzakwy46E
RB2fbie7kqjjdxcOPQJ1AES3nWR0MjHIrnqI2HQmAuSpEtl9vfsx/pRd1HIcFNTPmIepJZxi7E3g
XKLCWw51z9GHJpWTxS4w+5hLCp160zoWROy2yspFmDpEOavwb9LvrSWqPsldyazcROVE5wfHGbRq
g7cEDBgPjCTluOgR8uL3gWS0j7LI1VZpHqS60cBjfMNwCRxFpm/TAAWYMvLUlknkPyh7/rtRgzF9
ndb4LAZ1udIysPShx5Bn6EOMRE4zdwk1TYwolK7r43YTN42qYj5s8J+NW9/Y2XAQo1GfCpzw+i3K
bTg/hm/Vx752D6aEuNjrQNWNFkCMBlF5dXhr2fgi8IaAGkFtikgkTBdo5FDO7slqMMWJ0XIQE58v
Uyw9+5f3auG8+y6ar4ScwFULE0kXdwn7rMRKA0/5TseoFDkcz2Qbt1TNN0tOmvGDtIC+O2VGA8Xh
y182t3FGO57kcEvW+4EygobSlxQcatI66hPRMeNvfFRQ7cmam5t1xDYM85v4cFLsOmc70PsJfls8
x4pSqcEyoC9MEBqztitFeCQyIO4jCs+KqU1bQHiKHhJnXZH6fYXdn6jwysUNYV7Iy5JEOlNVOPs1
mw4hbZcJy3Li71g+EWsQC/In9ksSuMRNe1XEemHByC7+/Kvg4YwtN40kqhqxrtbDofTxgJ6N4WtN
i+b1HFwWNx99/4EpTsbUGmMtY4mLRSQJ4TIAjPPFhMomCXJZxrUD+X7yp0UHWR89R6TuBubmWwOs
kbCwD6v9ffLYOKhqvVV/lQbKI/C36X/B/Scho6M7H6TPgqlwV+G1fA5bRDYOaPXQWcPsOuvRmUxy
mszilW03iHwuAIiPT3tQr0INPRV8tlTOyD1DR8mNnQc3drUDDFcPEj9s9Tx+Y1trmF/J6FQGK8qO
eexN644Zcgrp/E8helz34u33FR+SLhPDeRqPEiIwwlHHtNHxmfPixtUSU+FsmJ9QVKvbDcr84z/8
xuXLhEyt4EL6PvBBc4ZyURQhZ//9GInUMdqjdUcz5lX94t4/tmexuRHIm3yBPIiALHC7kT4MFoPv
IQiRtP/UQSZmqhn697cfPy3kmLojXGI6QG20Eg/2nJnfGNqHdt0C5xvH9FmhmHzDvBIF+ILCS6UG
cjRL/MNKBwyCor4TZnEJI4+UP/0ydqmIYQ+lslykmSH/5Z7tCvKQ+C9fhzkPCzwazwXupis8jxzP
UdX5Y/za+9nxbnb0Wy4PSPTETVXqvstylGavtq/UlTL8yRQOP6C3LGg3EMyDGr7lNWP1s/lV0zdD
IGD7OuXdZ/HzbOVkT+gsinnOtdeNwmWotSNmi3SPUzu2qirTkKfZcRc5e7L3FpQPZ16TMcvZtxmP
QXUjZHNsqiLAyLHbLYskRI5KsQFm2PfMXz9afRF77zZhtIaT3jY59qxJ2eDIpVqlrVs2C4q9Ljs3
2nrY5QeX7Q9hcZRDXvt7WpKh/njB4qvOl7n8tlQUrMkNLyiAaAVN5FXaugPL6Yxu0VZlLZWr7+SK
3PVq1FgULtQd61czFWMczw9NONTBPArBr6sTGhQsraixNMtaV7xrYalOLbTXfYclqfG1yFIrbxV0
n1ZubzccOBXvVYBgPKB6jHwSiXmbuUnqfqPcAylLI1uUD3NhR5UmVuvFnFmQwIuOoGy0q6ngmG/6
CbnUWJ26Tk4Nop0r7CMpXXB3ylfgjj+Ko3ipxvsHdsZRqeFIhLUFVcQB53x9M1h1O/3qYxlyzigz
WD+Wi0jGNkymShT1RNRixwDbe+bcWpanHThKHedE0hqZsiOCu3H4ZNFNm1+Du4m69VfY2FVmtNsp
QharKbo4u/rZ09G7u7suSuw8xINbYQvuxsc16wXrQDpLieWUfqVCEIX0pzRrodgCNpBZNinU77eO
493WH8GxPClQptATeGUKI+VCYVhOFf7iFKcBYCMd/MJ3nVLCOMsE+owhxa9h+/B1lNbP0yhq7DN8
pEoomTRWdR5ZcCff1CeM6E6iCmYP9Ru9ydR8hY/HFrM4muSbkGydc+ZAQBmBunHrCF7lVWLxsqfY
psJSdxgm7a3pFCHS5Ie9dqoHsErp0Kk92DpwJVnhy1CPQgqq2ITkENYU6unDQRtrgiQLjEZfkd6O
l4Mf8txo7UcGPNqYyeUMOMw1ey8OFI2fPGdiMMt/VBzqpCStj7JQf4wQV7ItKMUwTGgXhZl6YCCs
GeBnY+j+9syGtk13vj7BBTwnC6IpZhe128iaWEzvewA3qUDzv8hUXs9E2ehfMwWhX+JrmTnsF213
X7jVIrRRcIROq647oGg7Ivo/rejulsQ3lTWASINPOwC3pYG/wXn1qQVQLn2gE7v58twLnTYVKYtU
ZsW3xa7WLxNbqRqi4b9mb3ng/Rwp/V5eMRHZeuJ4yQ3Ry9Stg0KjffbODtWvMdA6GILVcniiod8p
kAQrYmMdBbHjtbW1uOl0XWYN7zQkQ4B2ODu3I2zGICWLuI/mSq5iTv4TEv3sz5X6bCi41E6sHVBA
LCbGcea/F7wdEsvywvCohG5KwXNZDpNYbjPBZGOTdGpO3JoARzqsYlSanKngpxmGc6XSeTDfsg9b
mzKC4FUNE1wP7M+nuXckNoUNIVDbcACFYWO6Z+Q7sR8Skp3jPBCMvKoIoO0Ert17eNBD75ODLjO9
HuO933SVsXU5dMQsBLXza+G5mvBVWglyZ01XIKjBtY5XyuqBZVZ7NWhRorrDCx924hDQZs1BHGfF
xRIW+Z0HB2RB74U1TygWAwDdR4SVv3/jH0hCa6kiYuFwO+D+X5xprS8j+Gaav6yAY3DLnNQZhPNO
MiX3vRLdQtxlj5uSIYjUUZ8gDm/QvIPxsOe/dM+k6E2GxwWmGEOzqpLd8fh9M9S9EwWsrp2CPbvS
HR1WO6tUWRa5dDGkzlFvgu7nPxIWjwLkJH9N44dQBreU1i4lE14rs5g0RVoU3ONRwqNm3uG0/+FO
oOqaFqFwucuk14rQXNupfLQ8jqigNuhnmuLqX7knstMWw8fUbr6gWXa8TEDW4fQ5KDu5oIaqdT/u
VA7lRFj3Muo4m/YLj7aRRHZ8cXt6ZOyXIP/RP63smwfNwW2mnZZYvBtQzHH/36f2lcIAi2EPGtCH
N8Mf7jQC/wlTCQJTauzM3/Zzkq5lPQWek4VGXw4hhTsHLoc5vElmN+I8sIVd/gJ8RnnV8Hgl4w+o
FebVRp+14Qetw2BGMzZ9rlc2SKgvLOXVXxCzBSiXZsiSB6X8XMxSkTkeUphVLjpnkPtB5bDJkHCn
0IR3ztLbHmIYtRblRBgN7suWVppMd0xFqwNvVXkM6p/p9rUB40KSUlIa5aWKhZvO03RslHQ9zNiO
s0g9tCYf5XFYf9v9P8ri0e+2da2OZwXEfIVpwOLj8w4m0ng9WXWRP3lmddda1WKi9iCC9Q4Rewpe
lWJw9rKXDFcDPHncvTXSxPw44XerJvr6OjreKU5RCvDHLzMX+8FwF1N9cl2zR1QxCbsQPLKJgNcs
gq+hxX3bW8xnlgvo0CyeDuQk0fmNIwNnz2WyFPraa9Lpv7TnwtU7GkVUPfFzb8YAcPuR32rrNpZ9
oGxX1OVVpFDgL8TeSTwurAh9cGB/Y0BE7GXvobzsaMgFRZZC4AiZPhV62r7SzB9MGOKtbC0rlvuA
CT9ceuk0SdWOxjhNOgMayWAFCtZEemj2/zQdl5fIG9ES+f4+xSsJyMYYk57Dv4le2LdJhiaLGKqe
5vB62Qbr26b2NlO0mSQGGpk/UBlhDD5mvU4j6dwFFFxre/Fw2OegyeaHtqnP0KDT0agdLC2robR3
XDrFqLExn76qBeAvZMupg2rVOjnEkJjUryuUKkJA6Td1f8+Y6Qra/1DQL5G/IxQ2kObGm7hwoPpD
4yn6BkknEpL8cLNA+cbFWlP+qtQQ4lM1OXVctF0Es6mbcaJenlf8rde3o4NV+UwFU2xJ77OEPmSA
HV8ddsT9KLTXeY0DHzqv7wDkQcZXnBX/gedkxHpByTlGEtINcfOOskMakwp8Qh6R5kEmnUsq0Kh7
yhD4mMhX+M7EKYUEOTU4YwCYBwaFhB+h9L0G8v2UV1Cit1HcGKTF8a6qvcXRld26ABpzY3uGhFin
i+M7YjfKUoPMNQfLDtFYHwcXEPUTaKQ3UgDU6L+dpVt7P887JomTCyNsBaJONI6f5thc+7R2vpvB
2TBAlLDwd9ymkBZj6SW1mdwj9GSJy656deuyjGmxw5AEzs6jIikJiE6sA7ZPxRHXlKaBuudyfl/x
vjRJi+LligtuVri3fmmDeTQWaMTCgjun+4jgfliBGUF9iYHsmMo4wyuDj2rW7n82iY022PHHMQ5F
PtDd0gStOUXPQezRf++UhGzAfv3ZyIQjCFv8bB/UEF1A5DWyCy9whHgZ2lMH1MGtYy/f2GDjMf+8
lIaMN4gWkdbQSv8rzS/PxFWF1M6NbB+SwYVk3TxYJgBWL9ViwXkZXjtzxXlZHLgdl93kiBOwzjmO
KK1uNGroA/NCadVN4GthOFTezTSNUOYdv906DUuori19I3s4EFJ9qGrqdSvtVWCV1WAEz9zGDBQk
PI9ef1uM5abJmIa5q8d26JfX8KClVzXOI/y7t/KKMkuIHuYjXh8+tILzXzqVc9Vxqyj9OQYsTy9I
2oTDTTlYdbZKcVNRoHZBHgZCQaGoIZcWn0EhFpWjf+ufDvSGozSkw/J6vny2/iSdegRW8gxEve6g
1ePKxzDPzlMt87kiLA4veO5eITo+CwY6o45DWpUryi/0vGuNzz8PxCwHwOuDXC467h5QTNf7EvsE
fCG2PlfKxBBdenNKrCKUJvHyoB8AK1c97ZBFTc6VYJRIn0gFBYdvSv/rsHDX+c99C/B5PnrC5TY5
hxBUfp+Zk808nFdq5n7gb8u+lHnl5CLnTykP9scSWi3wphi9AP6BtECK8ySBej0AUIyIJQC2ahV2
S4BOjgNk98N1lV0H7WmT32HWJHGRSsRCWp1UWiFMnC3YEVRhg+H62YSr4GXJoOKpTo77xHqPsKrV
DsqdZ0AbeibG0k6VVL1xwWwmKMUT+SccWydXnWl5iUMO81fJaWgNq1dIYAE9iRg5Hekgxjh2tTo6
cUywWmF5TIBkWVEd37VAtViOQpMAece5weDFWuTBKm1w4baPG6WWZueHV5do6Woq2KWJPgYh+KoQ
5l5ntGFxKImJrA3vA9TZDkxsV/k2KGJrs0crCKtZQIlACGbMyCMStvWcafXS+3xbrNy8cGiLFsO7
A3OybBVshC1adTsQFPxFDc9PXvsvwnMfcjRJ79xgd1FQNGP6GJnF8M8AfrVGFeWj1sdP194Gy+NQ
iTLHtC5aByp56AFE6QAgz8A3BJg9I0Ho6Rray3QOPRgICvbD+Ai0w2QukJMm1Tb17wy01Koe1tKU
4u7havM6YRzT8MhnpX6q/z3IXOOAh+A1vRGaXInCxv5tpKojWTjW2AZpeatEZyGN8DFpiHmToTv2
zMnHVQt9uD8fU+cixjoW4VlxFTGvVH6JnSUm0EANjOZeJBSvfh6rD2A5VO4M0t3QTvcf+j1HLNBk
1Xd9ZD7T9t7zXnfHOMcM8/3mUJGFmtWM5RzWUFF2BzkDaNC+t1C7XG/YVsTu33YMCUyypYybQPmt
nlPaj+LI4PpULmfGpzVnO8y5CM7VRA8UvG0lEamVAnOtlJfqt6HkYA0gYM3rUwm6n6fRwsiiUVI7
bGAV6j7p/+8GHsEw2pT7IaPdTLZ+nJgzHBCu7Q3ny0gY+ppDk7LhWhpdusGE80a/Yj/l6Oyi8weK
ZvzrKHG0VIpnzoen8o61ISMYVp8+De+VNqwqwY2YScq/3VLB5LNJTfndmCl2+etFosBNdjEI+PnZ
QJRXu+QOnkIV8OjuQjAOATs7JeYh2vRxdEwedvOnvcyka/hPtgOn00W2TmyBB174nQlIFNv4d9S3
twmOiv2ahsA/wRiSgXMU5WjL/ix7V0BFLBEp3tzJbH/h63M+2YOVWUe3I5sxyACi0hx5d/hwJ6tc
nowqG5yTfUp4uyuo3gZpiiXF7MmZFXXcPJpMeZzJifobeMhr2zJ09fuJc3mbFhN92gpyBNCZdP7G
ehSEPjPp/e4uIc1gugp8O2ap4PU3jOOuXbMVc/bRocuuJX+sBvspmnyLX0xuIJIVErcZoOddRlW9
ISzSCD9isQ6pFKGA9OZO118LEGJfk8NF++fz90mgPRiVrcOn1Q4Q8XPtMyr25TXQx3Y2byzmEQgB
2rkHpu96SX/gpHseApx4UpiadGCwZIjz5qyERJKVxSSo4egqIVb1EcuHpLSka3kHRK6cTeOsH4nk
Ackszbc26rFXzoTjyXLzpMmheq2oYJS7cNvB4ctr25o1dJVYRX1/7haY2vwzSdmkuDHnP0ocvQLv
/LfYHU0y5tFbWgxaesbyFMUoHzwh67/T6PFLOEgeDjNqXREo2oE+uRQsxVmduPgvBhDpqCacQWfs
xo5qc6btSuXJavcLsA8MciXvxNek4354M9oVqMpUC0pHOthW0ajE0n0ENcgsnWzG1QwJNwMp0rWg
ymmc7a85h1Lj/nlrcQDXB790fP2oqELFMab0oCjjfIShx3+NIIJhkmD2+1tQea3WbaOQ4C2MBoD7
gwX5XrEqqFHK/lpqvYQBGv6UXXHPkdvqvPRbmf6WFtFHFZyFDLNTJfAdXjwgYD+gR5hLagSej7cG
RBrt87UoffIjG0mec141sfAD18t/7JX1UPGyg35YVmBDT9WuYnUpTF4BGB0Y+NeFNuHL/l0apzed
IAzirg0bJxSQTAO5+5ff/CA+yl2wZ2sL5EZXeyh20c78obfby2vHiiTfxokP/QBCzX1wnCCeAPC6
lHxCbIK/aNIZ+UDybDibpbHQ2Q6SgBOjL28AsHLvkb0Xwsr+IGLHL9X67kIjrGYNAFSvbdOk7WsN
k+pEWmQYRh4bh54TwE7vvvn54IuZ8zwcqYWuJfrx0ZWiuefapy9Dy20abY8Z6WmESEoN8bBPkin6
JJzJlEUFzefq5MYTHSA8Uv7wdaVTk9rAe8WU9mEUjRTDfCB0aJ5apJ5eTGEq3n4SqsfgfDeu+hWa
7MZAol1CE2PNEUHY6g+ygSlOrRRycMbF13cAQ5QuNgW+EiBplAG9frSjS77wHh5Yn+gtRs2KPply
atFaK931r28WFuB5cXrjmTUOKGjmEwEx0hg31mF+Jm7PuiWaPsAbWyYC0GOSuLRu7impPQquU2cv
aoRupOK0xkA6oHN3mAkzaaMlHAkw43uBFz//MmikVkxOv/6tgNYWy9/yP5oHbU/uZjwnpxZPMDE1
/VoTG7ng20Csm7iZOqRwb4Xr6AdeEcLaxZkrdsF7xRXaZr19F1+HjEfb6XpFnVCmLRwsKBJ95Qkr
wLbRqX2byVmsrT4xTyOM4bo3iTQJG7YIVe1Aj+fr1K01xMk6NwYmrK/YFuCRN7yekkQJYZ8X0Hbt
eVNLtgvOfjN2V7s88TzwQKnITbCA84QE5QNg+eV/w1JVF7Gj2jJXdY7fGp4C4OIHtpE3GdWY+pr4
3FB55D9bOjQ2Np6rQL8cltiqlY9EVfkWw8HIViROfq85NzjO21IkIVntIs+XamDbPPR1ksGaSJvy
cHM6Fhrnd4jFcSIdjef0h3chYK7BFsBxziovgQj62UZQlg22SYLv9ireUBfL92lUv72NpAo36665
AcaxKYtit0R8aN4ATxMkv0HgVCiYDcZubIH3x6S0cqN35nO3rXrJBhtrwe80lEYVIf5+ynv5Tn9c
4OFW25LRB2oOkPjWmsi2eugTrz4S6DGpP1t85O8aYaQ5SNBJJh8nGfzSIXUSvZgfn/JtSPxfo/rg
JcGWLnFQTKIfsQnYFTGGTeWgsZ1+0E1V4CNX/v3sZwUGhn3G8RAonLr49MstPN5Vg+07aw08FTFh
3JRdrHiRt/+4WTBFdxgNu4hBiHZLKWdtmO9HeXOTTVVr68SWt/fmpVA7nupNbogTwCePlmekfwpa
8Y0b+HOKHcGyiycD6UDzWv6dyc87ktZ+6q9j6GQRbnXOplukgNM6/pAmf5qjZuoSNdU95VwJcXQc
35CnUU7Tmw3/6mC6LswRP4rpeRh75xA35W9TvluK7ZSuyii8eslJM0VJJ7sWVXsqcLQuZGV42p5m
eui9AMIWP5RCw4lvHV6XNl7ADfV4DI0e7oRwV2CpzgqP5MPIAlmzP47Yl0z08sbvfpqPDkynySCJ
mPQLpagWDEQXvlge3QWsbzLS1NNbI1wRyUSG8YeBvpAMWMHzPUFfSDVvdwzknRhIJTDxfkIhXdYk
zU1I0kr+DQj/eN5XsbC8FevCScPcoM8dO+ZP7bC0c1Cju6czmyyd0pu9BYwDfzNMK2dcIu6f4sFz
pA2I2ZFSyXvZU+Qss45T3aR/wq2svIPobMX8/CZvkmsbzl05YcxqoyC5E/nyL+UIzRrOoonsYITU
TdcOYZITnVnAS5j9MOmbHdBqbSPdcJQe48CSC5sFk7xZzWTjQ5CwqvWlcF4iQhhIbvoJq/7Zwf06
RZAzmrTVT9zRG113LsRipF7q4j5GkUAGlhieHGBjRoYwQ2km4Dc7d3eRT5WQA78UkZLYEntBla9e
4AlqB9PP0yTYiDWjlh84vqe3i9kyixFR4xsoKLq7W+NrbDjlmAcw5bdr5Z78X68gOhlZzx70bdTO
sf/SexoExEHWgOgEpJ3jwi1bPIOZ5TwOyHibDYzqagV+MiM+MRdfTXvmqXfRH2sZcqBKgRewf5td
Z2Ux+sfVamJyjFeGkHqwcl03xfVibOlEtDEHQBYfVPLLNZLVa+8tXEXF++sRlpXxpjM7b0LDu+Tx
n5k1OLSPNkw0z0nGlZeEIi5Mn+J+csZLuT6ermimDVl+EeZ835HX8f+PyOYCQIvkdLry3J99x9ZX
5QkcAAgE2PZuVoPvPx7OENdqtnQyN6DDzqHZdI+8IL0oEavaQZEi40aaLSmZsLqw2jobs7fWTsbp
vypFH1PF5+DOanGG1uT0bTDrqJs28q2gR5W3nVLtGj0fMVUlliiff6T18HftR15V2AUGhIXL1yip
LEz+iRmqsX65r7h+VwGsqvFCtoCCNqKmlfZBXgLRXgh4PBoGssxQuxkZ4HBaLIWGGiiO45T1tSqf
0S0JZ8LBYmz9fdtyaKgQ6cIfRHGxtZWHQyqirIHZE/KDFE2/SoHk3nwK+zqrs4D1uDkguqk1gBVR
gDRhKNDmwSn94f/D6dy1qGT3l+pzA0xD/2IM4Q//E/3hNiwiYZe9GmZF3hsLmnwmt4Fnlqdtzd7h
qiR8O53x8ldJQVBo5qorClphhAK23+c+IZidpc++kNhrtu8P0t8AGkZSgXMLcwFWGoGUE3NKnBFH
OTzjNje8/4Qljz4i4bSzanUE9GspQsQ4yYz+lM+YhNnFOUuNYcGXMhyHC+PJF/BYSQNB7FspdXaI
+QbsY/xCXq7fR5/jDoBo/VSd0gz5W/uDozEKU2ZT7axL6vXZmngXf6yv5bO4vyRcrNQtb2MRU00S
pKNSQZm60Ca+bR+ThwXnINdA56d/0eyjknDxZQZvxXA1tB3eIl7i7jMAlxhv3q87Nx6Jn5CGCC8w
RGZfcAy9M2exEmu4kG8PR/59qeKQZF0wWdWnxUZsyHuGoAzSGIYTn59VJ0f1BGRwrc8l8TaUMXys
Fc/QHgfQGZqwyPBHhwRNLhQ2a2uKssU+McaHVGimKqYIycDJXQdhIB9ltipb11Rwei3igXyDEnYA
0DlC8Lq40snCA0GpEEQ9tM4ftcWKuDmMVagRP6kdqk/TmkQxPtJUSgokKHWxwYL4ePrZW8Hs9+1q
sFMMsfcCH5mVu5ExePtYj+wcI1hRa6z6zt1HbpUcisZ4KxtUAroPtygPanQ6YMpm5HlsHzyMbw+t
wxgaBzDYil2JZJRb5osM8Owo0R1YZnK0ak192YZL9UEDyg9jzgZpRbSTUWZAIoKy7kbNhALQMsfL
i2LNvUnvKxYvG2PjKJ2MduxepP7i6Ynb5sTs4GQEQeCxd+VPSfXrkDwdlxilevmswOTNQ6H6Gp1O
O8mAwgFUTXEjhpYZNpg/aeaD5dp+PJwPrn65sHFjx6Y2wmaU5w7hOE+0GEOLI9ReL/fNKuvTKTWk
3nu0iuYhFR4+o9bL1XtRqagLq7htOE7iSLuQsU7NZdbvijGTD5g9vcTb7WSv+DVWgHVeMazxTC9N
VnEOLpJVznfBKGCwFpXIHqpEA4B03GIsFPG5C2f3Jr1Q/xSBze/GdEujdzM8ggRDwL+dQib3ARH9
kTl9PQpmizyt64SvuEYSxwgu7+2m2D/KzjlIwsMD6pV4YYh3Sua7OX/0F1dy6U7NL/dIbIY3eUQf
ECcJARGHe1JAqyFYUAcIn7XDKNnDO0K/ccU+y1Aefmr8hYMKCtYOx/2j/SA/5PllRUeNqSTnYkMs
AvlrP4lhLlDACLL8V9H0Fcb9WO5TMQNHSY8HEkxFT40PBxqysknbrSKsKcY99iQd9UKSURfDHRva
fY6hpeW6SBfbXhdgzRj4exXSlWTAFmN+V2MrVca5yh26RpHIt8k08eK8EjzCjWeb2VyJEcYekkBr
YawpwEIpLBWl3k3Hw/Wl+0vzEyP956li0aet7BI4zIANtW1eg/qCqD8okFDv7/02qZ5PBC0m/Z8U
XcW1vSUq7i9NKEX+zpgnPUmoxm+d8LOwYYf43vyxYZreU24qejjKhRJhH87z0oFKuryyv7zTQc24
SuCLtudQRcHX8dRkj1m34OCqUvTiO+RoZQhmtATWwH5IpFa7SF953M7Pezy75C2aDvSF84gP3jGr
Wr1YvYMcMdq53pSgwL7DmJ2Jg5lwYcSydZrFqqTRCkn3ZOoCBmngY00ydg2ptauKU9eOkmxoL/1u
8oeH/hr1ESDx+ggl3Eo1hlQGn2XQPVWClVrEjCyEcvlWKtZx4JNBf5RwNvLqm3h6ygvg7YWdG5az
UCnZtxuRiLvCU/kVOlv5bRyxThnlFnZsDWtZvnthuocJrplql8Kxm9TNLRyLGAfNe73dAeaiD04v
/m/tLX2oD2lQI0z2fRnUORfLaTul0VJRg7rx+10/HP4ihdqPRyT4QbWQNM7TkFpcIMZiFI2JAUJU
BmP8YLb9AKNjDn/QsUOT1vKIciAhQ9Hfo+rPlxgB5GgwK/iZjbFEZtIxTFL2TK7R8vkxJQ4Ty+nu
eoD9OUQg0/Y1OBkOGJZ05aC/zdWPML81JvhjA7BzJQUwnUw0pNL0T+z0ZpevKhD+XQtrvez2yJD1
9L5fjXWl4a0jmhYzSk1BHJ3uxKlrA2k8Vj3sAfQPaaQHi+pUlAso6eLwrQBtv0SM8/sYsn0TqJxq
khHmQW4Ypg/hOslS2KJ/EiZDGE3C2mZM9R1YntltK4MZOw1lmHTsfbvwrJd7aj9drRYQq7eaMGXD
mvfOPeLrC6tz65oNa3w6hE215b6Mt6F8hIbIL2P6vpuJbjhpfVWSg1pZOAGQYmjijFO5mo2Tkndc
YSRWlCn9yxclRI+Ej0Nwmck1fONbCTaA4TSJpPbGNqrcUlDhPn9bO008OwvsOyHv+zLwHJOx5zgI
ASYIU9d6s/CPssk3rT+Q7OncaNN9PHxYdelIOJZ39PzWm164677hlOvYRqaF5tcBzEkjYkQxtnY/
hGRudYI2UJ+EWU/4kVaLG9e1DHhUsm7HnqGipOS6RxUfxsSgeOsiH8C7LeczCcAuqq8mK+U7ai5Q
iVluwMH2fgFeWtvV2XIkJVNzomcIL0XWh0oziSD3A/46GXXZtKoGcJ8087lLhGDKqkOB7U0wM+8f
M0D4pEBqDVmMO1NY8f0cLSRYT/nAtpV0WubOMXX51CnNb2Zs4QL9DNmcYIxDAbYC9eaxhUGgJEiM
MHshxeDZTizFVkQjrha4HfpVFTGTgxGO9gb3WC2Jc6OCpa+w7soK1rcwh4oXddSsKxNkdTe0ahI/
K8eeN8McrmjcvbQVMjereY/vrKK8Bd6Lt2tBl8RCz533/FJqpxSPwsNIZC66zXCDF8VU77AzUInx
57WoxsBeRLs62m7zmYBGwlBClwvUl+RfPRZiAJ720+1vYqHA7fe8CUeJuF1G1q7eBjF9H8tjhAQV
EC3Vaspzr8xOssIde8VK64MIzty6NoZIqh8xWz/ezzE3ydoh4/DzN1JflfsHsi1ySgNyi1A87Vn8
uWvoRKFqswTyqdgyYrzXhy73S40w2/f+FH1u/HEiAIK6WW9kjmrI978LltgJSSis/pdfXsF6jH7d
TWwnReqgLXFNey0fY2Pez5NLpOySIbpL3Pz42lf3k+4SPaA7rXfSwxTO6fltIlj/sgY4r/Tg2wmV
FahBaCgls051ZS/hOPGU1ApVxwmE/MvOXE9+UjVBdhHfk0VOFpl04VaM2NBUCDsbe/MtCpGLEBUS
bj43SScFKmuQ76C4PY+EkykuhlhwsVBU7gXuEf/TwbhRhlebQqxSKSbT8SZ834Zq4BuzFkU0rZOb
qhBv8mwyAKn7AeG30VApRUu9lUFT5i14/aaz1L4wwkZZMUL5/QCwvFx3wJj7KjiLpql1OCLLM+X/
ZTQ1G1yQG5pN85dJKQ9cp2K4fSDBehijiMhGFm4h75LJFuz1ZbCAhTyN7neblucqKMbgEtIQGF6X
P0KFryEiKTtKAZBOK0w7ZpdpFAbVeWsGOwmoIQGdB38ryViHUHJK5NQ5mrGaiOIfUG+sKu4iFm0l
ZU6sRBiJpCQva/buZYXP32IsknLjKKtiALbR+GcaeCCV7IVNdyJXOp982dDdylGMJikuUDjnCc9C
NpxZyDlPYgN4IrD3etA6AwaH10242SzReWwM9G1z9KFAy+GGzFTWGcvbwGdnpv0JORZPg8hD396w
atfnzRE0P4CNIvp1Z+1OQAra9vSd2J5n7mnrJxjzOLeNrqO1rAuX6GOhueN86z4X7W9QHpEUoQjG
o5+a2Cp85lj48cSj3BuOFxl5104wpiVdlplAJfREWVwpBAVwHRvzngORo7XRA+VjetVIvc3w9su+
2VrJf6glI2ZfdSI7SjNDp2ijJoXmD/vMQ7bBX7qUmY/JlyNcK9EScIL9ZWUcVvJGIJk6vhsM1nG3
zQ9y7c5jFCabRTciJqTN9YBV9Jitlc+d7XXv/31vMVlf4KJd0ukwef5WBGGw8bnJjjoXGj3yPaDp
DHPzbB62pWVAEFKH6o2zJaa+uyHNymXWQ7ctOwE+i8Bd4Edrmngzdui7+J4TBZF3CkxF3PdnABob
eHGh5iYXG/DSu9nmA49AUzKGgvtXEc7X5CGTQsD2oUmhX2Sv7B8kMni6brDcq3BRhLY+pKP+d42Q
I2QSBIdplw6Z+/Kv5/1x32q68uxvr30ZdbKxZyyxlOMOCwXXgL5+JI4m35HhbBOFuGnJlxD8q7Gd
4K4TCiPMbA/jW4r9Fa8qd+Y6gpBZrl36hO0cUQDFEF1hCsMEIzwVFrg3MvtIEDDufbrPQTFtmtTO
lkXEBkeHrLgAhRt4Wqby/Z2blAqGPWt7Xmp1iMJEpkOr2eNHnERonXcCMoco/P1sbfkyRBUtbuZl
1N3QU0w8IRw03bVbu19L4XWv98WNcWa5Ug2P3Pt8Jg9H3jnphHvfFk1QDurpPkgP5ET63/DUR0wf
/LmWPsuwFTcYDZGHD0YikyywPLdtM6CGKqBMwMjf4FBYyc9x/FbjdXJn+Wtmy8e8ljbDfa2Hpdhz
6AQZa1Lox7xh8+E385t0VuofZI6Qi89fjkIt4a6XvasT0yOScOHIeFfOYrxfhFW4z9ecbAKN1Ai2
ShLZfB7yDSrwovC2YGJhqdPwfN/RTy1CPdzKG8IQUaGvUgWugCwTp/s5uiu7tijSGRVndspNCuMA
xkINm494+vNh6PGD0z5gJ9p8qq/y7k0w1O9UKh+Y4U0KA9Aps2qu+1CPsAHgFH57JMa7YbBzRP0U
0q/n7Rt0KfhQEpzAJrCdP25873Af67jg8PazrCOdbjGbLXOp9ihespjdAYhPeArraZmxfCN5kd/5
LvenNChaw+8TgUQ4I35bZSbuEWsZcx3nTYaXVhZg22NyeFKBk66XqRGWhNjDTFZaEsyUV35QAPqT
qHJJsoYDDmOwBMx5tc1oqxLOEXuVg0dZU3r6eT7XYXZwki4OzThtVFQrKaugjoaBQkBvqd6Dsd+y
zgmADhGNMEK6HEofvq7wcKuMyfOvADFx/R0EbQfgInPXyax9Jmrk/c7sNdss0XQsTPcyBrU3RUfB
JcNVavm1Nle2u0ToQtPEnqu19iJ+OpAFq9I2opx5JmcglynfVbpRPd19+xwv3CCiMistbwY58Hts
UdRqDnsQQCULbx/Wb3Z3zR5brX2e72+bMmIgaoiC+epRsI846MNzF+cWzmB7UC2zb/imyvsNhVG8
mqzG+xtCipGGRuzjVHns7sv9OnsTnJvHOgtzD0dKn9w9RZfyfKlM+BtG61MySHlG1KDHN5pqmMit
FaMYZdowxLRtZvha/rBiWl3NFNnhooEDXPLvHXeLCXN8YuLRmNsWz8yGQ9Z4xn/tQGR66SxANhfh
L7cPz22ABkEWxgJmsHlTFZsNcz2Dhud2VurNLnzJqy29tOlrtoGfrWfKrKmBODhA1AyKCKMXG6Yf
h0T+Wi4q6iOUa9srpeLMF07jUI6ufXYMHUSlqMT3HB0XXJzPAc7I/k7vzuL9vBThCavU3Y95J0Ow
cItbQm+HOH+BCpvaDVchQvLLBDn48Z912ZZSIXuI4bKK2Z13rhoSBXSw4qs0M27vnEjEjxa3etmU
RGSb98QhwFkigd60z06P9xge9P7+cISsYX98+WjkkjrCSw+thxvPJ62PIsy5TWMk3TiOf4tpvdcP
LLbBR15iVMiKdGgF21uJoVG2Sen1QXO0Id25EEMuDaoE9nffjQxEAS5etYDNtbyCTk3PqU8nSQEr
XT2ccHj/HqXE8Apd3GJ9FcnqSqzV7jNDVmiHKb+GGqDzkpP9Ho4ifxQ6Fs4AMsUK8CGt8372Z11Y
DkRWc2A+/UQKjOGNEXAyy2l5Cd35II8VRs/GvghAzJE8/idtQdgtZUI4b19RTm1OeuXwhutlGmV4
Si3l3A8geBdeZVZAsKgfQ6kjZLIO0usEFN7nezdHqK6ZyfaWW4Sslz53Kp5icbjSz8sQXWp5O8Gg
3LZyX5kzwYd285iqinqTEqQKbJ+e+0aZ6vCSydVLGEpAyZc1/3qKjKje1V8Aswm96jDObecSw46C
9beyxWuVHjwnN2AAQztx5CusDT0R5vJHZ7p0vtd+BG+aZosw4rnVam98Q4Hqojekr5nD/P3lFy0r
UeNeQWQs5aMuby98ehHnmavL51X+NkXn2ktVq4RcLncrNSSGy83Z9LxVUvGvdaPzxFfewQVAvMAx
7+0r69ca2xnj5HYJ5L4l4clKmTIAHFtlETnSEP8hK2N7xYgt0zImK7HU3GPnRfY51Ut3xDO1t8YT
fEir3mECEoz2dasMa1wMwNh5aD5LnmOxOyxMHSbrpmTL8ydNrM11TUD1azwDm9ayLMhLMJvNhbMS
+ZFWbllAr5BUREhFZUeWKELJ+5Nubgxr/kznneg0zPM3TtIDbmSpYvdXnhIX2ArqzEQEw4igbTkQ
seokCaLtWEJg2u+XhPJLt0wnJ/c2BEX7JLVCobYDzbaVK9veFmlPxu5YlwmU8I6rCD+J9yuEarbw
cbBo7MzyjCfXJ9NU3nFVBRu2/pgGSwtyxUE8XTjWbphHONoCo7emaCnPLIfFt0ntoE3ZUCKY8fhV
giRC5Wi//JrbSk1ozcr11wA8p5PJfuUiJj+GXILNzJALX9GTbNpZEJpenUN+QbkSYTATHDbxrVo9
vIkhP8RfP9XvOE/T7MrrBpg1443jiW0Qc8yKPXqh7Iij1xLgcccDhu7tg2TSrQNI3AJJYkHxuh3e
J9ln/69QJfvHqLHDZqAQHdw9oh1FeABCUInJ10Kz3CXSvinx6GMl7tf/3skDrvOSkPzuwJsYu77q
quVtOJMeq57wRK+SxVoJayZh1SL9nwj5iAuQRq7N/NEBLw83pDlGCpON7eSUUh87a/ZEaQhLyxm3
ngFu0lTqu6PdOrrGt2yNpRL/aolZRSt574pZgQnFlqq3In+lsMR0VhwjGnu7Qp99h9rgYoAj7ATZ
14FUXyn1k/snp5eOlWh9inTKMvZK0whNgwGewdCEGSl6B2KGkwPquGDgjHV91Z8Yk8hxZIaPCxsV
fP+VYsBgVzh1+pVEqUqI16+kKfhVL5TrYCsuUNlpx0oH01sX+tbhp1+luWhQeoYzRrFUepUrKHu+
EaC/fBWVcZ94K7U9GH+V9NdRNH/3yXhQyMnnBe97ishRWatZdeoKgyjXkaLZ+ME=
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
