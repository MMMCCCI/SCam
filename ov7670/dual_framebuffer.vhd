library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_framebuffer is
	port(
		clka  : in std_logic;
        wea   : in std_logic;
        
        addra : in std_logic_vector(18 downto 0);
        dina  : in std_logic_vector(11 downto 0);
    
        clkb  : in  std_logic;
        addrb : in  std_logic_vector(18 downto 0);
        
        doutb : out std_logic_vector(11 downto 0)
        );
end;

architecture func of dual_framebuffer is
	component frame_buffer is
	    generic (width : integer := 262144);
		port(
			clka  : in std_logic;
            wea   : in std_logic;
            addra : in std_logic_vector(18 downto 0);
            dina  : in std_logic_vector(11 downto 0);
        
            clkb  : in  std_logic;
            addrb : in  std_logic_vector(18 downto 0);
            doutb : out std_logic_vector(11 downto 0)
            );          

	end component;
	
	signal we0, we1 : std_logic;
	signal dout0,dout1: std_logic_vector(11 downto 0);

begin 
    fb0: frame_buffer generic map(width => 262144) port map(
                                clka  => clka,
                                wea   => we0,
                                addra => addra,
                                dina  => dina,
                                clkb  => clkb,
                                addrb => addrb,
                                doutb => dout0);
                                
    fb1: frame_buffer generic map(width => 45055) port map(
                                clka  => clka,
                                wea   => we1,
                                addra => addra,
                                dina  => dina,
                                clkb  => clkb,
                                addrb => addrb,
                                doutb => dout1);
                                
	
	we0   <= '1'   when unsigned(addra) < 262144 else '0'; 
	we1   <= '1'   when unsigned(addra) >=  262144 else '0';
	doutb <= dout0 when unsigned(addrb) < 262144 else dout1;

end func;

