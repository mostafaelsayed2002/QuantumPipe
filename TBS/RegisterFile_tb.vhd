LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY RegisterFile_TestBench IS
END ENTITY RegisterFile_TestBench;

ARCHITECTURE TestBenchArch OF RegisterFile_TestBench IS
    SIGNAL Clk : STD_LOGIC := '0';
    SIGNAL Rsrc1, Rsrc2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL Rout1, Rout2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Rin1, Rin2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SPin, SPout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CCRin, CCRout : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB1_Address, WB2_Address : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL WB1_Signal, WB2_Signal, SPWriteSignal : STD_LOGIC := '0';
    SIGNAL CCRWriteSignal : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

    COMPONENT RegisterFile
        PORT (
            Clk : IN STD_LOGIC;
            Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Rout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rin1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            Rin2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SPin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            SPout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            CCRout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB1_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB2_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB1_Signal : IN STD_LOGIC;
            WB2_Signal : IN STD_LOGIC;
            SPWriteSignal : IN STD_LOGIC;
            CCRWriteSignal : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    UUT : RegisterFile
    PORT MAP(
        Clk => Clk,
        Rsrc1 => Rsrc1,
        Rsrc2 => Rsrc2,
        Rout1 => Rout1,
        Rout2 => Rout2,
        Rin1 => Rin1,
        Rin2 => Rin2,
        SPin => SPin,
        SPout => SPout,
        CCRin => CCRin,
        CCRout => CCRout,
        WB1_Address => WB1_Address,
        WB2_Address => WB2_Address,
        WB1_Signal => WB1_Signal,
        WB2_Signal => WB2_Signal,
        SPWriteSignal => SPWriteSignal,
        CCRWriteSignal => CCRWriteSignal
    );

    -- Clock process
    PROCESS
    BEGIN
        WAIT FOR 5 ns;
        Clk <= NOT Clk;
    END PROCESS;

    -- Stimulus process
    PROCESS
    BEGIN
        WAIT FOR 10 ns;
        Rsrc1 <= "010"; -- Select R1 for Rout1
        Rsrc2 <= "010"; -- Select R2 for Rout2
        Rin1 <= x"0000000A"; -- Input data for R1
        Rin2 <= x"0000000F"; -- Input data for R2
        WB1_Address <= "000"; -- Write to R1
        WB2_Address <= "001"; -- Write to R1
        WB1_Signal <= '1'; -- Enable write to R1
        WB2_Signal <= '1'; -- Enable write to R1
        WAIT FOR 10 ns;
        WB1_Signal <= '0'; -- Enable write to R1
        WB2_Signal <= '0'; -- Enable write to R1
        Rsrc1 <= "000"; -- Select R1 for Rout1
        Rsrc2 <= "001"; -- Select R2 for Rout2

        -- Add more stimuli as needed

        WAIT;
    END PROCESS;

END TestBenchArch;