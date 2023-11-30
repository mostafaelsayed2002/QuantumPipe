LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Reg_tb IS
END ENTITY;

ARCHITECTURE Arch_Reg_tb OF Reg_tb IS
    -- Constants
    constant CLOCK_PERIOD : time := 10 ns;
    -- Signals
    SIGNAL Clk, Rst : std_logic := '0';
    SIGNAL Input_sig, Output_sig : std_logic_vector(63 DOWNTO 0);
    SIGNAL stop : BOOLEAN := FALSE; -- Declaration of stop signal

BEGIN
    -- Component instantiation
    UUT : ENTITY work.Reg
        GENERIC MAP (
            n => 64
        )
        PORT MAP (
            Clk => Clk,
            Input => Input_sig,
            Output => Output_sig,
            Rst => Rst
        );

    -- Clock process
    Clk_process: PROCESS
    BEGIN
        WHILE (NOT stop) LOOP
            Clk <= '0';
            WAIT FOR CLOCK_PERIOD / 2;
            Clk <= '1';
            WAIT FOR CLOCK_PERIOD / 2;
        END LOOP;
        WAIT;
    END PROCESS;

    -- Stimulus process
    Stimulus : PROCESS
    BEGIN
        Rst <= '1'; -- Reset active
        WAIT FOR 10 ns;
        Rst <= '0'; -- Release reset after 10 ns

        -- Stimulate Input signal
        Input_sig <= (OTHERS => '1'); -- Set Input to all '1's

        WAIT FOR 100 ns; -- Wait for some time

        -- Add more test scenarios or stimuli here

        stop <= TRUE; -- Set stop signal to end the clock process
        WAIT;
    END PROCESS;

END ARCHITECTURE Arch_Reg_tb;
