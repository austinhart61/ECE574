----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/08/2019 05:25:54 PM
-- Design Name: 
-- Module Name: seven_seg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity seven_seg is
    Port ( in_seg : in STD_LOGIC_VECTOR (3 downto 0);
           out_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_seg;

architecture Behavioral of seven_seg is

begin

    with in_seg select out_seg <=
        "0000001" when "0000",  -- 0 
        "1001111" when "0001",  -- 1
        "0010010" when "0010",  -- 2
        "0000110" when "0011",  -- 3
        "1001100" when "0100",  -- 4
        "0100100" when "0101",  -- 5
        "0100000" when "0110",  -- 6
        "0001111" when "0111",  -- 7
        "0000000" when "1000",  -- 8
        "0001100" when "1001",  -- 9
        "0001000" when "1010",  -- A
        "1100000" when "1011",  -- b
        "0110001" when "1100",  -- C
        "1000010" when "1101",  -- d
        "0110000" when "1110",  -- E
        "0111000" when "1111";  -- F

end Behavioral;
