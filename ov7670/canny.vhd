library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity canny is
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
end canny;

architecture func of canny is

component gaussfilter is
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

component sobel is
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

component rgbconv4bit is
  Port (
     din  : in std_logic_vector(11 downto 0);
     dout : out std_logic_vector(3 downto 0) := (others => '0')
  );
end component;

signal gval     : std_logic_vector(3 downto 0);
signal gauss_q  : std_logic_vector(3 downto 0);
signal sobel_q  : std_logic_vector(3 downto 0);
      
begin
    rgb2gray : rgbconv4bit 
    port map(
        din => din,
        dout => gval);

   gauss_filter : gaussfilter
         generic map (m_width => 3, i_width => 640, d_width => 4) port map (
                     din   => gval,
                     we    => we,
                     clk   => clk,
                     valid => valid,
                     dout  => gauss_q
          );
    
   
   sobel_filter : sobel
         generic map (m_width => 3, i_width => 640, d_width => 4) port map (
                    din   => gauss_q,
                    we    => we,
                    clk   => clk,
                    valid => valid,
                    dout  => sobel_q
         );
              
    process(clk) 
    begin
        if(unsigned(sobel_q) > 200) then 
            dout <= "000000001111";
        else 
            dout <= din;
        end if;
    end process;
end func;