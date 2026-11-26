library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adder is
    generic (N : natural := 10);
    port(
	a : in STD_LOGIC_VECTOR(N-1 downto 0);
	b : in STD_LOGIC_VECTOR(N-1 downto 0);
	ci : in STD_LOGIC;
	z : out STD_LOGIC_VECTOR(N-1 downto 0);
	co : out STD_LOGIC);
end entity adder;

architecture Behavioral of adder is

begin

process(a, b, ci)
variable sum: unsigned (N downto 0);
begin
sum := unsigned ('0' & a(N-1 downto 0)) + unsigned('0' & b(N-1 downto 0)) + unsigned'("" & ci);
z <= std_logic_vector(sum(N-1 downto 0));
co <= std_logic(sum(N));
end process;

end architecture Behavioral;
