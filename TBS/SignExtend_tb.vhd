LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY signExtend_tb IS
END signExtend_tb;

ARCHITECTURE behavior OF signExtend_tb IS
    SIGNAL s_input_tb : std_logic_vector(15 downto 0) := (others => '0');
    SIGNAL s_output_tb : std_logic_vector(31 downto 0);

    COMPONENT signExtend
        PORT(
            s_input  : IN  std_logic_vector(15 downto 0);
            s_output : OUT std_logic_vector(31 downto 0)
        );
    END COMPONENT;

BEGIN
    uut: signExtend
        PORT MAP(
            s_input => s_input_tb,
            s_output => s_output_tb
        );

    -- Stimulus and checking process
    stim_check_proc: PROCESS
    BEGIN
        s_input_tb <= "1010101010101010"; -- Test with a positive number
        WAIT FOR 10 ns;
        ASSERT s_output_tb = x"00005555" REPORT "Test Case 1 Failed" SEVERITY ERROR;

        s_input_tb <= "1101101101101101"; -- Test with a negative number
        WAIT FOR 10 ns;
        ASSERT s_output_tb = x"FFFFDB6D" REPORT "Test Case 2 Failed" SEVERITY ERROR;

        -- Add more test cases and assertions as needed

        -- Stop simulation after all test cases are complete
        WAIT;
    END PROCESS stim_check_proc;

END behavior;
