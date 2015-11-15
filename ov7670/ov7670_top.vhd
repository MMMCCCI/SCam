----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

entity ov7670_top is
  port (
    clk100       : in    std_logic;
    OV7670_SIOC  : out   std_logic;
    OV7670_SIOD  : inout std_logic;
    OV7670_RESET : out   std_logic;
    OV7670_PWDN  : out   std_logic;
    OV7670_VSYNC : in    std_logic;
    OV7670_HREF  : in    std_logic;
    OV7670_PCLK  : in    std_logic;
    OV7670_XCLK  : out   std_logic;
    OV7670_D     : in    std_logic_vector(7 downto 0);

    LED : out std_logic_vector(7 downto 0);

    vga_red   : out std_logic_vector(3 downto 0);
    vga_green : out std_logic_vector(3 downto 0);
    vga_blue  : out std_logic_vector(3 downto 0);
    vga_hsync : out std_logic;
    vga_vsync : out std_logic;

    btn : in std_logic
    );
end ov7670_top;

architecture Behavioral of ov7670_top is

  component debounce
    port(
      clk : in  std_logic;
      i   : in  std_logic;
      o   : out std_logic
      );
  end component;

  component clocking
    port
      (                                 -- Clock in ports
        CLK_100 : in  std_logic;
        -- Clock out ports
        CLK_50  : out std_logic;
        CLK_25  : out std_logic
        );
  end component;

  component ov7670_controller
    port(
      clk             : in    std_logic;
      resend          : in    std_logic;
      config_finished : out   std_logic;
      siod            : inout std_logic;
      sioc            : out   std_logic;
      reset           : out   std_logic;
      pwdn            : out   std_logic;
      xclk            : out   std_logic
      );
  end component;

  component dual_framebuffer
    port (
      clka  : in  std_logic;
      wea   : in  std_logic;
      addra : in  std_logic_vector(18 downto 0);
      dina  : in  std_logic_vector(11 downto 0);
      clkb  : in  std_logic;
      addrb : in  std_logic_vector(18 downto 0);
      doutb : out std_logic_vector(11 downto 0)
      );
  end component;

  component ov7670_capture
    port(
      pclk  : in  std_logic;
      vsync : in  std_logic;
      href  : in  std_logic;
      d     : in  std_logic_vector(7 downto 0);
      addr  : out std_logic_vector(18 downto 0);
      dout  : out std_logic_vector(11 downto 0);
      we    : out std_logic
      );
  end component;

  component vga
    port(
      clk25     : in  std_logic;
      vga_red   : out std_logic_vector(3 downto 0);
      vga_green : out std_logic_vector(3 downto 0);
      vga_blue  : out std_logic_vector(3 downto 0);
      vga_hsync : out std_logic;
      vga_vsync : out std_logic;

      frame_addr  : out std_logic_vector(18 downto 0);
      frame_pixel : in  std_logic_vector(11 downto 0)
      );
  end component;
  
  ---------------------------------------------------------------------------------------------------------------------------------//
   component sync is
        port (
               pclk   : in std_logic;
               clk    : in std_logic;
               valid  : out std_logic
        );
   end component;
   
   component fullbuffer is
           generic (matrix_width  : integer := 3;
                    image_width  : integer := 640);
           port (
               din   : in std_logic_vector(11 downto 0);
               we    : in std_logic;
               clk   : in std_logic;
               valid : in std_logic;
               
               dout : out std_logic_vector(11 downto 0)    
           );
    end component;
  ---------------------------------------------------------------------------------------------------------------------------------//  

  signal frame_addr  : std_logic_vector(18 downto 0);
  signal frame_pixel : std_logic_vector(11 downto 0);

  signal capture_addr    : std_logic_vector(18 downto 0);
  signal capture_data    : std_logic_vector(11 downto 0);
  signal capture_we      : std_logic;
  signal resend          : std_logic;
  signal config_finished : std_logic;

  signal clk_feedback  : std_logic;
  signal clk50u        : std_logic;
  signal clk50         : std_logic;
  signal clk25u        : std_logic;
  signal clk25         : std_logic;
  signal buffered_pclk : std_logic;
    ---------------------------------------------------------------------------------------------------------------------------------//
  signal valid   : std_logic;
  signal flb_out : std_logic_vector(11 downto 0);
  --------------------------------------------------------

begin

  btn_debounce : debounce
    port map(
      clk => clk50,
      i   => btn,
      o   => resend
      );

  Inst_vga : vga
    port map(
      clk25       => clk25,
      vga_red     => vga_red,
      vga_green   => vga_green,
      vga_blue    => vga_blue,
      vga_hsync   => vga_hsync,
      vga_vsync   => vga_vsync,
      frame_addr  => frame_addr,
      frame_pixel => frame_pixel
      );

  framebuffer : dual_framebuffer
    port map (
      clka  => OV7670_PCLK,
      wea   => capture_we,
      addra => capture_addr,
      dina  => flb_out,

      clkb  => clk50,
      addrb => frame_addr,
      doutb => frame_pixel
      );

  led <= "0000000" & config_finished;

  capture : ov7670_capture
    port map(
      pclk  => OV7670_PCLK,
      vsync => OV7670_VSYNC,
      href  => OV7670_HREF,
      d     => OV7670_D,
      addr  => capture_addr,
      dout  => capture_data,
      we    => capture_we
      );

  controller : ov7670_controller
    port map(
      --  clk   => clk50,
      clk             => clk25,
      sioc            => ov7670_sioc,
      resend          => resend,
      config_finished => config_finished,
      siod            => ov7670_siod,
      pwdn            => OV7670_PWDN,
      reset           => OV7670_RESET,
      xclk            => OV7670_XCLK
      );

  your_instance_name : clocking
    port map
    (                                   -- Clock in ports
      CLK_100 => CLK100,
      -- Clock out ports
      CLK_50  => CLK50,
      CLK_25  => CLK25
      );

    synchronize: sync 
        port map( 
            pclk   => OV7670_PCLK,
            clk    => CLK50,
            valid => valid
        );
    
    fl_buffer : fullbuffer 
        generic map (matrix_width => 3, image_width => 640)
        port map (
            din   => capture_data,
            we    => capture_we,
            clk   => clk50,
            valid => valid,
            dout  => flb_out
         );
    
end Behavioral;
