----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Austin Hartshorn
-- 
-- Create Date: 09/08/2019 04:26:45 PM
-- Design Name: 
-- Module Name: decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 4->16 decoder to control the segment display to show hex values. 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
    Port ( SW : in STD_LOGIC_VECTOR (3 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0));
end decoder;

architecture Behavioral of decoder is

begin

    with SW select LED <= 
        "0000000000000001" when "0000",
        "0000000000000010" when "0001",
        "0000000000000100" when "0010",
        "0000000000001000" when "0011",
        "0000000000010000" when "0100",
        "0000000000100000" when "0101",
        "0000000001000000" when "0110",
        "0000000010000000" when "0111",
        "0000000100000000" when "1000",
        "0000001000000000" when "1001",
        "0000010000000000" when "1010",
        "0000100000000000" when "1011",
        "0001000000000000" when "1100",
        "0010000000000000" when "1101",
        "0100000000000000" when "1110",
        "1000000000000000" when "1111";
    

end Behavioral;
