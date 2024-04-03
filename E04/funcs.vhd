--! Standard library
library IEEE;
--! Standard packages
use IEEE.std_logic_1164.ALL;
-- use IEEE.std_logic_arith.ALL;
-- use IEEE.std_logic_unsigned.ALL;
-- use IEEE.numeric_std.ALL;
-------------------------------------------------------------------------------
-- --
-- USP, PCS3335 - Laboratório Digital A --
-- --
-------------------------------------------------------------------------------
--
-- unit name: Funções Úteis (funcs)
--
--! @brief Diversas funções 32-bit úteis
--! adder32(a, b)
--! ch(x, y, z)
--! maj(x, y, z)
--! sigma0(x)
--! sigma1(x)
--! sum0(x)
--! sum1(x)
--
--! @author <Felipe Beserra (felipebeserra25@usp.br)>
--! @author <Renato Ferreira (renato.ferreiraspfc@usp.br)>
--
--! @date <01\04\2024>
--
--! @version <v0.1>
--
-------------------------------------------------------------------------------
--! @todo TEST funcs.vhd! \n
--! FIXME adder32: funcs.vhd:55:28:error: no function declarations for operator "+" \n
--
-------------------------------------------------------------------------------

--! @brief 32-bit Adder w/ no carry
--! @details adder32(a, b) = a + b
entity adder32 is
    port (
        a     :  in bit_vector (31 downto 0);
        b     :  in bit_vector (31 downto 0);
        r     : out bit_vector (31 downto 0) -- a + b
    );
end adder32;

-------------------------------------------------------------------------------

architecture adder32_arch of adder32 is

    signal s_sum : bit_vector (31 downto 0);

    begin

        s_sum <= ('0' & a) + ('0' & b);

        r <= s_sum(31 downto 0);
        -- carry_o <= s_sum(32);
end adder32_arch;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--! @brief 32-bit majority function, maj(x, y, z)
--! @details maj(x, y, z) = (x ∧ y) ⊕ (x ∧ z) ⊕ (y ∧ z)
--! @details https://en.wikipedia.org/wiki/Majority_function
entity maj is
    port(
        x,y,z: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end maj;

-------------------------------------------------------------------------------

architecture arch_maj of maj is
begin 
    q <= (x and y) xor (x and z) xor (y and z);
end architecture;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--! @brief Crazy 32-bit function, sigma0(x)
--! @details σ₀(x) = ∑{256}0 rotr2(x) ⊕ rotr13(x) ⊕ rotr22(x)
entity sigma0 is
    port(
        x:  in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sigma0;

-------------------------------------------------------------------------------

architecture arch_sigma0 of sigma0 is
begin
    q <= (x ror 7) xor (x ror 18) xor (x srl 3);
end architecture;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--! @brief Crazy 32-bit function, sigma1(x)
--! @details σ₁(x) = ∑{256}0 rotr6(x) ⊕ rotr11(x) ⊕ rotr25(x)
entity sigma1 is
    port(
        x:  in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sigma1;

-------------------------------------------------------------------------------

architecture arch_sigma1 of sigma1 is
begin 
    q <= (x ror 17) xor (x ror 19) xor (x srl 10);
end architecture;    

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--! @brief Crazy 32-bit function, Ch(x, y, z)
--! @details Ch(x, y, z) = (x ∧ y) ⊕ (¬x ∧ z)
entity ch is
    port(
        x,y,z: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end ch;

-------------------------------------------------------------------------------

architecture arch_ch of ch is
begin
    q <= (x and y) xor (not (x) and z);
end architecture;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

--! @brief Crazy 32-bit function, sum0(x)
--! @details ∑{256}0 (x) = rotr2(x) ⊕ rotr13(x) ⊕ rotr22(x)
entity sum0 is
    port(
        x: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0) 
    );
end sum0;

-------------------------------------------------------------------------------

architecture arch_sum0 of sum0 is
begin 
    q <= (x ror 2) xor (x ror 13) xor (x ror 22);
end architecture;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


--! @brief Crazy 32-bit function, sum1(x)
--! @details ∑{256}1 (x) = rotr6(x) ⊕ rotr11(x) ⊕ rotr25(x)
entity sum1 is
    port(
        x: in bit_vector(31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sum1;

-------------------------------------------------------------------------------

architecture arch_sum1 of sum1 is
begin 
    q <= (x ror 6) xor (x ror 11) xor (x ror 25);
end architecture;
