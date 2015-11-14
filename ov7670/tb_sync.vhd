library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sync is
end tb_sync;

architecture behavioral of tb_sync is
signal tb_pclk     : std_logic := '0';
signal tb_clk       : std_logic := '0';
signal tb_valid     : std_logic;

 component sync 
    port(
        pclk    : in std_logic;
        clk     : in std_logic;   
        valid   : out std_logic
    );
 end component;
 
constant clk_period : time := 20 ns;

begin
    
    s0 : sync 
        port map(
            pclk    => tb_pclk,
            clk     => tb_clk,    
            valid    => tb_valid
        );

  pclk_process : process
  begin
    tb_pclk <= '0';
    wait for clk_period;
    tb_pclk <= '1';
    wait for clk_period;
  end process;

  clk_process : process
  begin
     tb_clk <= '0';
     wait for clk_period/2;
     tb_clk <= '1';
     wait for clk_period/2;
  end process;

end behavioral;