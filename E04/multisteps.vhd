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
-- unit name: Multi StepFunctions (multisteps)
--
--! @file multisteps.vhd
--! @brief SHA-256 Hashing
--! SHA-256 Hashing for 512 bits
--
--! @author Felipe Beserra (felipebeserra25@usp.br)
--! @author Renato Ferreira (renato.ferreiraspfc@usp.br)
--
--! @date <01\04\2024>
--
--! @version <v0.1>
--
--! @details
--!
--! <b>Dependencies:</b>\n
--! stepfun.vhd
--! contador.vhd
--! funcs.vhd
--
-------------------------------------------------------------------------------
--! @todo Etender cálculos \n
--! Add Contador \n
--! Testar com testbench \n
--! CHALLENGE: Use registers? \n
--
-------------------------------------------------------------------------------

--! @brief SHA-256 MultiStepsFunctions
--! @details 64 clock cycles, hashes 512 bits


entity multisteps is
    port (
        clk, rst : in bit; -- Clock, Reset
        msgi :     in bit_vector(511 downto 0); -- Message_in
        haso :    out bit_vector(255 downto 0); -- Hash_out
        done :    out bit
    );
end multisteps;

-------------------------------------------------------------------------------  

architecture multisteps_arch of multisteps is
    
    -- H: √(8 primeiros números primos) --> "sqrt"
    constant const_H : array(0 to 7) of bit_vector(31 downto 0) := ( 
        x"6a09e667", x"bb67ae85", x"3c6ef372", x"a54ff53a", x"510e527f", x"9b05688c", x"1f83d9ab", x"5be0cd19"
    );

    -- K: ∛(64 primeiros números primos) --> "cube root"
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
    signal s_counter_en, s_counter_reset : bit;
    signal s_counter_o : natural range 0 to 63;

    -- stepfun component
    component stepfun is
        port (
            ai, bi, ci, di, ei, fi, gi, hi :  in bit_vector(31 downto 0);
            kpw :                             in bit_vector(31 downto 0);
            ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
        );
    end component;

    -- sigma0 component
    component sigma0 is
        port(
            x_i:  in bit_vector (31 downto 0);
            q_o: out bit_vector (31 downto 0)
        );
    end component;
    
    -- sigma1 component
    component sigma1 is
        port(
            x_i:  in bit_vector (31 downto 0);
            q_o: out bit_vector (31 downto 0)
        );
    end component;

    -- somador component
    component somador is
        port (
            x_i :      in bit_vector (31 downto 0);
            y_i :      in bit_vector (31 downto 0);
            carry_o : out bit;
            sum_o :   out bit_vector (31 downto 0) -- x_i + y_i
        );
    end component;

    -- funcs signals
    signal s_sigma0_i, s_sigma1_i : bit_vector(31 downto 0);
    signal s_sigma0_o, s_sigma1_o : bit_vector(31 downto 0);
    signal s_soma1_x_i, s_soma1_y_i, s_soma1_carry_o, s_soma1_sum_o : bit_vector(31 downto 0);
    signal s_soma2_x_i, s_soma2_y_i, s_soma2_carry_o, s_soma2_sum_o : bit_vector(31 downto 0);
    signal s_soma3_x_i, s_soma3_y_i, s_soma3_carry_o, s_soma3_sum_o : bit_vector(31 downto 0);

    -- multisteps signals
    signal s_W    : array(0 to 63) of bit_vector(31 downto 0);
    signal s_HASO : bit_vector(255 downto 0);
begin

    -- stepfun.vhd
    STEPFUN_PM: stepfun port map (
        s_a_i, s_b_i, s_c_i, s_d_i, s_e_i, s_f_i, s_g_i, s_h_i, s_kpw_i,
        s_a_o, s_b_o, s_c_o, s_d_o, s_e_o, s_f_o, s_g_o, s_h_o
    );

    -- sigma0.vhd
    SIGMA0_PM: sigma0 port map (s_sigma0_i, s_sigma0_o); -- σ₀(s_sigma0_i)
    -- sigma1.vhd
    SIGMA1_PM: sigma1 port map (s_sigma1_i, s_sigma1_o); -- σ₁(s_sigma1_i)

    -- somador.vhd
    SOMA1_PM: somador port map (s_soma1_x_i, s_soma1_y_i, s_soma1_carry_o, s_soma1_sum_o);
    SOMA2_PM: somador port map (s_soma2_x_i, s_soma2_y_i, s_soma2_carry_o, s_soma2_sum_o);
    SOMA3_PM: somador port map (s_soma3_x_i, s_soma3_y_i, s_soma3_carry_o, s_soma3_sum_o);

    process (clk, rst, msgi)
    begin
        if rst = '1' then
            -- reset: HASH_Out = Constante H
            s_HASO <= const_H(0) & const_H(1) & const_H(2) & const_H(3) &
                      const_H(4) & const_H(5) & const_H(6) & const_H(7);
            s_counter_o <= 0;
        elsif rising_edge(clk) then
            if s_counter_o < 16 then
                -- Wₜ = Mₜ (16 primeiros blocos de 32 bits de MSG_INPUT)
                s_W(s_counter_o) <= msgi((s_counter_o * 32 + 31) downto (s_counter_o * 32));
            else
                -- σ₁(Wₜ₋₂)
                s_sigma1_i <= s_W(s_counter_o - 2);
                -- σ₀(Wₜ₋₁₅)
                s_sigma0_i <= s_W(s_counter_o - 15);
            
                -- σ₁(Wₜ₋₂) + Wₜ₋₇
                s_soma1_x_i <= s_sigma1_o;
                s_soma1_y_i <= s_W(s_counter_o - 7);
                -- σ₀(Wₜ₋₁₅) + Wₜ₋₁₆
                s_soma2_x_i <= s_sigma0_o;
                s_soma2_y_i <= s_W(s_counter_o - 16);
            
                -- Wₜ = σ₁(Wₜ₋₂) + Wₜ₋₇ + σ₀(Wₜ₋₁₅) + Wₜ₋₁₆
                s_soma1_sum_o <= s_soma1_x_i + s_soma1_y_i;
                s_soma2_sum_o <= s_soma2_x_i + s_soma2_y_i;
                s_W(s_counter_o) <= s_soma1_sum_o + s_soma2_sum_o;
            end if;

            s_kpw_i <= s_W(s_counter_o) + const_K(s_counter_o);
            s_counter_o <= s_counter_o + 1;

            s_HASO <= s_a_o & s_b_o & s_c_o & s_d_o & 
                      s_e_o & s_f_o & s_g_o & s_h_o;
        end if;
    end process;

    done <= s_counter_o = 64;
    haso <= s_HASO;
end architecture;
