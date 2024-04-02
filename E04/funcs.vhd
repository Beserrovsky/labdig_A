--! @brief Crazy 32-bit function
--! @details σ₀(x) = ∑{256}0 rotr2(x) ⊕ rotr13(x) ⊕ rotr22(x)
entity sigma0 is
    port(
        x_i:  in bit_vector (31 downto 0);
        q_o: out bit_vector (31 downto 0)
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

--! @brief Crazy 32-bit function
--! @details σ₁(x) = ∑{256}0 rotr6(x) ⊕ rotr11(x) ⊕ rotr25(x)
entity sigma1 is
    port(
        x_i:  in bit_vector (31 downto 0);
        q_o: out bit_vector (31 downto 0)
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

--! @brief 32-bit Adder w/ carry
--! @details 
entity somador is
    port (
        x_i     :  in bit_vector (31 downto 0);
        y_i     :  in bit_vector (31 downto 0);
        carry_o : out bit;
        sum_o   : out bit_vector (31 downto 0) -- x_i + y_i
    );
end somador;

-------------------------------------------------------------------------------

architecture somador_arch of somador is

    signal s_sum : bit_vector (31 downto 0);

begin

    s_sum <= ('0' & x_i) + ('0' & y_i);

    sum_o <= s_sum(31 downto 0);
    carry_o <= s_sum(32);
end architecture;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

-- DEPRECATED BUT FUNCTIONAL

entity ch is
    port(
        x,y,z: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end ch;

entity sum0 is
    port(
        x: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0) 
    );
end sum0;

entity sum1 is
    port(
        x: in bit_vector(31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sum1;

entity maj is
    port(
        x,y,z: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end maj;

architecture arch_ch of ch is
begin
    q <= (x and y) xor (not (x) and z);
end architecture;

architecture arch_sum0 of sum0 is
begin 
    q <= (x ror 2) xor (x ror 13) xor (x ror 22);
end architecture;

architecture arch_sum1 of sum1 is
begin 
    q <= (x ror 6) xor (x ror 11) xor (x ror 25);
end architecture;

architecture arch_maj of maj is
begin 
    q <= (x and y) xor (x and z) xor (y and z);
end architecture;
