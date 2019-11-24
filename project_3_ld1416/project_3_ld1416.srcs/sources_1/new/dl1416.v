`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2019 12:54:46 PM
// Design Name: 
// Module Name: dl1416
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


module dl1416(
    input clk_fpga, 
    input [6:0] d_in,
    input [1:0] addr,
    input ce,
    input wr,
    input cu,
    output [63:0] d_out
    );
    
    wire [15:0] char; 
    
    rom_dl1416 rom(.addr(d_in), .data(char));
    
    ram_dl1416 ram(.clk_fpga(clk_fpga), .data_in(char), .addr(addr), .ce(ce), .wr(wr), .cu(cu), .mem(d_out));
        
endmodule
