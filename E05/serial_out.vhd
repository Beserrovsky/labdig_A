library IEEE;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_1164.ALL;



entity serial_out is
    generic(
        POLARITY: boolean := TRUE;
        WIDTH: natural := 7;
        PARITY: natural := 1;
        STOP_BITS: natural := 1
    );

    port (
        clock, reset, tx_go: in bit;
        tx_done: out bit;
        data: in bit_vector (WIDTH-1 downto 0);
        serial_o: out bit
    );
end serial_out;

architecture behavior of serial_out is
    type state_type is (IDLE, START_BIT, DATA_BITS);
    signal state : state_type := IDLE; -- Definindo um sinal para receber o valor de clock
    signal paridade : bit;
    signal start : bit;
begin
    -- Atribua o valor de clock ao sinal interno na sensibilidade do processo

    paridade <= '1' when PARITY = 1 else '0';
    start <= '0' when POLARITY = TRUE else '1';
    

    process(clock, reset)
        variable counter: integer range 0 to WIDTH + STOP_BITS - 1 := 0;
    begin
        if reset = '1' then
            state <= IDLE;
            tx_done <= '0';
            counter := 0;
            serial_o <= '1';

        elsif (clock'event AND clock = '1') then
    
            case state is
                when IDLE =>
                    counter := 0;
                    serial_o <= '1';
                    
                    if tx_go = '1' then
                        state <= START_BIT;
                    end if;

                when START_BIT =>
                    tx_done <= '0'; -- bit de inicio
                    serial_o <= start;
                    state <= DATA_BITS;

                when DATA_BITS =>
                    if counter < WIDTH then
                        serial_o <= data(WIDTH-(1+counter)); -- bits de dados
                        counter := counter + 1;

                    elsif counter = WIDTH then
                        serial_o <= paridade; -- Bit de paridade
                        counter := counter + 1;
                    
                    elsif (counter > WIDTH) and (counter < (WIDTH + STOP_BITS - 1)) then
                        serial_o <= '1';
                        counter := counter + 1;

                    elsif counter = (WIDTH + STOP_BITS - 1) then
                        state <= IDLE;
                        tx_done <= '1';
                        
                    end if;
              

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end behavior;
