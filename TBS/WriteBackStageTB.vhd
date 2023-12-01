LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY WriteBackStage_tb IS
END WriteBackStage_tb;

ARCHITECTURE behavior OF WriteBackStage_tb IS
    -- Constants
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"0000_0002";
    SIGNAL spsel : STD_LOGIC := '0';
    SIGNAL spoperation : STD_LOGIC := '0';
    SIGNAL wbsrc : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL memdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"DEADBEEF";
    SIGNAL aludata : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"C0FFEEFF";
    SIGNAL portdata : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"ABCDEF01";
    SIGNAL spval : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wbdata : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate the WriteBackStage unit
    UUT : ENTITY work.WriteBackStage
        PORT MAP(
            clk => clk,
            sp => sp,
            spsel => spsel,
            spoperation => spoperation,
            wbsrc => wbsrc,
            memdata => memdata,
            aludata => aludata,
            portdata => portdata,
            spval => spval,
            wbdata => wbdata
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WAIT FOR 5 ns;
        clk <= NOT clk;
    END PROCESS;

    -- Stimulus process
    stimulus : PROCESS
    BEGIN
        -- Test case 1: wbsrc = "00"
        wbsrc <= "00";
        spsel <= '0';
        spoperation <= '0';
        WAIT FOR 10 ns;
        ASSERT wbdata = memdata
        REPORT "Test Case 1 Failed" SEVERITY ERROR;

        -- Test case 2: wbsrc = "01"
        wbsrc <= "01";
        WAIT FOR 10 ns;
        ASSERT wbdata = aludata
        REPORT "Test Case 2 Failed" SEVERITY ERROR;

        -- Test case 3: wbsrc = "10"
        wbsrc <= "10";
        WAIT FOR 10 ns;
        ASSERT wbdata = portdata
        REPORT "Test Case 3 Failed" SEVERITY ERROR;

        wbsrc <= "11";
        WAIT FOR 10 ns;
        ASSERT wbdata = X"00000000"
        REPORT "Test Case 4 Failed" SEVERITY ERROR;

        wbsrc <= "00";
        spsel <= '1';
        spoperation <= '0';
        WAIT FOR 10 ns;
        ASSERT spval = STD_LOGIC_VECTOR(unsigned(sp) - 2)
        REPORT "Test Case 5 Failed" SEVERITY ERROR;

        spoperation <= '1';
        WAIT FOR 10 ns;
        ASSERT spval = STD_LOGIC_VECTOR(unsigned(sp) + 2)
        REPORT "Test Case 6 Failed" SEVERITY ERROR;

        WAIT;

    END PROCESS stimulus;

END behavior;