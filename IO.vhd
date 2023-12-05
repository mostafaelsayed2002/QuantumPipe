ENTITY IO IS
IO (
  clk : IN STD_LOGIC;
  portread : IN STD_LOGIC;
  portwrite : IN STD_LOGIC;
  indata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
  outdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
);
END IO;
ARCHITECTURE IOArch OF IO IS
SIGNAL PortReg : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN

PROCESS (clk)
BEGIN

  IF falling_edge(clk) BEGIN

    IF portwrite = '1' BEGIN
      PortReg <= indata;

    ELSIF portread = '1' BEGIN
      outdata <= PortReg;
    END IF;



  END IF;

END PROCESS;

END IOArch; -- PortArch