ENTITY FetchingStage IS
    PORT (
        clk : IN STD_LOGIC;
        fixpc : IN STD_LOGIC; -- hazard detection
        jmpflag : IN STD_LOGIC; -- control unit
        jmplocation : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        pcval : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        instr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

    );
END FetchingStage;

ARCHITECTURE FetchingStageArch OF FetchingStage IS
    SIGNAL pc : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    instrmem : ENTITY work.InstructionMemory
        PORT MAP(
            clk <= clk,
            addr <= pc,
            insout <= instr,
        );

    PROCESS (clk)
        VARIABLE pcaddoperand : INTEGER := 0;
        VARIABLE nextpc : STD_LOGIC_VECTOR(31 DOWNTO 0) := 0;
    BEGIN
        IF rising_edge(clk) THEN

            IF fixpc = '1' THEN
                nextpc := STD_LOGIC_VECTOR(to_integer(unsigned(pc)) + 1);
            ELSE
                nextpc := pc;
            END IF;

            IF jmpflag = '1' THEN
                pc <= jmplocation;
            ELSE
                pc <= nextpc;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE; -- FetchingStageArch