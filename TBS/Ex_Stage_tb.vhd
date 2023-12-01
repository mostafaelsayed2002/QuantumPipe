LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Ex_Stage_tb IS
END ENTITY Ex_Stage_tb;

ARCHITECTURE Testbench_ARCH OF Ex_Stage_tb IS
    -- Declare signals for your testbench
    SIGNAL IMM_EA : STD_LOGIC := '0';
    SIGNAL ALU_SRC : STD_LOGIC := '0';
    SIGNAL ALU_OP : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL FW_SEL_1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL FW_SEL_2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OP_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OP_2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL bit_ea_4 : STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL bit_ea_imm_16 : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rdst_WB_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALU_output : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rdst_SWAP_Ex : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rdst_SWAP_Mem : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Input_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Port_Data : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    -- Instantiate the Ex_Stage unit
    Ex_Stage_inst : ENTITY work.Ex_Stage
        PORT MAP (
            IMM_EA => IMM_EA,
            ALU_SRC => ALU_SRC,
            ALU_OP => ALU_OP,
            FW_SEL_1 => FW_SEL_1,
            FW_SEL_2 => FW_SEL_2,
            OP_1 => OP_1,
            OP_2 => OP_2,
            bit_ea_4 => bit_ea_4,
            bit_ea_imm_16 => bit_ea_imm_16,
            Rdst_WB_data => Rdst_WB_data,
            ALU_output => ALU_output,
            Rdst_SWAP_Ex => Rdst_SWAP_Ex,
            Rdst_SWAP_Mem => Rdst_SWAP_Mem,
            Result => Result,
            Input_1 => Input_1,
            Port_Data => Port_Data
        );

    -- Process to apply stimulus
    Stimulus_process: PROCESS
    BEGIN
        -- Apply test vectors
        IMM_EA <= '0';
        ALU_SRC <= '1';
        ALU_OP <= "0101";
        FW_SEL_1 <= (OTHERS => '0');
        FW_SEL_2 <= (OTHERS => '0');
        OP_1 <= "10111010100011111110001011010111";
        OP_2 <= "10001100000001101011001001111100";
        bit_ea_4 <= (OTHERS => '0');
        bit_ea_imm_16 <= (OTHERS => '0');
        Rdst_WB_data <= (OTHERS => '0');
        ALU_output <= (OTHERS => '0');
        Rdst_SWAP_Ex <= (OTHERS => '0');
        Rdst_SWAP_Mem <= (OTHERS => '0');

        -- Insert additional stimulus assignments here

        -- Wait for some time (optional)
        WAIT FOR 10 ns;
        
        -- Check the results
        ASSERT Result = "01000110100101101001010101010011" REPORT "Test failed!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        Alu_op <= "1001";
        OP_1 <= "00000000000000001111111111111111";
        OP_2 <= "11111111111111110000000000000000";

        WAIT FOR 10 ns;

        -- Apply test vectors for NEG operation
        ALU_OP <= "0010";
        OP_1 <= "00000000000000001111111111111111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for NEG operation
        ASSERT Result = "11111111111111110000000000000001" REPORT "Test failed for NEG operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for INC operation
        ALU_OP <= "0011";
        OP_1 <= "00000000000000001111111111111111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for INC operation
        ASSERT Result = "00000000000000010000000000000000" REPORT "Test failed for INC operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for DEC operation
        ALU_OP <= "0100";
        OP_1 <= "00000000000000001111111111111111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for DEC operation
        ASSERT Result = "00000000000000001111111111111110" REPORT "Test failed for DEC operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for AND operation
        ALU_OP <= "0111";
        OP_1 <= "11110000111100001111000011110000";
        OP_2 <= "00001111000011110000111100001111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for AND operation
        ASSERT Result = "00000000000000000000000000000000" REPORT "Test failed for AND operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for OR operation
        ALU_OP <= "1000";
        OP_1 <= "11110000111100001111000011110000";
        OP_2 <= "00001111000011110000111100001111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for OR operation
        ASSERT Result = "11111111111111111111111111111111" REPORT "Test failed for OR operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for XOR operation
        ALU_OP <= "1001";
        OP_1 <= "11110000111100001111000011110000";
        OP_2 <= "00001111000011110000111100001111";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for XOR operation
        ASSERT Result = "11111111111111111111111111111111" REPORT "Test failed for XOR operation!" SEVERITY FAILURE;
        WAIT FOR 10 ns;

        -- Apply test vectors for CMP operation
        ALU_OP <= "1010";
        OP_1 <= "00000000000000001111111111111111";
        OP_2 <= "00000000000000001111111111111110";

        -- Wait for some time (optional)
        WAIT FOR 10 ns;

        -- Check the results for CMP operation
        WAIT FOR 10 ns;
        ALU_OP <= "0101";
        IMM_EA <= '0';
        ALU_SRC <= '0';
        bit_ea_4 <= (OTHERS => '0');
        bit_ea_imm_16 <= "1011000111111110";
        
        WAIT FOR 10 ns;
        ALU_OP <= "0101";
        IMM_EA <= '0';
        ALU_SRC <= '0';
        bit_ea_4 <= (OTHERS => '0');
        bit_ea_imm_16 <= "0011000111111110";

        WAIT FOR 10 ns;
        ALU_OP <= "0101";
        IMM_EA <= '1';
        bit_ea_4 <= "0101";

        WAIT FOR 10 ns;
        ALU_OP <= "1111";

        



        -- Stop the simulation
        WAIT;
    END PROCESS Stimulus_process;

END ARCHITECTURE Testbench_ARCH;
