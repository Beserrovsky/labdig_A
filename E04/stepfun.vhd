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
        ai, bi, ci, di, ei, fi, gi, hi :  in bit_vector(31 downto 0);
        kpw :                             in bit_vector(31 downto 0);
        ao, bo, co, do, eo, fo, go, ho : out bit_vector(31 downto 0)
    );
end entity;

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
    
    component somador is 
    	port (
    		x :        in bit_vector(31 downto 0);
    		carry_in : in bit := '0';
            y :       out bit_vector(31 downto 0);
            q :       out bit_vector(31 downto 0)
    	); 
    end component;
    
    -- comum aas duas saidas
    signal sum_ei, ch_c, hi_soma_kpw, scomum1, scomum2, comum: bit_vector(31 downto 0); 
    
    -- somas que formam o e0
    signal e0f: bit_vector(31 downto 0); 
    
    -- somas que formam o a0
    signal a0maj, a0sum0, s1a0, a0f: bit_vector(31 downto 0); 
    begin
        -- calculo do termo em comum
        CHcomum: ch port map(ei, fi, gi, ch_c);
        sum1comum: sum1 port map(ei, sum_ei);
        somacomum1: somador port map(x=>hi, y=>kpw, q=>scomum1);
        somacomum2: somador port map(x=>sum_ei, y=>ch_c, q=>scomum2);
        somacomum: somador port map(x=>scomum1, y=>scomum2, q=>comum);
        -- calculo de e0:
        somae0: somador port map(x=>di, y=>comum, q=>e0f);
        -- calculo de a0:
        sum0a0: sum0 port map(ai, a0sum0);
        maja0: maj port map(ai, bi, ci, a0maj);
        soma1a0: somador port map(x=>a0maj, y=>a0sum0, q=>s1a0);
        somaa0: somador port map(x=>s1a0, y=>comum, q=>a0f);

        eo <= e0f;
        ao <= a0f;
        bo <= ai;
        co <= bi;
        do <= ci;
        fo <= ei;
        go <= fi;
        ho <= gi;
end architecture;
