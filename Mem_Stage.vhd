LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity Mem_Stage is 
    Port(
        --control
        call_sp : in std_logic;
        sp_sel : in std_logic;
        free : in std_logic;
        protect : in std_logic;
        mem_write : in std_logic;
        mem_read : in std_logic;
        --input 
        sp : in std_logic_vector(31 downto 0);
        clk : in std_logic;
        pc : in std_logic_vector(31 downto 0);
        alu_out : in std_logic_vector(31 downto 0);
        op_1 : in std_logic_vector(31 downto 0);
        --output
        mem_data : out std_logic_vector(31 downto 0)
    );
End Mem_Stage;

architecture arch_mem_stage of Mem_Stage is
    SIGNAL Address: std_logic_vector(31 downto 0);
    SIGNAL Pc_plus_1: std_logic_vector(31 downto 0);
    SIGNAL data: std_logic_vector(31 downto 0);
    begin 
    m0: Entity work.mux_2_1 GENERIC MAP(32) port map(
        a => alu_out,
        b => sp,
        sel => sp_sel,
        y => Address
    );

    add: Entity work.Adder_Subtractor port map(
        Operation_Sel => '1',
        Input1 => pc,
        Input2 => "01",
        Enable => '1',
        Result => Pc_plus_1
    );

    m1: Entity work.mux_2_1 GENERIC MAP(32) port map(
        a => Op_1,
        b => Pc_plus_1,
        sel => call_sp,
        y => data
    );

    mem: Entity work.DataMemory port map(
        clk => clk,
        memread => mem_read,
        memwrite => mem_write,
        protect => protect,
        free => free,
        addr => Address,
        datain => data,
        dataout => mem_data
    );

end architecture arch_mem_stage;