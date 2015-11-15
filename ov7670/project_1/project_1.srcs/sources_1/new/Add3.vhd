library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity add3 is
  Port ( 
    clk : in std_logic;
  
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : in std_logic_vector(11 downto 0);
    D : out std_logic_vector(11 downto 0)
  );
end add3;

architecture func of add3 is

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            D <= std_logic_vector(unsigned(A)+unsigned(B)+unsigned(C));
        end if;
    end process;

end func;
