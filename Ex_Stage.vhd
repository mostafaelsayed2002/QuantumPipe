LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Ex_Stage IS
    PORT (
        --control signals input 
        IMM_EA : IN STD_LOGIC;
        ALU_SRC : IN STD_LOGIC;
        ALU_OP : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        FW_SEL_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        FW_SEL_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        --data input
        OP_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        OP_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        bit_ea_4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        bit_ea_imm_16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_WB_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_output : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_SWAP_Ex : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_SWAP_Mem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --data output
        Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Input_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Port_Data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;

ARCHITECTURE ARCH_Ex_Stage OF Ex_Stage IS
    SIGNAL alu_in_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_in_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL op2_imm_ea : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL imm_ase : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL ea_ase : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL op2_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL c_new : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL cat_signal : STD_LOGIC_VECTOR(19 DOWNTO 0);
BEGIN

    se0 : ENTITY work.SignExtend GENERIC MAP(16) PORT MAP(
        length => '1',
        s_input => bit_ea_imm_16,
        s_output => imm_ase
        );

    cat_signal <= bit_ea_4 & bit_ea_imm_16;
    se1 : ENTITY work.SignExtend GENERIC MAP(20) PORT MAP(
        length => '0',
        s_input => cat_signal,
        s_output => ea_ase
        );
    m0 : ENTITY work.Mux_2_1 GENERIC MAP(32) PORT MAP(
        a => imm_ase,
        b => ea_ase,
        sel => IMM_EA,
        y => op2_imm_ea
        );

    m1 : ENTITY work.Mux_2_1 GENERIC MAP(32) PORT MAP(
        a => op2_imm_ea,
        b => OP_2,
        sel => ALU_SRC,
        y => op2_mux
        );
    m2 : ENTITY work.Mux_5_3 GENERIC MAP(32) PORT MAP(
        a => OP_1,
        b => Rdst_WB_data,
        c => Rdst_SWAP_Ex,
        d => Rdst_SWAP_Mem,
        e => Alu_output,
        s => Fw_Sel_1,
        y => alu_in_1
        );

    m3 : ENTITY work.Mux_5_3 GENERIC MAP(32) PORT MAP(
        a => op2_mux,
        b => Rdst_WB_data,
        c => Rdst_SWAP_Ex,
        d => Rdst_SWAP_Mem,
        e => Alu_output,
        s => Fw_Sel_2,
        y => alu_in_2
        );

    alu : ENTITY work.ALU PORT MAP(
        op => ALU_OP,
        c_old => "000",
        in1 => alu_in_1,
        in2 => alu_in_2,
        outp => Result,
        c_new => c_new
        );

    Input_1 <= alu_in_1;
    Port_Data <= alu_in_1;

END ARCH_Ex_Stage;