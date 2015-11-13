--------------------------------------------------------------------------------
-- Engineer:
-- Description:   
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity tb_ov7670_top is
end tb_ov7670_top;

architecture behavior of tb_ov7670_top is
  component ov7670_top
    port(
      clk100       : in    std_logic;
      OV7670_SIOC  : out   std_logic;
      OV7670_SIOD  : inout std_logic;
      OV7670_RESET : out   std_logic;
      OV7670_PWDN  : out   std_logic;
      OV7670_VSYNC : in    std_logic;
      OV7670_HREF  : in    std_logic;
      OV7670_PCLK  : in    std_logic;
      OV7670_XCLK  : out   std_logic;
      OV7670_D     : in    std_logic_vector(7 downto 0);
      vga_red      : out   std_logic_vector(3 downto 0);
      vga_green    : out   std_logic_vector(3 downto 0);
      vga_blue     : out   std_logic_vector(3 downto 0);
      vga_hsync    : out   std_logic;
      vga_vsync    : out   std_logic;
      btn          : in    std_logic
      );
  end component;

  --Inputs
  signal clk100       : std_logic                    := '0';
  signal OV7670_VSYNC : std_logic                    := '0';
  signal OV7670_HREF  : std_logic                    := '0';
  signal OV7670_PCLK  : std_logic                    := '0';
  signal OV7670_XCLK  : std_logic                    := '0';
  signal OV7670_D     : std_logic_vector(7 downto 0) := (others => '0');

  --BiDirs
  signal OV7670_SIOD : std_logic;

  --Outputs
  signal OV7670_SIOC  : std_logic;
  signal OV7670_RESET : std_logic;
  signal OV7670_PWDN  : std_logic;
  signal vga_red      : std_logic_vector(3 downto 0);
  signal vga_green    : std_logic_vector(3 downto 0);
  signal vga_blue     : std_logic_vector(3 downto 0);
  signal vga_hsync    : std_logic;
  signal vga_vsync    : std_logic;

  -- Clock period definitions
  constant clk100_period : time := 10 ns;
begin

  -- Instantiate the Unit Under Test (UUT)
  uut : ov7670_top
    port map (
      clk100       => clk100,
      OV7670_SIOC  => OV7670_SIOC,
      OV7670_SIOD  => OV7670_SIOD,
      OV7670_RESET => OV7670_RESET,
      OV7670_PWDN  => OV7670_PWDN,
      OV7670_VSYNC => OV7670_VSYNC,
      OV7670_HREF  => OV7670_HREF,
      OV7670_PCLK  => OV7670_PCLK,
      OV7670_XCLK  => OV7670_XCLK,
      OV7670_D     => OV7670_D,
      vga_red      => vga_red,
      vga_green    => vga_green,
      vga_blue     => vga_blue,
      vga_hsync    => vga_hsync,
      vga_vsync    => vga_vsync,
      btn          => '0'
      );

  -- Clock process definitions
  clk50_process : process
  begin
    clk100 <= '0';
    wait for clk100_period/2;
    clk100 <= '1';
    wait for clk100_period/2;
  end process;

  OV7670_PCLK_process : process
  begin
    wait for 5 ns;
    OV7670_PCLK <= '0';
    wait for clk100_period*2;
    OV7670_PCLK <= '1';
    wait for clk100_period*2 - 5 ns;
  end process;

end;
