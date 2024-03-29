// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Dec  3 21:20:30 2019
// Host        : DESKTOP-3FLIEQ6 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/austi/project_3_ld1416/project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/microblaze_mcs_0_stub.v
// Design      : microblaze_mcs_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bd_fc5c_0,Vivado 2019.1" *)
module microblaze_mcs_0(Clk, Reset, UART_rxd, UART_txd, GPIO1_tri_i, 
  GPIO2_tri_i)
/* synthesis syn_black_box black_box_pad_pin="Clk,Reset,UART_rxd,UART_txd,GPIO1_tri_i[31:0],GPIO2_tri_i[31:0]" */;
  input Clk;
  input Reset;
  input UART_rxd;
  output UART_txd;
  input [31:0]GPIO1_tri_i;
  input [31:0]GPIO2_tri_i;
endmodule
