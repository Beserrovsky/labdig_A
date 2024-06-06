library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity OV7670 is
  generic (
    WIDTH : integer  := 640;
    HEIGHT : integer := 480;
  );
  port (
    clk_i :   in std_logic;
    rst_i :   in std_logic;
    vsync_i : in std_logic;
    href_i :  in std_logic;
    pclk_i :  in std_logic;
    data_i :  in std_logic_vector(7 downto 0); --- '0' & "RGB555" -- 2 clk cycles per pixel
    
    scl_o :  out std_logic;
    sda_o :  out std_logic;
    xclk_o : out std_logic;
    rst_o :  out std_logic;

    data_o : out std_logic_vector(11 downto 0)  -- "RGB444"
  );
end entity OV7670;



-- TODO:
-- 1. SCCB interface for configuration?
--

architecture arch_OV7670 of OV7670 is

  begin
    
end architecture arch_OV7670;
