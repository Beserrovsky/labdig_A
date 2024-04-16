library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.numeric_std.ALL;

entity serial_in is
  generic (
    POLARITY : boolean := TRUE;
    WIDTH : natural := 8;
    PARITY : natural := 1;
    CLOCK_MUL : positive := 4
  );  
  port (
    clock, reset, start, serial_data : in bit; -- 19200bps

    done, parity_bit :  out bit;
    parallel_data :     out bit_vector(7 downto 0)
  ) ;
end serial_in ;

architecture arch_serial_in of serial_in is


begin



end architecture ; -- arch_serial_in