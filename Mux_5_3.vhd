LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity mux_5_3 is
    Generic (N: integer := 8);
    port(
        a,b,c,d,e: in std_logic_vector(N-1 downto 0);
        s: in std_logic_vector(2 downto 0);
        y: out std_logic_vector(N-1 downto 0):= (others => '0')
    );
End mux_5_3;

Architecture mux_5_3_arch of mux_5_3 is
    Begin 
        with s select
            y <= a when "000",
                b when "001",
                c when "010",
                d when "011",
                e when "100",
                a when others;
End mux_5_3_arch;