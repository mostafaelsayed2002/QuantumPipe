LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Mem_Stage_tb IS
END Mem_Stage_tb;

ARCHITECTURE behavior OF Mem_Stage_tb IS
    -- Component declarations
    COMPONENT Mem_Stage
        PORT (
            call_sp : IN STD_LOGIC;
            sp_sel : IN STD_LOGIC;
            free : IN STD_LOGIC;
            protect : IN STD_LOGIC;
            mem_write : IN STD_LOGIC;
            mem_read : IN STD_LOGIC;
            sp : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            clk : IN STD_LOGIC;
            pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            alu_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            op_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            mem_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL tb_call_sp, tb_sp_sel, tb_free, tb_protect, tb_mem_write, tb_mem_read, tb_clk : STD_LOGIC := '0';
    SIGNAL tb_sp, tb_pc, tb_alu_out, tb_op_1, tb_mem_data : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    -- Instantiate the Mem_Stage component
    uut : Mem_Stage PORT MAP(
        call_sp => tb_call_sp,
        sp_sel => tb_sp_sel,
        free => tb_free,
        protect => tb_protect,
        mem_write => tb_mem_write,
        mem_read => tb_mem_read,
        sp => tb_sp,
        clk => tb_clk,
        pc => tb_pc,
        alu_out => tb_alu_out,
        op_1 => tb_op_1,
        mem_data => tb_mem_data
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        WAIT FOR 2.5 ns; -- Half of the previous value
        tb_clk <= NOT tb_clk;
    END PROCESS;

    -- Stimulus process
    Stimulus_Process : PROCESS
    BEGIN
        -- Initialize inputs
        tb_call_sp <= '0';
        tb_sp_sel <= '0';
        tb_free <= '0';
        tb_protect <= '0';
        tb_mem_write <= '0';
        tb_mem_read <= '0';
        tb_sp <= "00010000010000010000001111000010";
        -- tb_clk <= '0'; -- Remove this line
        tb_pc <= (OTHERS => '0');
        tb_alu_out <= (OTHERS => '0');
        tb_op_1 <= (OTHERS => '0');

        WAIT FOR 10 ns;
        tb_pc <= "00010000010000001000000100000010";
        tb_call_sp <= '1';
        tb_sp_sel <= '1';
        tb_mem_read <= '0';
        tb_mem_write <= '1';
        WAIT FOR 10 ns;
        tb_mem_write <= '0';
        tb_mem_read <= '1';
        WAIT;
    END PROCESS Stimulus_Process;

END behavior;