library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity add_2 is
  generic(d_width : integer := 12);
  Port ( 
    A : in std_logic_vector(d_width-1 downto 0);
    B : in std_logic_vector(d_width-1 downto 0);
    C : out std_logic_vector(d_width-1 downto 0)
    );
end add_2;

architecture Behavioral of add_2 is
begin
    C <= std_logic_vector(unsigned(A)+unsigned(B));
    
end Behavioral;
