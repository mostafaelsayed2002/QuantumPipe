LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Decode_Stage IS
    PORT (
        Clk : IN STD_LOGIC;
        Instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB1_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB2_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB1_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB2_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB1_Signal : IN STD_LOGIC;
        WB2_Signal : IN STD_LOGIC;
        Data_R1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Data_R2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        jmp_Flag : OUT STD_LOGIC := '0';
        Zero_Flag : OUT STD_LOGIC := '0';
        Neg_Flag : OUT STD_LOGIC := '0';
        Carry_Flag : OUT STD_LOGIC := '0';
        SPout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Decode_Stage;
ARCHITECTURE Decode_Stage_Arch OF Decode_Stage IS
    -- COMPONENT RegisterFile
    --     PORT (
    --         Clk : IN STD_LOGIC;
    --         Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         Rout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --         Rout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    --         Rin1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    --         Rin2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    --         CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         CCRout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         WB1_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         WB2_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    --         WB1_Signal : IN STD_LOGIC;
    --         WB2_Signal : IN STD_LOGIC
    --     );
    -- END COMPONENT;

    -- COMPONENT mux_2_1
    --     GENERIC (
    --         N : INTEGER := 8
    --     );
    --     PORT (
    --         a, b : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    --         sel : IN STD_LOGIC;
    --         y : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    --     );
    -- END COMPONENT;

    SIGNAL opCode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Rdst : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL CCR_Temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Mux1_in : STD_LOGIC;
    SIGNAL Mux2_in : STD_LOGIC;
    SIGNAL Mux1_Out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Mux2_Out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp1 : STD_LOGIC;
    SIGNAL temp2 : STD_LOGIC;
    SIGNAL ORING : STD_LOGIC;
BEGIN

    opCode <= Instruction(15 DOWNTO 11);
    Rdst <= Instruction(10 DOWNTO 8);
    Rsrc1 <= Instruction(7 DOWNTO 5);
    Rsrc2 <= Instruction(4 DOWNTO 2);
    ORING <= '1' WHEN ((opCode(4 DOWNTO 3) = "11") OR (opCode(4) = '0')) ELSE
        '0';
    Mux2_in <= '1' WHEN ((opCode = "10101") OR (opCode = "10110")) ELSE
        '0';

    Mux1_in <= Mux2_in or ORING;
        
    Mux1 : ENTITY work.Mux_2_1 GENERIC MAP(3) PORT MAP(
        a => Rsrc1,
        b => Rdst,
        sel => Mux1_in,
        y => Mux1_Out
        );

    Mux2 : ENTITY work.Mux_2_1 GENERIC MAP(3) PORT MAP(
        a => Rsrc2,
        b => Rsrc1,
        sel => Mux2_in,
        y => Mux2_Out
        );

    RF : ENTITY work.RegisterFile PORT MAP(
        Clk => CLk,
        Rsrc1 => Mux1_Out,
        Rsrc2 => Mux2_Out,
        Rout1 => Data_R1,
        Rout2 => Data_R2,
        Rin1 => WB1_data,
        Rin2 => WB2_data,
        CCRin => CCRin,
        CCRout => CCR_Temp,
        WB1_Address => WB1_Address,
        WB2_Address => WB2_Address,
        WB1_Signal => WB1_Signal,
        WB2_Signal => WB2_Signal
        );
    Zero_Flag <= CCR_Temp(0);
    Neg_Flag <= CCR_Temp(1);
    Carry_Flag <= CCR_Temp(2);

    temp1 <= '1' WHEN ((opCode = "01101") AND (CCR_Temp(0) = '1')) ELSE
        '0';
    temp2 <= '1' WHEN (opCode(4 DOWNTO 1) = "0111") ELSE
        '0';
    jmp_Flag <= (temp1) OR (temp2);

END ARCHITECTURE Decode_Stage_Arch;