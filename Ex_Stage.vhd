LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Ex_Stage IS
    PORT (
        --control signals input 
        IMM_EA : IN STD_LOGIC;
        ALU_SRC: IN STD_LOGIC;
        FW_SRC: IN STD_LOGIC;
        ALU_OP: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        IMP_SRCs: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        FW_SEL_1: IN STD_LOGIC(2 DOWNTO 0);
        FW_SEL_2: IN STD_LOGIC(2 DOWNTO 0);
        --data input
        OP_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        OP_2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        bit_ea_4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        bit_ea_imm_16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_WB_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_output : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_SWAP_Ex: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rdst_SWAP_Mem: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --data output
        Result: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Input_1: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Port_Data: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)   
    );
END ENTITY;



ARCHITECTURE ARCH_Ex_Stage OF Ex_Stage IS
    SIGNAL alu_in_1: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_in_2: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL op2_imm_ea: STD_LOGIC_VECTOR(31 DOWNTO 0);

    
    m0: entity work.Mux_2_1 GENERIC MAP(32) port map(
        a => OP_2,
        b => bit_ea_imm_16,
        sel => IMM_EA,
        y => op2_imm_ea
    );



    m1: entity work.Mux_5_3 GENERIC MAP(32) port map(
        a => OP_1,
        b => Rdst_WB_data,  
        c => Rdst_SWAP_Ex,
        d => Rdst_SWAP_Mem,
        e => Alu_output,
        sel => Fw_Sel_1,
        y => alu_in_1
    );
    m2: entity work.Mux_5_3 GENERIC MAP(32) port map(
        a => op2_imm_ea,
        b => Rdst_WB_data,  
        c => Rdst_SWAP_Ex,
        d => Rdst_SWAP_Mem,
        e => Alu_output,
        sel => Fw_Sel_2,
        y => alu_in_2
    );


END ARCH_Ex_Stage; 

