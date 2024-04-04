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
-- unit name: Step Function (stepfun)
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
-------------------------------------------------------------------------------
--! @todo <Etender stepfun> \n
-------------------------------------------------------------------------------

entity stepfun is
    port (
        ai, bi, ci, di, ei, fi, gi, hi :  in  bit_vector(31 downto 0); 
        kpw                            :  in  bit_vector(31 downto 0);
        ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
    );
end stepfun;

architecture stepfun_arch of stepfun is

    component ch is 
        port (
            x, y, z : in bit_vector(31 downto 0);
            q :      out bit_vector(31 downto 0)
        );
    end component;
    
    component maj is 
        port (
            x, y, z : in bit_vector (31 downto 0);
            q :      out bit_vector (31 downto 0)
        );
    end component;
    
    component sum0 is 
        port (
            x :  in bit_vector(31 downto 0);
            q : out bit_vector(31 downto 0)
        );
    end component;
    
    component sum1 is 
        port (
            x :  in bit_vector(31 downto 0);
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
