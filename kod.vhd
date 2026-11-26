library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipelined_multiplier is
	generic (N : natural := 10);
	port (
	clk : in std_logic;
	rst : in std_logic;
	a : in std_logic_vector(N-1 downto 0);
	b : in std_logic_vector(N-1 downto 0);
	z : out std_logic_vector(2*N-1 downto 0)
	);
end entity pipelined_multiplier;

architecture Structural of pipelined_multiplier is
type matrix is array (N-1 downto 0) of std_logic_vector (N downto 0);
type array1 is array (N-1 downto 0) of std_logic;
type registar is array (N-1 downto 0) of std_logic_vector (N-1 downto 0);

component adder is 
	generic(N : natural := 10);
	port (
	a  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        b  : in  STD_LOGIC_VECTOR(N-1 downto 0);
        z  : out STD_LOGIC_VECTOR(N-1 downto 0);
        ci : in  STD_LOGIC;
        co : out STD_LOGIC
	);
end component adder;

signal regA, regB: registar;
signal co, sel : array1;
signal sum, sig, c, zp_reg: matrix;
signal zp : std_logic_vector(N-1 downto 0);

begin

process(clk, rst)
begin
if(rst = '1') then
  regA <= (others => (others => '0'));
  regB <= (others => (others => '0'));
elsif (clk'event and clk = '1') then
  regA(0) <= a;
  regB(0) <= b;

  for i in 1 to N-1 loop
    regA(i) <= regA(i-1);
    regB(i) <= regB(i-1);
  end loop;
end if;
end process; 
--generisanje sel 
--parcijalni proizvodi c
lo: for i in 0 to N-1 generate
  l1: if(i = (N-1)) generate
    sel(i) <= '1';
  end generate;
  l2: if(i < (N-1)) generate
    sel(i) <= '0';
  end generate;
  l3: for j in 0 to N-1 generate 
    c(i)(j) <= (regA(i)(i) and regB(i)(j)) xor sel(i);
  end generate;
  c(i)(N) <= c(i)(N-1); 
end generate;

--povezivanje sabiraca
l4: for i in 0 to N-1 generate
  l5: if (i=0) generate
      sum(0) <= c(0)(N downto 0);
      co(0) <= c(0)(N);
      zp(0) <= c(0)(0); 
      end generate;
  l6: if (i>= 1) generate
        l7: adder generic map (N => N+1)
	port map (
	a => sig(i-1),
	b => c(i),
	z => sum(i),
	ci => sel(i),
	co => co(i)
	);
	zp(i) <= sum(i)(0);
      end generate;
end generate;

process(clk, rst)
begin
  if rst = '1' then
    sig <= (others => (others => '0'));
    zp_reg <= (others => (others => '0'));
  elsif (clk'event and clk='1') then
    --upis medjuzbirova u blokove REG na ras ivicu takta
    sig(0) <= co(0) & sum(0)(N downto 1);
    for i in 1 to N-1 loop
      sig(i) <= sum(i)(N) & sum(i)(N downto 1);
    end loop;
    --delay za zp
    for i in 0 to N-1 loop
      zp_reg(i)(0) <= zp(i);
      for d in 1 to N-i-1 loop
        zp_reg(i)(d) <= zp_reg(i)(d-1);
      end loop;
    end loop;
  end if;
end process;

izlaz: for i in 0 to N-1 generate
  z(i) <= zp_reg(i)(N-i-1);
end generate;

z(2*N-1 downto N) <= sig(N-1)(N-1 downto 0);

end Structural;