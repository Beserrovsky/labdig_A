library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity FPGA is -- "Terasic DE0-CV" - 5CEBA4F23C7N 
  port (
    CLOCK_50 : in bit; -- 50 MHZ

    SW :     in bit_vector(9 downto 0);
    GPIO_0 : in bit_vector(35 downto 0);

    GPIO_1 : out bit_vector(35 downto 0);
    LEDR :   out bit_vector(9 downto 0);
    HEX0 :   out bit_vector(6 downto 0);
    KEY :    out bit_vector(3 downto 0);

    VGA_HS : out std_logic;
    VGA_VS : out std_logic;
    VGA_R  : out std_logic_vector(3 downto 0);
    VGA_G  : out std_logic_vector(3 downto 0);
    VGA_B  : out std_logic_vector(3 downto 0)
  ) ;
end FPGA;

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
  end component;

  signal s_camdata : std_logic_vector(7 downto 0);

  component VGA is
    generic( --for 800 x 600 @ 72 Hz 50.0 MHz
      h_polarity        : boolean := true;
      h_display         : integer := 800;
      h_front_porch     : integer := 56;
      h_sync_pulse_time : integer := 120;
      h_back_porch      : integer := 64;

      v_polarity        : boolean := true;
      v_display         : integer := 600;
      v_front_porch     : integer := 37;
      v_sync_pulse_time : integer := 6;
      v_back_porch      : integer := 23
    );
    port (  
      clock : in  std_logic;

      in_s_red   : in std_logic_vector(3 downto 0); --tests 
      in_s_green : in std_logic_vector(3 downto 0); --tests 
      in_s_blue  : in std_logic_vector(3 downto 0); --tests 
      hsync : out std_logic;
      vsync : out std_logic;
      red   : out std_logic_vector(3 downto 0); 
      green : out std_logic_vector(3 downto 0);
      s_blue  : out std_logic_vector(3 downto 0);
          x: out integer;
          y: out integer
    );
  end component;

  signal s_red   : std_logic_vector(3 downto 0); 
  signal s_green : std_logic_vector(3 downto 0);
  signal s_blue  : std_logic_vector(3 downto 0);
  signal s_x     : integer;
  signal s_y     : integer;

  begin

    D_DIVIDER: clock_divider
      generic map (DIVIDER:=1)
      port map (CLOCK_50, s_reset, s_clk25);

    D_OV7670: OV7670
      port map (
        s_clk25,
        s_reset,
        GPIO_0(0),
        GPIO_0(1),
        GPIO_0(2),
        GPIO_0(3 downto 0),
        s_camdata
      );
    
    D_VGA: VGA
      generic map (
        h_polarity        => true,
        h_display         => 800,
        h_front_porch     => 56,
        h_sync_pulse_time => 120,
        h_back_porch      => 64,

        v_polarity        => true,
        v_display         => 600,
        v_front_porch     => 37,
        v_sync_pulse_time => 6,
        v_back_porch      => 23
      )
      port map (
        s_clk25,
        s_red,
        s_green,
        s_blue,
        VGA_HS,
        VGA_VS,
        VGA_R,
        VGA_G,
        VGA_B,
        s_x,
        s_y
      );

end arch_FPGA ; -- arch_FPGA
