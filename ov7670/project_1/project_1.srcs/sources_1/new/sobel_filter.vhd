library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--    | l | m | r
--  --|---|---|---
--  o | 1 | 0 | -1
--  --|---|---|---
--  m | 2 | 0 | -2
--  --|---|---|---
--  u | 1 | 0 | -1

entity sobel_filter is
  Port (
        clk : in std_logic;
  
        l_o : in std_logic_vector(11 downto 0);
        r_o : in std_logic_vector(11 downto 0);
        l_m : in std_logic_vector(11 downto 0);
        r_m : in std_logic_vector(11 downto 0);
        l_u : in std_logic_vector(11 downto 0);
        r_u : in std_logic_vector(11 downto 0);
        
        dout : out std_logic_vector(11 downto 0));
  
end sobel_filter;

architecture func of sobel_filter is

component add2 is
  Port ( 
    clk : in std_logic;
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0));
end component;

component add3 is
  Port ( 
    clk : in std_logic;
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : in std_logic_vector(11 downto 0);
    D : out std_logic_vector(11 downto 0));
end component;

signal d1 : std_logic_vector(11 downto 0);
signal d2 : std_logic_vector(11 downto 0);
signal d3 : std_logic_vector(11 downto 0);
signal d4 : std_logic_vector(11 downto 0);
signal d5 : std_logic_vector(11 downto 0);
signal d6 : std_logic_vector(11 downto 0);

signal q1 : std_logic_vector(11 downto 0);
signal q2 : std_logic_vector(11 downto 0);
signal q3 : std_logic_vector(11 downto 0);

begin
    add01 : add2 port map ( 
        clk => clk,
        A => d1,
        B => d2,
        C => q1);
    
    add02 : add2 port map (
        clk => clk, 
        A => d3,
        B => d4,
        C => q2);
    
    add03 : add2 port map (
        clk => clk, 
        A => d5,
        B => d6,
        C => q3);
     
    add04 : add3 port map (
        clk => clk,
        A => q1,
        B => q2,
        C => q3,
        D => dout);

    process(clk)
    begin
        if(rising_edge(clk)) then
            d1 <= l_o;
            d2 <= std_logic_vector(resize((-1)*signed(r_o),12));
            d3 <= std_logic_vector(resize(2*unsigned(l_m),12));
            d4 <= std_logic_vector(resize((-2)*signed(r_m),12));
            d5 <= l_u;
            d6 <= std_logic_vector(resize((-1)*signed(r_u),12));
        end if;
    end process;

end func;
