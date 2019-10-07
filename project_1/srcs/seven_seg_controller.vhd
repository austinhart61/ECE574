----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/23/2019 09:35:58 PM
-- Design Name: 
-- Module Name: seven_seg_controller - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_seg_controller is
    Port( clock_100MHz : in STD_LOGIC;
           -- reset : in STD_LOGIC;
           -- in_bus : in STD_LOGIC_VECTOR (15 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_seg_controller;

architecture Behavioral of seven_seg_controller is
    signal anode_counter: STD_LOGIC_VECTOR(1 downto 0);
    signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
    --signal all_segs: STD_LOGIC_VECTOR(27 downto 0) := "0000000000000000000000000000";
    signal in_bus: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal number_counter: STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    component seven_seg port(in_seg : in STD_LOGIC_VECTOR (3 downto 0);
                        out_seg : out STD_LOGIC_VECTOR (6 downto 0)); end component;
begin

U1 : seven_seg port map(in_seg => in_bus,
                    out_seg => sev_seg);

process(anode_counter)
begin
    case anode_counter is
    when "00" =>
        anodes <= "0111";
        in_bus <= number_counter(15 downto 12);
    when "01" =>
        anodes <= "1011";
        in_bus <= number_counter(11 downto 8);
    when "10" =>
        anodes <= "1101";
        in_bus <= number_counter(7 downto 4);
    when "11" =>
        anodes <= "1110";
        in_bus <= number_counter(3 downto 0);
    end case;
end process; 

process(clock_100MHz)
begin
    if(rising_edge(clock_100MHz)) then
        if(refresh_counter /= 9999) then
            refresh_counter <= refresh_counter + 1;
            number_counter <= number_counter + 1; 
        else
            refresh_counter <= (others => '0'); 
            number_counter <= (others => '0'); 
            anode_counter <= anode_counter + 1; 
        end if;
    end if; 
    
end process;

end Behavioral;
