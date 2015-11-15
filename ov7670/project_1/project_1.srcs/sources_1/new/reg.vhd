library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
    port(
         clk   : in  std_logic;
         we    : in  std_logic;
         
         d     : in  std_logic_vector(11 downto 0);
         
         q     : out std_logic_vector(11 downto 0)
         );
end reg;

architecture func of reg is

begin
    process(clk) 
    begin
        if(rising_edge(clk)) then
            if(we = '1') then
                q <= d;
            end if;        
        end if;
    end process;

end func;
