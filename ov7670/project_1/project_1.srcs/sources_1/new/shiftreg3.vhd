library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftreg3 is
  Port (
    din  : in  std_logic_vector(11 downto 0);
    q1   : out std_logic_vector(11 downto 0); 
    q2   : out std_logic_vector(11 downto 0);
    q3   : out std_logic_vector(11 downto 0);  
    
    clk  : in  std_logic;
    we   : in  std_logic
  );
end shiftreg3;

architecture func of shiftreg3 is
type ram_type is array (2 downto 0) of std_logic_vector (11 downto 0);
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
   for i in 0 to 2 generate
     
      first: if(i = 0) generate 
      reg0: reg port map(din,q(i),clk,we);
      end generate first;
      
      other: if(i > 0) generate
      regx: reg port map(q(i-1),q(i),clk,we);
      end generate other;
     
   end generate gen_reg;
    q1 <= q(0);
    q2 <= q(1);
    q3 <= q(2);
end func;
