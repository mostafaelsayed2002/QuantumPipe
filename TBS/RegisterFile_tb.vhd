LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY RegisterFile_tb IS
END ENTITY RegisterFile_tb;

ARCHITECTURE RegisterFile_tbArch OF RegisterFile_tb IS
    CONSTANT ClockFreq : INTEGER := 100e6;
    CONSTANT ClockPeriod : TIME := 1200ms / ClockFreq;
    SIGNAL Clk : STD_LOGIC := '1';
    SIGNAL Rsrc1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rsrc2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rout1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rout2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rin1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rin2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PCin : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PCout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SPin : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL SPout : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CCRin : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CCRout : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RWriteSignal1 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RWriteSignal2 : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PCWriteSignal : STD_LOGIC := '0'; -- '0' Read / '1' Write
    SIGNAL SPWriteSignal : STD_LOGIC := '0'; -- '0' Read / '1' Write
    SIGNAL CCRWriteSignal : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0'); -- '0' Read / '1' Write
BEGIN
    rg : ENTITY work.RegisterFile(RegisterFileArch) PORT MAP(
        Clk => Clk,
        Rsrc1 => Rsrc1,
        Rsrc2 => Rsrc2,
        Rout1 => Rout1,
        Rout2 => Rout2,
        Rin1 => Rin1,
        Rin2 => Rin2,
        PCin => PCin,
        PCout => PCout,
        SPin => SPin,
        SPout => SPout,
        CCRin => CCRin,
        CCRout => CCRout,
        RWriteSignal1 => RWriteSignal1,
        RWriteSignal2 => RWriteSignal2,
        PCWriteSignal => PCWriteSignal,
        SPWriteSignal => SPWriteSignal,
        CCRWriteSignal => CCRWriteSignal);

    Clk <= NOT Clk AFTER ClockPeriod /2;
    PROCESS
    BEGIN
        WAIT FOR 12 ns;

        Rsrc1 <= "001";
        Rsrc2 <= "010";
        Rin1 <= (OTHERS => '1');
        Rin2 <= (OTHERS => '1');
        PCin <= (OTHERS => '1');
        SPin <= (OTHERS => '1');
        CCRin <= "010";

        WAIT FOR 2 ns;

        RWriteSignal1 <= "001";
        RWriteSignal2 <= "010";
        PCWriteSignal <= '0';
        SPWriteSignal <= '0';
        CCRWriteSignal <= "111";

        WAIT FOR 5 ns;

        RWriteSignal1 <= "001";
        RWriteSignal2 <= "010";
        PCWriteSignal <= '1';
        SPWriteSignal <= '1';
        CCRWriteSignal <= "000";

        WAIT FOR 5 ns;

        PCWriteSignal <= '0';
        SPWriteSignal <= '0';

    END PROCESS;
END ARCHITECTURE RegisterFile_tbArch;