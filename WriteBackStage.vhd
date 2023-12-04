LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBackStage IS
    PORT (
        wbsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --
        memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        aludata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        portdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        wbdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')--
    );
END WriteBackStage;
ARCHITECTURE WriteBackStageArch OF WriteBackStage IS

BEGIN
    PROCESS (wbsrc, memdata, aludata, portdata)
    BEGIN
        CASE to_integer(unsigned(wbsrc)) IS
            WHEN 0 =>
                wbdata <= memdata;
            WHEN 1 =>
                wbdata <= aludata;
            WHEN 2 =>
                wbdata <= portdata;
            WHEN OTHERS =>
                wbdata <= X"0000_0000";
        END CASE;

    END PROCESS;

END WriteBackStageArch; -- WriteBackStage