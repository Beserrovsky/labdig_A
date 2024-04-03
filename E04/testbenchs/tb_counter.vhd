-----------------------------------------------------------------------
-- Test Bench for counter (ESD figure 2.6)
-- by Weijun Zhang, 04/2001
-----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;			 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counter_TB is			-- entity declaration
end counter_TB;

-----------------------------------------------------------------------

architecture TB of counter_TB is

	component contador is 
    port (
        clk_i, rst_i, en_i   :  in bit; -- clock, reset, enable
        counter_o            : out integer range 0 to 63 -- 64 valores
    );
	end component;

    signal T_clock:     bit;
    signal T_clear:     bit;
    signal T_count:     bit;
    signal T_Q:         integer range 0 to 63;

begin
    
    U_counter: contador port map (T_clock, T_clear, T_count, T_Q);
	
    process				 
    begin
	T_clock <= '0';			-- clock cycle is 10 ns
	wait for 5 ns;
	T_clock <= '1';
	wait for 5 ns;
    end process;
	
    process

	variable err_cnt: integer :=0;

    begin								
			
	T_clear <= '1';			-- start counting
	T_count <= '1';
	wait for 20 ns;	
		
	T_clear <= '0';			-- clear output
		
	-- test case 1
	wait for 10 ns;
	assert (T_Q=1) report "Failed case 1" severity error;
	if (T_Q/=1) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 2
	wait for 10 ns;
	assert (T_Q=2) report "Failed case 2" severity error;	
	if (T_Q/=2) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 3
	wait for 10 ns;
	assert (T_Q=3) report "Failed case 3" severity error;
	if (T_Q/=3) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 4
	wait for 10 ns;
	assert (T_Q=0) report "Failed case 4" severity error;
	if (T_Q/=0) then
	    err_cnt := err_cnt+1;
	end if;
			
	-- test case 5
	wait for 20 ns;	
	T_clear <= '1';
	wait for 10 ns;
	assert (T_Q=0) report "Failed case 5" severity error;
	if (T_Q/=0) then
	    err_cnt := err_cnt+1;
	end if;
			
       	-- summary of all the tests
	if (err_cnt=0) then 			
	    assert false 
	    report "Testbench of Counter completed successfully!" 
	    severity note; 
	else 
	    assert true 
	    report "Something wrong, try again" 
	    severity error; 
	end if; 
		
	wait;
		
    end process;

end TB;

----------------------------------------------------------------
configuration CFG_TB of counter_TB is
	for TB
	end for;
end CFG_TB;
----------------------------------------------------------------