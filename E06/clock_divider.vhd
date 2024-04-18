library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.numeric_std.ALL;
  
entity clock_divider is
  generic (
    IN_FREQ :  positive := 50000000; -- 50 MHz
    OUT_FREQ : positive := 4800      -- 4800 bps
  );
	port (
		clk_i, reset_i : in bit;
		clk_o :         out bit
  );
end clock_divider;
  
architecture arch_clock_divider of clock_divider is
  
  constant COUNT_MAX : integer := (IN_FREQ / OUT_FREQ);
  constant COUNT_WIDTH : integer := 32;

  signal s_count : unsigned(COUNT_WIDTH-1 downto 0) := (others => '0');
  signal s_state : bit := '0';
  
begin
  
  process(clk_i, reset_i)
  begin
    if(reset_i='1') then
      s_count <= (others => '0');
      s_state <= '0';
    elsif(clk_i'event and clk_i='1') then

      if s_count = COUNT_MAX-1 then
        s_state <= NOT s_state;
        s_count <= (others => '0');
      else
        s_count <= s_count + 1;
      end if;
    end if;

    clk_o <= s_state;
  end process;
end arch_clock_divider; -- arch_clock_divider