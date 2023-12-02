LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode_Stage_Testbench IS
END ENTITY Decode_Stage_Testbench;

ARCHITECTURE tb_arch OF Decode_Stage_Testbench IS
    -- Constants
    CONSTANT CLOCK_PERIOD : TIME := 10 ns;

    -- Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL Instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB1_Address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB2_Address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB1_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB2_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB1_Signal : STD_LOGIC := '0';
    SIGNAL WB2_Signal : STD_LOGIC := '0';
    SIGNAL Data_R1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Data_R2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL jmp_Flag : STD_LOGIC;
    SIGNAL Zero_Flag : STD_LOGIC;

BEGIN
    -- Instantiate the Decode_Stage component
    UUT : ENTITY work.Decode_Stage
        PORT MAP(
            Clk => clk,
            Instruction => Instruction,
            WB1_Address => WB1_Address,
            WB2_Address => WB2_Address,
            WB1_data => WB1_data,
            WB2_data => WB2_data,
            WB1_Signal => WB1_Signal,
            WB2_Signal => WB2_Signal,
            Data_R1 => Data_R1,
            Data_R2 => Data_R2,
            jmp_Flag => jmp_Flag,
            Zero_Flag => Zero_Flag
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WAIT FOR CLOCK_PERIOD / 2;
        clk <= NOT clk;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Initialize inputs
        reset <= '1';
        WAIT FOR CLOCK_PERIOD;

        -- Deassert reset
        reset <= '0';
        WAIT FOR CLOCK_PERIOD;

        WB1_Address <= "000";
        WB2_Address <= "001";
        WB1_Signal <= '1';
        WB2_Signal <= '1';
        WB1_data <= x"0000001F";
        WB2_data <= x"11111111";
        WAIT FOR CLOCK_PERIOD;
        WB1_Signal <= '0';
        WB2_Signal <= '0';
        WAIT FOR CLOCK_PERIOD;

        -- Test case 1
        Instruction <= "0111000000100000"; -- jmp = 1 / data1 = 0000001F / data2= 11111111 / zero flag =0
        WAIT FOR CLOCK_PERIOD;

        Instruction <= "0111001100100000"; -- jmp = 1 / data1 = 00000000 / data2= 11111111 / zero flag =1
        WAIT FOR CLOCK_PERIOD;

        -- Test case 2
        Instruction <= "0110100100000000"; -- jmp = 1 / data1 = 11111111 / data2= 0000001F / / zero flag =0
        WAIT FOR CLOCK_PERIOD;

        -- Add more test cases as needed

        -- End simulation after test cases
        WAIT;
    END PROCESS stimulus_process;

END ARCHITECTURE tb_arch;