library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Add2 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0)
    );
end Add2;

architecture Behavioral of Add2 is

begin
    C <= std_logic_vector(unsigned(A)+unsigned(B));
    
end Behavioral;
