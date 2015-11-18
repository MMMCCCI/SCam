library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity linebuffer is
  generic (width : integer := 640;
           d_width : integer := 12);
  port (
        clk     : in std_logic;
        we      : in std_logic;

        din    : in std_logic_vector(d_width-1 downto 0);
        dout   : out std_logic_vector(d_width-1 downto 0)
  );
end;

architecture behavioral of linebuffer is
  signal addrIn : std_logic_vector(18 downto 0) := (others => '0');
  signal addrOut: std_logic_vector(18 downto 0) := (0 => '1', others  => '0');
  
  component frame_buffer is
        generic (width : integer := 262144;
                 d_width : integer := 12);
        port(
            clka    : in std_logic;
            wea     : in std_logic;
            addra   : in std_logic_vector(18 downto 0);
            dina    : in std_logic_vector(d_width-1 downto 0);
              
            clkb    : in  std_logic;
            addrb   : in  std_logic_vector(18 downto 0);
            doutb   : out std_logic_vector(d_width-1 downto 0)
          );            
   end component;
  
begin

fb: frame_buffer generic map (width => width,d_width => d_width) port map(
        clka    => clk,
        wea     => we,
        addra   => addrIn,
        dina    => din,
        clkb    => clk,
        addrb   => addrOut,
        doutb   => dout);
        
process(clk)
begin
    if(rising_edge(clk)) then
        if(we = '1') then
            if(unsigned(addrIn) < width-1) then
                addrIn <= std_logic_vector(unsigned(addrIn)+1);
            else
                addrIn <= (others => '0');
            end if;
        
            if(unsigned(addrOut) < width-1) then
                addrOut <= std_logic_vector(unsigned(addrOut)+1);
            else
                addrOut <= (others => '0');
            end if;
        end if;
     end if;
     
            
end process;

end behavioral;
