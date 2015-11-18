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
  
  component linebuffer is
    generic (width   : integer := 640;
             d_width : integer := 12);
    port (
          clk    : in std_logic;
          we     : in std_logic;
  
          din    : in std_logic_vector(d_width-1 downto 0);
          dout   : out std_logic_vector(d_width-1 downto 0)
    );
  end component;
  
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

begin
 
    shift_reg: 
       for i in 0 to m_width-1 generate
          first: if( i=0) generate 
          sreg0: shiftreg3 generic map(d_width => d_width) port map (
                  din  => din,
                  q1   => m_q(0),
                  q2   => m_q(1),
                  q3   => m_q(2),
                  clk  => valid,
                  we   => we
          );
          end generate first;
          
          other: if(i > 0) generate
          sregx : shiftreg3 generic map(d_width => d_width) port map ( 
            din  => l_q(i-1),
            q1   => m_q((i*3)),
            q2   => m_q((i*3)+1),
            q3   => m_q((i*3)+2),
            clk  => valid,
            we   => we
          );
          end generate other;
          
       end generate shift_reg;
       
       
      line_buff: 
        for i in 0 to m_width-2 generate
           lbx : linebuffer generic map(width => i_width-m_width, d_width => d_width) port map (
                clk  => valid,
                we   => we,
                din  => m_q((i*3)+2),
                dout => l_q(i));
        end generate line_buff;
        
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