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
        out_port : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    );
END Quantum_Pipe;

ARCHITECTURE Arch_Quantum_Pipe OF Quantum_Pipe IS
    SIGNAL clk : STD_LOGIC;
    SIGNAL fixpc : STD_LOGIC;
    SIGNAL jmpflag : STD_LOGIC;
    SIGNAL pcval : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Regout_FD : STD_LOGIC_VECTOR(47 DOWNTO 0);
    SIGNAL WB1_Signal : STD_LOGIC;
    SIGNAL WB2_Signal : STD_LOGIC;
    SIGNAL WB1_Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB2_Address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WB2_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Data_R1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Data_R2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero_flag : STD_LOGIC;
    SIGNAL Regout_DE : STD_LOGIC_VECTOR(142 DOWNTO 0);
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
BEGIN
    PROCESS (clk)
    BEGIN
        WAIT FOR 10 ns;
        clk <= NOT clk;
    END PROCESS;
    F : FetchingStage PORT MAP(
        clk => clk,
        fixpc => fixpc,
        jmpflag => jmpflag,
        jmplocation => Data_R1,
        pcval => pcval,
        instr => instr
    );
    REG_FD : Reg GENERIC MAP(
        48) PORT MAP(
        Clk => clk,
        Input => ,
        Output => Regout_FD,
        Rst => reset
    );
    D : Decode_Stage PORT MAP(
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
    );
    REG_DE : Reg GENERIC MAP(
        143) PORT MAP(
        Clk => clk,
        Input => Regout_FD(3 DOWNTO 0) & Date_R1 & Data_R2 & zero_flag,
        Output => Regout_DE,
        Rst => reset
    );

    E : Ex_Stage PORT MAP(
        IMM_EA => IMM_EA,
        ALU_SRC => ALU_SRC,
        ALU_OP => ALU_OP,
        FW_SEL_1 => FW_SEL_1,
        FW_SEL_2 => FW_SEL_2,
        OP_1 => Regout_DE(32 DOWNTO 1),
        OP_2 => Regout_DE(64 DOWNTO 33),
        bit_ea_4 => Regout_DE(68 DOWNTO 65),
        bit_ea_imm_16 => instr,
        ----
        Rdst_WB_data => Rdst_WB_data, -- from wb
        ALU_output => ALU_output, -- from memory
        Rdst_SWAP_Ex => Rdst_SWAP_Ex,
        Rdst_SWAP_Mem => Rdst_SWAP_Mem,
        Result => Excute_Result,
        Input_1 => Excute_Input,
        Port_Data => in_port
    );

    REG_DE : Reg GENERIC MAP(
        149) PORT MAP(
        Clk => clk,
        Input => ,
        Output => Regout_DE,
        Rst => reset
    );
END ARCHITECTURE Arch_Quantum_Pipe;