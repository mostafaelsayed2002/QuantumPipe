LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBackStage IS
    PORT (
        clk : IN STD_LOGIC; --
        sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        spsel : IN STD_LOGIC; --
        spoperation : IN STD_LOGIC; --
        wbsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --
        memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        aludata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        portdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        spval : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --
        wbdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) --
    );
END WriteBackStage;
ARCHITECTURE WriteBackStageArch OF WriteBackStage IS

BEGIN
    PROCESS (clk)
        VARIABLE sphelper : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN

        IF rising_edge(clk) THEN

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

            IF spsel = '1' THEN
                sphelper := sp;
                IF spoperation = '0' THEN
                    sphelper := STD_LOGIC_VECTOR(UNSIGNED(sphelper) - 2);
                ELSE
                    sphelper := STD_LOGIC_VECTOR(UNSIGNED(sphelper) + 2);
                END IF;
                spval <= sphelper;
            END IF;

        END IF;
    END PROCESS;

END WriteBackStageArch; -- WriteBackStage