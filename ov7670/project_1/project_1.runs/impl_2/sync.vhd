library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync is
  port (
    pclk  : in std_logic;
    clk   : in std_logic;
    valid : out std_logic
    );
end;

architecture func of sync is
signal tclk : std_logic;

begin

    process (clk)
    begin
        if (clk'event and clk = '1') then
            tclk    <= pclk; 
            valid   <= (not pclk) and tclk; 
        end if;
    end process;

end func;