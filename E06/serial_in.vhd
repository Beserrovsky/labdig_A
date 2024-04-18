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

  -- N-bit Shift Register
  component shift_reg is
    generic (
      WIDTH : natural := 8
    );
    port (
      clk_i, reset_i, data_i : in bit;
      
      data_o : out bit_vector(WIDTH-1 downto 0)
    );
  end component;

  signal s_buffer : bit_vector(7 downto 0);
  signal s_counter : 


begin

  D_SREG : shift_reg
    generic map (WIDTH:=8)
    port map (clock, reset, serial_data, parallel_data);

  -- Toda vez que chega um dado, entra e joga pra direita
  -- WIDTH + (paridade) + (stop_bit)

  process( sensitivity_list )
  begin
    
  end process;


  -- Maquina de estados
  -- Idle -->  Mesmo que mandar dados, ele não recebe
  -- Waiting --> Pronto pra receber, esperando
  -- Running --> Rodando
  -- DONE --> RESET volta pro IDLE, START volta pro WAITING

  -- POLARITY --> 1 = serial_data active high
  -- POLARITY --> 0 = serial_data active false

  -- WIDTH --> tamanho palavras

  -- PARITY --> 0 = par
  -- PARITY --> 1 = impar

end architecture ; -- arch_serial_in