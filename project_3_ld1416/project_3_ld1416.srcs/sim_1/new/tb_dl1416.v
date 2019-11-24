`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2019 09:31:55 PM
// Design Name: 
// Module Name: tb_dl1416
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


module tb_dl1416(

    );
    
    reg clk_fpga; 
    reg [6:0] d_in;
    reg [1:0] addr;
    reg ce;
    reg wr;
    reg cu;
    wire [63:0] d_out;
    
    dl1416 uut(.clk_fpga(clk_fpga), .d_in(d_in), .addr(addr),
        .ce(ce), .wr(wr), .cu(cu), .d_out(d_out));
        
    initial begin
        clk_fpga = 0; 
        ce = 0; 
        cu = 1; 
        wr = 1; 
        
        d_in = 7'b1000001;  //A
        addr = 2'b00;
        
        #260; 
        wr = 0; 
        
        #260;
        wr = 1;     
        d_in = 7'b0101010;  //*
        addr = 2'b01;
        
        #260;
        wr = 0;
        
        #260;
        wr = 1;     
        d_in = 7'b1010000;  //P
        addr = 2'b10;
        
        #260;
        wr = 0;
        
        #260;
        wr = 1;     
        d_in = 7'b0110011;  //3
        addr = 2'b11;
        
        #260;
        wr = 0;
        
        #260;
        
    end
    
    always
        #20 clk_fpga = !clk_fpga;
        
endmodule
