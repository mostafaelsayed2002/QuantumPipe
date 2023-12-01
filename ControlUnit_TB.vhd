LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ControlUnit_TB IS
END ENTITY ControlUnit_TB;

ARCHITECTURE testbench OF ControlUnit_TB IS
    SIGNAL Op_Code : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0'); -- Initial value

    SIGNAL IMM_Jump, No_Operation, IMM_Effective_Address, ALU_Source_Select, Forwarding_Source, Forwarding_Swap, Call_Stack_Pointer,
    Free_Operation, Protection_Signal, Memory_Read, Memory_Write, Write_Back, Write_Back_2, Port_Read, Port_Write,
    Stack_Pointer_Select, Stack_Pointer_Update : STD_LOGIC;

    SIGNAL ALU_Op_Code : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Implicit_Sources, Write_Back_Source : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    -- Instantiate the control unit
    UUT : ENTITY work.ControlUnit
        PORT MAP(
            Op_Code => Op_Code,
            IMM_Jump => IMM_Jump,
            No_Operation => No_Operation,
            IMM_Effective_Address => IMM_Effective_Address,
            ALU_Source_Select => ALU_Source_Select,
            Forwarding_Source => Forwarding_Source,
            Forwarding_Swap => Forwarding_Swap,
            Call_Stack_Pointer => Call_Stack_Pointer,
            Free_Operation => Free_Operation,
            Protection_Signal => Protection_Signal,
            Memory_Read => Memory_Read,
            Memory_Write => Memory_Write,
            Write_Back => Write_Back,
            Write_Back_2 => Write_Back_2,
            Write_Back_Source => Write_Back_Source,
            Port_Read => Port_Read,
            Port_Write => Port_Write,
            Stack_Pointer_Select => Stack_Pointer_Select,
            Stack_Pointer_Update => Stack_Pointer_Update,
            ALU_Op_Code => ALU_Op_Code,
            Implicit_Sources => Implicit_Sources
        );

    -- Stimulus process
    PROCESS
    BEGIN
        -- Iterate through all opcodes
        FOR I IN 0 TO 31 LOOP
            Op_Code <= STD_LOGIC_VECTOR(to_unsigned(I, 5));
            WAIT FOR 10 ns;
        END LOOP;
        WAIT;
    END PROCESS;
END ARCHITECTURE testbench;