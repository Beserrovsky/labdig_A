--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.ALL;
-------------------------------------------------------------------------------
-- --
-- USP, PCS3335 - Laboratório Digital A --
-- --
-------------------------------------------------------------------------------
--
-- unit name: Contador Simples (contador)
--
--! @brief Conta até 64 (0 --> 63)
--! Contador com sinais de reset e enable
--
--! @author <Felipe Beserra (felipebeserra25@usp.br)>
--! @author <Renato Ferreira (renato.ferreiraspfc@usp.br)>
--
--! @date <01\04\2024>
--
--! @version <v0.1>
--
-------------------------------------------------------------------------------
--! @todo <TESTAR contador!> \n
--
-------------------------------------------------------------------------------

entity contador is 
port (
    clk_i, rst_i, en_i   :  in bit; -- clock, reset, enable
    counter_o            : out bit_vector(5 downto 0) -- 64 valores
);
end contador;

-------------------------------------------------------------------------------

architecture contador_arch of contador is
    
    signal s_counter : bit_vector(5 downto 0);

begin

    process(clk_i, rst_i, en_i)
        if rst_i = '1' then
            counter_o <= 0;
        elsif (clk_i'event and clk_i='1') then
            if en_i = '1' then
                s_counter <= s_counter + 1;
            end if;
        end if;
    end process;
    
  counter_o <= s_counter;
end architecture;
