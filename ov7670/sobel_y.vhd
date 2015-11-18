library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel_y is
    generic( d_width : integer := 12);
    port (
        d1   : in std_logic_vector(d_width-1 downto 0);
        d2   : in std_logic_vector(d_width-1 downto 0);
        d3   : in std_logic_vector(d_width-1 downto 0);
        
        q    : out std_logic_vector(d_width-1 downto 0)    
    );
end sobel_y;

architecture func of sobel_y is

component Add2 is
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
    add_0: Add2
    generic map(d_width => d_width)
    port map(
        A => d1,
        B => d3,
        C => q1);
        
     add_1: Add2
     generic map(d_width => d_width)
     port map(
         A => d2,
         B => d2,
         C => q2);
    
     add_2: Add2
     generic map(d_width => d_width)
     port map(
         A => q1,
         B => q2,
         C => q);
end func;