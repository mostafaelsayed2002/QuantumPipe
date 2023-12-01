LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Reg IS
    GENERIC (n : integer := 64);
    PORT (
        Clk : IN std_logic;
        Input : IN std_logic_vector(n-1 DOWNTO 0);
        Output : OUT std_logic_vector(n-1 DOWNTO 0);
        Rst : IN std_logic
    );
END ENTITY Reg;

ARCHITECTURE ARCH_Reg OF Reg IS
BEGIN
    PROCESS (Clk, Rst)
    BEGIN
        IF Rst = '1' THEN
            Output <= (OTHERS => '0');
        ELSIF rising_edge(Clk) THEN
            Output <= Input;
        END IF;
    END PROCESS;
END ARCH_Reg;
