library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add2 is
  Port (
    clk : in std_logic;
    
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0));
end add2;

architecture func of add2 is

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            C <= std_logic_vector(unsigned(A)+unsigned(B));
        end if;
    end process;
    
end func;
