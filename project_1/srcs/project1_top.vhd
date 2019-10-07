library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project1_top is
    Port ( in_bit : in std_logic; 
           clock_100MHz : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR (2 downto 0); 
           sclk : out STD_LOGIC;
           ce : out STD_LOGIC;
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out STD_LOGIC_VECTOR (6 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC;
           color_val : out STD_LOGIC_VECTOR (11 downto 0));
end project1_top;

architecture Behavioral of project1_top is

component clk_wiz_0 port(
            clk_in1     : in std_logic;
            clk_25MHz   : out std_logic);
end component; 

component seven_segment_display_VHDL port(
           clock_100MHz : in STD_LOGIC;
           displayed_number : in STD_LOGIC_VECTOR (15 downto 0);
           anodes : out STD_LOGIC_VECTOR (3 downto 0);
           sev_seg : out STD_LOGIC_VECTOR (6 downto 0));
end component; 

component light_sensor port(
           clk_25MHz : in STD_LOGIC;
           serial_in : in std_logic; 
           reading : out STD_LOGIC_VECTOR (7 downto 0);
           sclk : out STD_LOGIC;
           ce : out STD_LOGIC);
end component;

component vga_display port(
           clk_25MHz : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR (2 downto 0);
           color_val : out STD_LOGIC_VECTOR (11 downto 0); 
           x_pos : out STD_LOGIC_VECTOR (7 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC); 
end component; 

signal clk_25MHz : std_logic; 
signal sensor_value : std_logic_vector (7 downto 0);
signal x_pos : std_logic_vector (7 downto 0); 
signal value_to_display : std_logic_vector (15 downto 0); 

begin

U2 : clk_wiz_0 port map(
    clk_in1 => clock_100MHz,
    clk_25MHz => clk_25Mhz
);

U3 : light_sensor port map(
    clk_25Mhz => clk_25MHz, 
    serial_in => in_bit, 
    reading => sensor_value, 
    sclk => sclk,
    ce => ce
);

U4 : seven_segment_display_VHDL port map(
    clock_100MHz => clock_100MHz,
    displayed_number => value_to_display,
    anodes => anodes, 
    sev_seg => sev_seg 
);

U7 : vga_display port map(
    clk_25MHz => clk_25MHz, 
    switches => switches,
    x_pos => x_pos,
    hsync => hsync, 
    vsync => vsync,
    color_val => color_val
);

process(clk_25MHz)
begin 
    if clk_25MHz'event and clk_25MHz = '1' then
        value_to_display <= x_pos & sensor_value;
    end if; 
end process; 

end Behavioral;
