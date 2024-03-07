-------------------------------------------------------------------------------
-- Author: Bruno Albertini (balbertini@usp.br)
-- Modified by: Felipe Beserra & Renato Ferreira
-- Module Name: hex2seg
-- Description:
--    VHDL module to convert from hex (4b) to 7-segment
-------------------------------------------------------------------------------
entity hex2seg is
  port ( hex : in  bit_vector(3 downto 0); -- Entrada binaria
         seg : out bit_vector(6 downto 0)  -- Saída hexadecimal
         -- A saída corresponde aos segmentos gfedcba nesta ordem. Cobre
         -- todos valores possíveis de entrada.
      );
end hex2seg;

architecture comportamental of hex2seg is
begin

seg <= -- gfedcba 
  "1000000" when hex = "0000" else --'0'
  "1001111" when hex = "0001" else --'1'
  "0100100" when hex = "0010" else --'2'
  "0110000" when hex = "0011" else --'3'
  "0011001" when hex = "0100" else --'4'
  "0010010" when hex = "0101" else --'5'
  "0000010" when hex = "0110" else --'6'
  "1111000" when hex = "0111" else --'7'
  "0000000" when hex = "1000" else --'8'
  "0010000" when hex = "1001" else --'9'
  "0001000" when hex = "1010" else --'A'
  "0000011" when hex = "1011" else --'B'
  "1000110" when hex = "1100" else --'C'
  "0100001" when hex = "1101" else --'D'
  "0000110" when hex = "1110" else --'E'
  "0001110" when hex = "1111" else --'F'
  "1111111"; --inválido
end comportamental;
