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
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL fixpc : STD_LOGIC :='0';
    SIGNAL jmpflag : STD_LOGIC :='0';
    SIGNAL pcval : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Regout_FD : STD_LOGIC_VECTOR(47 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL RegIN_FD : STD_LOGIC_VECTOR(47 DOWNTO 0):=(OTHERS =>'0');
    --/////////////////////////////////////////
    SIGNAL WB1_Signal : STD_LOGIC:='0';
    SIGNAL WB2_Signal : STD_LOGIC:='0';
    SIGNAL WB1_Address : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL WB2_Address : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL WB1_data : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL WB2_data : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Data_R1 : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Data_R2 : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    --/////////////////////////////////////////
    SIGNAL zero_flag : STD_LOGIC:='0';
    SIGNAL Regout_DE : STD_LOGIC_VECTOR(150 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL IMM_EA : STD_LOGIC:='0';
    SIGNAL ALU_SRC : STD_LOGIC:='0';
    SIGNAL ALU_OP : STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Fw_Sel_1 : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Fw_Sel_2 : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Rdst_WB_data : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL ALU_output : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');

    -- SIGNAL Rdst_SWAP_Mem : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- SIGNAL Rdst_SWAP_Ex : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Excute_Result : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL Excute_Input : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');

    SIGNAL D_IMM_Jump : STD_LOGIC:='0';
    SIGNAL D_No_Operation : STD_LOGIC:='0';
    SIGNAL D_IMM_Effective_Address : STD_LOGIC:='0';
    SIGNAL D_ALU_Source_Select : STD_LOGIC:='0';
    SIGNAL D_Forwarding_Source : STD_LOGIC:='0';
    SIGNAL D_ALU_Op_Code : STD_LOGIC_VECTOR(3 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL D_Implicit_Sources : STD_LOGIC_VECTOR(1 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL D_Forwarding_Swap : STD_LOGIC:='0';
    SIGNAL D_Call_Stack_Pointer : STD_LOGIC:='0';
    SIGNAL D_Free_Operation : STD_LOGIC:='0';
    SIGNAL D_Protection_Signal : STD_LOGIC:='0';
    SIGNAL D_Memory_Read : STD_LOGIC:='0';
    SIGNAL D_Memory_Write : STD_LOGIC:='0';
    SIGNAL D_Write_Back : STD_LOGIC:='0';
    SIGNAL D_Write_Back_2 : STD_LOGIC:='0';
    SIGNAL D_Write_Back_Source : STD_LOGIC_VECTOR(1 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL D_Port_Read : STD_LOGIC:='0';
    SIGNAL D_Port_Write : STD_LOGIC:='0';
    SIGNAL D_Stack_Pointer_Select : STD_LOGIC:='0';
    SIGNAL D_Stack_Pointer_Update : STD_LOGIC:='0';
    SIGNAL OPCODE_OR_NOP : STD_LOGIC_VECTOR(4 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL RegIN_DE : STD_LOGIC_VECTOR(150 DOWNTO 0):=(OTHERS =>'0');

    SIGNAL REGIN_EM : STD_LOGIC_VECTOR(149 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL REGOUT_EM : STD_LOGIC_VECTOR(149 DOWNTO 0):=(OTHERS =>'0');

    SIGNAL Neg_Flag : STD_LOGIC:='0';
    SIGNAL Carry_Flag : STD_LOGIC:='0';
    SIGNAL SPin : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL SPout : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL CCRin : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL SPWriteSignal : STD_LOGIC:='0';
    SIGNAL CCRWriteSignal : STD_LOGIC_VECTOR(2 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL SPNextVal : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');

    SIGNAL MemDataOut : STD_LOGIC_VECTOR(31 DOWNTO 0):=(OTHERS =>'0');

    SIGNAL REGIN_MW : STD_LOGIC_VECTOR(175 DOWNTO 0):=(OTHERS =>'0');
    SIGNAL REGOUT_MW : STD_LOGIC_VECTOR(175 DOWNTO 0) :=(OTHERS =>'0');

    SIGNAL ORing : STD_LOGIC:='0';
    SIGNAL anding : STD_LOGIC:='0';

    





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
    ORing <= Regout_DE(148) or (Regout_DE(148) and Regout_DE(0)) or REGOUT_EM(149)  or Regout_MW(175);
    M0 : ENTITY work.MUX_2_1 GENERIC MAP(
        5) PORT MAP(
        a => Regout_FD(15 DOWNTO 11),
        b => "00000",
        sel => ORing,
        y => OPCODE_OR_NOP
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
        WB1_Address => Regout_MW(40 DOWNTO 38),
        WB2_Address => Regout_MW(37 DOWNTO 35),
        WB1_data => Rdst_WB_data,
        WB2_data => Regout_MW(31 DOWNTO 0),
        WB1_Signal => Regout_MW(173),
        WB2_Signal => Regout_MW(172),
        Data_R1 => Data_R1,
        Data_R2 => Data_R2,
        jmp_Flag => jmpflag,
        Zero_Flag => zero_flag,
        Neg_Flag => Neg_Flag,
        Carry_Flag => Carry_Flag,
        SPin => Regout_MW(136 downto 105), --- mostafa
        SPout => SPout,
        CCRin => CCRin,
        SPWriteSignal => SPWriteSignal,
        CCRWriteSignal => CCRWriteSignal

        );

    RegIN_DE <= D_IMM_Jump & --150
        D_No_Operation & -- 149
        D_IMM_Effective_Address & -- 148 -----mostafa
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
        ------ From the WB stage------
        Rdst_WB_data => Rdst_WB_data, -- from wb 
        ALU_output => REGOUT_EM(72 DOWNTO 41), -- from memory
        Rdst_SWAP_Ex => REGOUT_EM(136 DOWNTO 105),
        Rdst_SWAP_Mem => REGOUT_MW(168 DOWNTO 137),
        ---- outputs
        Result => Excute_Result,
        Input_1 => Excute_Input,
        Port_Data => out_port
        );

    REGIN_EM <=
        Regout_DE(149) & --NOP => 149
        Regout_DE(139) & -- SwapForward => 148
        Regout_DE(138) & -- call_stack_ptr => 147
        Regout_DE(137) & -- free => 146
        Regout_DE(136) & -- protect => 145
        Regout_DE(135) & -- Mem_rd => 144
        Regout_DE(134) & -- Mem_wr => 143
        Regout_DE(133) & -- WB => 142
        Regout_DE(132) & -- WB_2 => 141 
        Regout_DE(131 DOWNTO 130) & -- WB src => 139 - 140
        Regout_DE(127) & -- stack ptr select => 138
        Regout_DE(126) & -- stack ptr update => 137
        Excute_Input & -- 105 - 136
        Regout_DE(100 DOWNTO 69) & -- PCVal => 73 - 104
        Excute_Result & -- 41 - 72
        Regout_DE(64 DOWNTO 33) & --Operand1 => 9 - 40
        Regout_DE(109 DOWNTO 101) -- Rdst/Rsrc1/Rsrc2 => 0 - 8 
        ;
    REG_EM : ENTITY work.Reg GENERIC MAP(
        150) PORT MAP(
        Clk => clk,
        Input => REGIN_EM,
        Output => REGOUT_EM,
        Rst => reset
        );
       
    anding <= REGOUT_EM(138) AND REGOUT_MW(169);
    M : ENTITY work.Mem_Stage PORT MAP(
        call_sp => REGOUT_EM(147),
        sp_sel => REGOUT_EM(138),
        free => REGOUT_EM(146),
        protect => REGOUT_EM(145),
        mem_write => REGOUT_EM(143),
        mem_read => REGOUT_EM(144),
        SPoperation => REGOUT_EM(147),
        SPOrSPNext => anding,
        sp => SPout,
        clk => clk,
        pc => REGOUT_EM(104 DOWNTO 73),
        alu_out => REGOUT_EM(72 DOWNTO 41),
        op_1 => REGOUT_EM(40 DOWNTO 9),
        ForwardingSP => REGOUT_MW(136 DOWNTO 105), --The next stage Sp value
        mem_data => MemDataOut,
        SPOut => SPNextVal
        );

    REGIN_MW <=
        Regout_EM(149) & --NOP => 175
        Regout_EM(148) & -- SwapForward => 174
        Regout_EM(142) & -- WB => 173
        Regout_EM(141) & -- WB_2 => 172
        Regout_EM(140 DOWNTO 139) & -- WB src =>  171 - 170 
        Regout_EM(138) & -- stack ptr select => 169
        REGOUT_EM(136 DOWNTO 105) & --Alu Input 1 => 168 - 137
        SPNextVal & -- 136 - 105
        MemDataOut & -- 104 - 73 
        REGOUT_EM(72 DOWNTO 41) & --ALU_output => 72 - 41
        REGOUT_EM(8 DOWNTO 0) & -- Rdst/Rsrc1/Rsrc2 => 40 - 32
        REGOUT_EM(40 DOWNTO 9); --Operand1 => 31 - 0 

    REG_MW : ENTITY work.Reg GENERIC MAP(
        176) PORT MAP(
        Clk => clk,
        Input => REGIN_MW,
        Output => Regout_MW,
        Rst => reset
        );
        

    WB_Stage : ENTITY work.WriteBackStage
        PORT  map(
            clk => clk,
            wbsrc => Regout_MW(171 DOWNTO 170), --
            memdata => Regout_MW(104 DOWNTO 73), --
            aludata => Regout_MW(72 DOWNTO 41), --
            portdata => in_port, --
            wbdata => Rdst_WB_data--
        );
END ARCHITECTURE Arch_Quantum_Pipe;