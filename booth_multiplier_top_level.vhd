-- =============================================================================================================
--   Name                           :| Ver  :| Author					:| Last Mod. Date 	:| Changes Made:
--   Booth Multiplier Top Level     :| V1.0 :| Robert Jiang			    :| 12/27/2021		:| Added VHDL file
-- =============================================================================================================
--   Description
--   Calculates and outputs the product of two 4-bit signed numbers on 4-display 7-segment
-- =============================================================================================================

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity implementation
entity booth_multiplier_top_level is
     
    port(
        CLK, RESET : in std_logic;
        M, N : in std_logic_vector(3 downto 0);
        HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(7 downto 0));

end booth_multiplier_top_level;

-- architecture implementation
architecture booth_multiplier_top_level_arch of booth_multiplier_top_level is

    -- booth multiplier component
    component booth_multiplier is 
        
        port (
            CLK, RESET : in std_logic;
            M, N : in std_logic_vector(3 downto 0);
            P : out std_logic_vector(7 downto 0));

    end component;

    -- signed 8-bit to 8-bit unsigned magnitude with negative flag bit component
    component signed_to_mag is 
        
        port (
            S : in std_logic_vector (7 downto 0);
            MAG : out std_logic_vector(7 downto 0);
            NEG : out std_logic);

    end component;

    -- unsigned 8-bit magnitude to 3-digit BCD component
    component mag_to_bcd3 is 
        
        port (
            MAG : in std_logic_vector(7 downto 0);
            BCD : out std_logic_vector(11 downto 0));

    end component;

    -- 3-digit BCD to 4-display 7-segment component
    component bcd3_to_7seg is 

        port (
            BCD : in std_logic_vector(11 downto 0);
            NEG : in std_logic;
            HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(7 downto 0));
            
    end component;

    signal P, MAG : std_logic_vector(7 downto 0);
    signal BCD : std_logic_vector(11 downto 0);
    signal NEG : std_logic;

begin

    multiply : booth_multiplier port map (CLK => CLK, RESET => RESET, M => M, N => N, P => P);

    to_mag : signed_to_mag port map (S => P, MAG => MAG, NEG => NEG);

    to_bcd3 : mag_to_bcd3 port map (MAG => MAG, BCD => BCD);

    to_7seg : bcd3_to_7seg port map (BCD => BCD, NEG => NEG, HEX0 => HEX0, HEX1 => HEX1, HEX2 => HEX2, HEX3 => HEX3);
    
end booth_multiplier_top_level_arch;