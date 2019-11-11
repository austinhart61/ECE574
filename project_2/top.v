`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 09:30:07 AM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top(
    input clk_fpga,
    input reset, 
    input rx, 
    output tx
    );
    
    wire clk_100MHz;
    wire clk_10MHz; 
    wire [6:0] mb_cnt; 
    wire [31:0] from_mb;
    wire [6:0] cnt_div;
    wire [6:0] cnt;
    wire [31:0] out_chunk;
    wire [31:0] out_chunk_div; 
    
    microblaze_mcs_0 mblaze (
        .Clk(clk_100MHz),                  // input wire Clk
        .Reset(reset),              // input wire Reset
        .UART_rxd(rx),        // input wire UART_rxd
        .UART_txd(tx),        // output wire UART_txd
        .GPIO1_tri_i(cnt),  // input wire [6 : 0] GPIO1_tri_i
        .GPIO1_tri_o(from_mb),  // output wire [31 : 0] GPIO1_tri_o
        .GPIO2_tri_i(out_chunk),  // input wire [31 : 0] GPIO2_tri_i
        .GPIO2_tri_o(mb_cnt),  // output wire [6 : 0] GPIO2_tri_o
        .GPIO3_tri_i(out_chunk_div),  // input wire [31 : 0] GPIO3_tri_i
        .GPIO4_tri_i(cnt_div)  // input wire [6 : 0] GPIO4_tri_i
    );
    
    clk_wiz_0 clk_wizard (
        // Clock out ports
        .clk_100MHz(clk_100MHz),     // output clk_100MHz
        .clk_10MHz(clk_10MHz), 
        // Status and control signals
        .reset(reset), // input reset
        // Clock in ports
        .clk_in1(clk_fpga)
    );      // input clk_in1
    
    mul128 big_mul (
        .clk(clk_10MHz), 
        .reset(reset), 
        .from_mb(from_mb),
        .mb_cnt(mb_cnt),
        .cnt(cnt),
        .out_chunk(out_chunk)
    );
    
    div64 big_div (
        .clk(clk_10MHz), 
        .reset(reset), 
        .from_mb(from_mb),
        .mb_cnt(mb_cnt), 
        .out_chunk(out_chunk_div), 
        .cnt_div(cnt_div)
    );
        
endmodule
