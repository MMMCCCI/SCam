library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fullbuffer is
    generic (m_width  : integer := 3;
             i_width  : integer := 640;
             d_width  : integer := 12);
    port (
        din   : in std_logic_vector(11 downto 0);
        we    : in std_logic;
        clk   : in std_logic;
        valid : in std_logic;
        
        dout : out std_logic_vector(11 downto 0)    
    );
end fullbuffer;

architecture func of fullbuffer is

  type m_type is array (m_width-1 downto 0) of std_logic_vector (11 downto 0);
  signal m_q: m_type;
  type l_type is array (m_width-2 downto 0) of std_logic_vector (11 downto 0);
  signal l_q: l_type;  
  type q_type is array (8 downto 0) of std_logic_vector (11 downto 0);
  signal m_q9: q_type;

  component shiftreg3 is
  Port (
    din  : in  std_logic_vector(11 downto 0);
    q1   : out std_logic_vector(11 downto 0); 
    q2   : out std_logic_vector(11 downto 0);
    q3   : out std_logic_vector(11 downto 0); 
    
    clk  : in  std_logic;
    we   : in  std_logic
 
  );
  end component;
  
  component linebuffer is
    generic (width : integer := 640);
    port (
          clk    : in std_logic;
          we     : in std_logic;
  
          din    : in std_logic_vector(11 downto 0);
          dout   : out std_logic_vector(11 downto 0)
    );
  end component;
  
  component rgbconverter is
    Port (
       din  : in std_logic_vector(11 downto 0);
       dout : out std_logic_vector(11 downto 0)
    );
  end component;
  
  component sobel_filter is
    Port ( 
          din1 : in std_logic_vector(11 downto 0); --  1
          din2 : in std_logic_vector(11 downto 0); -- -1
          din3 : in std_logic_vector(11 downto 0); --  2
          din4 : in std_logic_vector(11 downto 0); -- -2
          din5 : in std_logic_vector(11 downto 0); --  1 
          din6 : in std_logic_vector(11 downto 0); -- -1
          
          dout : out std_logic_vector(11 downto 0)
    );
  end component;
  
  signal gout : std_logic_vector(11 downto 0); 
  signal soutx : std_logic_vector(11 downto 0); 
  signal souty : std_logic_vector(11 downto 0); 

begin
    rgb2grey : rgbconverter port map (
        din  => din,
        dout => gout
    );
 
    shift_reg: 
       for i in 0 to m_width-1 generate
          first: if( i=0) generate 
          sreg0: shiftreg3 port map (
                  din  => gout,
                  q1   => m_q9(0),
                  q2   => m_q9(1),
                  q3   => m_q9(2),
                  clk  => valid,
                  we   => we
          );
          end generate first;
          
          other: if(i > 0) generate
          sregx : shiftreg3 port map ( 
            din  => l_q(i-1),
            q1   => m_q9((i*3)),
            q2   => m_q9((i*3)+1),
            q3   => m_q9((i*3)+2),
            clk  => valid,
            we   => we
          );
          end generate other;
          
       end generate shift_reg;
       
       
      line_buff: 
        for i in 0 to m_width-2 generate
           lbx : linebuffer generic map(width => i_width-m_width) port map (
                clk  => valid,
                we   => we,
                din  => m_q9(i*3),
                dout => l_q(i));
        end generate line_buff;
        
       sobelx: sobel_filter port map(
            din1 => m_q9(0),
            din2 => m_q9(2),
            din3 => m_q9(3),
            din4 => m_q9(5),
            din5 => m_q9(6),
            din6 => m_q9(8),
            
            dout => soutx
       );
       sobely: sobel_filter port map(
                   din1 => m_q9(0),
                   din2 => m_q9(6),
                   din3 => m_q9(1),
                   din4 => m_q9(7),
                   din5 => m_q9(2),
                   din6 => m_q9(8),
                   
                   dout => souty
              );
       
       dout <= std_logic_vector(abs(signed(soutx)) + abs(signed(souty)));
       
end func;
