LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_3_2_tb IS
END ENTITY;

ARCHITECTURE Arch_mux_3_2_tb OF mux_3_2_tb IS
    -- Constants
    CONSTANT N_VALUE : INTEGER := 8;

    -- Signals
    SIGNAL a_sig, b_sig, c_sig, y_sig : STD_LOGIC_VECTOR(N_VALUE-1 DOWNTO 0);
    SIGNAL sel_sig: STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    -- Instantiate the mux_3_2
    -- You can customize the generic value if needed
    mux_inst : ENTITY work.mux_3_2
        GENERIC MAP (
            N => N_VALUE
        )
        PORT MAP (
            a => a_sig,
            b => b_sig,
            c => c_sig,
            s => sel_sig,
            y => y_sig
        );

    -- Stimulus process
    stimulus_process: PROCESS
    BEGIN
        -- Initialize signals
        a_sig <= (others => '0');
        b_sig <= (others => '1');
        c_sig <= (others => '0');

        sel_sig <= "00";

        -- Test case 1
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        sel_sig <= "00";
        WAIT FOR 10 ns;
        ASSERT y_sig = a_sig
            REPORT "Test Case 1 Failed"
            SEVERITY FAILURE;

        -- Test case 2
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        sel_sig <= "01";
        WAIT FOR 10 ns;
        ASSERT y_sig = b_sig
            REPORT "Test Case 2 Failed"
            SEVERITY FAILURE;

        -- Test case 3
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        sel_sig <= "10";
        WAIT FOR 10 ns;
        ASSERT y_sig = c_sig
            REPORT "Test Case 3 Failed"
            SEVERITY FAILURE;

        -- Test case 4 (additional test case to cover "when others" condition)
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        sel_sig <= "11";
        WAIT FOR 10 ns;
        ASSERT y_sig = a_sig
            REPORT "Test Case 4 Failed"
            SEVERITY FAILURE;

        WAIT;
    END PROCESS stimulus_process;

END ARCHITECTURE Arch_mux_3_2_tb;
