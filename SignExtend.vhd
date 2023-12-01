LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity signExtend is 
    Generic(N : integer := 20); -- N is the length of the input
    Port ( 
        length : in std_logic;
        s_input : in std_logic_vector(N-1 downto 0);
        s_output : out std_logic_vector(31 downto 0)
    );
End signExtend; 

Architecture ArchSignExtended of signExtend is
    Begin
    -- s_output <=  x"0000" & s_input when (s_input(N-1) = '0' and length = '1') 
    -- else x"FFFF" & s_input when (s_input(N-1) = '1' and length = '1') 
    -- else x"000" & s_input when (s_input(N-1) = '0' and length = '0') 
    -- else x"FFF" & s_input when (s_input(N-1) = '1' and length = '0')
    -- else x"000" & s_input;
        
    s_output <= x"0000" & s_input when (s_input(N-1) = '0' and length = '1') 
    else x"FFFF" & s_input when (s_input(N-1) = '1' and length = '1')  
    else x"000" & s_input when (s_input(N-1) = '0' and length = '0') 
    else x"FFF" & s_input when (s_input(N-1) = '1' and length = '0');

    End ArchSignExtended;
