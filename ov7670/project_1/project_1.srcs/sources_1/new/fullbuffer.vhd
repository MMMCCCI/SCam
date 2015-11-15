library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.p.all;

entity fullbuffer is
    generic (matrix_width  : integer := 3;
             image_width  : integer := 640);
    port (
        clk   : in std_logic;
        we    : in std_logic;
        valid : in std_logic;
        
        din   : in std_logic_vector(11 downto 0);
        
        dout : out std_logic_vector(11 downto 0));
        
end fullbuffer;

architecture func of fullbuffer is
  
  type l_type is array (matrix_width-2 downto 0) of std_logic_vector (11 downto 0);
  signal lb_out: l_type;
  
  type two_dim_arr is array (matrix_width-1 downto 0) of port_array (matrix_width-1 downto 0);
  signal arrays: two_dim_arr;
  
  signal gout : std_logic_vector(11 downto 0); 
  signal soutx : std_logic_vector(11 downto 0); 
  signal souty : std_logic_vector(11 downto 0); 

  component shiftregister is
    generic (width : integer := 3);
    Port (
      clk  : in  std_logic;
      we   : in  std_logic;
      
      din  : in  std_logic_vector(11 downto 0); 
      dout : out port_array(width-1 downto 0)
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
          clk : in std_logic;
    
          l_o : in std_logic_vector(11 downto 0); --  1
          r_o : in std_logic_vector(11 downto 0); -- -1
          l_m : in std_logic_vector(11 downto 0); --  2
          r_m : in std_logic_vector(11 downto 0); -- -2
          l_u : in std_logic_vector(11 downto 0); --  1 
          r_u : in std_logic_vector(11 downto 0); -- -1
          
          dout : out std_logic_vector(11 downto 0)
    );
  end component;

begin
    rgb2grey : rgbconverter port map (
        din  => din,
        dout => gout);
 
    shift_reg: 
       for i in 0 to matrix_width-1 generate
          first: if(i = 0) generate 
          sreg0: shiftregister port map (
                  clk  => valid,
                  we   => we,
                  din  => gout,
                  dout => arrays(i));
          end generate first;
          
          other: if(i > 0) generate
          sregx : shiftregister port map ( 
            clk  => valid,
            we   => we,
            din  => lb_out(i-1),
            dout => arrays(i));
          end generate other;
          
       end generate shift_reg;
       
      line_buff: 
        for i in 0 to matrix_width-2 generate
           lbx : linebuffer generic map(width => image_width-matrix_width) port map (
                clk  => valid,
                we   => we,
                din  => arrays(i)(2),
                dout => lb_out(i));
        end generate line_buff;
        
        sobelx: sobel_filter port map(
            clk => clk,
        
            l_o => arrays(0)(0),
            r_o => arrays(0)(2),
            l_m => arrays(1)(0),
            r_m => arrays(1)(2),
            l_u => arrays(2)(0),
            r_u => arrays(2)(2),
            
            dout => soutx);
       
       sobely: sobel_filter port map(
            clk => clk,
            
            l_o => arrays(0)(2),
            r_o => arrays(2)(2),
            l_m => arrays(0)(1),
            r_m => arrays(2)(1),
            l_u => arrays(0)(0),
            r_u => arrays(2)(0),
                   
            dout => souty);
       
       dout <= std_logic_vector(abs(signed(soutx)) + abs(signed(souty)));
       
end func;
