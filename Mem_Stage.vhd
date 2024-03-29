LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Mem_Stage IS
    PORT (
        --control
        call_sp : IN STD_LOGIC;
        sp_sel : IN STD_LOGIC;
        free : IN STD_LOGIC;
        protect : IN STD_LOGIC;
        mem_write : IN STD_LOGIC;
        mem_read : IN STD_LOGIC;
        SPoperation : IN STD_LOGIC;
        --input 
        clk : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_out : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        op_1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        --output
        mem_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        mem_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')

    );
END Mem_Stage;

ARCHITECTURE arch_mem_stage OF Mem_Stage IS
    SIGNAL Address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Pc_plus_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
    SIGNAL Sp : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"0000_0FFF";
    SIGNAL sp_plus_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL spout : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    sp_plus_2 <= STD_LOGIC_VECTOR(UNSIGNED(sp) + 2);

    m0 : ENTITY work.mux_2_1 GENERIC MAP(32) PORT MAP(
        a => alu_out,
        b => spout,
        sel => sp_sel,
        y => Address
        );
    m1 : ENTITY work.mux_2_1 GENERIC MAP(32) PORT MAP(
        a => Op_1,
        b => Pc_plus_1,
        sel => call_sp,
        y => data
        );

    m3 : ENTITY work.mux_2_1 GENERIC MAP(32) PORT MAP(
        a => Sp,
        b => sp_plus_2,
        sel => SPoperation,
        y => spout
        );

    mem_address <= address;

    mem : ENTITY work.DataMemory PORT MAP(
        clk => clk,
        memread => mem_read,
        memwrite => mem_write,
        protect => protect,
        free => free,
        addr => Address,
        datain => data,
        dataout => mem_data
        );

    add : ENTITY work.Adder_Subtractor PORT MAP(
        Operation_Sel => '1',
        Input1 => pc,
        Input2 => "01",
        Enable => '1',
        Result => Pc_plus_1
        );
    PROCESS (clk)
        VARIABLE sphelper : STD_LOGIC_VECTOR(31 DOWNTO 0);

    BEGIN
        IF rising_edge(clk) THEN
            IF sp_sel = '1' THEN
                sphelper := sp;
                IF SPoperation = '0' THEN
                    sphelper := STD_LOGIC_VECTOR(UNSIGNED(sphelper) - 2);
                ELSE
                    sphelper := STD_LOGIC_VECTOR(UNSIGNED(sphelper) + 2);
                END IF;
                Sp <= sphelper;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE arch_mem_stage;