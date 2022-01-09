-- =============================================================================================================
--   Name                           :| Ver  :| Author					:| Last Mod. Date 	:| Changes Made:
--   Magnitude to BCD               :| V1.0 :| Robert Jiang			    :| 12/24/2021		:| Added VHDL file
-- =============================================================================================================
--   Description
--   Converts 8-bit unsigned magnitude to 3-digit BCD
-- =============================================================================================================

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity implementation
entity mag_to_bcd3 is 
    
    port (
        MAG : in std_logic_vector(7 downto 0);
        BCD : out std_logic_vector(11 downto 0));

end mag_to_bcd3;

-- architecture implementation
architecture mag_to_bcd3_arch of mag_to_bcd3 is
    
    component signed_to_mag is 
        
        port (
            S : in std_logic_vector(7 downto 0);
            MAG : out std_logic_vector(7 downto 0);
            NEG : out std_logic);

    end component;

    signal BCD2, BCD1, BCD0 : std_logic_vector (3 downto 0);

    signal MAG_mod100, MAG_mod10 : std_logic_vector (7 downto 0);
    
begin

    MAG_mod100 <= std_logic_vector(signed(MAG) mod 100);

    MAG_mod10 <= std_logic_vector(signed(MAG) mod 10);

    BCD2 <= "0000" when ((MAG < "01100100") AND (MAG >= "00000000")) else
            "0001" when ((MAG > "01100011") AND (MAG <= "11000111")) else
            "0010" when ((MAG > "11000111") AND (MAG <= "11111111")) else
            "0000";
    
    BCD1 <= "0000" when ((MAG_mod100 < "00001010") AND (MAG_mod100 >= "00000000")) else
            "0001" when ((MAG_mod100 > "00001001") AND (MAG_mod100 <= "00010011")) else
            "0010" when ((MAG_mod100 > "00010011") AND (MAG_mod100 <= "00011101")) else
            "0011" when ((MAG_mod100 > "00011101") AND (MAG_mod100 <= "00100111")) else
            "0100" when ((MAG_mod100 > "00100111") AND (MAG_mod100 <= "00110001")) else
            "0101" when ((MAG_mod100 > "00110001") AND (MAG_mod100 <= "00111011")) else
            "0110" when ((MAG_mod100 > "00111011") AND (MAG_mod100 <= "01000101")) else
            "0111" when ((MAG_mod100 > "01000101") AND (MAG_mod100 <= "01001111")) else
            "1000" when ((MAG_mod100 > "01001111") AND (MAG_mod100 <= "01011001")) else
            "1001" when ((MAG_mod100 > "01011001") AND (MAG_mod100 <= "01100011")) else
            "0000";

    BCD0 <= MAG_mod10(3 downto 0);

    BCD <= BCD2 & BCD1 & BCD0;

end mag_to_bcd3_arch;