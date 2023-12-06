
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;



ENTITY IO IS
 port (
  clk : IN STD_LOGIC;
  portread : IN STD_LOGIC;
  portwrite : IN STD_LOGIC;
  indata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  outdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END IO;
ARCHITECTURE IOArch OF IO IS
SIGNAL PortReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

PROCESS (clk)
BEGIN

  IF falling_edge(clk) THEN
    IF portwrite = '1' THEN
      PortReg <= indata;

    ELSIF portread = '1' THEN
      outdata <= PortReg;
    END IF;



  END IF;

END PROCESS;

END IOArch; -- PortArch