LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Adder_Subtractor_TB IS
END ENTITY Adder_Subtractor_TB;

ARCHITECTURE testbench_arch OF Adder_Subtractor_TB IS
    SIGNAL Operation_Sel, Enable : STD_LOGIC;
    SIGNAL Input1, Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Input2 : STD_LOGIC_VECTOR(1 DOWNTO 0);

    COMPONENT Adder_Subtractor
        PORT (
            Operation_Sel : IN STD_LOGIC;
            Input1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Input2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            Enable : IN STD_LOGIC;
            Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    -- Instantiate the Adder_Subtractor component
    UUT : Adder_Subtractor PORT MAP(
        Operation_Sel => Operation_Sel,
        Input1 => Input1,
        Input2 => Input2,
        Enable => Enable,
        Result => Result
    );

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Test case 1: Addition
        Operation_Sel <= '1'; -- Adder
        Input1 <= "00000000000000000000000000001111";
        Input2 <= "01";
        Enable <= '1';
        WAIT FOR 10 ns;

        -- Test case 2: Subtraction
        Operation_Sel <= '0'; -- Subtractor
        Input1 <= "00000000000000000000000000001111";
        Input2 <= "01";
        Enable <= '1';
        WAIT FOR 10 ns;

        -- Additional test cases can be added here

        -- End the simulation
        WAIT;
    END PROCESS stimulus_process;

END ARCHITECTURE testbench_arch;