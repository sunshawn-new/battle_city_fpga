// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Nov 13 17:19:36 2026
// Host        : LAPTOP-8QJD8CCP running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_headquarters_sim_netlist.v
// Design      : blk_mem_headquarters
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_headquarters,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
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
  (* C_INIT_FILE = "blk_mem_headquarters.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_headquarters.mif" *) 
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 19696)
`pragma protect data_block
+ELaQzqeWYtbdMvg/TmYbPiAuxejHuG0k65N8vleNouVT4mqQCtQeVWqJmu1CnUVYrxDlAZz55aW
XrmCBMJpeT0wgjR1ezFitrbrBbocMBZhZ2Lz1Uf8bTFnaRAnA6VG4nIoS3eIvaXx921oEDtY2KAY
g8mvPGsveWU+w2LjdlzkAA7VmHZu5GCz7wulTH6TSNtZCvG0uWf1cN6Of+udMW/8MiXu3iUK9coV
QllDtbOtR6e7YTMU/pCGA4TlCcJmS5d3BHalADk4QEB0h4hkXh8aRj/Lbii1TYflkuSGRVXNXBmZ
pRKw+CttUwvFJvhWs2Fe7IVWKzrG4aUA8KKTkooYad/vJpgtQv5pubrmn/Tj3f/b8wez2VgCKOwY
q/iTqp9IvpfNcErjh49C5zFO11AyZu4jSSgVco/ihKbWIN/NOjed5oc+n34dTiqAs/BtwCTHyhWS
U2zkP6eGX4StmMu1SmDuFyLSTF6OYZ4TKt04p/H8HbVVLu2MxMaXa9jUmNvhhXvjr59OBkzC8hHB
gCBDpZLyHz3ORq63ZxWh1AoD/bghaHqEYuc9Bbm2q9WERpe5LGUBOeP5aIw5Z6ZOkqAMFYYUd+nG
qy8bRCw3p9qDO0fzBVlRw3ay4pMEeiwruwBChLZmFIKk3IeMhP+Z/Q7lFmHIKOsZjpcyPiZzVPV2
AsfgWpGXowApPUbF3LQZ2czDaFiT+CcLKx0eSUjNMJBFB6C0dVggHvub5DqjBWjG+16oybSBiv3z
yW4u8NtNudH7Z3XO+iW/c+RZohDmaayUyLnbZbcXAzFq9/6N576xWZiGv33R6Nz8l08JKOsc/xW6
PuPkvvCdZsYw3LZbGTOCcZ7agGErr0yfVbYtdrT3PJ596We0DL98I9NJxMRPzBnzqj56Ie4NbsqZ
y5997cjCocjFC1g6KtiKNjHm0J65pFcGpCB/qlCKXFmSSjRcxJPtcKpZPWWsmKNLrNJcGnaj7NZu
qM3jfNBrtPbUFlKidhvc/mykRQfzpojhjSCboBk+SfqDxt/zte9uztlop3GPCN9sJFWVumcldnrq
1GD2H+OHyGe8qYHMHqkd4+1zxNXWD+ukSGdQSGY/0unks2b4m8APAPfZy/TxedDiRddvnW5LqHwO
1Z8Gf60JT8lyJqczq7YD1e9PBKLDgkvdOFRiMWt7VaFGM5EWuqlBoQKQLYq3TJH9zFfi++mhVaGB
QiehsiW+cZ62cXx0cfAj8NqZDYpeFvmC6Q6hY5QJBVkD/qFdG1gCmoYvF95HF4i0XAYU5AcCbf6E
RePxJMWiculvIoSHV5zFycd2ENmM2ui6UIv/4Nem5brwuIngl1zXazyHQ7QG5wNSnVk752g+/Llx
+AnH5FdI8Q1B8f1PyiU/SqKhD65YHCVBE0Ftgb4kYonuSl0RDSVvTRWJZ/pizquOC5bUEomsQVXc
KnHIfcMhxmTuywsztaCxfHT0IInFKR/ksOmdli0nwP11VTl8JATjUMg8vz0qJe/uLIGYlQWIeFqV
XUlNxLYSg4MCP5oMYSf+Fc+DduNEbbspbolMC42zs1Ch4Ry/zE1XcoFWBjO92BWFhU2s27+ZNXXX
zTcL8PPD8k8jbUFIND1LziSOkGZxFRo/Y5YnDybRvpLfN793Jy1pkg7JwZstgaQXjSZqOoLHkwU7
zAgqx9KWv6oZU/075oAHq99fuxffFPlwPhMIVCS95chwGbWR/9TQb+mJsYsQe5PMWo9obHMZJcPc
sbeCMcvYPPuGISlAIUwYwQh2k2hK+3g9YFoWEacZqJmU6xRvZpkxTf3dgAop5mCZvt0GtW66VVHr
0x1ghonk85hl38j+4sPwkPrAD/oks1HA8Uq6M+LDergWqeFulq6VUFAlewkhzG1HqT1uTwM5S64d
NdLvnCkO1epOyKLkuoqD3lcVnXOHXpK4QYGcYZoxbQwIvywEYLmjZBydTvYbWfTZyo/vjygT+Grf
Dm0hh3bKBvfsK9w/55LP5vAo6hQgVg8EPQkXJYfJZEb0DhXtd2qR6Pkb/MU59Rtvu37560SiPgV3
kQEXSg6/7olIE0XipgeU/teOcvebG9lZYjpSokN9DzclsrJNLP8AnTz1Ei8Oo0zSOzZSdI3fJOpB
TPrs+MMVZxV4LOLYWNp5SOpqYEk4iIQ76wqPX9NZOtKYwx/jc5nghBaXQnn4ZiwTixLbF+lujO2W
AFTN9A1ovlD7Ano7WoU7SJBAmP+IvPrODOWJPv7QK0FPwG4WOowjEXNELnPzYojs1rrLskIL74oj
W8xyjMie4oK8fRLWkNQOEqhwto9/8VVbXNhdSfaxPQcvLNjpEj/xN0szz16LQQrBeHqMZ3XGaGbu
iBIbZ9Ds+vxl/XWHWi8OADQGnJ5aJvlJlzg1uqwqhQqni9erW/bCQMpSOlOyUWykn1lqnqRwQFgf
xeXBE1PzE5aTq7JI1h2G5UbRrnUsA/yzPl121Tad5VJ2pl6VUhUpIp642MiLv1JhWyewW7H7YLK2
LYTHPGqjkACcBKwztToSD/I/atVMJhNUxn4d7NqVtngC/02HlZB5gkxyjjZ0bvusiTEfAZCpx6k7
ZvCgEhOyOsgoYyOU/mq0IEvK6IZ478dfDloSRfVPeN31fwzp36u/nGO9Tmw0yrM89A0/guszW2/U
NGI1XEFCyZ7pKih+om0h/7mG81lm84SRf+onqlVCEs94KtEalCTnpH2KCUgO3vARuDUE/7b6abp2
R+t/u8l2Ug2Au1DaJ5DiBa4KZrD7/vZs8qMsIXO4aRA9MfI8dcyzxu9KKlbfENIY03hmxFbgWlaV
Gz3GZejDpW/zhIDcQL8mISFexrj1lImsyhY46x+MCHVcRw0TcZVMiEvLNxqNBiOLPjjRiqB+1cPZ
axFQj/R8iLUUvtULXDisUfdTJ7OSJtJtueaJIUcPb2HgsaHT+AkOgeNoLIAJO9PPMTIjeVBqkeE3
ih66gV8yjT0QA6YWY4AYLL0neE9oPQk2tPrmTefTKb+I1ty1IynGXma6yEb8Bfbj/5IAfa8xefG5
8XnmtVdIkwNyMLnpXs2yZLe8akZoqXUEQEb+VPylHPWczTnyo6mRv/X3AXyP5G+HAuHjeeW4PUMW
BqyMUS1rtUp8niuCZuW9D1upWBVrHvWYCUSP7cEWlTKGFNwBmlTOk53z0JyBs3cxB70D7KEo2Jz7
2DheWr3E3NfdUKSf8G9u8wD+pYdBS0GFzrjryqKEL2zUX1RNAO2U6l1bXu+7aVkdX2B4YsuaUC4j
c71Ad9elwW/+JwSGub8rm/izU6Lc5n/6KzVWi+sz9I76vnmSQx2vlhyTCxaXX2KvZVQxpJprhrAS
yHZzPB5Iq2f+3x7I+FxdYI0bNJ9wMLL71Hk/dHzUM5XLaKTEAEydEPiharEK79AEv8Bek9TQgsVV
t6a71tnAcNSiBxemFgbNogxpDHF6w/OOamx3xvz76p6IMCppvJwTcBAup/89K3X7JFPImRg8cM7X
G/3M29knkOE3BZ/rMSvDxYxCA7UCP5y/wgHV1vHUHGSRlbqksfCqUCA/un4daIyKML3gblu62W05
f6tLej0/AoW10ZEmIl8X/pHTyCp4ebflckDNQUP4CT0wIL9noy5VbQDPPH8xBp3HKfeCyg6eHuVI
0aC1pMhY3ogMhBtPpnpubag+8LscbkpLmg9fANU1HOCsMtwe47ezZ7uM02zLYD0lqcvKSQYbMCH4
acwC2a6ZIXunbHXJ1yd4NB/PvWtAMD2rvBinGCg61SVDvmQ4wl6xEAQVM3Rrr3DODf6zIwP2wIg0
ZugvI2ga3rZ7I5+9MoUQZqUqBMRv8HlpsGkaUDgEuP+x/y0GEqw0L2haY9u739fnmgoVvdbiHOJV
TrWsx2X3oOSSs0aNsPZg+S/0iI373BXLlBsCp5lH1Dd7mzx414lAX8EikZ6V5LeeRiw5zKje1b0w
fY/Pu4YBG3SsfY9cC2DA3Q+tgIveMZHswzHU4fE/IKTPLQEzDvVSJXOGA3iBlJsEp8okzhgoKZul
SvWw1fFolNZM/CIK/pvXaQY12KcECw9zRYCtgrw+T1S83Rx86yzEfyg3FXVwdDmRzsSniaHLXVnG
RwBDoP+FFXxlClsWNXFExJTDXzRAlKGrPCIObS2yDYp40G3tpFVzxs7gOFrZMZ5mLkmK9Rc2h+Zg
lVVDHcIFgGD+v164AJa4SRItVk1p1wa06GYoevSUn9+EtWvZALMUPNQfM/rA+pEQs5wd3FngBZat
I/gjWKe1yZ/wRwgMgOMY0o77xZ2b4B9a67RSnRvJF9iWmemT03SjPVDIh9joIKqZXNG+ejOD15ZX
zmsaZRapc8SKlSGS39q8pyciNBqa42GGk5Gd4pARrp3YxADt/y0CZLWDJH032YFp2gEfDFTF6P+L
vlPY6eq9HBUOQM8ieXPXBVLBcCTl+7zIac2S5J/V4SHV/hQQS7fco1ECsb6FvcllJd8ny3s85WqA
opWwsBbTH9i9M8fHQVfj/ng6v/aVDlnB9YtNoAfzWYqr0sHQqsYjalWLFIDFeUfW0j0g1Lvaqqsz
E1g+dkCcvSwPRbUEyopWkAEFv2npeHdw/j/Vjr0Fpo8m402BlbBbmuWWkYmHmQwWGLwYJXDJ8Oa3
ujDt9KSNu8LhCsXuLIe7qEFSC9McNugZaeyQtB/WCmISZLChRZW34QxMkogpysr8ZBMIyNjQ3Jeo
gEebY8h4u+cawVUf/731r9VWSarjfxi6Hrjy20Tvfs2jXGeUA2ctfPt1lTRH4DgXo5LxFlnZThFZ
VXjzev3eFDivOpQhiZSNSqIEIkJ98sbeF3YjmAoB2B6MTXl6e6bypkOE0elXXttZG/0lADaD1nVQ
cy7wLCBXiu/yoOgeoWYQ1D1cr5wKraw1hy3f0TY0FDZakFXkVNkYftMkIObRhrFKro9Cwgq23Ovv
0VGL5TO8W7L5l3/8R9uLTfzL14RaIIaqHd3I9H/OwV4i9ONlXayTwpNqQ4g5enGcRQ5Z3lcwAgpZ
t26dWWmPHX48e15zcDOAGbrwiUKRRd89+ki9mECh52XFax0XCtchV2V7HyS80wL1LPryIFP+VTGS
Ukdkn1zD14pzGwgSRSfkx4GYtabU2NHYBxD+xYXMbUKJ7Wil8on24DrxGSMFjbzRfhZGM6Tz7fM7
HWPt+Lr8GG+zkJ5i2IOLk+68fud405+cW6BUYU9poM/aLfSZkTZ08Xakz2TzTejq9sAibocuhE4n
X2R3Q8ReizHJ/wN2IMi0WNCCmPOrzZlMSVhJMn1hw1WqgD0IOTF0vQWKL6cmtMCtb4jQEH9girgE
01oBJi4dqLkJw1IvHrH81ocii45g/srNjj/JICoXarPtzpVLtkG4XhRnZlqufovSbHjq/xG5edkI
pU2ikJzT3bYYCFg/Nz/wlHt2Ft4TxlKFO0cpDOhootx9uva9oBrugJQiO+EPsccdzFTRcdYbgFe7
SA+QwZEy7pZCXLeXNG1P/2fuCKYbeUICaUPXLf1nB+I7COD9WZ5NAj+3VO+ujGnqqMPhzVFn2Osj
tg5n+YPiesECFpkmOUyi/IlIC9XrjbW5UWWvlB9BHvLuZggWw02I8jys7g6+VuZkscDDH9XBdH+x
enYkxvZVk+4RMOZM22KfD26c144To9opdUulYsLRrJUtzPGAlzdezU5ldxJSHwbYZCZqdbwJzrOr
omEgss7/28VJbxoRKfCgmVZE8+CwBFO2AwIThMeQHwyC6vIt6Io+yp2l3gBRp1ZMkzilOoxp34g2
R8OLWMA6aN882ddgPcwBXcQCZtPTUA6XJQcNz1BMhtX/FquIl+QaLxv9JHs4vcK6k1QVZt3HAiXB
rU51YQlZTjviPU8GezB77ZJQk8+cfY596hkNzDgzYeeaf0BOIzDnbtv+g4EBPF0cf95qwNmwx4Nd
CxKpm5WNellXy9ZcacifG6ykeRhtXMW1YAPzqzI+im76WjBoJdp0UWCaETvaTuzdJUWV5jtKNwaf
fQNDHJ63b+r8YhK/EuhljVxsQxA9qFMbhJOanVPRi87s+Qr+2bNyQMAnXgscCuR/hbWUNPYzLvzE
ltE4tJmxKXJiPa4XK1Tm1vVQSpfIBxdqC5sHQEW0KAfhBwYf/gsQIiGJsFMyov+LUbsUejSx3LdL
Y8sLg2AhYaDaRhRaIStdkZZ2OdRAwe09mUUnsuwhKg3doRsjWZ9d3BVQKg6ZCNJj936EdQPOMlvn
wuhyYeD8lVDllcwbrjQOLGhXQEnvBSCyLnX+Kj3n5OjIiNwq0nUe38ZaaA+189JsrbQRewdhxSDU
N2GEIW1x0ZarM2+sT4tgLSr6Twe5LiPqLzTYvKswj5HT/WQNeJM/B84O3CSFnkXSMdic7dmf+P+d
OluKiT3NHw50kBNy+xj7gIxKnqZ0tU/9Ak5axafIo8BsTSwvfPE+t/DOaeqGdVKUzxllMcSZcE4O
1hi2yQyDw3qxCxNQTqFqTEeHrIrSiH7ONTMaNtIbaflmwOwrT1+hfEXHepxQ4jSclPi8/N8FKrsv
+52Cew5cTHmXgq+HPoUe7Fj3G2McuwWjA71E+GEHfOYZcqWvNOWl7Op587uU/KkRHVxdyfJQgwzO
G7AXoCUTihXIR5eorpmCDMFecIb1/ZYklj/RMCpDNihvaidw6FY4hJDEEAdYx38yHv+AMObtaQYJ
lG1ZS+K14UVFkcCSb/Q20LaDIHny6Vs4HpQOF1VAm5S581DA364EWVJlE37aZxdJeL/RZGZCmStK
mlgX9/LgUfiYXTLeaJhki+3UFs6Xk8pz2Q1Oep1tFxr1uAkzE3a1jdSd2f/Ut4l6sSps50/bln+P
jLFN3HhqXtvTaEty3/vjA1pKeRpd1vOs11NkdiFrsMpiJcYjCHK+1GvdxwUpuAWrU52zZHeGYs9q
fmooU16TaEiBdvJ9v8DSisZTW9xVmsG66AdsDXXUHJIdDm7Cdy+5XMsL2VAeoIgYEyE/22j8S0EV
AOR2ZOg40LiK3x2a5+ZXMZIWAjImyOFbNnsmem8cIWNoTCEUwW+pj+9CsA/QqVdAs+azSWuF+SSd
alxNffidaGRGyO5sQDPGWkgG3kkCoaYEmojpGviFfISbKS8Bl3W0V7iFSRorLMbPJPoxWWCccayO
rDj7xW3SUFF8vD5ZOBEBnmiHNzbqHb+9VWFBig2xj8KEyE17nePUxtHx8AyTu+PYnbbj7d7x1gtu
3UAhDkrNmOoh9/IYabF30PCJAnlIpLlcrh1X98AfTHvLJu0A9qm997ufByDZoWBGXx2wmsop+Xxv
oRcYFHrO1CB5vToECyZLB4HDn9vplhkQIcIeqRjnDgDUgxhldLtxKfXoessRdUXi7VkowxsmwHUt
OoAC4WeMF776Bi8Eo/UUp5bRpRYi5+R+7wyJuqdnzFORBuCV0MSh/LUwxJmRVc4uCroAUkphkhs8
oHMysJbdYamcxJsgmx0dhuMEn9UTozMB5gWXjfUKLrsoVWxVgPljayk4JnzHHGdG5qoczkO/ue8r
EGVWzxJeT71qhRkUrTTbRdI3NKTGTme0rluOzO+chR4SRKbHhRv8CquFdS9AIUglK4T+FrSk4JDS
f7mcJpU8OCL6nEppfCFLgxwqvCTV5+N7UzF90csofTg1FZ2I4zuypw/MWaL/rmc3shlnh+PMEPSk
DTrZllRuOUm+qvsGu73leJ617qpwymbvv9pBJT9T6Hum+Ht4KvJzVjOpOQyZbP81bNu856oHtF6f
TGSblUZhq/RsJKk0TZXEb/8l2tdLUP617GF5GaQ5aPxe9+4uxiRegZUQUBIHaOfqtfolOeFxCOgS
NaZJv25g4oDBsMwOlMcM+Q/jkXWpZreNcRBrgORuiJhbCMH8qkVBfwOvFcMcPfL8LE8MhhT87OR1
Rvb6Rbjv9jLQzTO6VkisKztZKr0r3nzdeHk0N1W7D9PolG3XWwZPAqdwIkum753SfVD6R9swvtAE
aMoBFkzpPFwqE6M/9jocL/8KEijKbGIrh3oU4dOL9zVZpZsfCdfRhUbOBS0R5GHYM1Vm8MONPjZB
qakx+RFIov5NE6ri98YL+HUC4d9/0By0oZapH8esI7yd5QUW1GNjOJu47q9TQAGv6evNcgrqsUqC
pU5OaELr88zrllIcdkCWsDX5sol5CrbUwG4MlN4sr0P1WG8e6h/TG1BOWd6UhLLb6iTXwRbJ5akJ
XxWrCSUxc/nFs8p3xeduQMPHeOTtnF05tliz/QMMDN21C0EPk29ZtBORTJBfMZ60IPCvye9LI9q6
AcRLginNz7gHRI9Oo7MS63rpbGw05hDbd2uO4AVE4g4moY1xiw76QVmermQnQIvTdBEJLdA5GRHM
cVzBcxp5nTPadaMAGaEjYtWjKZ/0G8sSEj1ZuM9Kuvuw+FAl81UH/rUjRdN+t5Gv6lpeF8wdF/Un
TdB9Jo6+3mFiye5QVKvFeOrO7JPOGVCOHBww/XGUeRvKXhMPCdEZWLVh86tKY190ZcLEpPJbuTZT
RN1wg4fvEZj2hIsEPif5FTdJP5ib+DwNQI1+okogjnxEQu293Oe+Nfh4g91cF8na6SOttWx5HLFl
ymQbViNJK2jbC+dJvtHNvpjCiflLkZd9eYQz3tKVfXcYBK4OA08glSXJoSVimP6pZfYUoZHOjGe8
dXO4z/hIAzvsHD+jzP2qzOdmG7ShQGfLjWpugsFYG3gQVx/Jf1UA9k3s/dcZ3aHtLA1yIJk3FjAW
KIKzjtebnk+qwT2opVnJpNrxdyUylvaktnaYnDO2ssVH3f35WoaZwzWflVa/STbAwKNqgciGySag
BIAJ3kZrF4Wm8cIHGuuvSX0J9ulUVJGFSwhhKWmDw8NPh+X5u3eR4bycCCJlMJ/U66pfyOm+4VCd
UOi6Nvei0K9YnTPcc09IXA5D7JkxI6SVIVvRUPGR6m+8pkeWN7EPsMEKnsJ8ljvSYRv49gjHUgb1
FpuxUcVQbq96SLxEd7HmDv8S81WYYzziJwhtcSeawF/RntuPFvdIv5RQtO0uWbsHF1jLYrU32g9d
R0ULeGsxGe1LEVeeHD2/CVtf8/5G3WCwvlSpECIG+ewOz0LL8dODy1nQ5MlGIEGlAb2WTteDy/sP
Rd5sKRyNY+2NLLs6NHKgQ1MH6FAEhNNi+yQHaJ+a410GJCKxJ8B7XklgeF43mtD4do1S6hPBwDuO
Oj+cu/R0VGRmRJq1J7dd7XzcHA05mMs7ECdotGmuiLhPB8KO4u8sqqm0kB0G1f5Rb0kO70nJEygQ
8TPnLeURlXXxkQQ9HjpL/ZRam28nlnWQANT+kkR0MoXeeoqNUaHIsWeVWHSoxigwDpGqo4sWo2yU
q9qVn4QSmQh0uscC85BNeqS23fSe3Mso7jh9G6iDrypDUq5/KDqUe07hVfgh0/rREFZ/u4iWrqZK
XbiVnzNVOkmKJ+zoo1sdPjH5sBW2h40uwF8qibnnRJsqoqJ587MwRijv17Sr/BX/BpiEcjpyY844
ELA33l2qBGZIxhawSqzCJa/sq/81iBgLSCExPd3y/uD7kME3dCjMiZ+/79uazRPny/UQxj55iCJu
S8DXjd3onY7yYOYAMLVamrXNGOW9sKnueLuQ+pvGiSwboyNF8e9bu0GpBzWBDT2CQmbIOaV7l6t8
euex28xvrEt8BIAnxamX9QE8FXpxg6LlJSvcsLS7aTGe6veo2mWxQHT7XDA1gx/EsR+dpSubmQIY
JTKe+2vaYMHDUpDzGzif2w7msV0VdPnrdZc3AZg6lg6CyvJaRZ3p9WeS7nf9hqVCDK8+/a2FgCmV
f255nsP3Fd6gVgxS+wKERn0BpoXk7sKIOzc7lLjeOGZl0ZRbdNajGScCTURpLxstO8ZFYN8VnrZ8
SqYTb5UvrATJfpAaZRvRl7be/i1x9jtTKsu5RkUO5PWLpTTpYOpD64fa1nAzHyObfyBr2V3Vv09J
BeeZ2y6RPNtW+z4rH/2pka+DOVkvb16ywmSWQktT1S2UQW9nA3/bfpUOSYieoCuEt/RKoKQpgTJu
+ek+n+1/3qCHOjWAo5CRcpAs/Kdt/ZnX1uYwu3FufVIppqYLMWry1i3jS+adtBNMFY0TW+fiQGAc
j0IAuZjmW6foqHj+z2wPmOdGr+8czJwYXxhd4GxlOs/k1RowN3qlgbSSS8OaDiDni0+a5M1eTfOw
voEa84C2nvVkYOqslsD8iWvwmr94srwGRnISKNOt8bjPJhLsMLW8kYcfkrZsChh7XBca+ctVrfkh
d4O5DllLdl2pf8zE3LExDOvMbwBi8TAeO9TyvSC66/KBRjh2+DLSyNILtn9e84lFyG+nQdUCfKLS
MHxq0Zp3zeBaBBGvS7BINZsEHxvjXlxagMzNOQExQEs8SjIm1Xx031HYA7E+3gu/eEvwTO00qwaU
/ZLiTcIf8HEbcjlRr9WMd7GTgL7Q5eBvG4zM/vyfTGUBEjRA7qnyrarDYE6BbTAk1cqpBO8W3ZXq
Cr1V6G2gM5vLl2U9NhXwusWCaJnjueGPBqlKHQO45ns6oIAdZNFbFCnYPWI5sn4s1B/EZbOlcHnD
MZcj2NplX3wpZWOpnKcjb7f2O6Tqrx3Qzu4Wg4Ow+Z+8GLmspLwH/a2uMHXhP5UvHcm+f3rkDRsz
mJU0IqfRkLhE3CQRSo5DHon1JT6zjOkqVUZNfKAh0fFEwbdsmzD57ab247Ht3lZvNqBokTdQQJKP
NHYXYsFNTQdY4nnAjhbYSvQm6/IwoYEf+pf5fbmloPObdX4IuhvmpyJvdMkmk93x4xv0PKBRZzDp
Bp2lyCsnpt10Wm8GN9qU1RebEu7ObTgbiTyzifV9G7twMI7qnyxtRl/ZMz8IAmHYE8mNrwlGjaGz
ExjHTT2NHpKbMwvKQlVwSS1ZlV8XIV1pUHGdvPumOmTQ9PlEfjqgIGh9pPmsZUH3n25gyg2EVEVO
QhBwhUBLl3giW5kp5+soa+ch5WqLqaBYJNzs4nxGY7oerGK/lDakBiUJztvqJDdaOzvRNnxTTDhx
hCtO/kcK3MvWURS5/zA3hfA1LMBPb0hW4+6Yq9/hOn+h4Uqgx8RcoVCeAIL39KzgFyjkwfbdowTk
OKmWn8534N4mVdILm5heD8c77pa9usSLT87IHrA+rcscxtDdNi/qukioXE+i+CBJYHeIS+WfE/5R
YLuMT+LT4UuEFzolSoL5qYfDl8vYQ3i2ULlhQ4BIlMqC0TIhl/OoArknvKOkvUcndsB6vMAS1V2h
QFiT3hYDJuK9la2UnKUtJDB7BV3RK8zKO4UJVW2YjSTIIQenHjhXtXT0RJ53MU/41N/NUVDdazcs
p7HiohhEtybcyB7rJoLWpcv7hGpvGBdBMcKRJLnbmWncXQe4xbeCB+kIzBHe/4gcDEc1prsZJqRa
Ybhass7PLO/Mg2/+SfzuvPowzmZ608sKAvKG4ftnO1h03CwwXOoQRELffHRJMsQiAWLoe+PSF+yc
f0trW98KQ37wf0bCIQLQlaEgdUdR9nUoHhtQr2WlrZi1AHcPXcBa7eAJDk75O4HaRqdQZo0SWthf
Hcof6zmds/jU+/wXngxeUbWjUWx0Oav4JckHIoZAH6Ml6ReUeZlPeMuw/2w53W1tQxIDpEanrhrB
sIiu/dmIxpGk6RRGFKYMcNkkJb2GCFWyIP1E/6kWflt4MQR5Mo7vWQiHYYdV1DANkpS0UVkMBCmR
A17j0RQm1M+Bi+kPMS4AlXP3MwVbI/ZhwaOoPqLBlex+w0hjWxfPrD3OWEpgCXtXg3X5gi8WpTTV
g8de3pTEL0dmn4iyU/HoJZ1TiPZOVurR+pbtqX/z91KrKv6iOQLVcPizPVB8V85rNd4X0zduPbtF
vsverqDQIRx03/a+lVzEpMIAOoJW3GlXkiUO+GYm+pPN3FJAFzO0nfNL0R8L+7gLXQmzGbv+5c1W
3YfkPvv5UxJEEHKU24vRmRRq8RigooTCUC2/GAXn7/BeS4tXoJSGWuw5w6UfuOyLU9y71/55XgSF
VCKd9NCyRCZFmawXY4FpmAI+PRmE1W3oBGD9XVR7sUBOnoeoBssH6my/PX0e8pBGSeM7i36xEbHE
sZxQ7qUJaApHSKtW1sKPm7sh/nw9YJ0rSFvHA61m46gN6rf8F2dRKAZAUwETVOvmt99hALRcGgEw
ZmmV9lyh73KikVkiDLkJuX4cXS40kgoLfwx3yrBWDETmpfbi3vOKWrIvDbsAdZZSLKpjeW2JLuNl
Lw5IBw9r6q+N42n9xelew/q55dJaMIDcTyspUU8sqNMyFD2iIhZ1GrnON4D5ow9G9UCWQfCVGfvb
EU/3jbKx6uhHFbqRGn8rNRWmgqj+SY3lwZO6VRjz424lM6kR3GKI8st6hr9oNh3wtYstVCetFxlX
5fzdxcbn1CZCl4yYdTI/V0JupvFLtGufLqeFbFFaRFAwuVWf7n/iIYEd9V/3CxVcuaiCE3DKASF4
ahV6DqL3INt88VEDgz9MXccdMxXg0eFGe0iy/PBCh8uyqK2GS5SHx9McQpGXVvmijisREUDPObwa
VFEb6wXBa9ll+q1JVTYpHXXzzw1NdIO+e+B6aolynO8q74Otu6kcogddiH8ONo5C/cdUkRSRaVsS
4ZRRp7fHga4CqqAlrQKiZglvm62mYrxlUpTsa4J4kDFc9cJN5T5+ZuiCi6549HLValx7cCnVSpwl
33QOo/PzINUq8boPGuLL63VBXVAX+pKoVsKKzgvJK0DVL6vOVu2p5tCTdIfbtDu+WL2uZK95NdDZ
znZFe5QVXWeEtMjOyCDGp8nCsStbV4dsIpwJNVNBE8azaWRs3ZupxSa0VJu0Uptx1hFbKSwMrDXc
F+LB2046DA8giecJT0SZHXUkfru6n6aAmPSu8I4PGiLZ8yteNpkNsm68MnB/L57RONP8bxmuKMMO
78gh+srCZVxoVyyIzBdAiZ56IQZoTuTyLkjMGeVgg7aXj6RtlY6BXuj+tSfd+EaAEttViTFogWye
Ag7XD7u1MQAVcFEsINOmyBobrn5HaRDMY+x4vCXAGrmJHX1PdblAjKtJjPbNKWowhNLHSoE4dVhe
vQFjQ4JGbYlSs6QHvFBhzeltn4lLVPpce2750GAKFAcVQaGq1NR4aoLZwhxkMwUnSGq/J7zfpM+o
0MglMhPzTxjv5/CjhjsEaxfb1B4PO/u4q1HrJeV37pA1JdGfxRN8ZqGorc9ap97m/e4GqpUno41F
bI2CXhdlmf0x/GyNimivyKeK99Cmx5dtnGppaAFmrW9oA84Wt6TCRIUsgPmH1YBAynvGNiZYufqZ
MNhm14DVoQPj4jD2KofNO+XZqGfLRXWxRF+fIAQOdrcbnps/sskr3/uGQyAg1pbMbWYiuTNVEOSs
71EbgPd93w3Lhk1BITJAIRbOTuuOxp4VQU2Z5H64Nel3suV/wNtBsXDPY9r9CgN9rGxY7uqT9EJ+
wEhEc5xfM9KYSFLHk7lMl1yvxZQyRc/PqkETl2joLLVaPo4PuVJhDmtm2TLzE5WbQq4EuzLVEn0P
kVZmc+fsiw3Fh2JsvJTyQ4mZYVpjTvTHOr8xuE9CuY2x9yqAXeyRzyA99jcaSEbVBeo9KvQlJAfv
0ZIfyOLWtV0AwcbF9xBzG8EhmzbUYtQ0IH/+YgmaejD385quDB5U5j4wS01ZAL2TfnOgkzkVGaQA
47yTcX6PLfDJll4UrWTVXZ5dluDPctMthZa5RmAOBjoTYZPR7GW2YbUl5jZuMizOZRv5IC+alEuh
EpbGwpYaA26fWdC8XGUT1Zbv+22i1OklIuxrgqv8r7Gnf3WwRvAdeygd6oisvUMWWeyIWGUoldGk
T/yj1jZso0G64I+P1Uy8sTUVWK024FbWv8creavlrDzrTheSSNR9tkiaZgQDYTdZ9H6lZKH+w1vx
9L3eamGEXeQmM2v2+2BU0jJ1GPkyLxoNUAPrDbKFYyFqTgXk2VyYvU6d3vr6p8tfi1V5CgCjUrQz
Dw2Aix7ouLkfe4u2rgDwJJjurzocesjZV9MRjuWFG+eOCqsTsL3EGrA/w2siTfMSvo+o8ci9JtAV
wVILFIAkOazRsPas2gezq4eQUi5hzm+0BYD9ux6cww3u8oirOSkDljZb/WQmFlH9+uYsN8aWu/B8
nxZLdcZ+l6JfDASZ3ee6lP82fyB4UI1qtBAhUzytdSSSaGFV3EmXg1utky+LvhKYbl1mRP6GbdjF
AhE7GIfXP5P1DLV736e4SS165dSbNm/muwD8tYgRPdl+e7YBmlOZYW3elhd7+Gxclkv1ZNsz9aSd
0iK6uZ6skMrRLUuHvhfdRQZiOljxRXsv+dK+76i9r/jF0sVoBDn6issdubuYOQGj9QHK0X8QB981
g677+p5qWzlblWVlsoL2gL31VrJdJFKJ9pNIJTSb59/S/KNi52qcaSBwOaUWRMe2T21QhFf4gcfz
hAa1ZzxiSUlaIjtT8q7GjfHisE1frrU6sBqyy1S28ENRiIQyZB4VThXNQJomUVikQd95296y1F2Q
ZYHXiPCy7S0J8YoCUV02aRIoFm0p2Pnen6Whc/jBw3fHlzOT4+GCBt7OchWQmoVm44FVgguaEO25
5jKMrWR8iWTTMvS1ilFhc4fj9hcsTRxrKJAx/WW915m5s8IB9gVuWzUuMVU+0Bix1v5BXDcTV23q
RD1dwxroOjwRiwlkC+zodpC6J6xcI11slsaEHLKThBpLnf1ZvzhjLuIceraZdlXq5249I/T2S2gA
miMFL3tqw9gyE2znJPAQI7gjgREqByHeeCTYoWCJCEyp+1f5RLGOlHZSBXean6a69/Q7dqlrpE82
okQcigFvsXDSUz4MjtRnzIll9EyA+wJbAGTVUNDxC6cINhSaT1F6B4tdS2mzDg/Y7xTLcbLFPYzV
r1EycajCsKv5wLf64B/6SG0E5fmTTGlL1E2YCE0b7nYIsmJTAqa1laNrvAN6THYrcg2PCaX3YSxY
kI7ZqI8tKc0O7+Pa33xuT3BZ2aBYVZZxQJFfuKwtVvZpmqXe7C45reiUMEoedLQnMEwCOHlGjUlz
c8V+HReimBgiClOfN0udi7LwHZQQsGTc/Lyog6xpqIbnwTo3M7O8yCsf+4gvXZXJpwFPHjHPCUpz
dEDKpCjcbNW+zHetIKAki2z896lwTJfU9YmJc6GNs20O5MGgaUEGP/FVnf77tpMPvx9wK43yUWYD
AQDveqi60+dVv4hH1MtsHWyMU1cQrrjnOrL0OPDRnJXUubafnbjP2Y06IFY0ZA3/U57CAQ6d14bJ
T5FRo1bBcnl+ix4ccR3m17LO/X5C54V+0dhi75BFv5xMjsjvdQwSfdFb1lsE2cce6fxJuTFnSmVQ
XtciB+i0PgtJQQD8c8J9KRzmTXZajZIFyMUQ9Og1iO7X86oq7KqxpsNKNBayKBvIZ/vVo34+kx7h
5EMJWOqbZLQJUz7bvDJTGo4bf/sjxRTGInBDBj4TvdjwjUBckL66Sb2J7mSj2M5gK0jv9PdrDYTP
2ZGEBYPqQtx6XbhZWJ/EZ75QhKU1tOEEcD1CBntXxfNx0JqYRJfpoPEldq9UV4u1oixsZt3ykIv8
B38zK/lMdUn+phcPXE5J/0Wx+rnONGZ3z5F5tyELmfmVQ2J6UXwzTlnHFuR3TKMlsEnCjVQH9qn+
1AdGxQCExsRwyg68bT0czZorJqCsTppsebL//VamjnTfY/vjsNYl7efieE9MA0mXwRIk1hZ8GTxf
9z7KvgE/SOVFWtz2PthrDO5O6IPURIjWxXytsGOp8/yawSw2pbcN1h19Vyhj4P2mJYsNkGdo0Yqm
GV4FDfUdcYAAveWIiCwZfDWEeDKypwQok6OBC2Fk3NQUGj5By4LmENBx7Dveql2c+3M4QbblvZfn
2wG/qpo965dTEDqQr2ajQXxA/3pho+5adCm8QV+SucRoPrwWQmyWPweHvkAQiEcBnDz3N7ktnZTk
BROCJe5+KO2lViGbtOnhuDzWvXXFOpA108KpfwP95AzAnpICWk5Udf4cSKS2BY3GBDh/RuVnD95v
hb/QtVRGWX+7uvPfO941CmsxAn/Ts9GqHk3zAuSM6L8+7m1spctunGpXtPwjjjD+ZM0rPhxZv/Yu
5CcA5ddozBxRDwsw88Xnb1tjDvt6d4OT67fDlOWaKjCfgb3d5H9s6Hxln53hdpk8Wm9fAL8oD10T
PBPkUrYU8eWhXegmENPQQlEHUyy3kazyeKYZ8Ov2+ykXBH3So6WFlG850eGp5LY7yGtNxDzxMJvX
XQFXd/owFMaf4Se0tjfsy1HgO9A/zTFEb4euAQUw61hF+aLAkkWq57GBiLXsGULXifPfxUQOcrSD
c6eiTj4qzeK19E12rZs7dKrzrF+mqDsFHnKGG4sRznCxTjqr0l89Qy50+Rs9tflGBQPBgbqfLM6k
gRcuVHcRgnBmOjmrHv+hntrwINdYP7HCUFW0P/O9WGZ5FIh4Cu2ZHe7jNq7AE89MEtw1Y1tyKZgi
f/GC1N6M9nW22Cx0IgpaI/bZtRO7DRdQHV76si1TeOXqh6vFSJzxjV0LeCd1L2PgHMKP7LrCJvSL
RE5cCp+916ISldCAsc+nFzyNl/5fL9ZmB8id+ZLxwbuk2yZSQacnJ/tk01nxYDKSapClQEkubAiF
sT6XxLJwml/APuz0n7FOUrxD7nnFlid8WVSUiXHjoOCURdJuurWqdpwceJkGeRr0lLYnmd4Z+RHp
SoHjlKUQKom/3t1U6eCGNVvIz1KDNjzcDaqGJKW3T62T4t4WyVvwTyy54ZeuT0d+55mvmlbyNruu
bs0sotvrA4zwm+GRq0mowGN3lUepDqDSudFgiQ/d2kMZq5fhDbSsvPKc7QBlrKw1OXG4VtrUadAF
jqLORem64ar19oNt2+mskXhkWJ7Mv/uTAGk60I+A4ahfZQx/X8nLmp82xfVCBEnA2X9SB3hXoWsd
GaP81Gz+vwQAGnvOrc6yaVwrTRjNOynCoOpai9zAoeQwiYzWr6B723XYEuj5aR/tazcxtDgnZ0+V
5saQz7w21RZTBHtgWPC1YQWJT5VaHmg6ga/tjkrVGYy04HKNme0keU31bubGxYyaNeKbYcLNzljK
p2zU7K+txxG4rA3iM4iIBboZLz6/AXW6FcXccvR5orAdkIVGdZsRgXLr0eKTbrUm7VPBTotL75P/
v0abQvgS3SQlnvH9riaA80u+YqUKCeWKxSHYfAZ3VPaJkjIb6gdJtURrReNzKrWFPQS4bRG3qqSY
GfwVfqn2aqerezOVblnAALpwiwinHE8cFfmOKOnAVIN5e0oFpoVnT1eXC3XskanEJAp2P1fCARxl
zUTAt+XwV7vNpsh/s8z0ctmAVZX2mu4UTe+Hnct0z84UC7YT0DUC/w3TFjybPGJDaip/tSnaeIq/
zbFxdxGCi80KiLaXGEgQhWxhkC2iFADhtI8Y9/HUZd9eZrNG/GvZ/PU7rP7dt7RXgl4CvqV2CHMj
53UJvIsFH++Lz6/u81DulyKuiYw2mWywHrWU3vHxf9YpVgFzx0rtYOJUQpZXHhsFqAQQv7ychtcZ
OmrQKtV3QqhnB2t9O7NXtr8KBkutyfx1580or0ejdKl1913qiLF/g+NH6mLPlB4NDWZYfJmgMnPf
epqsT7Tb5xzLdts+u8Ilkm6GzNa2pjXXWwJ9s7wrjj9skKjN136mVFy5lRVtNBrBcIg+BQyEXhJI
/6gba/SFV+bvqDRU4+8pPhoppL48deM/yCE91SAdloGRYVW03iYboo8siN4kK1tKAtsHDvLaQNQV
GwObNWVhr4N+0snOvhYfAxWqwh59L6aT+Q//eusQNmsS0mZA99RcxyYqCHOc01ddOJ6TM+Gn6JeW
4o/7AQVoHJA1WJo3zNJiockZtqiZ7tAkU37ZOI3ILSyvPV2P6t+MfX3BCiSPZBcIknPZnXo1TRS9
E0Tcq1m79w275mcGeHuaST8b04k69Y7t8MZE79VrCnkcIKePSSP/Z7zKN7vSSseuhbzz054Nm+P9
pEhlVC6xJUTwSHxdTYrOa5rfBRGnmJFLTeZ0LsHdnNxeyDB23PIY0mQ1TrR20PHtVmMCcyjGvCp5
1hV53kgnqiTfTCL16xkOUveVl0Nh+G4LD0/nErZOTwcB3/wBNq67GSC3LcX1/pX7ZDrBwC9SoZA2
jBhNe6Utrw0q1BXlXUrm25Df6Qll1i6c667sCkVxoY8kAIFk5jdOyBTObHQMtMED6RBKQJ7nBelT
COau1SX9Di6RZcLs5TrbrRtOzSP+gXcg13Da8yBP/DDsoZwmdiWZh38V+Ffusde6cmj+SNArnPoB
6jw9JQ2PRjgC5vgPN0irtuDC9Si1ysXjmOj39UG24DEzInzggn9yCGgf1e7BAVu2FhR8Jr+XL2pp
o5a57FUUMP3WFOaAZJ74pTZ+hSuCR6oPdnti8+uDJ0Tqlxb2EVxf06IMiiAnGc4ZLbuqDSRxkFN9
sKV3LcERYyap8w6DtLCM/beW+bBR6BsmtTRO0mpYKvtoUYhaS6xdqPUC0pAaBEv7ZfckM5uQyhfD
sJiuU55NHzH0Zw7BXa0yWfbK/bnPhSps476CIaWdNeTpiCJZKRAseZ77YHOoL+j/tUINfkfFMNOc
cT17I42daQmSYlcZ+aDmxoNZR20p0JJHeZPtYr/c5dOsAAhhi26N0bFRR8zjtusTdwKODiLB+7b9
LBHZXSOa3EJlGVLomnDkl5m0w2VE6r0AXVlkfGaHMU6PMLkQGoR1b0m6XgxT2w84m4HKe3Z+AkEK
z7eqry/NxesfzHBcnh7JhzaIlpeaTUHhM/Lb6j0fMhGF1gK5vT1w7mTLTXk2ErKpq2Xg+IIEMe1D
F4yE/Or0/+9zWabS38A0lzwO0Ppz5zP+8liX7FnhLl38VaykIXJHQytvNVimIkUxIyOtmbJsikLx
0pIrnZ/PcD5UzXD6FFdd5aF2dsBrbOYVBn1KX0JsDiYmjzD2rsg6Y/ica0Yt61aU7nlVteMLeGEx
LALg3r4gEB4mL9V1baDjhJQHZXVgjkruTuRBDwkvZr0Zj0IcqwPohcG+GXZ2FwcOiFYmxzF+0XLh
DVsAXCqD1Dtvnts3J30Fq5aLFHz4d/9+9BHkxzE7TmDCUVgZ+PMHbbUFB9enS+gloHA+AjP3u0z+
okOvEasLDB5XNQZNonALB2F3hbZKVu5J8Jx0nlUY+QqeVNrBEIMgPYcDcitiCj2EO7ZZM18A7lms
/UA5RqNdtP5SGN8d20ZNIFdwkagvGJZLFKLAQhFUzJCJ6QAeia7HNi51hFZ7BkzLx5r3eRAbwV9x
bas5epYMtYWa1t0DYtPDccpXrC58Ofd41m66SImeHeNZaT2zQsNCIDxVsJ/EuVX7KayN9N0lrUWa
tWrG2dcYwfp1LG5GwRq3jNcHe16dfm4DNPsNcq+mBGbtyoACVAg17VL/490cHyg2C1fFNF0+z2Yj
pv/RpaTgUGUJKw1MJKKqW+KRV0PIqA4r5U/kKHJcS7POcl3e1Ze9G2ERkG5VDATekWNuJXMcbreY
8BczQrmu+I8KISiTKqD8WEWKN410RN5EKYgnPk7TWlTPmfIIC7l52K5lgorgXn552Bb6p0DeH/JW
UKp/eT4MWPxM1g15MatkRb/cPYjSlBh30CDDyZS9JpCkccshWwhvUJQZOI3icJRtH/zb7JUikRfB
LBhvxZ01f1cGpG/xV6BFokpCFyL5Gj77CiWfISPpdBSpBl9uTKJ2kgNqYAZiCpWPr54Ypdspr71x
o8JAkO6lU2C8orqVe+I0sOyzuQfms+AbhzgNwSGi9shNOTE3bVtLX/r5RtB22yTn3J+du116bPq3
VfPXpBOmCT6COXjdW3vG8XQEDBUxg8juXPWlYscWiTGT8fmNmeRlfUreHkD0SYJ9OKyafsMTMLWN
LyldR4lUlGB7TFXLQJS+fKeQgUK7SqqRavZxUG7D3E1eEGXeWz1yW7b61aIzOrcI7CB0+/tfygdE
KIqN3G1px00hjEsnS3LCEarhxFZ5i5/bVK15rEnFJBynLIxX36N5hFhqeOU8rQrxiym67yxCW8nU
Gl7yzJd4S1U6k3S7Sbu0LyfGdvx0NhH3hM80tQVG+b0F8Kxjz7u9KxPCAe3Dr/Ey3g2BO3YXbETe
GSoMSiGOKMcNcVB0WUJY9oWrvnNRgYYglZi5DIRvSgKdm6BayKoQZEFu2QlMPG9YXVhmGuozsUNy
q/j7VBkcj3/c1SvLKCqbkij6sSyV1xK5e0YqgQ36DT9O+K6udUaELR0NAUALTn5hj0/PxKfffJyJ
AARJsy/eTmRrp3gsESar0mQb4iHXbbc2tRzyVlssDDa6VAWV3QgZZ89KRM5vKN/KA5Ia0C920l+6
b+2PxZyT0Jmgk37vCgMtUMxyLlmYlmag4ScpUd37hc24E5FtP7rrRHgrM5M8ylLYiN0VggAXSZSy
r2hOyYvCWJWzU0VjadFNIqOIcbcaWa3YDiJTFb4dPePywfEt2yi0oAwXPuhmrQxa3cjCnp+20AHd
gF6Kk9exom3dlUTV1bvOYVB2v/cZ51kfB1gGZiysazB//B7aFGotpf3SKQyyaUR1g/sHeSgB5/Dx
UoSn7bY78Vde0vcaW8criJkgaYUG4pVe3P66CiopEL4BTCUwpu5A1QaGQfgMkWlHvsKT4d0RrsAd
3D4lkXVJukpKey0pvBSCWedMRz75DofIs9jlG7JhdsIo7BajqeBASC21g97LPdqcsK8ezKQd7XNw
i7bnsDiKjIjcu2+WxcPfnyNlGv5brN/+XkscDRMwEuB6CfBNObvfFWsGQCgyflBcV21UYglJjZgj
fZ7k/aPakvR+mWsa6Oac7CvWOx+s9thMGAOHIr63HFZfwalQ3zhxmksNkEsZMk0AHJwgufpSNMba
g/f78+LpJul2x09jRg7x2tqIJYDUv03lYv8JDdzl1Wl7wwfx9pRX0jl2LCVLJLFKrDhZRO5x0qxn
WG1j6mz6oofhMbBDoxaSKacjlrIw6BCq0vuu5HADGuEl7SVHRHnRBcXxOUhjFQWNN4bYguJyAFeD
C1GH1Zpl2C6t6vFRXaJPhVBHAeh1cRccJNY5SWrQffdrdqQ0EQJEitWHj2NEmJ3gwPZ5ODVW5qrz
oG8mkL7lbfMrqiw3ReMDmgHdFFh0pLhPjw4dkS9/x2ha7wvSMNW+dYiz87yT9jpvCd6Jx4bg71Ij
hAvfcJFiF8GjTgzrgtEaR98hF+8kvLUmWKLH/oT08XOnvGb62czFx/lXa05il1OqfNeRm0eA9ByF
y3N7MbfGlGMrq3qfKoM/0ZXHszgXpfBLFkoyVdKQsZtV3D42xUjPF9zN/yHQA22EszVoKOF0siW7
Ssw/9VORTiSxN2WdgviQHCeMYpSj12chGI2JpN9BQVQkjQua9QAUFgnat8tPet7EBPZO6p7lcjpp
k49SY0Y1D4ZITsBPiFuNpufLgjBvEbpVypYP1Md0mIvwbfkzbW5ZAz/bxCs6RbUqZj66YbOuTBgx
d+RoI9CVCnc4r4d7xndyvUvTzgtT+YfcM/WRSU24YWAsw5tPPv7WESj4+k92LAcPEMiVfVuZTSP6
NzUC1rJzAfg1dlN/hqGn3FSFeO3ZOAP4jVZORviUJO/BEP2dzv0esVnCla2vMemqymbIghIhIgbR
B4JkLEfWU9IuU81+nyvig4JauNdNXZhRN9jgv0Nh7x/2FvANq+Wbk4GFNN4nOn6fkEoCHTucGWBs
DeaJKBQIhfBXTrBNnFR+KHGcE0LZzsoze+ebuRQNWo+k7NxfzVuFZmyRqeQGHHpk1lVMfxedF4Kc
G94qht1+ByBvNpnKMDoIxFTklKnV7AO46Wbme4ku3TeHR4UdgjVlUfh1n6ukKc/7tMzFfUXvcsjq
FN0oQemVf6aRpt/YFbgbvxpQ+J7QBwD4I56izA5RGovrXnryAcIaYr7hOSTh7Exu3XDMZlwiAJRR
6AvKfi8Y5KYPTSeih6+5Cw22KIxwiOTF7keDvC8ZVhKhiG9vA4Ne96gpPr7nja+fJ1sWOdIUap6L
K60TDok6AwhQZY8yCphXg9TEMhAsAzRerwb/GyBU9yd8JmhGD9jFqevdJxlX4WwTp85cSmuwNW4J
0wpjY3y44uDf5e8orTiI8RZuLkZTmyylBI2+QPzVsoWZ7TR7ZUaCBx0SQSOyKCuo+DrbcFPSFMd1
tkG40/jT98/BmzhuIRjAipxai++pdu4gtyxEz41yPUEWqjqOifNiLbONBby8jJ3kjQRvVaDom7kc
BtL8V4gHALszOoHM8pSnAAqCsBmW63sjPswS7+F6PN+zyGuMnn6rT66UdWC1eigGTKQjhqHr1mqy
kLT/fU1Z1RMd87e+sdBomgvLkqN+ti/yVr2xtR0n0L6uhVDH77PBbGPyRlbWeUGpMSLG1uRy4gxf
vGVkE69qVyNIxdZGt85GbGk7MiZ4LvaRzSIVWgW646AbZ/QpqDVduwJAa3yDxDb5DYp2T4xe0DKg
803Sic/NoYplDYCG51HYzxFedX/HdgT2NiBOmpFyXrmSw4/Nx6KQrX6+r5Adv+8KgwNFEGKi+2ej
FCdODjSOTXzF0UWOh40PMuHH2Wad1hP+AQMfYPTNQ8Hq63bK2rmRWlGqJvKXSNpTtgHU1c11yaxG
WuzWZcU9YPaYfJRjRirymeVPg4odTqMgqppnzdGVxC/NeeowhPazjELwhoMvcKVuHh3CGPQft2OM
JfYjemBeJeRPKBRDW6CICn2ErDrOD2eXCYGRnRiWTFokqaHOKv75EI2b95mD2TUfo+QrYd7vDi6h
xQan2+13Kkxz1tNqf7eIBeE6ZYVnjiNg9JukqrKT5nJ6lGAVxEybBGiNCVV9Xm7W29f/4DEdLPDT
2Ks+j+nYmjSRzjtxT/z7p4b0P1D/ChuJ6gw1mqodNNhCF5YivNGk7i5NYFWDZ6j2YVwNuYkm9yK/
tyeQqYQftlObUvsZ70rB7Rwk2/zMook73y0YtAReJoHpcl1TFxLY0lp7YbZNHF3UKZIxEnk9x4Fk
+yXnFJVkeBrlRYCg3mqlPXwyluUmIFCg48wLWq8VRcdrYlM+69kqTM7NKTpkbsKbGWOPip+t0jQv
nvzzE/dpE8QRLlzVNgD2DTsgvTIuOQF5BydkauuIMfUCgwGQU/A38SHNkDJtZCc8IX5Bth7WARek
AY+1tnylMi7sAICKc5STFAMSGjMMkktBr0BGrwcNE4v8ATwm80c0cXilq8gPPxi7nDsBelfzRGFr
ViyUVnwAOeDqwzGzkNwUanUdTK7z0RIjGE+jeTlrmxU9P5EAp0u5RMHOpl4VTHpqU/R+xIdyoWlc
d3vuqckxcpGLI6p9+kLLoQ+DQ0KHqsWnJt9Pgpm/dzwQydpPt2C/MsUAkMjqXmHwYrOAkqyawvcf
ctngE0v40UEQwkVLEUi/jN2NjohrtgomrkzZZr4u5lAncUMQi7hVU8DEsRM2Yn8JOdHUW/Wy0NwB
YmUWU/RkekMrQaoHux9SCNvM0m9wxpfomNA/vG+MPxLVSu38j8bxne2FsJJUmvHWSAgGNcv9NqYD
q79H9ScczqiKMgv/zazVT/FJ6UKjANDMl7/7RMWbCevkdxAGTROdmXydgmLGosGlIu1RpFRPCk01
Ov1V/ZkT9x8dj5Q201EyimuymHY1DG+mW3a7VtiFhpyi4iskr58NozYh9LOypXe6ZDd7ESyq3CYp
274JDbbAKJPnBudJJyyjG8mt2OP/VRrlJE0o02Nc4z/1vVebPEy4UuVwtd9psfTjgtvj0sGr6Ftd
i0t4eaarQqluaMEIAfpcJtMXutfETnhA6FK8Ud806RXPaXjta0ml/lG6eyKGzqq0ghNiYzz/8YF8
DybShZTBdez+tMqWsDbxA4KYD6wj+hzBXBv7OzWTGokszqrwml/TDVxeCGeHzTVakcg6ehyYW5SQ
rqWFCSNNAkgm7sjM2YF9ZEmmV0KaJjy9R5+UZNS+w/AcdMJ8JSYWus62LiQXTvJZ0NxCQCmiXlnm
dOFEYVhwF0MGSBEjIYSmYaCT60urIR73T1gvh5do9kZhk7F/iVxzJhxj6hs4oNrVpmUbmUgORNBv
vGWO+JsKmqLpRZkI+7wZthpv/ZzQrn0iYi8kVeoUm7ars1RMLsVAl5CJBQBWbOWHPw7SmV1I+CTi
xFS3e7Pa+y9ZUj3GV5eAF6npKHJKHn10jDvVY5200zfbVrXBn7SpTIb64dF/+OQKX/DX4WaTnymm
uy4LtGqgZ0Vg9DUKPtJWxnEhjf8uvlxOeoF09g3bsSl/H4f6zpUZOAbihcwKj5gx3EUxT3CBtlTt
8gxvdh+KZ5uou/ICHxCix1Ed1Qg2U/V3ojlyTxJocQJZCSxjdYg2X8934igAkpKGiWT7K+Agxy36
4gZyTo7cwxUdI4qvL/Y8xQSz+O19Vj3ulCzy/mAfd5fhyk0XGPRHwBR5PRxenVXN82idDcStgpI+
UwV6XKSKqimZBWxh6YMJQDR1h1VDUpO0wLTuS6eabilwO4A3qFjwO4COhaA6HSLXTaBp4mA1EeUm
Lq8Sf966YbbS2wB3fSi9+JvTYbMJOxU/axuIK5Xgq2r8jq1v+9CdyuvGeN7UtEqZTZmn5UcvYXHM
8Bli359A7feAzWCxDKEFO0tidET4igPBS+S2+oZkEh1iJtYFcTR27+xoX9JZZaMx5u2Xk36rDvBa
pRE682VxNZ0Kl99LzBpnnuefNTYyf6Zm0nMrb6aQv+q9Ry8xdAjwmx0YVIyFf7E800q7rYZWJfiQ
lm+rCzDdhz1+Z7NuwvLSHZOWOu8WYuqVKZhp/rhnC1phppdsZwixAWbBiDKPjbZ6AOYBmJVoXsFf
nDGz8xzLmzEfjvMUyqcSTxBBdmI+2KmcWqRwC1gVfWWMlFnzdAFS7SOHjYA6mRuI6wg90ZeZD/7o
WF8qlUlhlIQBXu2/zTNWsM5xnGgsb4IZTx55sdszqAFYlfKTacTGfXbmxocyqNkGtSD4HvekbGyK
cIpmVTdfU2FoZa619nmVJKO4cEPJgtJDLS1DCgklGNzh4HGtVbSOWZ4vN4rtf23fJdio7Ti/81aT
PL8l5P6IFle8IzdrHZTALBeb1o3+aZHz7V3Vcvs/9JQroNufks7q8tKDxEwJZGYOujppayCLNyAc
rXueg6UgGJtjliPGOM0AzVdb0nGZfP3OMj5TWV6BY8hM4F/hELSUbUMuXrsGchBaRUhuQuUk7mNk
QyZvehhqIa1Tpqd6c4fAmOPOqXFvFwk4hxMbpxxhQ350xez9zYvsxjs4q1zhxOMNg/w0upTCPd8t
Oix2YIZasQ2Ro/DrM0xillncjsGUoWwfZ0Ugm07ycbk5808rLC8UlhHQ5cTL5cRfVL9M6MUkXVw+
5V0JhlIRYHgg2psivOAIYqvgigLsFvuxmaK3i/gJRnb7SPw/YPXkDRo8XDblR362WFhduYZ9b7Sp
hjX1xJPT1qivy4V+H3FKdhrq5RHm7mJI3g+sjlhtFaW1YYBgfMHK0/OVx1oOkWYZSKQJBUHzqwHs
6oDr66EASv0VlwAez8yOHHg/4x1l+VwVcjQLl4N/Fq9H3ON9v2UxeLG8/fbBwrXH3jgaLM4M7IEa
FzCVJZ3H/zWCch9ShDi8reOC9IMIGjnk43viC2UcTzi+6Ial5GgIsOpx/xldKfN/D9BfGMdzMp8H
bt3u4m3O+Q8J4yWLT8I61Q4OfLDXBDiKgVNHFa/YYtPgaXAnLFWgclPs2+4CXN6wB7G3qac2M9Iz
6lW3hRTq5du/ggMNhkO7DV5PyjZ2vWdWoCOfEhJJg6pySIhB3cSmttMhDTl60bvO/ojB6AisTBIg
tHjDWXa7BbW1vm9F2YEIcXceX5GtpdKxvr/mXalPbMDnJ58nDpuYYu5vLR4dON2ohdUQW0DKQ0U0
1p22KdDDirHT4Pf+3XzpbzfGcrXJ2dQf2PIiqUG+3ogFHMUdHf8FBOm+7o9HCwzN0t/XmhtwSqYP
KrfVgD/cAgrLzcD5Csq0niRDBxT5HjxrmFMSisrxaPh3SmMLSzvpa5lBci0/oAB8OttQrnHhSCf9
7SJf5odJDT1ye/IWWug9ooBqzZsfWATpJU1e2v8cpSS6e8L2Lx+RIuQ1l51ugrdGnKoyVjACwRXH
VSgedU3XaRVqcHtpo3swqwChJp2rGWAxM2WZ8WS8miyIkmlsWouNwvvlbAVLO7+IfcQRUwo5D2JC
Bl5HvRRtMonkaiGSnMleknKDs34gupvvfk7Xzr5UZg==
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
