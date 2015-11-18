library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_linebuffer is
end tb_linebuffer;

architecture behavioral of tb_linebuffer is
signal sclk     : std_logic := '0';
signal we       : std_logic := '0';
signal din     : std_logic_vector(11 downto 0);
signal dout    : std_logic_vector(11 downto 0);

 component linebuffer 
    port(
        clk     : in std_logic;
        we      : in std_logic;   
        din     : in std_logic_vector(11 downto 0);
        dout    : out std_logic_vector(11 downto 0)
    );
 end component;
 
constant clk_period : time := 20 ns;

begin
    
    lb : linebuffer 
        port map(
            clk     => sclk,
            we     => we,    
            din    => din,
            dout   => dout
        );

  clk_process : process
  begin
    sclk <= '0';
    wait for clk_period/2;
    sclk <= '1';
    wait for clk_period/2;
  end process;

  stim_proc : process
  begin
    wait for clk_period*5;
    din <= "000000100000";
    we <= '1';
    wait for clk_period*2;
    we <= '0';
   -- din0 <= (others => '0');
  end process;

end behavioral;