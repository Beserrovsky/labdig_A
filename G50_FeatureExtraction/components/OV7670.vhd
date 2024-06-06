library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity OV7670 is
  port (
    clk_i :   in std_logic;
    rst_i :   in std_logic;
    vsync_i : in std_logic;
    href_i :  in std_logic;
    pclk_i :  in std_logic;
    data_i :  in std_logic_vector(7 downto 0);
    
    data_o : out std_logic_vector(7 downto 0)
  );
end entity OV7670;

architecture arch_OV7670 of OV7670 is

  begin
    
    
end architecture arch_OV7670;
