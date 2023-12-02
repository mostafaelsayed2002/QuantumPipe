LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity Quantum_Pipe is 
    Port(
        --inputs
        in_port: in std_logic_vector(31 downto 0);
        intr: in std_logic;
        reset: in std_logic;
        --output 
        out_port: out std_logic_vector(31 downto 0);
    );
End Quantum_Pipe;

architecture Arch_Quantum_Pipe of Quantum_Pipe is 
    SIGNAL clk : std_logic;
    SIGNAL fixpc : std_logic;
    SIGNAL jmpflag : std_logic;
    SIGNAL pcval : std_logic_vector(31 downto 0);
    SIGNAL instr : std_logic_vector(15 downto 0);
    SIGNAL Regout_FD : std_logic_vector(47 downto 0);
    SIGNAL WB1_Signal : std_logic;
    SIGNAL WB2_Signal : std_logic;
    SIGNAL WB1_Address : std_logic_vector(2 downto 0);
    SIGNAL WB2_Address : std_logic_vector(2 downto 0);
    SIGNAL WB1_data : std_logic_vector(31 downto 0);
    SIGNAL WB2_data : std_logic_vector(31 downto 0);
    SIGNAL Data_R1 : std_logic_vector(31 downto 0);
    SIGNAL Data_R2 : std_logic_vector(31 downto 0);
    SIGNAL zero_flag : std_logic;
    SIGNAL Regout_DE : std_logic_vector(142 downto 0);
    SIGNAL IMM_EA : std_logic;
    SIGNAL ALU_SRC : std_logic;
    SIGNAL ALU_OP : std_logic_vector(3 downto 0);
    SIGNAL Fw_Sel_1 : std_logic_vector(2 downto 0);
    SIGNAL Fw_Sel_2 : std_logic_vector(2 downto 0);
    SIGNAL Rdst_WB_data : std_logic_vector(31 downto 0);
    SIGNAL ALU_output : std_logic_vector(31 downto 0);
    begin
        process(clk)
        begin
            wait for 10 ns;
            clk <= not clk;
        end process;
    F: FetchingStage port map(
        clk => clk,
        fixpc => fixpc,
        jmpflag => jmpflag,
        jmplocation => Data_R1,
        pcval => pcval,
        instr => instr 
    );
    REG_FD: Reg GENERIC MAP(48) port map(
        Clk => clk,
        Input => pcval & instr ,
        Output => Regout_FD,
        Rst => reset
    );
    D: Decode_Stage port map(
        Clk => clk,
        Instruction => Regout_FD(15 downto 0),
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
    REG_DE: Reg GENERIC MAP(143) port map(
        Clk => clk,
        Input => Regout_FD(3 downto 0) & Date_R1 & Data_R2 & zero_flag,
        Output => Regout_DE,
        Rst => reset
    );

    E: Ex_Stage port map(
        IMM_EA => IMM_EA,
        ALU_SRC => ALU_SRC,
        ALU_OP => ALU_OP,
        FW_SEL_1 => FW_SEL_1,
        FW_SEL_2 => FW_SEL_2,
        OP_1 => Regout_DE(32 downto 1),
        OP_2 => Regout_DE(64 downto 33),
        bit_ea_4 => Regout_DE(68 downto 65),
        bit_ea_imm_16 => instr,
        ----
        Rdst_WB_data => Rdst_WB_data,
        ALU_output => ALU_output,
        ---        Rdst_SWAP_Ex => Regout_DE(195 downto 164),
        Rdst_SWAP_Mem => Regout_DE(227 downto 196),
        Result => Regout_DE(259 downto 228),
        Input_1 => Regout_DE(291 downto 260),
        Port_Data => Regout_DE(323 downto 292)
    );
    

end architecture Arch_Quantum_Pipe;





