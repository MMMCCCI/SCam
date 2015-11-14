library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package p is
   type port_array is array(natural range <>) of std_logic_vector(11 downto 0);
end;
package body p is
end package body;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.p.all;


entity shiftregister is

  generic (width : integer := 3);
  Port (
    din  : in  std_logic_vector(11 downto 0);
 --   dout : out std_logic_vector(11 downto 0); 
    dout : out port_array(width-1 downto 0);
    clk  : in  std_logic;
    we   : in  std_logic
  );
end shiftregister;

architecture func of shiftregister is
type ram_type is array (width-1 downto 0) of std_logic_vector (11 downto 0);
signal q: ram_type;

component reg
    port(
         d     : in  std_logic_vector(11 downto 0);
         q     : out std_logic_vector(11 downto 0);
         clk   : in  std_logic;
         we    : in  std_logic 
         );
end component;

begin
   gen_reg: 
   for i in 0 to width-1 generate
     
      first: if(i = 0) generate 
      reg0: reg port map(din,q(i),clk,we);
      end generate first;
      
      other: if(i > 0) generate
      regx: reg port map(q(i-1),q(i),clk,we);
      end generate other;
      
      dout(i) <= q(i);    
   end generate gen_reg;
 --  dout <= q(width-1);
end func;
