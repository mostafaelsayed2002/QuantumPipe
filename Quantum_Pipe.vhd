LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Quantum_Pipe IS
    PORT (
        --inputs
        in_port : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        intr : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        --output 
        out_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END Quantum_Pipe;

ARCHITECTURE Arch_Quantum_Pipe OF Quantum_Pipe IS
    SIGNAL clk : STD_LOGIC;
    SIGNAL fixpc : STD_LOGIC;
    SIGNAL jmpflag : STD_LOGIC;
    SIGNAL pcval : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Regout_FD : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL RegIN_FD : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL WB1_Signal : STD_LOGIC;
    SIGNAL WB2_Signal : STD_LOGIC;
    SIGNAL WB1_Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB2_Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WB2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Data_R1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Data_R2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero_flag : STD_LOGIC;
    SIGNAL Regout_DE : STD_LOGIC_VECTOR(150 DOWNTO 0);
    SIGNAL IMM_EA : STD_LOGIC;
    SIGNAL ALU_SRC : STD_LOGIC;
    SIGNAL ALU_OP : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL Fw_Sel_1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fw_Sel_2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rdst_WB_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ALU_output : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Rdst_SWAP_Mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rdst_SWAP_Ex : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Excute_Result : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Excute_Input : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL D_IMM_Jump : STD_LOGIC;
    SIGNAL D_No_Operation : STD_LOGIC;
    SIGNAL D_IMM_Effective_Address : STD_LOGIC;
    SIGNAL D_ALU_Source_Select : STD_LOGIC;
    SIGNAL D_Forwarding_Source : STD_LOGIC;
    SIGNAL D_ALU_Op_Code : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL D_Implicit_Sources : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL D_Forwarding_Swap : STD_LOGIC;
    SIGNAL D_Call_Stack_Pointer : STD_LOGIC;
    SIGNAL D_Free_Operation : STD_LOGIC;
    SIGNAL D_Protection_Signal : STD_LOGIC;
    SIGNAL D_Memory_Read : STD_LOGIC;
    SIGNAL D_Memory_Write : STD_LOGIC;
    SIGNAL D_Write_Back : STD_LOGIC;
    SIGNAL D_Write_Back_2 : STD_LOGIC;
    SIGNAL D_Write_Back_Source : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL D_Port_Read : STD_LOGIC;
    SIGNAL D_Port_Write : STD_LOGIC;
    SIGNAL D_Stack_Pointer_Select : STD_LOGIC;
    SIGNAL D_Stack_Pointer_Update : STD_LOGIC;
    SIGNAL OPCODE_OR_NOP : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL RegIN_DE : STD_LOGIC_VECTOR(150 DOWNTO 0);

    SIGNAL REGIN_EM : STD_LOGIC_VECTOR(150 DOWNTO 0);
    SIGNAL REGOUT_EM : STD_LOGIC_VECTOR(150 DOWNTO 0);

    SIGNAL SP : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Neg_Flag : STD_LOGIC;
    SIGNAL Carry_Flag : STD_LOGIC;
    SIGNAL SPin : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SPout : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL CCRin : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SPWriteSignal : STD_LOGIC;
    SIGNAL CCRWriteSignal : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
    PROCESS
    BEGIN
        WAIT FOR 10 ns;
        clk <= NOT clk;
    END PROCESS;
    F : ENTITY work.FetchingStage PORT MAP(
        clk => clk,
        fixpc => fixpc,
        jmpflag => jmpflag,
        jmplocation => Data_R1,
        pcval => pcval,
        instr => instr
        );

    RegIN_FD <= pcval & instr;
    REG_FD : ENTITY work.Reg GENERIC MAP(
        48) PORT MAP(
        Clk => clk,
        Input => RegIN_FD,
        Output => Regout_FD,
        Rst => reset
        );
    --control unit  

    M0 : MUX_2_1 GENERIC MAP(
        5) PORT MAP(
        Input_1 => Regout_FD(15 DOWNTO 11),
        Input_2 => "00000",
        SELECT => OR(),
        Output => OPCODE_OR_NOP
    );

    CU : ENTITY work.ControlUnit PORT MAP(
        Op_Code => OPCODE_OR_NOP,
        IMM_Jump => D_IMM_Jump,
        No_Operation => D_No_Operation,
        IMM_Effective_Address => D_IMM_Effective_Address,
        ALU_Source_Select => D_ALU_Source_Select,
        Forwarding_Source => D_Forwarding_Source,
        ALU_Op_Code => D_ALU_Op_Code,
        Implicit_Sources => D_Implicit_Sources,
        Forwarding_Swap => D_Forwarding_Swap,
        Call_Stack_Pointer => D_Call_Stack_Pointer,
        Free_Operation => D_Free_Operation,
        Protection_Signal => D_Protection_Signal,
        Memory_Read => D_Memory_Read,
        Memory_Write => D_Memory_Write,
        Write_Back => D_Write_Back,
        Write_Back_2 => D_Write_Back_2,
        Write_Back_Source => D_Write_Back_Source,
        Port_Read => D_Port_Read,
        Port_Write => D_Port_Write,
        Stack_Pointer_Select => D_Stack_Pointer_Select,
        Stack_Pointer_Update => D_Stack_Pointer_Update
        );
    D : ENTITY work.Decode_Stage PORT MAP(
        Clk => clk,
        Instruction => Regout_FD(15 DOWNTO 0),
        WB1_Address => WB1_Address,
        WB2_Address => WB2_Address,
        WB1_data => WB1_data,
        WB2_data => WB2_data,
        WB1_Signal => WB1_Signal,
        WB2_Signal => WB1_Signal,
        Data_R1 => Data_R1,
        Data_R2 => Data_R2,
        jmp_Flag => jmpflag,
        Zero_Flag => zero_flag,
        Neg_Flag => Neg_Flag,
        Carry_Flag => Carry_Flag,
        SPin => SPin,
        SPout => SPout,
        CCRin => CCRin,
        SPWriteSignal => SPWriteSignal,
        CCRWriteSignal => CCRWriteSignal,

        );

    RegIN_DE <= D_IMM_Jump & --150
        D_No_Operation & -- 149
        D_IMM_Effective_Address & -- 148
        D_ALU_Source_Select & -- 147
        D_Forwarding_Source & -- 146
        D_ALU_Op_Code & -- 145-142
        D_Implicit_Sources & -- 141-140
        D_Forwarding_Swap & --139
        D_Call_Stack_Pointer & --138
        D_Free_Operation & --137
        D_Protection_Signal & --136
        D_Memory_Read & --135
        D_Memory_Write & --134
        D_Write_Back & --133
        D_Write_Back_2 & --132
        D_Write_Back_Source & -- 131-130 
        D_Port_Read & --129
        D_Port_Write & --128
        D_Stack_Pointer_Select & --127
        D_Stack_Pointer_Update & --126
        instr & --125 - 110
        Regout_FD(10 DOWNTO 2) & --109 - 101 
        pcval & -- 100-69
        Regout_FD(3 DOWNTO 0) & -- 68-65
        Data_R1 & --64 - 33  
        Data_R2 & --32 - 1
        zero_flag;

    REG_DE : ENTITY work.Reg GENERIC MAP(
        151) PORT MAP(
        Clk => clk,
        Input => RegIN_DE,
        Output => Regout_DE,
        Rst => reset
        );

    --*-----------------------------------

    E : ENTITY work.Ex_Stage PORT MAP(
        IMM_EA => Regout_DE(148),
        ALU_SRC => Regout_DE(147),
        ALU_OP => Regout_DE(145 DOWNTO 142),

        FW_SEL_1 => FW_SEL_1,
        FW_SEL_2 => FW_SEL_2,

        OP_1 => Regout_DE(32 DOWNTO 1),
        OP_2 => Regout_DE(64 DOWNTO 33),
        bit_ea_4 => Regout_DE(68 DOWNTO 65),
        bit_ea_imm_16 => Regout_DE(125 DOWNTO 110),
        --?---- From the WB stage------
        Rdst_WB_data => Rdst_WB_data, -- from wb
        ALU_output => ALU_output, -- from memory
        Rdst_SWAP_Ex => Rdst_SWAP_Ex,
        Rdst_SWAP_Mem => Rdst_SWAP_Mem,
        --?----------------------------
        ---- outputs
        Result => Excute_Result,
        Input_1 => Excute_Input,
        Port_Data => out_port
        );

    REGIN_EM <=
        Regout_DE(149) & --NOP
        Regout_DE(139) & -- SwapForward
        Regout_DE(138) & -- call_stack_ptr
        Regout_DE(137) & -- free
        Regout_DE(136) & -- protect
        Regout_DE(135) & -- Mem_rd
        Regout_DE(134) & -- Mem_wr
        Regout_DE(133) & -- WB
        Regout_DE(132) & -- WB_2
        Regout_DE(131 DOWNTO 130) & -- WB src
        Regout_DE(127) & -- stack ptr select
        Regout_DE(126) & -- stack ptr update
        Excute_Input &
        Regout_DE(100 DOWNTO 69) &
        Excute_Result &
        Regout_DE(64 DOWNTO 33) &
        Regout_DE(109 DOWNTO 101)
        ;
    REG_EM : ENTITY work.Reg GENERIC MAP(
        151) PORT MAP(
        Clk => clk,
        Input => REGIN_EM,
        Output => REGOUT_EM,
        Rst => reset
        );

    M : ENTITY work.Mem_Stage PORT MAP(
        call_sp => REGOUT_EM(138),
        sp_sel => REGOUT_EM(127),
        free => REGOUT_EM(137),
        protect => REGOUT_EM(136),
        mem_write => REGOUT_EM(134),
        mem_read => REGOUT_EM(135),
        sp => REGOUT_EM(100 DOWNTO 69),
        clk => clk,
        pc => REGOUT_EM(68 DOWNTO 33),
        alu_out => ALU_output,
        op_1 => REGOUT_EM(32 DOWNTO 1),
        mem_data => out_port
        );

    REG_MW : ENTITY work.Reg GENERIC MAP(
        151) PORT MAP(
        Clk => clk,
        Input => REGIN_EM,
        Output => Regout_DE,
        Rst => reset
        );


END ARCHITECTURE Arch_Quantum_Pipe;