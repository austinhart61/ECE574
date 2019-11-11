`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2019 09:53:26 AM
// Design Name: 
// Module Name: mult
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

module mult(
input [31:0] in0,
input [31:0] in1,
output wire[63:0] res);
    
    assign res = in0*in1;
endmodule

