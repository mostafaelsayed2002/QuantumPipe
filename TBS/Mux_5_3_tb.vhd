LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_5_3_tb IS
END ENTITY;

ARCHITECTURE Arch_mux_5_3_tb OF mux_5_3_tb IS
    -- Constants
    CONSTANT N_VALUE : INTEGER := 8;
    
    -- Signals
    SIGNAL a_sig, b_sig, c_sig , d_sig , e_sig,  y_sig : STD_LOGIC_VECTOR(N_VALUE-1 DOWNTO 0);
    SIGNAL sel_sig: STD_LOGIC_VECTOR(2 DOWNTO 0);
    
BEGIN
    -- Instantiate the mux_2_1
    -- You can customize the generic value if needed
    mux_inst : ENTITY work.mux_5_3
        GENERIC MAP (
            N => N_VALUE
        )
        PORT MAP (
            a => a_sig,
            b => b_sig,
            c => c_sig,
            d => d_sig,
            e => e_sig,
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
        d_sig <= (others => '1');
        e_sig <= (others => '0');

        sel_sig <= "000";

        -- Test case 1
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        d_sig <= "01010101";
        e_sig <= "10101010";
        sel_sig <= "000";
        WAIT FOR 10 ns;
        ASSERT y_sig = a_sig
            REPORT "Test Case 1 Failed"
            SEVERITY FAILURE;

        -- Test case 2
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        d_sig <= "01010101";
        e_sig <= "10101010";
        sel_sig <= "001";
        WAIT FOR 10 ns;
        ASSERT y_sig = b_sig
            REPORT "Test Case 2 Failed"
            SEVERITY FAILURE;

        -- Test case 3
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        d_sig <= "01010101";
        e_sig <= "10101010";
        sel_sig <= "010";
        WAIT FOR 10 ns;
        ASSERT y_sig = c_sig
            REPORT "Test Case 3 Failed"
            SEVERITY FAILURE;

        -- Test case 4
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        d_sig <= "01010101";
        e_sig <= "10101010";
        sel_sig <= "011";
        WAIT FOR 10 ns;
        ASSERT y_sig = d_sig
            REPORT "Test Case 4 Failed"
            SEVERITY FAILURE;

        -- Test case 5
        WAIT FOR 10 ns;
        a_sig <= "10101010";
        b_sig <= "01010101";
        c_sig <= "10101010";
        d_sig <= "01010101";
        e_sig <= "10101010";
        sel_sig <= "100";
        WAIT FOR 10 ns;
        ASSERT y_sig = e_sig
            REPORT "Test Case 5 Failed"
            SEVERITY FAILURE;


        WAIT;
    END PROCESS stimulus_process;

END ARCHITECTURE Arch_mux_5_3_tb;
