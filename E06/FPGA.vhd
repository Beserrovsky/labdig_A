library IEEE;
	  use IEEE.STD_LOGIC_1164.ALL;
	  use IEEE.numeric_std.ALL;

entity FPGA is
  port (
    clk_i :  in bit; -- 50 MHZ
    SW_i :   in bit_vector(10 downto 0);
    BTN_i :  in bit_vector(4 downto 0);
    
    LED_o : out bit_vector(9 downto 0)
  ) ;
end FPGA;

architecture arch_FPGA of FPGA is
  component serial_in is
    generic (
      POLARITY : boolean := TRUE;
      WIDTH : natural := 8;
      PARITY : natural := 1;
      CLOCK_MUL : positive := 4
    );  
    port (
      clock, reset, start, serial_data : in bit;
  
      done, parity_bit :  out bit;
      parallel_data :     out bit_vector(7 downto 0)
    ) ;
  end component;

  signal s_reset, s_start : bit;
  signal s_clk19200 : bit;

  signal s_serial_data : bit;

  signal s_parallel_done, s_parallel_parity_bit : bit
  signal s_parallel_data : bit_vector(7 downto 0)
begin

  D_CLOCKDIVIDER: clock_divider
    generic map (IN_FREQ:=50000000, OUT_FREQ=19200)
    port map (clk_i, s_reset, s_clk48000);

  D_SERIAL_IN : serial_in
    port map (s_clk19200, s_reset, s_start, s_serial_data
              s_parallel_done, s_parallel_parity_bit, s_parallel_data)

end arch_FPGA ; -- arch_FPGA