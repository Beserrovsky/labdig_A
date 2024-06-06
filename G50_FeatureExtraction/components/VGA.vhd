library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity VGA is
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
end entity VGA;

architecture arch_VGA of VGA is

  constant c_HDISPLAY : integer := g_hdisplay;
  constant c_VDISPLAY : integer := g_vdisplay;

  constant c_HPULSE_START : integer := g_hdisplay + g_hfront_porch;
  constant c_VPULSE_START : integer := g_vdisplay + g_vfront_porch;

  constant c_HPULSE_END   : integer := g_hdisplay + g_hfront_porch + g_hsync_pulse_time;
  constant c_VPULSE_END   : integer := g_vdisplay + g_vfront_porch + g_vsync_pulse_time;

  constant c_HMAX   : integer := g_hdisplay + g_hfront_porch + g_hsync_pulse_time + g_hback_porch;
  constant c_VMAX   : integer := g_vdisplay + g_vfront_porch + g_vsync_pulse_time + g_vback_porch;

  signal s_hpos : integer range 0 to c_HMAX := 0;
  signal s_vpos : integer range 0 to c_VMAX := 0;

  signal s_hpulse : std_logic;
  signal s_vpulse : std_logic;

  begin
    with g_hpolarity select
      hsync_o <= s_hpulse when true,
              not s_hpulse when others;
    
    with g_vpolarity select
      vsync_o <= s_vpulse when true,
              not s_vpulse when others;
                
    x_o <= s_hpos;
    y_o <= s_vpos;

    p_counter: process(clk_i) begin
      if rising_edge(clk_i) then
        if s_hpos < c_HMAX then
          s_hpos <= s_hpos + 1;
        else
          s_hpos <= 0;

          if s_vpos < c_VMAX then
            s_vpos <= s_vpos + 1;
          else
            s_vpos <= 0;
          end if;

        end if;
      end if;
    end process;

    p_sync_pulses: process(clk_i) begin
      
      if s_hpos < c_HDISPLAY and s_vpos < c_VDISPLAY then --display
        red_o   <= red_i;
        green_o <= green_i;
        blue_o  <= blue_i;
      end if;

      if s_hpos > c_HPULSE_START and s_hpos < c_HPULSE_END then --syncpulse
        s_hpulse <= '1';--when g_hpolarity else '0';
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "0000";
      else
        s_hpulse <= '0';-- when g_hpolarity else '1';
      end if;

      if s_vpos > c_VPULSE_START and s_vpos < c_VPULSE_END then --syncpulse
        s_vpulse <= '1';-- when g_vpolarity else '0';
        red_o   <= "0000";
        green_o <= "0000";
        blue_o  <= "0000";
      else
        s_vpulse <= '0';-- when g_vpolarity else '1';
      end if;
    end process;

end architecture arch_VGA;
