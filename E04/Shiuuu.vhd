-- Um milagre

library ieee;
use ieee.numeric_bit.all;

entity stepfun is
	port (ai, bi, ci, di, ei, fi, gi, hi : in  bit_vector(31 downto 0); 
			kpw     							    : in  bit_vector(31 downto 0);
			ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
	);
end stepfun;

architecture arch of stepfun is

	component somadorNbits is
		generic (
				N		: positive := 32
		);
		port (a	 	: in  bit_vector(N-1 downto 0);
				b  	: in  bit_vector(N-1 downto 0);
				cin   : in  bit;
				s		: out bit_vector(N-1 downto 0);
				cout	: out bit
		);
	end component;

	component ch is
		 port ( x, y, z : in  bit_vector(31 downto 0);
				  q       : out bit_vector(31 downto 0)  
			  );
	end component;

	component maj is
		 port ( x, y, z : in  bit_vector(31 downto 0);
				  q       : out bit_vector(31 downto 0)  
			  );
	end component;	
	
	component sum0 is
		 port ( x : in  bit_vector(31 downto 0);
				  q : out bit_vector(31 downto 0)  
			  );
	end component;

	component sum1 is
		 port ( x : in  bit_vector(31 downto 0);
				  q : out bit_vector(31 downto 0)  
			  );
	end component;

	signal somaAux: unsigned(31 downto 0);
	signal ch_out, maj_out, sum0_out, sum1_out: bit_vector(31 downto 0);
	
begin

	ch0:   ch   port map(ei, fi, gi, ch_out);
	maj0:  maj  port map(ai, bi, ci, maj_out);
	sum00: sum0 port map(ai, sum0_out);
	sum10: sum1 port map(ei, sum1_out);
	
	somaAux <= unsigned(sum1_out) + unsigned(ch_out) + unsigned(hi) + unsigned(kpw);
	
	eo <= bit_vector(somaAux + unsigned(di));
	ao <= bit_vector(somaAux + unsigned(maj_out) + unsigned(sum0_out));

	-- As outras saidas corresspondem ao elemento anterior das entradas
	bo <= ai;
	co <= bi;
	do <= ci;
	fo <= ei;
	go <= fi;
	ho <= gi;
	
end architecture;

entity ch is
    port ( x, y, z : in  bit_vector(31 downto 0);
           q       : out bit_vector(31 downto 0)  
        );
end ch;

architecture arch of ch is
begin
	q <= (x and y) xor (not(x) and z);
end architecture;

component somadorNbits is
		generic (
				N		: positive := 32
		);
		port (a	 	: in  bit_vector(N-1 downto 0);
				b  	: in  bit_vector(N-1 downto 0);
				cin   : in  bit;
				s		: out bit_vector(N-1 downto 0);
				cout	: out bit
		);
	end component;

	entity maj is
    port ( x, y, z : in  bit_vector(31 downto 0);
           q       : out bit_vector(31 downto 0)  
        );
end maj;

architecture arch of maj is
begin
	q <= (x and y) xor (x and z) xor (y and z);
end architecture;

entity sum0 is
    port ( x : in  bit_vector(31 downto 0);
           q : out bit_vector(31 downto 0)  
        );
end sum0;

architecture arch of sum0 is
begin
	q <= (x(1 downto 0)  & x(31 downto 2)) xor	-- rotr^2(x)
		  (x(12 downto 0) & x(31 downto 13)) xor  -- rotr^13(x)
		  (x(21 downto 0) & x(31 downto 22));		-- rotr^22(x)
end architecture;

entity sum1 is
    port ( x : in  bit_vector(31 downto 0);
           q : out bit_vector(31 downto 0)  
        );
end sum1;

architecture arch of sum1 is
begin
	q <= (x(5 downto 0)  & x(31 downto 6)) xor	-- rotr^6(x)
		  (x(10 downto 0) & x(31 downto 11)) xor  -- rotr^11(x)
		  (x(24 downto 0) & x(31 downto 25));		-- rotr^25(x)
end architecture;

entity sigma0 is
    port ( x : in  bit_vector(31 downto 0);
           q : out bit_vector(31 downto 0)  
        );
end sigma0;

architecture arch of sigma0 is
begin
	q <= (x(6 downto 0)  & x(31 downto 7)) xor	-- rotr^7(x)
		  (x(17 downto 0) & x(31 downto 18)) xor  -- rotr^18(x)
		  ("000"          & x(31 downto 3));		-- shr^3(x)
end architecture;

entity sigma1 is
    port ( x : in  bit_vector(31 downto 0);
           q : out bit_vector(31 downto 0)  
        );
end sigma1;

architecture arch of sigma1 is
begin
	q <= (x(16 downto 0) & x(31 downto 17)) xor	-- rotr^17(x)
		  (x(18 downto 0) & x(31 downto 19)) xor  -- rotr^19(x)
		  ("0000000000"   & x(31 downto 10));		-- shr^10(x)
end architecture;
