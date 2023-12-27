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

        datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        int_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        reset : IN STD_LOGIC;
        int : IN STD_LOGIC;
        dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        mem_flags_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

    );
END DataMemory;

ARCHITECTURE DataMemoryArch OF DataMemory IS
    -- extra bit is for protection and liberation
    TYPE ram_type IS ARRAY(0 TO (2 ** ADDRESS_BITS - 1)) OF STD_LOGIC_VECTOR(16 DOWNTO 0);

    SIGNAL ram : ram_type := (OTHERS => (OTHERS => '0'));
    SIGNAL flags : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

BEGIN
    PROCESS (clk, reset) IS
        VARIABLE helper33 : STD_LOGIC_VECTOR(33 DOWNTO 0) := (OTHERS => '0');
        VARIABLE helper32 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE helper12 : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');

    BEGIN

        IF reset = '1' THEN
            ram <= (OTHERS => (OTHERS => '0'));
        ELSIF falling_edge(clk) THEN
            helper33(16 DOWNTO 0) := ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
            helper12 := STD_LOGIC_VECTOR(UNSIGNED(addr(11 DOWNTO 0)) + 1);
            helper33(33 DOWNTO 17) := ram(to_integer(UNSIGNED(helper12)));
            IF int = '1' THEN
                dataout <= ram(2)(15 DOWNTO 0) & ram(3)(15 DOWNTO 0);
                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))))(15 DOWNTO 0) <= datain(15 DOWNTO 0);
                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))))(16) <= '0';

                ram(to_integer(UNSIGNED(helper12)))(15 DOWNTO 0) <= datain(31 DOWNTO 16);
                ram(to_integer(UNSIGNED(helper12)))(16) <= '0';

                flags <= int_flags;
            ELSIF protect = '1' THEN

                helper33(16) := '1';
                helper33(33) := '1';

                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper33(16 DOWNTO 0);
                ram(to_integer(UNSIGNED(helper12))) <= helper33(33 DOWNTO 17);

            ELSIF free = '1' THEN

                helper33(16) := '0';
                helper33(33) := '0';

                ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper33(16 DOWNTO 0);
                ram(to_integer(UNSIGNED(helper12))) <= helper33(33 DOWNTO 17);

            ELSIF memwrite = '1' THEN

                IF helper33(16) = '0' AND helper33(33) = '0' THEN
                    helper33(15 DOWNTO 0) := datain(15 DOWNTO 0);
                    helper33(32 DOWNTO 17) := datain(31 DOWNTO 16);

                    ram(to_integer(UNSIGNED(addr(11 DOWNTO 0)))) <= helper33(16 DOWNTO 0);
                    ram(to_integer(UNSIGNED(helper12))) <= helper33(33 DOWNTO 17);
                END IF;
            ELSE
                helper33(16 DOWNTO 0) := ram(to_integer(UNSIGNED(addr(11 DOWNTO 0))));
                helper33(33 DOWNTO 17) := ram(to_integer(UNSIGNED(helper12)));

                -- 32 to dataout
                helper32(15 DOWNTO 0) := helper33(15 DOWNTO 0);
                helper32(31 DOWNTO 16) := helper33(32 DOWNTO 17);

                dataout <= helper32;
                mem_flags_out <= flags;
            END IF;
        END IF;

    END PROCESS;
END DataMemoryArch; -- DataMemoryArch