`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2019 05:56:40 PM
// Design Name: 
// Module Name: ram_dl1416
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


module ram_dl1416(
    input clk_fpga, 
    input [15:0] data_in, 
    input [1:0] addr,
    input ce, wr, cu, 
    output [63:0] mem
    );
    
    parameter Tw = 250;
    parameter cursor = 16'b0001_1100_0011_1000;
    
    reg [15:0] ram [0:3];
    wire [63:0] cursor_out; 
    wire clk_1Hz; 
        
    cursor_osc cc(.clk_fpga(clk_fpga), .clk_1Hz(clk_1Hz));
        
    // write characters into ram slots
    always @(negedge wr) begin
        if(!ce && cu) begin
            case(addr)
                2'b00: ram[addr] = data_in;
                2'b01: ram[addr] = data_in;
                2'b10: ram[addr] = data_in;
                2'b11: ram[addr] = data_in;
            endcase
        end
        
    end

    assign mem = {ram[0], ram[1], ram[2], ram[3]};

endmodule
