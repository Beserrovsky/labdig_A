----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Generate analog 800x600 VGA, double-doublescanned from 19200 bytes of RAM (160x120)
--
----------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;

entity vga is
    Port ( 
      clk50       : in  STD_LOGIC;
      vga_red     : out STD_LOGIC_VECTOR(2 downto 0);
      vga_green   : out STD_LOGIC_VECTOR(2 downto 0);
      vga_blue    : out STD_LOGIC_VECTOR(2 downto 1);
      vga_hsync   : out STD_LOGIC;
      vga_vsync   : out STD_LOGIC;
      frame_addr  : out STD_LOGIC_VECTOR(14 downto 0);
      frame_pixel : in  STD_LOGIC_VECTOR(7 downto 0)
    );
end vga;

architecture Behavioral of vga is
   -- Timing constants
   constant hRez       : natural := 800; 
   constant vRez       : natural := 600; 

   constant hMaxCount  : natural := 1040; --1056; timings alterados de acordo com o protocolo
   constant hStartSync : natural := 856; --840;  timings alterados de acordo com o protocolo
   constant hEndSync   : natural := 976; --968;  timings alterados de acordo com o protocolo

   constant vMaxCount  : natural := 666; --628; timings alterados de acordo com o protocolo 
   constant vStartSync : natural := 637; --601; timings alterados de acordo com o protocolo 
   constant vEndSync   : natural := 643; --605; timings alterados de acordo com o protocolo 
   constant hsync_active : std_logic := '1';
   constant vsync_active : std_logic := '1';

   signal hCounter : unsigned(10 downto 0) := (others => '0');
   signal vCounter : unsigned(9 downto 0) := (others => '0');
   signal address : unsigned(16 downto 0) := (others => '0');
   signal blank : std_logic := '1';

begin
   frame_addr <= std_logic_vector(address(16 downto 2)); --recebe somente 15 bits
   --2 ultimos bits para contagem?
   --pede 4*address, pede de 4 em 4 (visto que o address so é incrementado 1 vez por clock) 
   --frame_addr = 0 ate 160
   --160 enderecos?
   
   process(clk50)
   begin
      if rising_edge(clk50) then
         -- Count the lines and rows      
         if hCounter = hMaxCount-1 then
            hCounter <= (others => '0');
            if vCounter = vMaxCount-1 then
               vCounter <= (others => '0');
            else
               vCounter <= vCounter+1;
            end if;
         else
            hCounter <= hCounter+1;
         end if;

         if blank = '0' then --caso o contandor estiver na regiao da imagem
            vga_red   <= frame_pixel(7 downto 5);
            vga_green <= frame_pixel(4 downto 2);
            vga_blue  <= frame_pixel(1 downto 0);
         else --fora da regiao da imagem
            vga_red   <= (others => '0');
            vga_green <= (others => '0');
            vga_blue  <= (others => '0');
         end if;
   
         if vCounter  >= vRez then 
            address <= (others => '0');
            blank <= '1';
         else  
         --SOMENTE 640 PIXELS SAO SALVOS NA RAM?
         --porem existem 15 enderecos -> 32 768 bytes/pixels podem ser salvos
            if hCounter  >= 80 and hCounter  < 720 then --regiao da imagem?  640 pixels
               blank <= '0';
               if hCounter = 719 then
                  if vCounter(1 downto 0) /= "11" then --se nao for do tipo 4n-1? (3, 7, 11, 15)
                  --A CADA 4 LINHAS A RAM EH "RESETADA", ENTAO OS VOLTA A LER OS ENDERECOS DO 0?
                     address <= address - 639; --639 = 4x160 - 1  subtrai 639 do endereco(640 numero maximo de pixels?)
                  else --caso o "bloco" de ram ainda nao foi terminado de ser lido
                      address <= address+1;
                  end if;
               else --fora da regiao da imagem, soma o endereco de leitura (prox pixel)
                  address <= address+1;
               end if;
            else -- nao esta na regiao da imagem
               blank <= '1';
            end if;
         end if;
   
         -- Are we in the hSync pulse? (one has been added to include frame_buffer_latency)
         if hCounter > hStartSync and hCounter <= hEndSync then
            vga_hSync <= hsync_active;
         else
            vga_hSync <= not hsync_active;
         end if;

         -- Are we in the vSync pulse?
         if vCounter >= vStartSync and vCounter < vEndSync then
            vga_vSync <= vsync_active;
         else
            vga_vSync <= not vsync_active;
         end if;
      end if;
   end process;
end Behavioral;
