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
        insout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END InstructionMemory;


ARCHITECTURE InstructionMemoryArch OF InstructionMemory IS
TYPE mem_type IS ARRAY(0 TO (2 ** ADDRESS_BITS - 1)) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
-- function to initialize memory content
function init_memory_wfile(mif_file_name : in string) return mem_type is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(15 downto 0);
    variable temp_mem : mem_type;
    variable i : integer := 0;
    variable end_of_file : boolean := false;
begin
    for i in mem_type'range loop
        if not end_of_file then
            if not endfile(mif_file) then
                readline(mif_file, mif_line);
                read(mif_line, temp_bv);
                temp_mem(i) := to_stdlogicvector(temp_bv);
            else
                end_of_file := true; -- Set the flag when end of file is reached
            end if;
        else
            -- Handle situation when end of file is reached before reading all memory locations
            -- You might choose to fill remaining memory locations with a default value or take other action
            -- For example: temp_mem(i) := (others => '0');
            null;
        end if;
    end loop;
    return temp_mem;
end function;
-------------------------------------
    SIGNAL mem : mem_type:= init_memory_wfile("code.txt");
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            insout <= mem(to_integer(unsigned(pc(11 downto 0))));
        END IF;
    END PROCESS;

END InstructionMemoryArch; -- InstructionMemoryArch 