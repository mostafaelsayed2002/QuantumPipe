LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY RegisterFile IS
    PORT (
        Clk : IN STD_LOGIC;
        Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Rout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        Rin1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Rin2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SPin : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SPout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0 => Zero Flag / 1 => Neg Flag / 2 => Carry Flag
        CCRout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        WB1_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB2_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB1_Signal : IN STD_LOGIC;
        WB2_Signal : IN STD_LOGIC;
        SPWriteSignal : IN STD_LOGIC; -- '0' Read / '1' Write
        CCRWriteSignal : IN STD_LOGIC_VECTOR(2 DOWNTO 0) -- '0' Read / '1' Write
    );
END ENTITY RegisterFile;

ARCHITECTURE RegisterFileArch OF RegisterFile IS
BEGIN
    PROCESS (Clk)
        VARIABLE R0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R3 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R5 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R6 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE R7 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE SP : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE CCR : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        VARIABLE Rout1_Temp : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE Rout2_Temp : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    BEGIN
        IF rising_edge(Clk) THEN
            IF (WB1_Signal = '1') THEN

                CASE WB1_Address IS
                    WHEN "000" =>
                        R0 := Rin1;
                    WHEN "001" =>
                        R1 := Rin1;
                    WHEN "010" =>
                        R2 := Rin1;
                    WHEN "011" =>
                        R3 := Rin1;
                    WHEN "100" =>
                        R4 := Rin1;
                    WHEN "101" =>
                        R5 := Rin1;
                    WHEN "110" =>
                        R6 := Rin1;
                    WHEN OTHERS =>
                        R7 := Rin1;
                END CASE;
            END IF;

            IF (WB2_Signal = '1') THEN

                CASE WB2_Address IS
                    WHEN "000" =>
                        R0 := Rin2;
                    WHEN "001" =>
                        R1 := Rin2;
                    WHEN "010" =>
                        R2 := Rin2;
                    WHEN "011" =>
                        R3 := Rin2;
                    WHEN "100" =>
                        R4 := Rin2;
                    WHEN "101" =>
                        R5 := Rin2;
                    WHEN "110" =>
                        R6 := Rin2;
                    WHEN OTHERS =>
                        R7 := Rin2;
                END CASE;
            END IF;

            IF (SPWriteSignal = '1') THEN
                SP := SPin;
            END IF;

            IF (CCRWriteSignal(0) = '1') THEN
                CCR(0) := CCRin(0);
            END IF;

            IF (CCRWriteSignal(1) = '1') THEN
                CCR(1) := CCRin(1);
            END IF;

            IF (CCRWriteSignal(2) = '1') THEN
                CCR(2) := CCRin(2);
            END IF;
        END IF;

        IF falling_edge(Clk) THEN
            CASE Rsrc1 IS
                WHEN "000" =>
                    Rout1_Temp := R0;
                WHEN "001" =>
                    Rout1_Temp := R1;
                WHEN "010" =>
                    Rout1_Temp := R2;
                WHEN "011" =>
                    Rout1_Temp := R3;
                WHEN "100" =>
                    Rout1_Temp := R4;
                WHEN "101" =>
                    Rout1_Temp := R5;
                WHEN "110" =>
                    Rout1_Temp := R6;
                WHEN OTHERS =>
                    Rout1_Temp := R7;
            END CASE;

            CASE Rsrc2 IS
                WHEN "000" =>
                    Rout2_Temp := R0;
                WHEN "001" =>
                    Rout2_Temp := R1;
                WHEN "010" =>
                    Rout2_Temp := R2;
                WHEN "011" =>
                    Rout2_Temp := R3;
                WHEN "100" =>
                    Rout2_Temp := R4;
                WHEN "101" =>
                    Rout2_Temp := R5;
                WHEN "110" =>
                    Rout2_Temp := R6;
                WHEN OTHERS =>
                    Rout2_Temp := R7;
            END CASE;

            IF (Rout1_Temp = x"00000000") THEN
                CCR(0) := '1';
            ELSIF (Rout2_Temp = x"00000000") THEN
                CCR(0) := '1';
            ELSE
                CCR(0) := '0';
            END IF;

            Rout1 <= Rout1_Temp;
            Rout2 <= Rout2_Temp;

            SPout <= SP;

            CCRout(0) <= CCR(0);
            CCRout(1) <= CCR(1);
            CCRout(2) <= CCR(2);
        END IF;

    END PROCESS;
END RegisterFileArch;