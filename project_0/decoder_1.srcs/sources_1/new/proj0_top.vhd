----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/08/2019 05:58:53 PM
-- Design Name: 
-- Module Name: proj0_top - Behavioral
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

entity proj0_top is
    Port ( switches : in STD_LOGIC_VECTOR (3 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           leds : out STD_LOGIC_VECTOR (15 downto 0);
           sev_seg : out STD_LOGIC_VECTOR (6 downto 0));
end proj0_top;

architecture Behavioral of proj0_top is

    --signal anodes : std_logic_vector(3 downto 0) := "1110";
    component seven_seg is
       port (  in_seg   : in STD_LOGIC_VECTOR (3 downto 0);
               out_seg  : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    component decoder is 
        port ( SW       : in STD_LOGIC_VECTOR (3 downto 0);
               LED      : out STD_LOGIC_VECTOR (15 downto 0));
    end component;

begin
    anodes <= "1110";
    U1: decoder PORT MAP(   SW  =>  switches,
                            LED =>  leds);
    U2: seven_seg PORT MAP( in_seg => switches,
                            out_seg => sev_seg);

end Behavioral;
