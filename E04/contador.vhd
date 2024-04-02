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
--! @brief Conta até 64 (decimal), 6bits
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
--! @todo <TESTAR contador s/ registrador> \n
--! <Contador c/ registrador ?> \n
-------------------------------------------------------------------------------

entity contador is 
port (
    clk, reset, enable :  in bit;
    counter            : out bit_vector(5 downto 0) -- 64 valores
);
end entity;

-------------------------------------------------------------------------------

architecture contador_arch of contador is
    
    signal sig_counter : bit_vector(5 downto 0);

begin

    process(clk, reset, enable)
        if reset = '1' then
            counter <= 0
        elsif (clk='1' and clock'event) then
            if enable = '1' then
                sig_counter <= sig_counter + 1;
            end if;
        end if;
    end process;
    
  counter <= sig_counter;
end architecture;
