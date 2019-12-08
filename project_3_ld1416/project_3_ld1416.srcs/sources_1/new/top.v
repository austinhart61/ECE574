`timescale 1ns / 1ps

module top(
    input clk_fpga, 
    input [6:0] d_in,
    input [1:0] addr,
    input reset, 
    input ce,
    input wr,
    input cu,
    input rx, 
    output tx
    );
    
    wire [63:0] d_out; 
    
    dl1416 display(
        .clk_fpga(clk_fpga),        // fpga clock
        .d_in(d_in),                // data for ROM address
        .addr(addr),                // data for segment address
        .ce(ce),                    // chip enable signal
        .wr(wr),                    // write enable signal
        .cu(cu),                    // cursor signal
        .d_out(d_out)               // data out bus (dump from RAM)
    );
    
    microblaze_mcs_0 your_instance_name (
      .Clk(clk_fpga),               // input wire Clk
      .Reset(reset),                // input wire Reset
      .UART_rxd(rx),                // input wire UART_rxd
      .UART_txd(tx),                // output wire UART_txd
      .GPIO1_tri_i(d_out[31:0]),    // input wire [31 : 0] GPIO1_tri_i
      .GPIO2_tri_i(d_out[63:32])    // input wire [31 : 0] GPIO2_tri_i
    );
    
endmodule
