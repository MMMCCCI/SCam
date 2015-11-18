--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:33:50 11/16/2012
-- Design Name:   
-- Module Name:   C:/Users/Hamster/Projects/FPGA/LX45/ov7670_camera/tb_i2c_sender.vhd
-- Project Name:  ov7670_camera
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: i2c_sender
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity tb_i2c_sender is
end tb_i2c_sender;

architecture behavior of tb_i2c_sender is

  -- Component Declaration for the Unit Under Test (UUT)

  component i2c_sender
    port(
      clk   : in    std_logic;
      busy  : out   std_logic;
      siod  : inout std_logic;
      sioc  : out   std_logic;
      send  : in    std_logic;
      id    : in    std_logic_vector(7 downto 0);
      reg   : in    std_logic_vector(7 downto 0);
      value : in    std_logic_vector(7 downto 0)
      );
  end component;


  --Inputs
  signal clk   : std_logic                    := '0';
  signal send  : std_logic                    := '0';
  signal id    : std_logic_vector(7 downto 0) := "10000001";
  signal reg   : std_logic_vector(7 downto 0) := "10000001";
  signal value : std_logic_vector(7 downto 0) := "10000001";

  --BiDirs
  signal siod : std_logic;

  --Outputs
  signal busy : std_logic;
  signal sioc : std_logic;

  -- Clock period definitions
  constant clk_period : time := 20 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : i2c_sender
    port map (
      clk   => clk,
      busy  => busy,
      siod  => siod,
      sioc  => sioc,
      send  => send,
      id    => id,
      reg   => reg,
      value => value
      );

  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  stim_proc : process
  begin
    wait for 100 ns;

    wait for clk_period*10;
    send <= '1';
    wait for clk_period*2;
    send <= '0';

    wait;
  end process;

end;
