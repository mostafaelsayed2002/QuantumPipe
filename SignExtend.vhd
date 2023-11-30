LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity signExtend is 
    Port ( 
        s_input : in std_logic_vector(15 downto 0);
        s_output : out std_logic_vector(31 downto 0)
    );
End signExtend; 

Architecture ArchSignExtended of signExtend is
    Begin
    s_output <=  x"0000" & s_input when s_input(15) = '0' else x"FFFF" & s_input;
    End ArchSignExtended;
