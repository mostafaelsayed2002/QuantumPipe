LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY InstructionMemory IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        clk : IN STD_LOGIC;
        addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        insout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END InstructionMemory;

ARCHITECTURE InstructionMemoryArch OF InstructionMemory IS
    TYPE mem_type IS ARRAY(0 TO (2 ** ADDRESS_BITS - 1)) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mem : mem_type;
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            insout <= mem(to_integer(unsigned(addr(11 downto 0))));
        END IF;
    END PROCESS;
END InstructionMemoryArch; -- InstructionMemoryArch 