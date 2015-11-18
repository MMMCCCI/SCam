library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gaussfilter is
    generic (m_width  : integer := 3;
             i_width  : integer := 640;
             d_width  : integer := 12);
    port (
        din   : in std_logic_vector(d_width-1 downto 0);
        we    : in std_logic;
        clk   : in std_logic;
        valid : in std_logic;
        
        dout : out std_logic_vector(d_width-1 downto 0)    
    );
end gaussfilter;

architecture func of gaussfilter is

  component shiftreg3 is
  generic(d_width : integer := 12);
  Port (
    din  : in  std_logic_vector(d_width-1 downto 0);
    q1   : out std_logic_vector(d_width-1 downto 0); 
    q2   : out std_logic_vector(d_width-1 downto 0);
    q3   : out std_logic_vector(d_width-1 downto 0); 
    
    clk  : in  std_logic;
    we   : in  std_logic
 
  );
  end component;
  
 component gauss3 is
      generic (m_width  : integer := 3;
               i_width  : integer := 640;
               d_width  : integer := 12);
      port (
                     din   : in std_logic_vector(d_width-1 downto 0);
                     we    : in std_logic;
                     clk   : in std_logic;
                     valid : in std_logic;
                     
                     dout : out std_logic_vector(d_width-1 downto 0)    
                 );
      end component;
      
      component norm8 is
              generic(d_width : integer := 12);
              port (
                  d   : in std_logic_vector(d_width-1 downto 0);
                  q    : out std_logic_vector(d_width-1 downto 0)    
              );
      end component;
      
      signal gauss_q0 : std_logic_vector(d_width-1 downto 0);
      signal gauss_q1 : std_logic_vector(d_width-1 downto 0);
      
begin
    gauss_0 : gauss3
         generic map (m_width => 3, i_width => 640, d_width => d_width) port map (
                     din   => din,
                     we    => we,
                     clk   => clk,
                     valid => valid,
                     dout  => gauss_q0
                  );
    gauss_1 : gauss3
        generic map (m_width => 3, i_width => 640, d_width => d_width) port map (
                     din   => gauss_q0,
                     we    => we,
                     clk   => clk,
                     valid => valid,
                     dout  => gauss_q1
                   );
    normalize :  norm8
        generic map(d_width => d_width)
        port map (
                 d => gauss_q1,
                 q => dout 
        );
       
end func;