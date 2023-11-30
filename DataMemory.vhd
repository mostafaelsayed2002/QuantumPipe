LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY DataMemory IS
    GENERIC (
        ADDRESS_BITS : INTEGER := 12
    );
    PORT (
        clk : IN STD_LOGIC;
        memread : IN STD_LOGIC;
        memwrite : IN STD_LOGIC;
        protect : IN STD_LOGIC;
        free : IN STD_LOGIC;
        addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        datain : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END DataMemory;

ARCHITECTURE DataMemoryArch OF DataMemory IS
    -- extra bit is for protection and liberation
    TYPE ram_type IS ARRAY(0 TO (2 ** ADDRESS_BITS - 1)) OF STD_LOGIC_VECTOR(16 DOWNTO 0);

    SIGNAL ram : ram_type;

BEGIN
    PROCESS (clk) IS
        VARIABLE helper : STD_LOGIC_VECTOR(16 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF rising_edge(clk) THEN
            IF protect = '1' THEN
                helper := ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
                helper(16) := '1';
                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper;
            ELSIF free = '1' THEN
                helper := ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
                helper(16) := '0';
                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper;
            ELSIF memwrite = '1' THEN
                IF helper(16) = '0' THEN
                    helper(15 DOWNTO 0) := datain;
                    ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper;
                ELSE
                    ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
                END IF;
            ELSIF memread = '1' THEN
                helper := ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
                dataout <= helper(15 DOWNTO 0);
            END IF;
        END IF;

    END PROCESS;
END DataMemoryArch; -- DataMemoryArch