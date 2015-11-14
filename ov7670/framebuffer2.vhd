library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frame_buffer2 is
  port (
    clka  : in std_logic;
    wea   : in std_logic;
    addra : in std_logic_vector(18 downto 0);
    dina  : in std_logic_vector(11 downto 0);

    clkb  : in  std_logic;
    addrb : in  std_logic_vector(18 downto 0);
    doutb : out std_logic_vector(11 downto 0)
    );
end;


architecture syn of frame_buffer2 is
  type ram_type is array (45055 downto 0) of std_logic_vector (11 downto 0);
  signal RAM : ram_type;
begin

  process (clka)
  begin
    if (clka'event and clka = '1') then
      if (wea = '1') then
        RAM(to_integer(unsigned(addra))) <= dina;
      end if;
    end if;
  end process;

  process (clkb)
  begin
    if (clkb'event and clkb = '1') then
      doutb <= RAM(to_integer(unsigned(addrb)));
    end if;
  end process;


end syn;
