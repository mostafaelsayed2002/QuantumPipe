LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Adder_Subtractor IS
    PORT (
        Operation_Sel : IN STD_LOGIC; -- 1 Subractor , 0 Adder
        Input1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Input2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        Enable : IN STD_LOGIC; -- 0 diabled , 1 enabled
        Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY Adder_Subtractor;

ARCHITECTURE Adder_SubtractorArch OF Adder_Subtractor IS
BEGIN
    PROCESS (Operation_Sel, Input1, Input2, Enable)
    BEGIN
        IF (Enable = '1') THEN
            CASE Operation_Sel IS
                WHEN '0' =>
                    Result <= STD_LOGIC_VECTOR(unsigned(Input1) + unsigned(Input2));

                WHEN OTHERS =>
                    Result <= STD_LOGIC_VECTOR(unsigned(Input1) - unsigned(Input2));
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE Adder_SubtractorArch;