library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sobel is
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
end sobel;

architecture func of sobel is

  type l_type is array (m_width-2 downto 0) of std_logic_vector (d_width-1 downto 0);
  type q_type is array (8 downto 0) of std_logic_vector (d_width-1 downto 0);
  type sx_type is array (2 downto 0) of std_logic_vector (d_width-1 downto 0);
  type sy_type is array (1 downto 0) of std_logic_vector (d_width-1 downto 0);
  
  signal l_q: l_type;  
  signal m_q: q_type;
  signal s_qx: sx_type;
  signal s_qy: sy_type;
  
  signal qx : std_logic_vector(d_width-1 downto 0);
  signal qy : std_logic_vector(d_width-1 downto 0);

  component sobel_x is
        generic (d_width : integer := 12);
        port (
            d1   : in std_logic_vector(d_width-1 downto 0);
            d2   : in std_logic_vector(d_width-1 downto 0);
            
            q    : out std_logic_vector(d_width-1 downto 0)    
        );
   end component;
    
  component sobel_y is
      generic (d_width : integer := 12);
      port (
          d1   : in std_logic_vector(d_width-1 downto 0);
          d2   : in std_logic_vector(d_width-1 downto 0);
          d3   : in std_logic_vector(d_width-1 downto 0);
          
          q    : out std_logic_vector(d_width-1 downto 0)    
      );
  end component;
  
  component full_buffer is
      generic (m_width  : integer := 3;
               i_width  : integer := 640;
               d_width  : integer := 12);
      port (
          din   : in std_logic_vector(d_width-1 downto 0);
          we    : in std_logic;
          clk   : in std_logic;
          valid : in std_logic;
          
          q0,q1,q2,q3,q4,q5,q6,q7,q8 : out std_logic_vector(d_width-1 downto 0)    
      );
  end component;

begin

    fullbuffer : full_buffer
    generic map (m_width  => m_width,
                 i_width  => i_width,
                 d_width  => d_width)
    port map(
        din => din,
        we  => we,
        clk => clk,
        valid => valid,
        q0  => m_q(0),
        q1  => m_q(1),
        q2  => m_q(2),
        q3  => m_q(3),
        q4  => m_q(4),
        q5  => m_q(5),
        q6  => m_q(6),
        q7  => m_q(7),
        q8  => m_q(8)
    );

        
        sobelx_p1: 
             for i in 0 to m_width-1 generate
                   sx : sobel_x generic map(d_width => d_width) port map (
                                d1 => m_q(i*3),
                                d2 => m_q((i*3)+2),
                                q  => s_qx(i));
              end generate sobelx_p1;
                    
        sobelx_p2:  sobel_y generic map(d_width => d_width) port map (
                    d1 => s_qx(0),
                    d2 => s_qx(1),
                    d3 => s_qx(2),
                    q  => qx);
        
        sobely_p1_1 : sobel_y generic map(d_width => d_width) port map (
                                    d1 => m_q(0),
                                    d2 => m_q(1),
                                    d3 => m_q(2),
                                    q  => s_qy(0));
        sobely_p1_2 : sobel_y generic map(d_width => d_width) port map (
                         d1 => m_q(6),
                         d2 => m_q(7),
                         d3 => m_q(8),
                         q  => s_qy(1));

        
        sobely_p2 : sobel_x generic map(d_width => d_width) port map (
                        d1 => s_qy(0),
                        d2 => s_qy(1),
                        q  => qy);
           
       
       dout <= std_logic_vector(abs(signed(qx)) + abs(signed(qy)));
       
end func;