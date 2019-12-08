//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_fc5c_0_wrapper.bd
//Design : bd_fc5c_0_wrapper
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module bd_fc5c_0_wrapper
   (Clk,
    GPIO1_tri_i,
    GPIO2_tri_i,
    Reset,
    UART_rxd,
    UART_txd);
  input Clk;
  input [31:0]GPIO1_tri_i;
  input [31:0]GPIO2_tri_i;
  input Reset;
  input UART_rxd;
  output UART_txd;

  wire Clk;
  wire [31:0]GPIO1_tri_i;
  wire [31:0]GPIO2_tri_i;
  wire Reset;
  wire UART_rxd;
  wire UART_txd;

  bd_fc5c_0 bd_fc5c_0_i
       (.Clk(Clk),
        .GPIO1_tri_i(GPIO1_tri_i),
        .GPIO2_tri_i(GPIO2_tri_i),
        .Reset(Reset),
        .UART_rxd(UART_rxd),
        .UART_txd(UART_txd));
endmodule
