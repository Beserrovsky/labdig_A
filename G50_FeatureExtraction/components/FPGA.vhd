library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity FPGA is -- "Terasic DE0-CV" - 5CEBA4F23C7N 
  port (
    CLOCK_50 : in std_logic; -- 50 MHZ

    SW :       in std_logic_vector(9 downto 0);
    GPIO_0 :   in std_logic_vector(35 downto 0);

    GPIO_1 :  out std_logic_vector(35 downto 0);
    LEDR :    out std_logic_vector(9 downto 0);
    HEX0 :    out std_logic_vector(6 downto 0);
    KEY :     out std_logic_vector(3 downto 0);

    VGA_HS :  out std_logic;
    VGA_VS :  out std_logic;
    VGA_R  :  out std_logic_vector(3 downto 0);
    VGA_G  :  out std_logic_vector(3 downto 0);
    VGA_B  :  out std_logic_vector(3 downto 0)
  ) ;
end entity FPGA;

-- TODO:
--
--  1. Code a OV7670 camera interface
--  2. Forward the camera data to the VGA display
--  3. Add a simple image processing algorithm to the design
--

architecture arch_FPGA of FPGA is

  component clock_divider is
    generic(
      DIVIDER     : natural := 1
    );
    port (
      clock_in  : in std_logic;
      reset     : in std_logic;
      clock_out : out std_logic
    );
  end component;

  signal s_reset : std_logic := '0';
  signal s_clk25 : std_logic;

  component OV7670 is
    port (
      clk_i :   in std_logic;
      rst_i :   in std_logic;
      vsync_i : in std_logic;
      href_i :  in std_logic;
      pclk_i :  in std_logic;
      data_i :  in std_logic_vector(7 downto 0);
      
      data_o : out std_logic_vector(7 downto 0)
    );
  end component OV7670;
  
  signal s_camdata : std_logic_vector(7 downto 0);

  component VGA is
    generic( --for 800 x_o 600 @ 72 Hz 50.0 MHz
      g_hpolarity        : boolean := true;
      g_hdisplay         : integer := 800;
      g_hfront_porch     : integer := 56;
      g_hsync_pulse_time : integer := 120;
      g_hback_porch      : integer := 64;
  
      g_vpolarity        : boolean := true;
      g_vdisplay         : integer := 600;
      g_vfront_porch     : integer := 37;
      g_vsync_pulse_time : integer := 6;
      g_vback_porch      : integer := 23
    );
    port (  
      clk_i : in  std_logic;
      red_i   : in std_logic_vector(3 downto 0); --tests 
      green_i : in std_logic_vector(3 downto 0); --tests 
      blue_i  : in std_logic_vector(3 downto 0); --tests 
  
      hsync_o : out std_logic;
      vsync_o : out std_logic;
  
      red_o   : out std_logic_vector(3 downto 0); 
      green_o : out std_logic_vector(3 downto 0);
      blue_o  : out std_logic_vector(3 downto 0);
      
      x_o     : out integer;
      y_o     : out integer
    );
  end component VGA;

  signal s_red   : std_logic_vector(3 downto 0); 
  signal s_green : std_logic_vector(3 downto 0);
  signal s_blue  : std_logic_vector(3 downto 0);
  signal s_x     : integer;
  signal s_y     : integer;

  begin

    CLK_DIV_50_25: clock_divider
      generic map (DIVIDER => 1)
      port map (CLOCK_50, s_reset, s_clk25);

    CAM_OV7670: OV7670
      port map (
        clk_i   => s_clk25,
        rst_i   => s_reset,
        vsync_i => GPIO_0(0),
        href_i  => GPIO_0(1),
        pclk_i  => GPIO_0(2),
        data_i  => GPIO_0(10 downto 3),

        data_o  => s_camdata
      );
    
    VGA_OUT: VGA
      generic map (
        g_hpolarity        => true,
        g_hdisplay         => 800,
        g_hfront_porch     => 56,
        g_hsync_pulse_time => 120,
        g_hback_porch      => 64,

        g_vpolarity        => true,
        g_vdisplay         => 600,
        g_vfront_porch     => 37,
        g_vsync_pulse_time => 6,
        g_vback_porch      => 23
      )
      port map (
        clk_i   => s_clk25,
        red_i   => s_red,
        green_i => s_green,
        blue_i  => s_blue,
        
        hsync_o => VGA_HS,
        vsync_o => VGA_VS,

        red_o   => VGA_R,
        green_o => VGA_G,
        blue_o  => VGA_B,
        
        x_o => s_x,
        y_o => s_y
      );

end architecture arch_FPGA ; -- arch_FPGA
