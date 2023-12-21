LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBackStage IS
    PORT (
        wbsrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0); --
        memdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        aludata : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --
        wbdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')--
    );
END WriteBackStage;
ARCHITECTURE WriteBackStageArch OF WriteBackStage IS

BEGIN
    WITH (wbsrc) SELECT
    wbdata <= memdata WHEN "00",
        aludata WHEN "01",
        (OTHERS => '0') WHEN OTHERS;

END WriteBackStageArch; -- WriteBackStage