----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Captures the pixels coming from the OV760 camera and 
--              Stores them in block RAM
----------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity ov7670_capture is
    Port ( pclk  : in   STD_LOGIC;
           vsync : in   STD_LOGIC;
           href  : in   STD_LOGIC;
           d     : in   STD_LOGIC_VECTOR (7 downto 0);
           addr  : out  STD_LOGIC_VECTOR (14 downto 0);
           dout  : out  STD_LOGIC_VECTOR (11 downto 0);
           we    : out  STD_LOGIC);
end ov7670_capture;

architecture Behavioral of ov7670_capture is
   signal d_latch    : std_logic_vector(7 downto 0)  := (others => '0');
   signal href_last  : std_logic;
   signal cnt        : std_logic_vector(1 downto 0)  := (others => '0');
   signal hold_red   : std_logic_vector(3 downto 0)  := (others => '0');
   signal hold_green : std_logic_vector(3 downto 0)  := (others => '0');
   signal hold_blue  : std_logic_vector(3 downto 0)  := (others => '0');
   signal address    : STD_LOGIC_VECTOR(14 downto 0) := (others => '0');
   
begin
   addr <= address;
   process(pclk)
   begin
      if rising_edge(pclk) then
         we   <= '0';

         hold_red   <= d_latch(3 downto 0);
         
         hold_green <= d(7 downto 4);
         hold_blue  <= d(3 downto 0);

         dout <= hold_red & hold_green & hold_blue;
         
         href_last <= href;

         if vsync = '1' then -- Start new frame
            address <= (others => '1'); -- Next: 000000000000000
            href_last <= '0';
            cnt <= "00";
         else
            if href_last = '1' and address /= "100101011111111" then -- address /= last address
               if cnt = "11" then
                  d_latch <= d;
                  address <= std_logic_vector(unsigned(address)+1);
               end if;
               if cnt = "01" then
                  we <= '1';
               end if;
               cnt <= std_logic_vector(unsigned(cnt)+1);
            end if;
         end if;
      end if;
   end process;
end Behavioral;
