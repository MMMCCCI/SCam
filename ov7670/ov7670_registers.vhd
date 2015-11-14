----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mike Field <hamster@sanp.net.nz> 
-- 
-- Description: Register settings for the OV7670 Caamera (partially from OV7670.c
--              in the Linux Kernel
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ov7670_registers is
  port (
    clk      : in  std_logic;
    resend   : in  std_logic;
    advance  : in  std_logic;
    command  : out std_logic_vector(15 downto 0);
    finished : out std_logic
    );
end ov7670_registers;

architecture Behavioral of ov7670_registers is
  signal sreg    : std_logic_vector(15 downto 0);
  signal address : std_logic_vector(7 downto 0) := (others => '0');
begin

  command                   <= sreg;
  with sreg select finished <= '1' when x"FFFF", '0' when others;

  process(clk)
  begin
    if rising_edge(clk) then
      if resend = '1' then
        address <= (others => '0');
      elsif advance = '1' then
        address <= std_logic_vector(unsigned(address)+1);
      end if;

      case address is
        when x"00" => sreg <= x"1280";  -- COM7   Reset
        when x"01" => sreg <= x"1280";  -- COM7   Reset
        when x"02" => sreg <= x"1204";  -- COM7   Size & RGB output
        when x"03" => sreg <= x"1100";  -- CLKRC  Prescaler - Fin/(1+1)
        when x"04" => sreg <= x"0C00";  -- COM3   Lots of stuff, enable scaling, all others off
        when x"05" => sreg <= x"3E00";  -- COM14  PCLK scaling off

        when x"06" => sreg <= x"8C00";  -- RGB444 Set RGB format
        when x"07" => sreg <= x"0400";  -- COM1   no CCIR601
        when x"08" => sreg <= x"4010";  -- COM15  Full 0-255 output, RGB 565
        when x"09" => sreg <= x"3A04";  -- TSLB   Set UV ordering,  do not auto-reset window
        when x"0A" => sreg <= x"1438";  -- COM9  - AGC Celling
        when x"0B" => sreg <= x"4f40";  -- MTX1  - colour conversion matrix
        when x"0C" => sreg <= x"5034";  -- MTX2  - colour conversion matrix
        when x"0D" => sreg <= x"510C";  -- MTX3  - colour conversion matrix
        when x"0E" => sreg <= x"5217";  -- MTX4  - colour conversion matrix
        when x"0F" => sreg <= x"5329";  -- MTX5  - colour conversion matrix
        when x"10" => sreg <= x"5440";  -- MTX6  - colour conversion matrix
        when x"11" => sreg <= x"581E";  -- MTXS  - Matrix sign and auto contrast
        when x"12" => sreg <= x"3DC0";  -- COM13 - Turn on GAMMA and UV Auto adjust
        when x"13" => sreg <= x"1100";  -- CLKRC  Prescaler - Fin/(1+1)

        when x"14" => sreg <= x"1711";  -- HSTART HREF start (high 8 bits)
        when x"15" => sreg <= x"1861";  -- HSTOP  HREF stop (high 8 bits)
        when x"16" => sreg <= x"32A4";  -- HREF   Edge offset and low 3 bits of HSTART and HSTOP

        when x"17" => sreg <= x"1903";  -- VSTART VSYNC start (high 8 bits)
        when x"18" => sreg <= x"1A7B";  -- VSTOP  VSYNC stop (high 8 bits) 
        when x"19" => sreg <= x"030A";  -- VREF   VSYNC low two bits

        when x"1A" => sreg <= x"0E61"; -- COM5
        when x"1B" => sreg <= x"0F4B"; -- COM6
        when x"1C" => sreg <= x"1602"; -- RSVD 
                              
        when x"1D" => sreg <= x"1E37"; -- ABLC1 - Turn on auto black level
        when x"1E" => sreg <= x"2102"; -- ADCCTR1
        when x"1F" => sreg <= x"2291"; -- COM8  - AGC, White balance
        when x"20" => sreg <= x"2907";
        when x"21" => sreg <= x"330B"; -- spare
        when x"22" => sreg <= x"350B"; -- spare
        when x"23" => sreg <= x"371D"; -- spare
        when x"24" => sreg <= x"3871"; -- spare
        when x"25" => sreg <= x"392A"; -- COM8 - AGC, White balance
        when x"26" => sreg <= x"3C78"; -- spare
        when x"27" => sreg <= x"4D40"; -- AECH Exposure
        when x"28" => sreg <= x"4E20"; -- COMM4 - Window Size
        when x"29" => sreg <= x"6900"; -- spare
        when x"2a" => sreg <= x"6B4A"; -- AECGMAX banding filter step
        when x"2b" => sreg <= x"7410"; -- AEW AGC Stable upper limite
        when x"2c" => sreg <= x"8D4F"; -- AEB AGC Stable lower limi
        when x"2d" => sreg <= x"8E00"; -- VPT AGC fast mode limits
        when x"2e" => sreg <= x"8F00"; -- HRL High reference level
        when x"2f" => sreg <= x"9000"; -- LRL low reference level
        when x"30" => sreg <= x"9100"; -- DSPC3 DSP control
        when x"31" => sreg <= x"9600"; -- LPH Lower Prob High
        when x"32" => sreg <= x"9A00"; -- UPL Upper Prob Low
        when x"33" => sreg <= x"B084"; -- TPL Total Prob Low
        when x"34" => sreg <= x"B10C"; -- TPH Total Prob High
        when x"35" => sreg <= x"B20E"; -- NALG AEC Algo select
        when x"36" => sreg <= x"B382"; -- COM8 AGC Settings
        when x"37" => sreg <= x"B80A";
        when x"38" => sreg <= x"13CF";
        when x"39" => sreg <= x"552F";
        when x"3A" => sreg <= x"56BF";
        when others => sreg <= x"ffff";
      end case;
    end if;
  end process;
  
end Behavioral;

