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
--! @brief Contador até 64, 6bits
--! Contador com reset e enable
--
--! @author <Felipe Beserra (felipebeserra25@usp.br)>
--
--! @date <01\04\2024>
--
--! @version <v0.1>
--
-------------------------------------------------------------------------------
--! @todo <Criar contador s/ registrador> \n
--! <Contador c/ registrador ?> \n
-------------------------------------------------------------------------------

entity contador is 
	port (
		clk, reset, enable :  in bit;
        counter            : out bit_vector(5 downto 0) -- 64 valores
	);
end entity;

architecture contador_arch of contador is
    
    
    
    begin
    	
        
    	counter <= sig_counter;
end architecture;
