LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
-- Include textio package for file I/O
USE std.textio.ALL; -- Include textio package for file I/O

ENTITY InstructionMemory IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        clk : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        insout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
    );
END InstructionMemory;
ARCHITECTURE InstructionMemoryArch OF InstructionMemory IS
    TYPE mem_type IS ARRAY(0 TO (2 ** ADDRESS_BITS - 1)) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- function to initialize memory content
    FUNCTION init_memory_wfile(mif_file_name : IN STRING) RETURN mem_type IS
        FILE mif_file : text OPEN read_mode IS mif_file_name;
        VARIABLE mif_line : line;
        VARIABLE temp_bv : bit_vector(15 DOWNTO 0);
        VARIABLE temp_mem : mem_type;
        VARIABLE i : INTEGER := 0;
        VARIABLE end_of_file : BOOLEAN := false;
    BEGIN
        FOR i IN mem_type'RANGE LOOP
            IF NOT end_of_file THEN
                IF NOT endfile(mif_file) THEN
                    readline(mif_file, mif_line);
                    read(mif_line, temp_bv);
                    temp_mem(i) := to_stdlogicvector(temp_bv);
                ELSE
                    end_of_file := true; -- Set the flag when end of file is reached
                END IF;
            ELSE
                -- Handle situation when end of file is reached before reading all memory locations
                -- You might choose to fill remaining memory locations with a default value or take other action
                -- For example: temp_mem(i) := (others => '0');
                NULL;
            END IF;
        END LOOP;
        RETURN temp_mem;
    END FUNCTION;
    -------------------------------------
    SIGNAL mem : mem_type := init_memory_wfile("code.txt");
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            insout <= mem(to_integer(unsigned(pc(11 DOWNTO 0))));
        END IF;
    END PROCESS;

END InstructionMemoryArch; -- InstructionMemoryArch 