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
component add_2 is
  generic(d_width : integer := 12);
  Port ( 
    A : in std_logic_vector(d_width-1 downto 0);
    B : in std_logic_vector(d_width-1 downto 0);
    C : out std_logic_vector(d_width-1 downto 0)
    );
end component;

signal q1 : std_logic_vector(d_width-1 downto 0);
signal q2 : std_logic_vector(d_width-1 downto 0);

begin
    add0: add_2
    generic map(d_width => d_width)
    port map(
        A => d1,
        B => d3,
        C => q1);
        
     add1: add_2
     generic map(d_width => d_width)
     port map(
         A => d2,
         B => d2,
         C => q2);
    
     add2: add_2
     generic map(d_width => d_width)
     port map(
         A => q1,
         B => q2,
         C => q);
end func;