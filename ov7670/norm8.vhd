library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity norm8 is
    generic(d_width : integer := 12);
    port (
        d   : in std_logic_vector(d_width-1 downto 0);
        q    : out std_logic_vector(d_width-1 downto 0)    
    );
end norm8;

architecture func of norm8 is
begin
    q <= std_logic_vector(unsigned(d) srl 8);
end func;