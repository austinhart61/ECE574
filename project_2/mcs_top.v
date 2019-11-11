`timescale 1ns / 1ps

module mcs_top(
    input clk_fpga,
    input reset,
    input rx,
    output tx,
    input [2:0] sw,
    output [7:0] led,
    output [11:0] color,
    output hsync, 
    output vsync
);

wire clk_100MHz_mmcm;
wire clk_25MHz_mmcm;
wire blank;
wire [10:0] hcount; 
wire [10:0] vcount; 
reg [11:0] color_bus;
wire [11:0] color_gpio;  
wire [9:0] xypos;

microblaze_mcs_0 mb1 (
  .Clk(clk_100MHz_mmcm),                  // input wire Clk
  .Reset(reset),              // input wire Reset
  .UART_rxd(rx),        // input wire UART_rxd
  .UART_txd(tx),        // output wire UART_txd
  .GPIO1_tri_i(sw),  // input wire [2 : 0] GPIO1_tri_i
  .GPIO1_tri_o(led),  // output wire [7 : 0] GPIO1_tri_o
  .GPIO2_tri_o(xypos),  // output wire [9 : 0] GPIO2_tri_o
  .GPIO3_tri_o(color_gpio)  // output wire [11 : 0] GPIO3_tri_0
);

clk_wiz_0 clk_mgr (
    // Clock out ports
    .clk_100MHz_mmcm(clk_100MHz_mmcm),     // output 
    .clk_25MHz_mmcm(clk_25MHz_mmcm),     // output clk_100MHz_mmcm
    // Status and control signals
    .reset(reset), // input reset
    // Clock in ports
    .clk_in1(clk_fpga)      // input clk_in1
);

vga_controller_640_60 vga_vhdl_module (
    .rst(reset),
    .pixel_clk(clk_25MHz_mmcm),
    .HS(hsync),
    .VS(vsync),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank)
);

always @ (hcount, vcount, reset, blank, color_gpio, xypos) begin
    if(blank == 1 || reset == 1) begin
        color_bus = 12'b000000000000;
    end
    else begin
        if (hcount[9:5] == xypos[9:5] && vcount >= xypos[4:0] * 24 && vcount < xypos[4:0] * 24 + 32) begin
            color_bus = color_gpio; 
        end
        else begin
            color_bus = 12'b0;
        end
    end
end

assign color = color_bus; 
//assign xypos_temp = 10'b1000010000;

endmodule