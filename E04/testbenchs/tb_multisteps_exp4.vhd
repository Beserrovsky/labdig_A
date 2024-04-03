library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity dut is end;

architecture dut_arch of dut is

	component multisteps is
		port (clk, rst : in  bit;
				msgi     : in  bit_vector(511 downto 0);
				haso		: out bit_vector(255 downto 0);
				done		: out bit
		);
	end component multisteps;


	signal clk: bit := '0';
	signal rst: bit := '0';
	signal done: bit;
	signal finished: bit := '0';
	signal data: bit_vector(7 downto 0);
	signal Qword: bit_vector(63 downto 0);
	signal msgi: bit_vector(511 downto 0);
	signal check: bit_vector(31 downto 0);
	signal haso: bit_vector(255 downto 0);

	type ByteArray is array (natural range <>) of bit_vector(7 downto 0);
	type DwordArray is array (natural range <>) of bit_vector(31 downto 0);


	constant test_size: positive := 3;
	constant datas: ByteArray(test_size - 1 downto 0) := (x"00", x"01", x"02");
	constant asserts: DwordArray(test_size - 1 downto 0) := (x"DA5698BE", x"B8A4E897", x"27D75F9C");
	constant half_period : time := 1 ns;
	
begin

	clk <= not clk after half_period when finished /= '1' else '0';
	Qword <= data&data&data&data&data&data&data&data;
	msgi <= Qword&Qword&Qword&Qword&Qword&Qword&Qword&Qword;
	check <= haso(31 downto 0);

	exp4dut: multisteps
	port map(clk, rst, msgi, haso,  done);
	
	st: process
	begin
		for i in test_size - 1 downto 0 loop
			rst <= '1';
			data <= datas(i);
			wait for 4*half_period;
			rst <= '0';
			wait until rising_edge(done);
			assert check = asserts(i)
				report "Entrada: " &  to_hstring(unsigned(datas(i))) & " Esperado: " & to_hstring(unsigned(asserts(i))) & " Recebido: " & to_hstring(unsigned(check))
				severity note;
			wait for 4*half_period;
		end loop;
		finished <= '1';
		wait;
	end process;
end;
