library IEEE;
	 use IEEE.STD_LOGIC_1164.ALL;
	 use IEEE.numeric_std.ALL;

entity DE0CV is
  port (
    CLOCK_50,  CLOCK2_50 : in bit; -- 50 MHZ
	 CLOCK3_50, CLOCK4_50 : in bit; -- 50 MHZ
    
    GPIO_0 : in bit_vector(35 downto 0); -- 36x GPIO
	 SW :     in bit_vector(9 downto 0);  -- 10x Switches
	 KEY :    in bit_vector(3 downto 0);  -- 4x Push Buttons
    
    GPIO_1 : out bit_vector(35 downto 0); -- 36x GPIO
    LEDR :   out bit_vector(9 downto 0);  -- 10x LEDs
	 
    HEX0 :   out bit_vector(6 downto 0);  -- 6x 7 Segment displays
	 HEX1 :   out bit_vector(6 downto 0);  -- ""
	 HEX2 :   out bit_vector(6 downto 0);  -- ""
	 HEX3 :   out bit_vector(6 downto 0);  -- ""
	 HEX4 :   out bit_vector(6 downto 0);  -- ""
	 HEX5 :   out bit_vector(6 downto 0)   -- ""
	 
	 -- HEX :   out bit_vector(41 downto 0);  -- 6x 7 Segment displays
  ) ;
end DE0CV; -- 5CEBA4F23C7N

architecture arch_FPGA of DE0CV is
	signal s_switch :  bit_vector(9 downto 0);
	signal s_display : bit_vector(41 downto 0);
begin
	s_switch <= SW(0) & SW(1) & SW(2) & SW(3) & SW(4) &
					SW(5) & SW(6) & SW(7) & SW(8) & SW(9);


	-- Display SW state in correspondent LED
	LEDR <= s_switch;
	
	-- TODO: Pass data to s_display trough displayConverter

	-- 7-segment displays
	HEX0 <= s_display(6 downto 0);
	HEX1 <= s_display(13 downto 7);
	HEX2 <= s_display(20 downto 14);
	HEX3 <= s_display(27 downto 21);
	HEX4 <= s_display(34 downto 28);
	HEX5 <= s_display(41 downto 35);
end arch_FPGA ; -- arch_FPGA