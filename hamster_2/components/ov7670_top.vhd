----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Top level for the OV7670 camera project.
----------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity ov7670_top is
    Port ( 
      CLOCK_50     : in    STD_LOGIC;
      OV7670_SIOC  : out   STD_LOGIC;
      OV7670_SIOD  : inout STD_LOGIC;
      OV7670_RESET : out   STD_LOGIC;
      OV7670_PWDN  : out   STD_LOGIC;
      OV7670_VSYNC : in    STD_LOGIC;
      OV7670_HREF  : in    STD_LOGIC;
      OV7670_PCLK  : in    STD_LOGIC;
      OV7670_XCLK  : out   STD_LOGIC;
      OV7670_D     : in    STD_LOGIC_VECTOR(7 downto 0);

      LEDR          : out    STD_LOGIC_VECTOR(9 downto 0);

      VGA_R      : out   STD_LOGIC_VECTOR(3 downto 0);
      VGA_G    : out   STD_LOGIC_VECTOR(3 downto 0);
      VGA_B     : out   STD_LOGIC_VECTOR(3 downto 0);
      VGA_HS    : out   STD_LOGIC;
      VGA_VS    : out   STD_LOGIC;
      
      KEY  : in STD_LOGIC_VECTOR(3 downto 0)
    );
end ov7670_top;

architecture Behavioral of ov7670_top is

   COMPONENT debounce
   PORT(
      clk : IN std_logic;
      i : IN std_logic;          
      o : OUT std_logic
      );
   END COMPONENT;

   COMPONENT ov7670_controller
   PORT(
      clk   : IN    std_logic;    
      resend: IN    std_logic;    
      config_finished : out std_logic;
      siod  : INOUT std_logic;      
      sioc  : OUT   std_logic;
      reset : OUT   std_logic;
      pwdn  : OUT   std_logic;
      xclk  : OUT   std_logic
      );
   END COMPONENT;

   COMPONENT frame_buffer IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0); -- DINA
		rdaddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0); -- ADDRB
		rdclock		: IN STD_LOGIC ; -- CLKB
		wraddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);-- ADDRA
		wrclock		: IN STD_LOGIC  := '1';-- CLKA
		wren		: IN STD_LOGIC  := '0';-- WEA
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)-- DOUTB
	);
   END COMPONENT;

	COMPONENT cv_buffer IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (11 DOWNTO 0); -- DINA
		rdaddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0); -- ADDRB
		rdclock		: IN STD_LOGIC ; -- CLKB
		wraddress		: IN STD_LOGIC_VECTOR (14 DOWNTO 0);-- ADDRA
		wrclock		: IN STD_LOGIC  := '1';-- CLKA
		wren		: IN STD_LOGIC  := '0';-- WEA
		q		: OUT STD_LOGIC_VECTOR (11 DOWNTO 0)-- DOUTB
	);
   END COMPONENT;
	
   COMPONENT ov7670_capture
   PORT(
      pclk : IN std_logic;
      vsync : IN std_logic;
      href  : IN std_logic;
      d     : IN std_logic_vector(7 downto 0);          
      addr  : OUT std_logic_vector(14 downto 0);
      dout  : OUT std_logic_vector(11 downto 0);
      we    : OUT std_logic
      );
   END COMPONENT;

   COMPONENT vga
   PORT(
      clk50 : IN std_logic;
      vga_red : OUT std_logic_vector(3 downto 0);
      vga_green : OUT std_logic_vector(3 downto 0);
      vga_blue : OUT std_logic_vector(3 downto 0);
      vga_hsync : OUT std_logic;
      vga_vsync : OUT std_logic;
      
      frame_addr : OUT std_logic_vector(14 downto 0);
      frame_pixel : IN std_logic_vector(11 downto 0)         
      );
   END COMPONENT;

   COMPONENT clk40 is
      port (
         refclk   : in  std_logic := '0'; --  refclk.clk
         rst      : in  std_logic := '0'; --   reset.reset
         outclk_0 : out std_logic;        -- outclk0.clk
         locked   : out std_logic         --  locked.export
      );
   end COMPONENT clk40;

   signal sclk40 : std_logic;
   
   signal frame_addr  : std_logic_vector(14 downto 0);
   signal frame_pixel : std_logic_vector(11 downto 0);
	
	signal cv_addr  : std_logic_vector(14 downto 0);
   signal cv_pixel : std_logic_vector(11 downto 0);

   signal capture_addr  : std_logic_vector(14 downto 0);
   signal capture_data  : std_logic_vector(11 downto 0);
   signal capture_we    : std_logic;
   signal resend : std_logic;
   signal config_finished : std_logic;

begin

   clk40_inst : clk40
      port map (
         refclk   => CLOCK_50,
         rst      => '0',
         outclk_0 => sclk40,
         locked   => open
      );

   btn_debounce: debounce 
      port map(
         clk => sclk40,
         i   => not KEY(0),
         o   => resend
      );

   Inst_vga: vga 
      port map(
         clk50       => sclk40,
         vga_red     => VGA_R,
         vga_green   => VGA_G,
         vga_blue    => VGA_B,
         vga_hsync   => VGA_HS,
         vga_vsync   => VGA_VS,
         frame_addr  => frame_addr,
         frame_pixel => frame_pixel
      );

   fb : frame_buffer
      port map (
         wrclock  => OV7670_PCLK,
         wren   => capture_we,
         wraddress => capture_addr,
         data  => capture_data,
         
         rdclock  => sclk40,
         rdaddress => frame_addr,
         q => frame_pixel
      );
	
	cvb : cv_buffer
      port map (
         wrclock  => OV7670_PCLK,
         wren   => capture_we,
         wraddress => capture_addr,
         data  => capture_data,
         
         rdclock  => sclk40,
         rdaddress => cv_addr,
         q => cv_pixel
      );

   LEDR <= "000000000" & config_finished;
  
   capture: ov7670_capture 
      port map(
         pclk  => OV7670_PCLK,
         vsync => OV7670_VSYNC,
         href  => OV7670_HREF,
         d     => OV7670_D,
         addr  => capture_addr,
         dout  => capture_data,
         we    => capture_we
      );
   
   controller: ov7670_controller 
      port map(
         clk   => sclk40,
         sioc  => ov7670_sioc,
         resend => resend,
         config_finished => config_finished,
         siod  => ov7670_siod,
         pwdn  => OV7670_PWDN,
         reset => OV7670_RESET,
         xclk  => OV7670_XCLK
      );
end Behavioral;
