library ieee;
use ieee.std_logic_1164.all;

entity pipelined_multiplier_tb is
    generic(N : NATURAL := 8);
end pipelined_multiplier_tb;

architecture TB_ARCHITECTURE of pipelined_multiplier_tb is

    component pipelined_multiplier
        generic(N : NATURAL := 10);
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            a   : in  std_logic_vector(N-1 downto 0);
            b   : in  std_logic_vector(N-1 downto 0);
            z   : out std_logic_vector(2*N-1 downto 0)
        );
    end component;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '0';
    signal a, b : std_logic_vector(N-1 downto 0) := (others => '0');
    signal z    : std_logic_vector(2*N-1 downto 0);

begin
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    UUT : pipelined_multiplier
        generic map (N => N)
        port map (
            clk => clk,
            rst => rst,
            a   => a,
            b   => b,
            z   => z
        );

    stim_process : process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        a <= x"FD";
        b <= x"FD";
        wait for 100 ns;

        a <= x"FD";
        b <= x"03";
        wait for 100 ns;

        a <= x"03";
        b <= x"03";
        wait for 100 ns;

        a <= x"80";
        b <= x"80";
        wait for 100 ns;

        a <= x"7F";
        b <= x"80";
        wait for 100 ns;

        wait;
    end process;

end TB_ARCHITECTURE;
