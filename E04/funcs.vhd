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

entity sigma0 is
    port(
        x: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sigma0;

entity sigma1 is
    port(
        x: in bit_vector (31 downto 0);
        q: out bit_vector (31 downto 0)
    );
end sigma1;

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

architecture arch_sigma0 of sigma0 is
begin
    q <= (x ror 7) xor (x ror 18) xor (x srl 3);
end architecture;

architecture arch_sigma1 of sigma1 is
begin 
    q <= (x ror 17) xor (x ror 19) xor (x srl 10);
end architecture;
