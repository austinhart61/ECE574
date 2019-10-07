library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_25MHz_1MHz is
    Port ( clk_25MHz : in STD_LOGIC;
           clk_1MHz : out STD_LOGIC;
           clk_1MHz_pulse : out STD_LOGIC);
end div_25MHz_1MHz;

architecture Behavioral of div_25MHz_1MHz is
    signal counter_1MHz : integer range 0 to 24;            --Counter to divide clock to 1MHz
begin

--1MHz clock divider
process(clk_25MHz)
begin
    if clk_25MHz'event and clk_25MHz = '1' then
        if counter_1MHz = 24 then
            counter_1MHz <= 0;
        else
            counter_1MHz <= counter_1MHz + 1;
        end if;
    end if;
end process;

--1MHz 50% duty cycle signal and pulse
clk_1MHz <= '1' when counter_1MHz < 13 else '0';
clk_1MHz_pulse <= '1' when counter_1MHz = 24 else '0'; 

end Behavioral;
