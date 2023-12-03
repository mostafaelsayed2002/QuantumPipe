LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY FetchingStage IS
    PORT (
        clk : IN STD_LOGIC;
        fixpc : IN STD_LOGIC; -- hazard detection
        jmpflag : IN STD_LOGIC; -- control unit
        jmplocation : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        pcval : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        instr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')

    );
END FetchingStage;

ARCHITECTURE FetchingStageArch OF FetchingStage IS
    SIGNAL pc : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL insout : STD_LOGIC_VECTOR(15 DOWNTO 0);

    COMPONENT InstructionMemory
        PORT (
            clk : IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            insout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    instrmem : ENTITY work.InstructionMemory
        PORT MAP(
            clk => clk,
            pc => pc,
            insout => insout
        );

    PROCESS (clk)
        VARIABLE pcaddoperand : INTEGER := 0;
        VARIABLE nextpc : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF rising_edge(clk) THEN

            IF fixpc = '1' THEN
                nextpc := pc;
            ELSE
                nextpc := pc;
                nextpc := STD_LOGIC_VECTOR((unsigned(nextpc)) + 1);
            END IF;

            IF jmpflag = '0' THEN
                pc <= nextpc;
            ELSE
                pc <= jmplocation;
            END IF;

            pcval <= nextpc;

        END IF;
    END PROCESS;
    instr <= insout;
END ARCHITECTURE; -- FetchingStageArch