LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY Hazard_Detection IS
    PORT (
        Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MemRead : IN STD_LOGIC;
        InsertNop : OUT STD_LOGIC;
        FixPC : OUT STD_LOGIC
    );
END ENTITY Hazard_Detection;


ARCHITECTURE Arch_Hazard_Detection OF Hazard_Detection IS
BEGIN
    PROCESS(MemRead, Rsrc1, Rsrc2, Rdst)
    BEGIN
        IF MemRead  = '1' and (Rsrc1 = Rdst or Rsrc2 = Rdst) THEN
            InsertNop  <= '1';
            FixPC  <= '1';
        ELSE 
            InsertNop  <= '0';
            FixPC  <= '0';
        END IF;
    END PROCESS;
END ARCHITECTURE Arch_Hazard_Detection;