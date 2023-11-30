LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity mux_3_2 is 
    generic ( 
        N : integer := 8
    );
    port (
        a : in std_logic_vector(N-1 downto 0);
        b : in std_logic_vector(N-1 downto 0);
        c : in std_logic_vector(N-1 downto 0);
        s : in std_logic_vector(1 downto 0);
        y : out std_logic_vector(N-1 downto 0)
    );
end mux_3_2;

architecture arch_mux_3_2 of mux_3_2 is
begin
    with s select
    y <= a when "00",
        b when "01",
        c when "10",
        a when others;
end arch_mux_3_2;


