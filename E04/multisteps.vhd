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
-- unit name: Multi Step Functions (multisteps)
--
--! @brief <Implements SHA256 hashing>
--! Secure hashing using prime numbers
--
--! @author <Felipe Beserra (felipebeserra25@usp.br)>
--! @author <Renato Ferreira (renato.ferreiraspfc@usp.br)>
--
--! @date <01\04\2024>
--
--! @version <v0.1>
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! <stepfun>
--! <contador>
--! <registrador>
-------------------------------------------------------------------------------
--! @todo <Etender cálculos> \n
--! <Add Contador> \n
--! <Testar com testbench> \n
--
-------------------------------------------------------------------------------

entity multisteps is
    port (
        clk, rst : in bit;
        msgi :     in bit_vector(511 downto 0);
        haso :    out bit_vector(255 downto 0);
        done :    out bit
    );
end entity;

architecture multisteps_arch of multisteps is
    
    -- H: 8 primeiros números primos!
    constant H : constant_array := ( 
        x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a" 
        x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19"
    );
    
    constant K : constant_array := (

    );
    
    signal sig_H, sig_K               : bit_vector(31 downto 0);
    signal sig_W                      : bit_vector(31 downto 0);
    
    -- counter signals
    signal sig_counter_en

    -- stepfun signals
    signal sig_a, sig_b, sig_c, sig_d : bit_vector(31 downto 0); 
    signal sig_e, sig_f, sig_g, sig_h : bit_vector(31 downto 0);
    signal sig_kpw                    : bit_vector(31 downto 0);
    
    signal clks
    
begin

    COUNTER: counter port map (
        
    );

    sig_kpw <= sig_W + sig_K;
    
    STEP: stepfun port map (
        sig_a, sig_b, sig_c, sig_d, sig_e, sig_f, sig_g, sig_h,
        sig_kpw
    );  
      
end architecture;
