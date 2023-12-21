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
        SPout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        CCRin : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- 0 => Zero Flag / 1 => Neg Flag / 2 => Carry Flag
        CCRout : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
        WB1_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB2_Address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB1_Signal : IN STD_LOGIC;
        WB2_Signal : IN STD_LOGIC
    );
END ENTITY RegisterFile;

ARCHITECTURE RegisterFileArch OF RegisterFile IS
    SIGNAL R0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R3 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R4 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R5 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R6 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL R7 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL CCR : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    BEGIN
    
    CCRout <= CCR;
    
    PROCESS (Clk)
    BEGIN
    IF rising_edge(Clk) THEN
            CCR <= CCRin;
            IF (WB1_Signal = '1') THEN

                CASE WB1_Address IS
                    WHEN "000" =>
                        R0 <= Rin1;
                    WHEN "001" =>
                        R1 <= Rin1;
                    WHEN "010" =>
                        R2 <= Rin1;
                    WHEN "011" =>
                        R3 <= Rin1;
                    WHEN "100" =>
                        R4 <= Rin1;
                    WHEN "101" =>
                        R5 <= Rin1;
                    WHEN "110" =>
                        R6 <= Rin1;
                    WHEN OTHERS =>
                        R7 <= Rin1;
                END CASE;
            END IF;

            IF (WB2_Signal = '1') THEN

                CASE WB2_Address IS
                    WHEN "000" =>
                        R0 <= Rin2;
                    WHEN "001" =>
                        R1 <= Rin2;
                    WHEN "010" =>
                        R2 <= Rin2;
                    WHEN "011" =>
                        R3 <= Rin2;
                    WHEN "100" =>
                        R4 <= Rin2;
                    WHEN "101" =>
                        R5 <= Rin2;
                    WHEN "110" =>
                        R6 <= Rin2;
                    WHEN OTHERS =>
                        R7 <= Rin2;
                END CASE;
            END IF;


        END IF;
    END PROCESS;


    PROCESS (Clk)
    BEGIN
        IF falling_edge(Clk) THEN
            CASE Rsrc1 IS
                WHEN "000" =>
                    Rout1 <= R0;
                WHEN "001" =>
                    Rout1 <= R1;
                WHEN "010" =>
                    Rout1 <= R2;
                WHEN "011" =>
                    Rout1 <= R3;
                WHEN "100" =>
                    Rout1 <= R4;
                WHEN "101" =>
                    Rout1 <= R5;
                WHEN "110" =>
                    Rout1 <= R6;
                WHEN OTHERS =>
                    Rout1 <= R7;
            END CASE;

            CASE Rsrc2 IS
                WHEN "000" =>
                    Rout2 <= R0;
                WHEN "001" =>
                    Rout2 <= R1;
                WHEN "010" =>
                    Rout2 <= R2;
                WHEN "011" =>
                    Rout2 <= R3;
                WHEN "100" =>
                    Rout2 <= R4;
                WHEN "101" =>
                    Rout2 <= R5;
                WHEN "110" =>
                    Rout2 <= R6;
                WHEN OTHERS =>
                    Rout2 <= R7;
            END CASE;

        END IF;

    END PROCESS;

END RegisterFileArch;