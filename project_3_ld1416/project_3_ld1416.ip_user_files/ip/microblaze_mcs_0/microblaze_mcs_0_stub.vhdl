-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Tue Dec  3 21:20:30 2019
-- Host        : DESKTOP-3FLIEQ6 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/austi/project_3_ld1416/project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/microblaze_mcs_0_stub.vhdl
-- Design      : microblaze_mcs_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity microblaze_mcs_0 is
  Port ( 
    Clk : in STD_LOGIC;
    Reset : in STD_LOGIC;
    UART_rxd : in STD_LOGIC;
    UART_txd : out STD_LOGIC;
    GPIO1_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    GPIO2_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end microblaze_mcs_0;

architecture stub of microblaze_mcs_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "Clk,Reset,UART_rxd,UART_txd,GPIO1_tri_i[31:0],GPIO2_tri_i[31:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "bd_fc5c_0,Vivado 2019.1";
begin
end;