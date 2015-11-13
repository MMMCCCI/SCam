library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity top_accu is
   Port ( 
        din1 : in std_logic_vector(11 downto 0);
           din2 : in std_logic_vector(11 downto 0);
           din3 : in std_logic_vector(11 downto 0);
           din4 : in std_logic_vector(11 downto 0);
           din5 : in std_logic_vector(11 downto 0);
           din6 : in std_logic_vector(11 downto 0);
           din7 : in std_logic_vector(11 downto 0);
           din8 : in std_logic_vector(11 downto 0);
           din9 : in std_logic_vector(11 downto 0);
           
           dout : out std_logic_vector(11 downto 0)
   );
end top_accu;

architecture Behavioral of top_accu is
component Accumulator is
  Port ( 
        din1 : in std_logic_vector(11 downto 0);
        din2 : in std_logic_vector(11 downto 0);
        din3 : in std_logic_vector(11 downto 0);
        din4 : in std_logic_vector(11 downto 0);
        din5 : in std_logic_vector(11 downto 0);
        din6 : in std_logic_vector(11 downto 0);
        din7 : in std_logic_vector(11 downto 0);
        din8 : in std_logic_vector(11 downto 0);
        din9 : in std_logic_vector(11 downto 0);
        
        dout1 : out std_logic_vector(11 downto 0);
        dout2 : out std_logic_vector(11 downto 0);
        dout3 : out std_logic_vector(11 downto 0);
        dout4 : out std_logic_vector(11 downto 0)
  );
end component;

component Accumulator2 is
  Port ( 
        din1 : in std_logic_vector(11 downto 0);
        din2 : in std_logic_vector(11 downto 0);
        din3 : in std_logic_vector(11 downto 0);
        din4 : in std_logic_vector(11 downto 0);
        
        dout1 : out std_logic_vector(11 downto 0);
        dout2 : out std_logic_vector(11 downto 0)
  );
end component;

component Add2 is
  Port ( 
    A : in std_logic_vector(11 downto 0);
    B : in std_logic_vector(11 downto 0);
    C : out std_logic_vector(11 downto 0)
    );
end component;

signal st01_out1 : std_logic_vector(11 downto 0);
signal st01_out2 : std_logic_vector(11 downto 0);
signal st01_out3 : std_logic_vector(11 downto 0);
signal st01_out4 : std_logic_vector(11 downto 0);

signal st02_out1 : std_logic_vector(11 downto 0);
signal st02_out2 : std_logic_vector(11 downto 0);

begin

stage01 : Accumulator Port Map( 
        din1 => din1,
        din2 => din2,
        din3 => din3,
        din4 => din4,
        din5 => din5,
        din6 => din6,
        din7 => din7,
        din8 => din8,
        din9 => din9,
        
        dout1 => st01_out1,
        dout2 => st01_out2,
        dout3 => st01_out3,
        dout4 => st01_out4
  );
  
stage02 : Accumulator2 Port Map ( 
          din1 => st01_out1,
          din2 => st01_out2,
          din3 => st01_out3,
          din4 => st01_out4,
          
          dout1 => st02_out1,
          dout2 => st02_out2
    );
    
stage03 : Add2 port map ( 
        A => st02_out1,
        B => st02_out2,
        C => dout
     );



end Behavioral;
