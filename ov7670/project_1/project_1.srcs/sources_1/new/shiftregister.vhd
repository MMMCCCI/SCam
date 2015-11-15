library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.p.all;

entity shiftregister is
  generic (width : integer := 3);
  Port (
    din  : in  std_logic_vector(11 downto 0);
    dout : out port_array(width-1 downto 0);
    clk  : in  std_logic;
    we   : in  std_logic
  );
end shiftregister;

architecture func of shiftregister is
type c_array is array (width-1 downto 0) of std_logic_vector (11 downto 0);
signal connect_array: c_array;

component reg
    port(
         clk   : in  std_logic;
         we    : in  std_logic;
         
         d     : in  std_logic_vector(11 downto 0);
         
         q     : out std_logic_vector(11 downto 0) 
         );
end component;

begin
   gen_reg: 
   for i in 0 to width-1 generate
     
      first: if(i = 0) generate 
      reg0: reg port map(
        d   => din,
        q   => connect_array(i),
        clk => clk,
        we  => we);
      end generate first;
      
      other: if(i > 0) generate
      regx: reg port map(
        d   => connect_array(i-1),
        q   => connect_array(i),
        clk => clk,
        we  => we);
      end generate other;
      
      dout(i) <= connect_array(i);    
   end generate gen_reg;
end func;
