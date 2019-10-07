----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/01/2019 10:35:06 AM
-- Design Name: 
-- Module Name: div_25MHz_10Hz - Behavioral
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

entity div_25MHz_10Hz is
    Port ( clk_25MHz : in STD_LOGIC;
           clk_10Hz : out STD_LOGIC);
end div_25MHz_10Hz;

architecture Behavioral of div_25MHz_10Hz is
    signal div_counter_10Hz : integer range 0 to 2499999;       --Counter to divide clock to 10Hz
begin

--10Hz clock divider
process(clk_25MHz)
begin
    if clk_25MHz'event and clk_25MHz = '1' then
        if div_counter_10Hz = 2499999 then
            div_counter_10Hz <= 0;
        else
            div_counter_10Hz <= div_counter_10Hz + 1;
        end if;
    end if;
end process;
--10Hz pulse signal
clk_10Hz <= '1' when div_counter_10Hz = 2499999 else '0';

end Behavioral;
