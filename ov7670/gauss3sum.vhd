library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gauss3sum is
    generic(d_width : integer := 12);
    port (
        d1   : in std_logic_vector(d_width-1 downto 0);
        d2   : in std_logic_vector(d_width-1 downto 0);
        d3   : in std_logic_vector(d_width-1 downto 0);
        
        q    : out std_logic_vector(d_width-1 downto 0)    
    );
end gauss3sum;

architecture func of gauss3sum is
begin
    q <= (std_logic_vector(unsigned(d1)+unsigned(d2)+unsigned(d2)+unsigned(d1)));
end func;