entity stepfuntb is 
end entity;

architecture stepfuntb_arch of stepfuntb is
    component stepfun is
        port(
            ai, bi, ci, di, ei, fi, gi, hi: in bit_vector(31 downto 0);
            kpw: in bit_vector(31 downto 0);
            ao, bo, co, do, eo, fo, go, ho: out bit_vector(31 downto 0)
        );
    end component;
    signal sig_ai, sig_bi, sig_ci, sig_di, sig_ei, sig_fi, sig_gi, sig_hi, sig_kpw : bit_vector(31 downto 0);
    signal sig_ao, sig_bo, sig_co, sig_do, sig_eo, sig_fo, sig_go, sig_ho: bit_vector(31 downto 0);
    begin
        DUT: stepfun port map(sig_ai, sig_bi, sig_ci, sig_di, sig_ei, sig_fi, sig_gi, sig_hi, sig_kpw, sig_ao, sig_bo, sig_co, sig_do, sig_eo, sig_fo, sig_go, sig_ho);
        process is
            begin
                assert false report "simulation start" severity note;

                assert false report "TESTE 1" severity note; -- TUDO 1

                sig_ai <= "11111111111111111111111111111111";
                sig_bi <= "11111111111111111111111111111111";
                sig_ci <= "11111111111111111111111111111111";
                sig_di <= "11111111111111111111111111111111";
                sig_ei <= "11111111111111111111111111111111";
                sig_fi <= "11111111111111111111111111111111";
                sig_gi <= "11111111111111111111111111111111";
                sig_hi <= "11111111111111111111111111111111";
                sig_kpw <= "11111111111111111111111111111111";
                wait for 1 ns;
                assert (sig_ao /= "11111111111111111111111111111010") report "OK ao 1/5" severity note;
                assert (sig_bo /= "11111111111111111111111111111111") report "OK bo 1/5" severity note;
                assert (sig_co /= "11111111111111111111111111111111") report "OK co 1/5" severity note;
                assert (sig_do /= "11111111111111111111111111111111") report "OK do 1/5" severity note;
                assert (sig_eo /= "11111111111111111111111111111011") report "OK eo 1/5" severity note;
                assert (sig_fo /= "11111111111111111111111111111111") report "OK fo 1/5" severity note;
                assert (sig_go /= "11111111111111111111111111111111") report "OK go 1/5" severity note;
                assert (sig_ho /= "11111111111111111111111111111111") report "OK ho 1/5" severity note;

                assert false report "TESTE 2" severity note; -- TUDO 0
                
                sig_ai <= "00000000000000000000000000000000";
                sig_bi <= "00000000000000000000000000000000";
                sig_ci <= "00000000000000000000000000000000";
                sig_di <= "00000000000000000000000000000000";
                sig_ei <= "00000000000000000000000000000000";
                sig_fi <= "00000000000000000000000000000000";
                sig_gi <= "00000000000000000000000000000000";
                sig_hi <= "00000000000000000000000000000000";
                sig_kpw <= "00000000000000000000000000000000";
                wait for 1 ns;
                assert (sig_ao /= "00000000000000000000000000000000") report "OK ao 2/5" severity note;
                assert (sig_bo /= "00000000000000000000000000000000") report "OK bo 2/5" severity note;
                assert (sig_co /= "00000000000000000000000000000000") report "OK co 2/5" severity note;
                assert (sig_do /= "00000000000000000000000000000000") report "OK do 2/5" severity note;
                assert (sig_eo /= "00000000000000000000000000000000") report "OK eo 2/5" severity note;
                assert (sig_fo /= "00000000000000000000000000000000") report "OK fo 2/5" severity note;
                assert (sig_go /= "00000000000000000000000000000000") report "OK go 2/5" severity note;
                assert (sig_ho /= "00000000000000000000000000000000") report "OK ho 2/5" severity note;

                assert false report "TESTE 3" severity note; -- Palavra de entrada: 00001111

                sig_ai <= "00001111000011110000111100001111";
                sig_bi <= "00001111000011110000111100001111";
                sig_ci <= "00001111000011110000111100001111";
                sig_di <= "00001111000011110000111100001111";
                sig_ei <= "00001111000011110000111100001111";
                sig_fi <= "00001111000011110000111100001111";
                sig_gi <= "00001111000011110000111100001111";
                sig_hi <= "00001111000011110000111100001111";
                sig_kpw <= "00001111000011110000111100001111";
                wait for 1 ns;
                assert (sig_ao /= "00011110000111100001111000011101") report "OK ao 3/5" severity note;
                assert (sig_bo /= "00001111000011110000111100001111") report "OK bo 3/5" severity note;
                assert (sig_co /= "00001111000011110000111100001111") report "OK co 3/5" severity note;
                assert (sig_do /= "00001111000011110000111100001111") report "OK do 3/5" severity note;
                assert (sig_eo /= "10010110100101101001011010010110") report "OK eo 3/5" severity note;
                assert (sig_fo /= "00001111000011110000111100001111") report "OK fo 3/5" severity note;
                assert (sig_go /= "00001111000011110000111100001111") report "OK go 3/5" severity note;
                assert (sig_ho /= "00001111000011110000111100001111") report "OK ho 3/5" severity note;

                assert false report "TESTE 4" severity note; -- Palavra de entrada: 11110000

                sig_ai <= "11110000111100001111000011110000";
                sig_bi <= "11110000111100001111000011110000";
                sig_ci <= "11110000111100001111000011110000";
                sig_di <= "11110000111100001111000011110000";
                sig_ei <= "11110000111100001111000011110000";
                sig_fi <= "11110000111100001111000011110000";
                sig_gi <= "11110000111100001111000011110000";
                sig_hi <= "11110000111100001111000011110000";
                sig_kpw <= "11110000111100001111000011110000";
                wait for 1 ns;
                assert (sig_ao /= "11100001111000011110000111011101") report "OK ao 4/5" severity note;
                assert (sig_bo /= "11110000111100001111000011110000") report "OK bo 4/5" severity note;
                assert (sig_co /= "11110000111100001111000011110000") report "OK co 4/5" severity note;
                assert (sig_do /= "11110000111100001111000011110000") report "OK do 4/5" severity note;
                assert (sig_eo /= "01101001011010010110100101100101") report "OK eo 4/5" severity note;
                assert (sig_fo /= "11110000111100001111000011110000") report "OK fo 4/5" severity note;
                assert (sig_go /= "11110000111100001111000011110000") report "OK go 4/5" severity note;
                assert (sig_ho /= "11110000111100001111000011110000") report "OK ho 4/5" severity note;

                assert false report "TESTE 5" severity note; -- Palavra de entrada: 11000111

                sig_ai <= "11000111110001111100011111000111";
                sig_bi <= "11000111110001111100011111000111";
                sig_ci <= "11000111110001111100011111000111";
                sig_di <= "11000111110001111100011111000111";
                sig_ei <= "11000111110001111100011111000111";
                sig_fi <= "11000111110001111100011111000111";
                sig_gi <= "11000111110001111100011111000111";
                sig_hi <= "11000111110001111100011111000111";
                sig_kpw <= "11000111110001111100011111000111";
                wait for 1 ns;
                assert (sig_ao /= "11110011111100111111001111110000") report "OK ao 5/5" severity note;
                assert (sig_bo /= "11000111110001111100011111000111") report "OK bo 5/5" severity note;
                assert (sig_co /= "11000111110001111100011111000111") report "OK co 5/5" severity note;
                assert (sig_do /= "11000111110001111100011111000111") report "OK do 5/5" severity note;
                assert (sig_eo /= "00100011001000110010001100100000") report "OK eo 5/5" severity note;
                assert (sig_fo /= "11000111110001111100011111000111") report "OK fo 5/5" severity note;
                assert (sig_go /= "11000111110001111100011111000111") report "OK go 5/5" severity note;
                assert (sig_ho /= "11000111110001111100011111000111") report "OK ho 5/5" severity note;

        wait;
        end process;
        end architecture;
