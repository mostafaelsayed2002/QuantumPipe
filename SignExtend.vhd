LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY signExtend IS
    GENERIC (N : INTEGER := 20); -- N is the length of the input
    PORT (
        length : IN STD_LOGIC;
        s_input : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        s_output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END signExtend;

ARCHITECTURE ArchSignExtended OF signExtend IS
BEGIN
    -- s_output <=  x"0000" & s_input when (s_input(N-1) = '0' and length = '1') 
    -- else x"FFFF" & s_input when (s_input(N-1) = '1' and length = '1') 
    -- else x"000" & s_input when (s_input(N-1) = '0' and length = '0') 
    -- else x"FFF" & s_input when (s_input(N-1) = '1' and length = '0')
    -- else x"000" & s_input;

    s_output <= x"0000" & s_input WHEN (s_input(N - 1) = '0' AND length = '1')
        ELSE
        x"FFFF" & s_input WHEN (s_input(N - 1) = '1' AND length = '1')
        ELSE
        x"000" & s_input WHEN (s_input(N - 1) = '0' AND length = '0')
        ELSE
        x"FFF" & s_input WHEN (s_input(N - 1) = '1' AND length = '0');

END ArchSignExtended;