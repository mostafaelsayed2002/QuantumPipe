LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity mux_2_1 is
    generic (
        N : integer := 8                 
    );
    port(
        a,b: in std_logic_vector(N-1 downto 0);
        sel: in std_logic;
        y: out std_logic_vector(N-1 downto 0):= (others => '0')
    );
end entity;

architecture arch_mux_2_1 of mux_2_1 is
    begin 
        y <= a when sel = '0' else b;
end architecture;
