LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_2_1_tb IS
END ENTITY;

ARCHITECTURE Arch_mux_2_1_tb OF mux_2_1_tb IS
    -- Constants
    CONSTANT N_VALUE : INTEGER := 8;
    
    -- Signals
    SIGNAL a_sig, b_sig, y_sig: STD_LOGIC_VECTOR(N_VALUE-1 DOWNTO 0);
    SIGNAL sel_sig: STD_LOGIC;
    
BEGIN
    -- Instantiate the mux_2_1
    -- You can customize the generic value if needed
    mux_inst : ENTITY work.mux_2_1
        GENERIC MAP (
            N => N_VALUE
        )
        PORT MAP (
            a => a_sig,
            b => b_sig,
            sel => sel_sig,
            y => y_sig
        );

    -- Stimulus process
    stimulus_process: PROCESS
    BEGIN
        -- Initialize signals
        a_sig <= (others => '0');
        b_sig <= (others => '1');
        sel_sig <= '0';

        -- Test case 1
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        sel_sig <= '0';
        WAIT FOR 10 ns;
        ASSERT y_sig = a_sig
            REPORT "Test Case 1 Failed"
            SEVERITY FAILURE;

        -- Test case 2
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        sel_sig <= '1';
        WAIT FOR 10 ns;
        ASSERT y_sig = b_sig
            REPORT "Test Case 2 Failed"
            SEVERITY FAILURE;

        -- Add more test cases as needed

        WAIT;
    END PROCESS stimulus_process;

END ARCHITECTURE Arch_mux_2_1_tb;
