library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity light_sensor is
    Port ( clk_25MHz : in STD_LOGIC;                    --MMCM clock
           serial_in : in std_logic;                    --SDO 
           reading : out STD_LOGIC_VECTOR (7 downto 0); --light sensor reading
           sclk : out STD_LOGIC;                        --SCLK signal
           ce : out STD_LOGIC);                         --Chip enable
end light_sensor;

architecture Behavioral of light_sensor is
    signal clk_1MHz : std_logic;                                --1MHz clock signal
    signal clk_10Hz : std_logic;                                --10MHz clock signal (pulse)
    signal clk_1MHz_pulse : std_logic;                          --1MHz clock signal (pulse)
    signal ce_reg : std_logic;                                  --ce register
    signal light_value : std_logic_vector(7 downto 0);          --Light value register  
    signal light_shift_reg : std_logic_vector(7 downto 0);      --Light shift register of sdo bits
    signal data_counter : std_logic_vector(3 downto 0);         --Data shifting counter
    
    component div_25MHz_1MHz port(
        clk_25MHz : in STD_LOGIC;
        clk_1MHz : out STD_LOGIC;
        clk_1MHz_pulse : out STD_LOGIC);
    end component; 
    
    component div_25MHz_10Hz port(
        clk_25MHz : in STD_LOGIC;
        clk_10Hz : out STD_LOGIC);
    end component; 
    
begin

U5: div_25MHz_1MHz port map(
    clk_25MHz => clk_25MHz,
    clk_1MHz => clk_1MHz,
    clk_1MHz_pulse => clk_1MHz_pulse
);

U6: div_25MHz_10Hz port map(
    clk_25MHz => clk_25MHz, 
    clk_10Hz => clk_10Hz
);

--If 1MHz and 10Hz pulse are 1, then trigger a sample (Ce=0)
process(clk_1MHz_pulse)
begin
    if clk_1MHz_pulse'event and clk_1MHz_pulse = '1' then
        if clk_10Hz = '1' then
            ce_reg <= '0';
        elsif data_counter = 15 then
            ce_reg <= '1';
        end if;
    end if;
end process;

--Increment data counter when ce = 0. Reset at 15 counts. 
process(clk_1MHz_pulse)
begin
    if clk_1MHz_pulse'event and clk_1MHz_pulse = '1' then
        if ce_reg = '0' then
            if data_counter = 15 then
                data_counter <= x"0";
            else
                data_counter <= data_counter + '1';
            end if;
        end if;
    end if;
end process;

--Shift in bits until only data bits are in the shift register
process(clk_1MHz_pulse)
begin
    if clk_1MHz_pulse'event and clk_1MHz_pulse = '1' then
        if data_counter < 11 then
            light_shift_reg <= light_shift_reg(6 downto 0) & serial_in;
        end if;
    end if;
end process;

--Set new output value when 16 samples have been counted, else retain old value
process(clk_1MHz_pulse)
begin
    if clk_1MHz_pulse'event and clk_1MHz_pulse = '1' then
        if data_counter = 15 then
            light_value <= light_shift_reg;
        else
            light_value <= light_value;        
        end if;
    end if; 
end process;

--Set output
ce <= ce_reg;
sclk <= clk_1MHz;
reading <= light_value;

end Behavioral;
