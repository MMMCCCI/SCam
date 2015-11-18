library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rgbconv4bit is
  Port (
     din  : in std_logic_vector(11 downto 0);
     dout : out std_logic_vector(3 downto 0) := (others => '0')
  );
end rgbconv4bit;

architecture Behavioral of rgbconv4bit is
begin

 dout <= din(7 downto 4);


end Behavioral;