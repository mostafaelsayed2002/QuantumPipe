LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU_TB IS
END ENTITY;

ARCHITECTURE TB_ARCH OF ALU_TB IS
    -- Constants
    CONSTANT CLOCK_PERIOD : TIME := 10 ns;

    -- Signals
    SIGNAL clk, rst : STD_LOGIC := '0';
    SIGNAL op : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL c_old : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL c_new : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL in1, in2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL outp : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- Component instantiation
    COMPONENT ALU
        PORT (
            op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            c_old : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            outp : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            c_new : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Clock process
    PROCESS
    BEGIN
        WAIT FOR CLOCK_PERIOD / 2;
        clk <= NOT clk;
    END PROCESS;

    -- Stimulus process
    PROCESS
    BEGIN

        -- Test case 0: NOP
        op <= "0000";
        in1 <= X"ABCD1234";
        in2 <= X"87654321";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000000" AND c_new = c_old) REPORT "Test Case 0 failed" SEVERITY failure;

        -- Test case 1: NOT
        op <= "0001";
        in1 <= X"00000000";
        in2 <= X"00000000";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"FFFFFFFF" AND c_new(1 downto 0) = "10") REPORT "Test Case 1 failed" SEVERITY failure;

        -- Test case 2: NEG
        op <= "0010";
        in1 <= X"00000001";
        in2 <= X"00000000";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"FFFFFFFF" AND c_new(1 downto 0) = "00") REPORT "Test Case 2 failed" SEVERITY failure;

        -- Test case 3: INC
        op <= "0011";
        in1 <= X"FFFFFFFF";
        in2 <= X"00000000";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000000" AND c_new(2) = '1') REPORT "Test Case 3 failed" SEVERITY failure;

        -- Test case 4: DEC
        op <= "0100";
        in1 <= X"00000001";
        in2 <= X"00000000";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000000" AND c_new = "001") REPORT "Test Case 4 failed" SEVERITY failure;

        -- Test case 5: ADD/ADDI
        op <= "0101";
        in1 <= X"7FFFFFFF";
        in2 <= X"00000001";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"80000000" AND c_new(1 downto 0) = "10") REPORT "Test Case 5 failed" SEVERITY failure;

        -- Test case 6: SUB
        op <= "0110";
        in1 <= X"80000000";
        in2 <= X"00000001";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"7FFFFFFF" AND c_new(1 downto 0) = "00") REPORT "Test Case 6 failed" SEVERITY failure;

        -- Test case 7: AND
        op <= "0111";
        in1 <= X"55555555";
        in2 <= X"AAAAAAAA";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000000" AND c_new = "001") REPORT "Test Case 7 failed" SEVERITY failure;

        -- Test case 8: OR
        op <= "1000";
        in1 <= X"55555555";
        in2 <= X"AAAAAAAA";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"FFFFFFFF" AND c_new = "010") REPORT "Test Case 8 failed" SEVERITY failure;

        -- Test case 9: XOR
        op <= "1001";
        in1 <= X"55555555";
        in2 <= X"AAAAAAAA";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"FFFFFFFF" AND c_new = "010") REPORT "Test Case 9 failed" SEVERITY failure;

        -- Test case 10: CMP
        op <= "1010";
        in1 <= X"80000000";
        in2 <= X"7FFFFFFF";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000001" AND c_new = "000") REPORT "Test Case 10 failed" SEVERITY failure;

        -- Test case 11: BITSET
        op <= "1011";
        in1 <= X"00000000";
        in2 <= X"00000001";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"00000001" AND c_new = c_old) REPORT "Test Case 11 failed" SEVERITY failure;

        -- Test case 12: RCL
        op <= "1100";
        in1 <= X"12345678";
        in2 <= X"00000003";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"09123456" AND c_new = "000") REPORT "Test Case 12 failed" SEVERITY failure;

        -- Test case 13: RCR
        op <= "1101";
        in1 <= X"12345678";
        in2 <= X"00000003";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"78091234" AND c_new = "000") REPORT "Test Case 13 failed" SEVERITY failure;

        -- Test case 14: No operation
        op <= "1110";
        in1 <= X"ABCDEF01";
        in2 <= X"12345678";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"ABCDEF01" AND c_new = c_old) REPORT "Test Case 14 failed" SEVERITY failure;

        -- Test case 15: Load second operand
        op <= "1111";
        in1 <= X"ABCDEF01";
        in2 <= X"12345678";
        WAIT FOR CLOCK_PERIOD;
        ASSERT (outp = X"12345678" AND c_new = c_old) REPORT "Test Case 15 failed" SEVERITY failure;

        WAIT;

    END PROCESS;

    -- ALU instantiation
    UUT : ALU PORT MAP(
        op => op,
        c_old => c_old,
        in1 => in1,
        in2 => in2,
        outp => outp,
        c_new => c_new
    );

END TB_ARCH;