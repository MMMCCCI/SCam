library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Add3 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : in std_logic_vector(11 downto 0);
    D : out std_logic_vector(11 downto 0)
  );
end Add3;

architecture Behavioral of Add3 is

begin
    D <= std_logic_vector(unsigned(A)+unsigned(B)+unsigned(C));

end Behavioral;
