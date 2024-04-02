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

-------------------------------------------------------------------------------    

architecture multisteps_arch of multisteps is
    
    -- H: sqrt(8 primeiros números primos)!
    constant const_H : array(0 to 7) of bit_vector(31 downto 0) := ( 
        x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19"
    );

    -- K: sqrt(64 primeiros números primos)!
    constant const_K : array(0 to 63) of bit_vector(31 downto 0) := (
        x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5", x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
        x"d807aa98", x"12835b01", x"243185be", x"550c7dc3", x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
        x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc", x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
        x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7", x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
        x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13", x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
        x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3", x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
        x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5", x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
        x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208", x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
    );
    
    -- counter signals
    signal sig_counter_en, sig_counter_reset : bit;
    signal sig_counter_o : bit_vector(5 downto 0);

    -- stepfun signals
    signal sig_a_i, sig_b_i, sig_c_i, sig_d_i : bit_vector(31 downto 0); 
    signal sig_e_i, sig_f_i, sig_g_i, sig_h_i : bit_vector(31 downto 0);
    signal sig_kpw                            : bit_vector(31 downto 0);
    signal sig_a_o, sig_b_o, sig_c_o, sig_d_o : bit_vector(31 downto 0); 
    signal sig_e_o, sig_f_o, sig_g_o, sig_h_o : bit_vector(31 downto 0);
    
    -- funcs signals
    signal sig_sigma0_i, sig_sigma1_i : bit_vector(31 downto 0);
    signal sig_sigma0_o, sig_sigma1_o : bit_vector(31 downto 0);

    -- Maybe use register?
    signal sig_W    : array(0 to 63) of bit_vector(31 downto 0);
    signal sig_HASO : bit_vector(255 downto 0);
begin

    -- contador.vhd
    COUNTER_PM: counter port map (
        clk, sig_counter_reset, sig_counter_en,
        sig_counter_o
    );

    -- stepfun.vhd
    STEPFUN_PM: stepfun port map (
        sig_a_i, sig_b_i, sig_c_i, sig_d_i, sig_e_i, sig_f_i, sig_g_i, sig_h_i,
        sig_kpw,
        sig_a_o, sig_b_o, sig_c_o, sig_d_o, sig_e_o, sig_f_o, sig_g_o, sig_h_o
    );

    -- funcs.vhd
    SIGMA0_PM: sigma0 port map (sig_sigma0_i, sig_sigma0_o);
    SIGMA1_PM: sigma1 port map (sig_sigma1_i, sig_sigma1_o);

    process (clk, rst, msgi)
        if rst = '1' then
            -- reset: HASH_Out = Constante H
            sig_HASO <= const_H(0) & const_H(1) & const_H(2) & const_H(3) &
                        const_H(4) & const_H(5) & const_H(6) & const_H(7);
        elsif (clk = '1' and clock'event) then
            if sig_counter_o < 16 then

                -- Wₜ = Mₜ (16 primeiros blocos de 32 bits de MSG_INPUT)
                sig_W(sig_counter_o) <= msgi((31 + sig_counter_o * 32) downto (0 + (sig_counter_o - 1) * 32));
                    -- 0 --> (31 downto 0), 1 --> (63 downto 32)... 
            else
                -- σ₁(Wₜ₋₂)
                sig_sigma1_i <= sig_W(sig_counter_o - 16) & sig_W(sig_counter_o - 7);

                -- σ₀(Wₜ₋₁₅)
                sig_sigma0_i <= sig_W(sig_counter_o - 15) & sig_W(sig_counter_o - 2);
            
                -- Wₜ = σ₁(Wₜ₋₂) + Wₜ₋₇ + σ₀(Wₜ₋₁₅) + Wₜ₋₁₆
                sig_W(sig_counter_o) <= 
                    sig_sigma1_o & sig_W(sig_counter_o - 2) & sig_W(sig_counter_o - 7) & sig_sigma0_o;
            end if;

            sig_kpw <= sig_W(sig_counter_0) + const_K(sig_counter_o);

            sig_HASO <= sig_a_o & sig_b_o & sig_c_o & sig_d_o & 
                        sig_e_o & sig_f_o & sig_g_o & sig_h_o;
        end if;
    end process;

    done <= sig_counter_o = 63;
    haso <= sig_HASO;
end architecture;
