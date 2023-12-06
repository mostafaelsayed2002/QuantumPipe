LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        op : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        c_old : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        outp : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

        c_new : OUT STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0')

    );
END ENTITY;

ARCHITECTURE ARCH_ALU OF ALU IS

    CONSTANT ZERO : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000000";

    FUNCTION SetFlag(imm_res : IN STD_LOGIC_VECTOR(31 DOWNTO 0))
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE flags : STD_LOGIC_VECTOR(1 DOWNTO 0);
    BEGIN
        IF SIGNED(imm_res) = 0 THEN
            flags(0) := '1';
        ELSE
            flags(0) := '0';
        END IF;

        IF SIGNED(imm_res) < 0 THEN
            flags(1) := '1';
        ELSE
            flags(1) := '0';
        END IF;

        RETURN flags;

    END SetFlag;

BEGIN
    PROCESS (in1, in2, op)
        VARIABLE imm_res : STD_LOGIC_VECTOR(31 DOWNTO 0);
        VARIABLE helper : INTEGER;
    BEGIN
        CASE op IS
                -- NOP OUT IN JZ JMP CALL RET RTI
            WHEN "0000" =>
                outp <= X"0000_0000";
                c_new <= c_old;
                -- NOT
            WHEN "0001" =>
                imm_res := NOT in1;
                outp <= imm_res;

                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);

                -- NEG 
            WHEN "0010" =>

                imm_res := STD_LOGIC_VECTOR(signed(in1) + 1);
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);

                imm_res := STD_LOGIC_VECTOR(0 - signed(in1));

                outp <= imm_res;

                -- INC
            WHEN "0011" =>

                imm_res := STD_LOGIC_VECTOR((unsigned(in1)) + 1);
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                IF in1 = X"FFFF_FFFF" THEN
                    c_new(2) <= '1';
                END IF;

                outp <= imm_res;

                -- DEC
            WHEN "0100" =>

                imm_res := STD_LOGIC_VECTOR(UNSIGNED(in1) - 1);
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);

                outp <= imm_res;

                --  ADD/ADDI
            WHEN "0101" =>

                imm_res := STD_LOGIC_VECTOR(UNSIGNED(in1) + UNSIGNED(in2));
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                IF (imm_res < in1) OR (imm_res < in2) THEN
                    c_new(2) <= '1';
                END IF;
                outp <= imm_res;

                -- SUB 
            WHEN "0110" =>
                imm_res := STD_LOGIC_VECTOR(UNSIGNED(in1) - UNSIGNED(in2));
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);

                outp <= imm_res;

                -- AND
            WHEN "0111" =>
                imm_res := in1 AND in2;
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);
                outp <= imm_res;

                -- OR
            WHEN "1000" =>
                imm_res := in1 OR in2;
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);
                outp <= imm_res;

                -- xor 
            WHEN "1001" =>
                imm_res := in1 XOR in2;
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);
                outp <= imm_res;

                -- cmp
            WHEN "1010" =>
                imm_res := STD_LOGIC_VECTOR(UNSIGNED(in1) - UNSIGNED(in2));
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);
                outp <= imm_res;

                -- bitset
            WHEN "1011" =>
                imm_res := in1;
                imm_res(to_integer(unsigned(in2(4 DOWNTO 0)))) := '1';
                c_new(1 DOWNTO 0) <= SetFlag(imm_res);
                c_new(2) <= c_old(2);
                outp <= imm_res;

                -- rcl
            WHEN "1100" =>
                helper := to_integer(unsigned(in2(4 DOWNTO 0)));
                imm_res := in1(helper - 1 DOWNTO 0) & in1(31 DOWNTO helper);
                c_new(2) <= in1(helper);
                outp <= imm_res;

                -- rcr
            WHEN "1101" =>
                helper := to_integer(unsigned(in2(4 DOWNTO 0)));
                imm_res := in1(31 DOWNTO helper + 1) & in1(helper DOWNTO 0);
                c_new(2) <= in1(helper);
                outp <= imm_res;

            WHEN "1110" =>
                c_new <= c_old;
                outp <= in1;
            WHEN "1111" =>
                c_new <= c_old;
                outp <= in2;
            WHEN OTHERS =>
                outp <= X"0000_0000";
                c_new <= c_old;
        END CASE;
    END PROCESS;
END ARCH_ALU; -- ARCH_ALU