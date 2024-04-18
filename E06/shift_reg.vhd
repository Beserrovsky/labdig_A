library IEEE;
    use IEEE.std_logic_1164.ALL;
    use IEEE.numeric_std.ALL;

-- @brief N-bit Right Shifter Register
-- @details SIPO, rising_edge, N := 8
entity shift_reg is
  generic (
    WIDTH : natural := 8
  );
  port (
    clk_i, reset_i, data_i : in bit;
    
    data_o : out bit_vector(WIDTH-1 downto 0)
  );
end shift_reg; 

architecture arch_shift_reg of shift_reg is
  signal s_buffer : bit_vector(WIDTH-1 downto 0) := ( others => '0');
begin

  process( data_i, reset_i, clk_i, s_buffer )
  begin
    if (reset_i = '1') then
      s_buffer <= ( others => '0');
    end if ;

    if (clk_i'event and clk_i = '0') then
      s_buffer <= data_i & s_buffer(WIDTH-1 downto 1);
    end if ;
  end process;

  data_o <= s_buffer;
end architecture ;