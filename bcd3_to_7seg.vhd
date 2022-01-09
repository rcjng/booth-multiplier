-- =============================================================================================================
--   Name                           :| Ver  :| Author					:| Last Mod. Date 	:| Changes Made:
--   BCD To 7-Segment               :| V1.0 :| Robert Jiang			    :| 12/25/2021		:| Added VHDL file
-- =============================================================================================================
--   Description
--   Converts 3-digit BCD to 7-Segment on the Altera MAX10 DE10-Lite FPGA 
-- =============================================================================================================

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity implementation
entity bcd3_to_7seg is 

    port (
        BCD : in std_logic_vector(11 downto 0);
        NEG : in std_logic;
        HEX0, HEX1, HEX2, HEX3 : out std_logic_vector(7 downto 0));

end bcd3_to_7seg;

-- architecture implementation
architecture bcd3_to_7seg_arch of bcd3_to_7seg is 

    signal BCD0, BCD1, BCD2 : std_logic_vector(3 downto 0);

begin
    
    BCD2 <= BCD(11 downto 8);
    BCD1 <= BCD(7 downto 4);
    BCD0 <= BCD(3 downto 0);

    with NEG select

        -- 7-segment is active low
        HEX3 <= "11111111" when '0',
                "10111111" when '1',
                "11111111" when others;

    with BCD2 select

        -- 7-segment is active low
        HEX2 <= "11000000" when "0000",
                "11111001" when "0001",
                "10100100" when "0010",
                "10110000" when "0011",
                "10011001" when "0100",
                "10010010" when "0101",
                "10000010" when "0110",
                "11111000" when "0111",
                "10000000" when "1000",
                "10010000" when "1001",
                "11111111" when others;


    with BCD1 select
    
        -- 7-segment is active low
        HEX1 <= "11000000" when "0000",
                "11111001" when "0001",
                "10100100" when "0010",
                "10110000" when "0011",
                "10011001" when "0100",
                "10010010" when "0101",
                "10000010" when "0110",
                "11111000" when "0111",
                "10000000" when "1000",
                "10010000" when "1001",
                "11111111" when others;

    with BCD0 select
        
        -- 7-segment is active low
        HEX0 <= "11000000" when "0000",
                "11111001" when "0001",
                "10100100" when "0010",
                "10110000" when "0011",
                "10011001" when "0100",
                "10010010" when "0101",
                "10000010" when "0110",
                "11111000" when "0111",
                "10000000" when "1000",
                "10010000" when "1001",
                "11111111" when others;

end bcd3_to_7seg_arch;