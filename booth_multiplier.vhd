-- =============================================================================================================
--   Name                           :| Ver  :| Author					:| Last Mod. Date 	:| Changes Made:
--   Booth Multiplier               :| V1.0 :| Robert Jiang			    :| 12/26/2021		:| Added VHDL file
-- =============================================================================================================
--   Description
--   Calculates the 8-bit signed product of two 4-bit signed numbers taken as input 
-- =============================================================================================================

-- library declarations
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- entity implementation
entity booth_multiplier is 
    
    port (
        CLK, RESET : in std_logic;
        M, N : in std_logic_vector  (3 downto 0);
        P : out std_logic_vector(7 downto 0));

end booth_multiplier;

-- architecture implementation
architecture booth_multiplier_arch of booth_multiplier is

    -- state enum to simulate HLSM state transitions
    type state_type is (INIT, ADD, SUB, SKIP, SET_P, SHIFT_P, SET_S, RESULT);

    signal PS, NS : state_type := INIT;
    signal next_Z, Z : std_logic_vector(8 downto 0) := "0000" & N & '0';
    signal next_A, A : std_logic_vector(3 downto 0) := "0000";
    signal next_I, I : integer := 4;
    signal next_S, S : std_logic_vector(1 downto 0) := N(0) & '0';

begin

    -- sequential logic : stores output and intermediate values
    seq : process (CLK, RESET, NS) is
    begin

        if (RESET = '1') then

            PS <= INIT;
            
        elsif (rising_edge(CLK)) then
            
            PS <= NS;
            Z <= next_Z;
            A <= next_A;
            I <= next_I;
            
            S <= next_S;
        end if;

    end process seq;

    -- combinational logic : calculates next state, next output, and intermediate values
    comb : process (PS, M, N, Z, A, I, S) is
    begin

        P <= Z(8 downto 1);

        case PS is

            when INIT =>
            
                next_Z <= "0000" & N & '0';
                next_A <= "0000";
                next_I <= 4;
                next_S <= N(0) & '0';

                if (I > 0 AND S = "01") then     
                    NS <= ADD;
                elsif (I > 0 AND S = "10") then 
                    NS <= SUB;
                elsif (I > 0 AND (S = "00" OR S = "11")) then 
                    NS <= SKIP;
                else 
                    NS <= INIT;
                end if;

            when ADD =>

                next_Z <= Z;
                next_A <= std_logic_vector(signed(A) + signed(M));
                next_I <= I;
                next_S <= S;

                NS <= SET_P;

            when SUB =>
                
            next_Z <= Z;
                next_A <= std_logic_vector(signed(A) - signed(M));
                next_I <= I;
                next_S <= S;

                NS <= SET_P;

            when SKIP =>
                
                next_Z <= Z;
                next_A <= A;
                next_I <= I;
                next_S <= S;

                NS <= SET_P;

            when SET_P =>

                next_Z <= A & Z(4 downto 0);
                next_A <= A;
                next_I <= I;
                next_S <= S;

                NS <= SHIFT_P;

            when SHIFT_P =>

                next_Z <= std_logic_vector(shift_right(signed(Z), 1));
                next_A <= A;
                next_I <= I;
                next_S <= S;

                NS <= SET_S;

            when SET_S =>

                next_Z <= Z;
                next_A <= Z(8 downto 5);
                next_I <= I - 1;
                next_S <= Z(1) & Z(0);

                NS <= RESULT;

            when RESULT =>

                next_Z <= Z;
                next_A <= A;
                next_I <= I;
                next_S <= S;

                if (I > 0 AND S = "01") then 
                    NS <= ADD;
                elsif (I > 0 AND S = "10") then 
                    NS <= SUB;
                elsif (I > 0 AND (S = "00" OR S = "11")) then 
                    NS <= SKIP;
                else 
                    NS <= RESULT;
                end if;

            when others =>

                next_Z <= "000000000";
                next_A <= "0000";
                next_I <= 0;
                next_S <= "00";

            end case;

    end process comb;
    
end booth_multiplier_arch;
