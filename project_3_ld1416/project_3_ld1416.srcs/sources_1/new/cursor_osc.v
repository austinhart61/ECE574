`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2019 08:17:46 PM
// Design Name: 
// Module Name: cursor_osc
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


module cursor_osc(
    input clk_fpga,
    output clk_1Hz
    );
    
    reg clk_div = 0; 
    reg [24:0] counter; 
    reg [15:0] cursor_ram [0:3];
    
    //create the 1Hz clock to blink the cursor
    always @(posedge clk_fpga) begin
        if(counter == 0) begin
            counter <= 24999999;
            clk_div <= ~clk_div; 
        end else begin
            counter <= counter - 1; 
        end
    end
    
    assign clk_1Hz = clk_div; 
    
endmodule
