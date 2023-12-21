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
        CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
        CCRout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0):= (OTHERS => '0');
        JZ : OUT STD_LOGIC
    );
END ENTITY Decode_Stage;
ARCHITECTURE Decode_Stage_Arch OF Decode_Stage IS

    SIGNAL opCode : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Rdst : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rsrc2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL CCR_Temp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Mux1_in : STD_LOGIC;
    SIGNAL Mux2_in : STD_LOGIC;
    SIGNAL Mux1_Out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Mux2_Out : STD_LOGIC_VECTOR(2 DOWNTO 0);

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
    CCRout <= CCR_Temp;

    JZ <= '1' WHEN opCode = "01101" ELSE
        '0';
    temp2 <= '1' WHEN (opCode(4 DOWNTO 1) = "0111") ELSE
        '0';
    jmp_Flag <=  temp2; -- (temp1) OR (temp2);

END ARCHITECTURE Decode_Stage_Arch;