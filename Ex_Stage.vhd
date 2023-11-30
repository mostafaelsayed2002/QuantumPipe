LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Ex_Stage IS
    PORT (


    
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        c_old : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        outp : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        c_new : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

    );
END ENTITY;



ARCHITECTURE ARCH_Ex_Stage OF Ex_Stage IS


END ARCH_Ex_Stage; 

