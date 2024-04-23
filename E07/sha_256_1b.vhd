library IEEE;
use IEEE.numeric_bit.all;

entity sha_256_1b is
    port (
        clock, reset: in bit;
        serial_in: in bit;
        serial_out: out bit
    );
end sha_256_1b;

architecture behavior of sha_256_1b is

component serial_out is
    generic( 
        POLARITY  : boolean := TRUE;
        WIDTH     : natural := 7;
        PARITY    : natural := 1;
        STOP_BITS : natural := 1
    );

    port( 
        clock, reset, tx_go  : in  bit;
        tx_done              : out  bit;
        data                 : in bit_vector(WIDTH-1 downto 0);    
        serial_o : out  bit
    );
end component;

component serial_in is

    generic( 
        POLARITY  : boolean := TRUE;
        WIDTH     : natural := 8;
        PARITY    : natural := 1;
        CLOCK_MUL : natural := 4
    );

    port( 
        clock, reset, start, serial_data : in  bit; -- clock ja reduzido da fpga
        done, parity_bit                 : out  bit;
        parallel_data                    : out bit_vector(WIDTH-1 downto 0)
    );
end component;


component multisteps is
    entity multisteps is 
port(
    clk, rst : in bit;
    msgi : in bit_vector(511 downto 0);
    haso : out bit_vector(255 downto 0);
    done : out bit
);
end component;

begin

    -- Signals for communication with serial_in
    signal serial_in_clock, serial_in_reset, serial_in_start, serial_in_serial_data : bit;
    signal serial_in_done, serial_in_parity_bit : bit;
    signal serial_in_parallel_data : bit_vector(7 downto 0); -- 1 byte
    
    -- Signals for communication with multisteps
    signal multisteps_clock, multisteps_reset : bit;
    signal multisteps_msgi : bit_vector(511 downto 0);
    signal multisteps_haso : bit_vector(255 downto 0);
    signal multisteps_done : bit;
    
    -- Signals for internal state
    signal current_byte : bit_vector(7 downto 0);
    signal calculation_started : boolean := false;
    signal received_bytes : natural := 0;
    constant MAX_WAIT_CYCLES : natural := 64; -- Maximum wait cycles before ending calculation
    
begin

    -- Process for receiving byte from serial_in and calculating hash
    process (clock)
    begin
        if rising_edge(clock) then
            -- Check for asynchronous reset
            if serial_in_reset = '1' then
                -- Reset internal state
                calculation_started <= false;
                received_bytes <= 0;
                wait_counter <= 0;
            else
                -- Check if we have a new byte
                if serial_in_done = '1' then
                    -- Reset serial_in_done for next byte
                    serial_in_done <= '0';
                    
                    -- Get the received byte
                    current_byte <= serial_in_parallel_data;
                    received_bytes <= received_bytes + 1;
                    
                    -- Start the calculation if not started
                    if not calculation_started then
                        -- Initialize multisteps_msgi with zeros
                        multisteps_msgi <= (others => '0');
                        -- Start calculation with the received byte
                        multisteps_msgi(7 downto 0) <= current_byte;
                        calculation_started <= true;
                    else
                        -- Add the received byte to the ongoing calculation
                        multisteps_msgi(7 + received_bytes*8 downto received_bytes*8) <= current_byte;
                    end if;
                    
                    -- Reset wait counter
                    wait_counter <= 0;
                    
                else
                    -- If no new byte received, check if we should end calculation
                    if calculation_started and wait_counter < MAX_WAIT_CYCLES then
                        wait_counter <= wait_counter + 1;
                    end if;
                    
                    -- If calculation done, transmit least significant byte of hash
                    if multisteps_done = '1' then
                        -- Transmit least significant byte of hash
                        -- Assuming serial_out_data is the output data signal
                        serial_out_data <= multisteps_haso(7 downto 0);
                        -- Reset for next calculation
                        calculation_started <= false;
                        received_bytes <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Connect clock and reset signals
    serial_in_clock <= clock;
    serial_in_reset <= reset;
    multisteps_clock <= clock;
    multisteps_reset <= reset;

    -- Connect serial_in_start based on received_bytes
    serial_in_start <= '1' when received_bytes = 0 else '0';

    -- Connect serial_out_tx_go, serial_out_data, and serial_out_reset based on internal signals
    -- You need to define these signals based on your serial_out component
    -- serial_out_tx_go <= calculation_started;
    -- serial_out_data <= '0';
    -- serial_out_reset <= reset;

end behavior;




