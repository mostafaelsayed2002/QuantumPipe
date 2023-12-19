LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;


ENTITY Forwarding_Unit IS
    PORT (
        Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the first source 000
        Rsrc2_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the second source 001
         
        Rdst_Ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the first dist ex 001
       
        Rdst_Mem : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the first dist mem 000
        
        Rsrc1_Ex : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the second dist ex 000
       
        Rsrc1_Mem : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- the second dist mem 000
               
        WB_Ex : IN STD_LOGIC; --1
        WB_Mem : IN STD_LOGIC;--0


        SWAP_FW_Ex : IN STD_LOGIC;
        SWAP_FW_Mem : IN STD_LOGIC;

        SEL_OP1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        SEL_OP2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Forwarding_Unit;

ARCHITECTURE Arch_Forwarding_Unit OF Forwarding_Unit IS
BEGIN
    PROCESS (Rsrc1, Rsrc2_Rdst, Rdst_Ex, Rdst_Mem, Rsrc1_Ex, Rsrc1_Mem, WB_Ex, WB_Mem, SWAP_FW_Ex, SWAP_FW_Mem)
    VARIABLE R1_equal_Rdst1_Ex : STD_LOGIC := '0';
    VARIABLE R1_equal_Rdst1_Mem : STD_LOGIC := '0';
    VARIABLE R1_equal_Rdst2_Ex : STD_LOGIC := '0';
    VARIABLE R1_equal_Rdst2_Mem : STD_LOGIC := '0';
    -------------------------------------------
    VARIABLE R2_equal_Rdst1_Ex : STD_LOGIC := '0';
    VARIABLE R2_equal_Rdst1_Mem : STD_LOGIC := '0';
    VARIABLE R2_equal_Rdst2_Ex : STD_LOGIC := '0';
    VARIABLE R2_equal_Rdst2_Mem : STD_LOGIC := '0';    
    BEGIN
        -- calc the state of the Rsrc1
        IF Rsrc1 = Rdst_Ex THEN
            R1_equal_Rdst1_Ex := '1';
        ELSE
            R1_equal_Rdst1_Ex := '0';
        END IF;
        IF Rsrc1 = Rdst_Mem THEN
            R1_equal_Rdst1_Mem := '1';
        ELSE
            R1_equal_Rdst1_Mem := '0';
        END IF;    
        IF Rsrc1 = Rsrc1_Ex THEN
            R1_equal_Rdst2_Ex := '1';
        ELSE
            R1_equal_Rdst2_Ex := '0';
        END IF;  
        IF Rsrc1 = Rsrc1_Mem THEN
            R1_equal_Rdst2_Mem := '1';
        ELSE
            R1_equal_Rdst2_Mem := '0';
        END IF;  
        -- calc the state of the Rsrc2
        IF Rsrc2_Rdst = Rdst_Ex THEN
            R2_equal_Rdst1_Ex := '1';
        ELSE
            R2_equal_Rdst1_Ex := '0';
        END IF;
        IF Rsrc2_Rdst = Rdst_Mem THEN
            R2_equal_Rdst1_Mem := '1';
        ELSE
            R2_equal_Rdst1_Mem := '0';
        END IF;    
        IF Rsrc2_Rdst = Rsrc1_Ex THEN
            R2_equal_Rdst2_Ex := '1';
        ELSE
            R2_equal_Rdst2_Ex := '0';
        END IF;  
        IF Rsrc2_Rdst = Rsrc1_Mem THEN
            R2_equal_Rdst2_Mem := '1';
        ELSE
            R2_equal_Rdst2_Mem := '0';
        END IF;  

        -- set the  SEL_OP1
        IF SWAP_FW_Ex = '1' and (R1_equal_Rdst1_Ex = '1' or R1_equal_Rdst2_Ex ='1') THEN     
            IF R1_equal_Rdst1_Ex= '1' THEN
                SEL_OP1 <= "100"; -- select Rdst1 EX 
            ELSE 
                SEL_OP1 <= "010"; -- select Rdst2 EX 
            END IF;
        ELSE
            IF SWAP_FW_Mem = '1' and (R1_equal_Rdst1_Mem = '1' or   R1_equal_Rdst2_Mem ='1') THEN 
                IF R1_equal_Rdst1_Mem = '1' THEN
                    SEL_OP1 <= "001"; -- select Rdst1 mem 
                ELSE 
                    SEL_OP1 <= "011"; -- select Rdst2 mem 
                END IF;
            ELSE 
                IF WB_Ex = '1' and R1_equal_Rdst1_Ex = '1'  THEN 
                    SEL_OP1 <= "100"; -- select Rdst1 EX
                ELSE 
                    IF WB_Mem = '1' and R1_equal_Rdst1_Mem = '1' THEN
                         SEL_OP1 <= "001"; -- select Rdst1 mem 
                    ELSE 
                        SEL_OP1 <= "000"; -- select Default
                    END IF;
                END IF;
            END IF;
        END IF;  


        -- set the  SEL_OP2
        IF SWAP_FW_Ex = '1' and (R2_equal_Rdst1_Ex = '1' or   R2_equal_Rdst2_Ex ='1') THEN     
            IF R2_equal_Rdst1_Ex= '1' THEN
                SEL_OP2 <= "100"; -- select Rdst1 EX 
            ELSE 
                SEL_OP2 <= "010"; -- select Rdst2 EX 
            END IF;
        ELSE
            IF SWAP_FW_Mem = '1' and (R2_equal_Rdst1_Mem = '1' or  R2_equal_Rdst2_Mem ='1') THEN 
                IF R2_equal_Rdst1_Mem = '1' THEN
                    SEL_OP2 <= "001"; -- select Rdst1 mem 
                ELSE 
                    SEL_OP2 <= "011"; -- select Rdst2 mem 
                END IF;
            ELSE 
                IF WB_Ex = '1' and R2_equal_Rdst1_Ex = '1'  THEN 
                    SEL_OP2 <= "100"; -- select Rdst1 EX
                ELSE 
                    IF WB_Mem = '1' and R2_equal_Rdst1_Mem = '1' THEN
                        SEL_OP2 <= "001"; -- select Rdst1 mem 
                ELSE 
                        SEL_OP2 <= "000"; -- select Default
                    END IF;
                END IF;
            END IF;
        END IF; 



    END PROCESS;
END ARCHITECTURE Arch_Forwarding_Unit;


