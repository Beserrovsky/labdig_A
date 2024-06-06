library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.numeric_std.ALL;

entity clock_divider is
  generic(
    DIVIDER   : natural := 1
  );
  port (
    clock_in  :  in std_logic;
    reset     :  in std_logic;
    clock_out : out std_logic
  );
end clock_divider;

--50 000 000 / 2*4800  = 5208.3333 -> 5208
--50 000 000 / 2*19200 = 1302.0833 -> 1302
architecture arch_divider of clock_divider is
  signal clock_counter : integer   :=  0 ;
  signal clock_aux     : std_logic := '0';

  begin
    p_freq_divider: process (clock_in, reset) begin
      if reset = '1' then
        clock_aux <= '0';
        clock_counter <= 0;
      elsif clock_in = '1' and clock_in'event then
        if clock_counter = DIVIDER - 1 then
          clock_aux <= not clock_aux;
          clock_counter <= 0;
        else
          clock_counter <= clock_counter + 1;
        end if;
      end if;
    end process;

    clock_out <= clock_aux;
end architecture arch_divider;
