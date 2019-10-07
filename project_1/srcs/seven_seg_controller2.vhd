library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
entity seven_segment_display_VHDL is
    Port ( clock_100MHz : in STD_LOGIC;
           displayed_number : in STD_LOGIC_VECTOR (15 downto 0); 
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out STD_LOGIC_VECTOR (6 downto 0));
end seven_segment_display_VHDL;

architecture Behavioral of seven_segment_display_VHDL is
component seven_seg port(in_seg : in STD_LOGIC_VECTOR (3 downto 0);
                        out_seg : out STD_LOGIC_VECTOR (6 downto 0)); end component;
signal get_seg: STD_LOGIC_VECTOR (3 downto 0);
signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
signal anode_counter: std_logic_vector(1 downto 0);

begin

U1 : seven_seg port map(in_seg => get_seg,
                    out_seg => sev_seg);

process(clock_100MHz)
begin 
    if(rising_edge(clock_100MHz)) then
        refresh_counter <= refresh_counter + 1;
    end if;
end process;
-- This generates about a 2ms active time for each anode
anode_counter <= refresh_counter(19 downto 18);

process(anode_counter)
begin
    case anode_counter is
    when "00" =>
        anodes <= "0111"; 
        get_seg <= displayed_number(15 downto 12);
    when "01" =>
        anodes <= "1011"; 
        get_seg <= displayed_number(11 downto 8);
    when "10" =>
        anodes <= "1101"; 
        get_seg <= displayed_number(7 downto 4);
    when "11" =>
        anodes <= "1110"; 
        get_seg <= displayed_number(3 downto 0);
    end case;
end process;

end Behavioral;