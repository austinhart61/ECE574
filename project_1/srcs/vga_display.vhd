library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_display is
    Port ( clk_25MHz : in STD_LOGIC;
           switches : in STD_LOGIC_VECTOR (2 downto 0);
           color_val : out STD_LOGIC_VECTOR (11 downto 0); 
           x_pos : out STD_LOGIC_VECTOR (7 downto 0);
           hsync : out STD_LOGIC;
           vsync : out STD_LOGIC);
end vga_display;

architecture Behavioral of vga_display is

component vga_controller_640_60 port(
   rst         : in std_logic;
   pixel_clk   : in std_logic;

   HS          : out std_logic;
   VS          : out std_logic;
   hcount      : out std_logic_vector(10 downto 0);
   vcount      : out std_logic_vector(10 downto 0);
   blank       : out std_logic
);
end component; 

signal reset : std_logic := '0'; 
signal hor_count : std_logic_vector(10 downto 0); 
signal ver_count : std_logic_vector(10 downto 0); 
signal blank : std_logic; 
signal x_pos_reg : std_logic_vector(7 downto 0);

begin

U8 : vga_controller_640_60 port map(
    rst => reset, 
    pixel_clk => clk_25MHz,
    hs => hsync, 
    vs => vsync, 
    hcount => hor_count, 
    vcount => ver_count, 
    blank => blank
);

process(blank, switches, hor_count, ver_count)
begin
if blank = '1' then
    color_val <= x"000";
else
    case switches is
    when "001" =>
        -- red
        color_val <= x"F00";
    when "010" =>
        -- blue and yellow
        if hor_count(5) = '1' then
            color_val <= x"00F";
        else
            color_val <= x"FF0";
        end if;
    when "011" =>
        -- white block @ (2, 8)
        if hor_count(10 downto 5) = 2 and ver_count >= 8 * 24 and ver_count < 8 * 24 + 24 then
            color_val <= x"FFF";
        else
            color_val <= x"000";
        end if;
    when "100" =>
        -- red block @ (11, 11)
        if hor_count(10 downto 5) = 11 and ver_count >= 11 * 24 and ver_count < 11 * 24 + 24 then
            color_val <= x"0F0";
        else
            color_val <= x"000";
        end if;
    when "101" =>
        -- yellow block @ (14, 3)
        if hor_count(10 downto 5) = 14 and ver_count >= 3 * 24 and ver_count < 3 * 24 + 24 then
            color_val <= x"FF0";
        else
            color_val <= x"000";
        end if;
    when "110" =>
        -- blue block @ (19, 8)
        if hor_count(10 downto 5) = 19 and ver_count >= 8 * 24 and ver_count < 8 * 24 + 24 then
            color_val <= x"00F";
        else
            color_val <= x"000";
        end if;
    when others =>
        -- else, this account for 000 & 111
        color_val <= x"000";
    end case; 
end if; 
end process; 

process(switches)
begin
    case switches is 
    when "011" =>
        x_pos_reg <= x"02";
    when "100" =>
        x_pos_reg <= x"11";
    when "101" =>
        x_pos_reg <= x"14";
    when "110" =>
        x_pos_reg <= x"19";
    when others =>
        x_pos_reg <= x"00"; 
    end case; 
end process; 

x_pos <= x_pos_reg; 

end Behavioral;
