library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity sobel_filter is
  Port ( 
        din1 : in std_logic_vector(11 downto 0);
        din2 : in std_logic_vector(11 downto 0);
        din3 : in std_logic_vector(11 downto 0);
        din4 : in std_logic_vector(11 downto 0);
        din5 : in std_logic_vector(11 downto 0);
        din6 : in std_logic_vector(11 downto 0);
        
        dout : out std_logic_vector(11 downto 0)
  );
end sobel_filter;

architecture Behavioral of sobel_filter is

component Add2 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0)
    );
end component;

component Add3 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : in std_logic_vector(11 downto 0);
    D : out std_logic_vector(11 downto 0)
  );
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
   add01 : Add2 port map ( 
    A => d1,
    B => d2,
    C => q1
    );
    
    add02 : Add2 port map ( 
        A => d3,
        B => d4,
        C => q2
    );
    
    add03 : Add2 port map ( 
        A => d5,
        B => d6,
        C => q3
     );
     
     add04 : Add3 port map ( 
         A => q1,
         B => q2,
         C => q3,
         D => dout
      );

    d1 <= din1;
    d2 <= std_logic_vector(resize((-1)*signed(din2),12));
    d3 <= std_logic_vector(resize(2*unsigned(din3),12));
    d4 <= std_logic_vector(resize((-2)*signed(din4),12));
    d5 <= din5;
    d6 <= std_logic_vector(resize((-1)*signed(din6),12));

end Behavioral;
