library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Accumulator2 is
  Port ( 
        din1 : in std_logic_vector(11 downto 0);
        din2 : in std_logic_vector(11 downto 0);
        din3 : in std_logic_vector(11 downto 0);
        din4 : in std_logic_vector(11 downto 0);
        
        dout1 : out std_logic_vector(11 downto 0);
        dout2 : out std_logic_vector(11 downto 0)
  );
end Accumulator2;

architecture Behavioral of Accumulator2 is

component Add2 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0)
    );
end component;

begin
   add01 : Add2 port map ( 
    A => din1,
    B => din2,
    C => dout1
    );
    
    add02 : Add2 port map ( 
        A => din3,
        B => din4,
        C => dout2
    );

end Behavioral;