-- =============================================================================================================
--   Name                           :| Ver  :| Author					:| Last Mod. Date 	:| Changes Made:
--   2's Complement to Magnitude    :| V1.0 :| Robert Jiang			    :| 12/24/2021		:| Added VHDL file
-- =============================================================================================================
--   Description
--   Converts 8-bit 2's Complement to 8-bit unsigned magnitude with a negative flag bit
-- =============================================================================================================

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity implementation
entity signed_to_mag is 
    
    port (
        S : in std_logic_vector(7 downto 0);
        MAG : out std_logic_vector(7 downto 0);
        NEG : out std_logic);

end signed_to_mag;

-- architecture implementation
architecture signed_to_mag_arch of signed_to_mag is
    
    -- upper and lower BCD nibbles 
    signal U, S_U : std_logic_vector(7 downto 0);

    signal S_S, S_MSB, MAG_S : integer;

begin

    -- ignores sign bit
    S_U <= '0' & S(6 downto 0);
    
    -- converts to integer and takes the absolute value of the difference between S_S and 2^7
    S_S <= to_integer(unsigned(S_U));
    S_MSB <= 2**7;
    MAG_S <= abs(S_S - S_MSB);

    U <= std_logic_vector(to_unsigned(MAG_S, U'length));

    with (S(7)) select
        MAG <=  S_U when '0',
                U when '1',
                "00000000" when others;

    NEG <=  S(7);

end signed_to_mag_arch;