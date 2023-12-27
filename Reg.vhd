LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Reg IS
    GENERIC (n : INTEGER := 64);
    PORT (
        Clk : IN STD_LOGIC;
        Input : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Output : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0) := (OTHERS => '0');
        reset : IN STD_LOGIC;
        Fix : IN STD_LOGIC;
        isWb : IN STD_LOGIC
    );
END ENTITY Reg;

ARCHITECTURE ARCH_Reg OF Reg IS
BEGIN
    PROCESS (Clk, reset)
    BEGIN
        IF isWb = '1' THEN
            IF reset = '1' THEN
                Output <= (OTHERS => '0');
            ELSIF Fix = '0' THEN
                IF falling_edge(Clk) THEN
                    Output <= Input;
                END IF;
            END IF;
        ELSE
            IF reset = '1' THEN
                Output <= (OTHERS => '0');
            ELSIF Fix = '0' THEN
                IF rising_edge(Clk) THEN
                    Output <= Input;
                END IF;
            END IF;
        END IF;

        IF reset = '1' THEN
            Output <= (OTHERS => '0');
        ELSIF Fix = '0' THEN
            IF rising_edge(Clk) THEN
                Output <= Input;
            END IF;
        END IF;
    END PROCESS;
END ARCH_Reg;