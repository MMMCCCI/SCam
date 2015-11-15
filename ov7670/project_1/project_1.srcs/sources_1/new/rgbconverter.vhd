library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rgbconverter is
  Port (
     din  : in std_logic_vector(11 downto 0);
     
     dout : out std_logic_vector(11 downto 0) := (others => '0')
  );
end rgbconverter;

architecture func of rgbconverter is
  signal r    : std_logic_vector(3 downto 0);
  signal g    : std_logic_vector(3 downto 0);
  signal b    : std_logic_vector(3 downto 0);

begin
 r <= din(11 downto 8);
 g <= din(7  downto 4);
 b <= din(3  downto 0);
 
 dout(11 downto 8) <= std_logic_vector((unsigned(r)+unsigned(g)+unsigned(b))/3);
 dout(7 downto 4) <= std_logic_vector((unsigned(r)+unsigned(g)+unsigned(b))/3);
 dout(3 downto 0) <= std_logic_vector((unsigned(r)+unsigned(g)+unsigned(b))/3);

end func;
