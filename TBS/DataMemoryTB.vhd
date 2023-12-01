LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY DataMemory_TB IS
END DataMemory_TB;

ARCHITECTURE tb_arch OF DataMemory_TB IS
    CONSTANT ADDRESS_BITS : INTEGER := 12;
    CONSTANT CLOCK_PERIOD : TIME := 10 ns;

    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL memread, memwrite, protect, free : STD_LOGIC := '1';
    SIGNAL addr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL datain, dataout : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    mem : ENTITY work.DataMemory
        PORT MAP(
            clk => clk,
            memread => memread,
            memwrite => memwrite,
            protect => protect,
            free => free,
            addr => addr,
            datain => datain,
            dataout => dataout
        );

    CLK_PROCESS : PROCESS
    BEGIN
        WAIT FOR CLOCK_PERIOD / 2;
        clk <= NOT clk;
    END PROCESS;

    STIMULUS_PROCESS : PROCESS
    BEGIN
        memread <= '0';
        memwrite <= '0';
        protect <= '0';
        free <= '0';
        addr <= (OTHERS => '0');
        datain <= (OTHERS => '0');

        -- Test scenario 1: Write data to memory
        WAIT FOR CLOCK_PERIOD;
        memwrite <= '1';
        addr <= X"0000_0000"; -- Address 0
        datain <= "0101010101010101"; -- Data to be written
        WAIT FOR CLOCK_PERIOD;
        memwrite <= '0';

        -- Test scenario 2: Read data from memory
        WAIT FOR CLOCK_PERIOD;
        memread <= '1';
        addr <= X"0000_0000"; -- Address 0
        WAIT FOR CLOCK_PERIOD;
        memread <= '0';

        -- Test scenario 3: Protect a memory location
        WAIT FOR CLOCK_PERIOD;
        protect <= '1';
        addr <= X"0000_0000"; -- Address 0
        WAIT FOR CLOCK_PERIOD;
        protect <= '0';

        WAIT FOR CLOCK_PERIOD;
        memwrite <= '1';
        addr <= X"0000_0000"; -- Address 0
        datain <= X"FFFF"; -- Data to be written
        WAIT FOR CLOCK_PERIOD;
        memwrite <= '0';

        WAIT FOR CLOCK_PERIOD;
        memread <= '1';
        addr <= X"0000_0000"; -- Address 0
        WAIT FOR CLOCK_PERIOD;
        memread <= '0';

        -- free 
        WAIT FOR CLOCK_PERIOD;
        free <= '1';
        addr <= X"0000_0000"; -- Address 0
        WAIT FOR CLOCK_PERIOD;
        free <= '0';

        -- write after free
        WAIT FOR CLOCK_PERIOD;
        memwrite <= '1';
        addr <= X"0000_0000"; -- Address 0
        datain <= X"FFFF"; -- Data to be written
        WAIT FOR CLOCK_PERIOD;
        memwrite <= '0';

        -- read after free
        WAIT FOR CLOCK_PERIOD;
        memread <= '1';
        addr <= X"0000_0000"; -- Address 0
        WAIT FOR CLOCK_PERIOD;
        memread <= '0';

        WAIT;
    END PROCESS;

END tb_arch;