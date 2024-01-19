library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity latency_tb is
end entity;

architecture sim of latency_tb is
  -- Constants
  constant CLK_PERIOD   : time := 20 ns;

  -- Signals
  signal CLK           : std_logic := '0';
  signal RESET         : std_logic := '0';
  signal INPUT_KEY     : std_logic_vector(127 downto 0) := (others => '0');
  signal INPUT_VALID   : std_logic := '0';
  signal OUTPUT_KEY    : std_logic_vector(127 downto 0) := (others => '0');
  signal OUTPUT_KEY_FOUND : std_logic := '0';
  signal OUTPUT_DATA   : std_logic_vector(15 downto 0) := (others => '0');
  signal OUTPUT_VALID  : std_logic := '0';
  signal CONFIG_KEY    : std_logic_vector(127 downto 0) := (others => '0');
  signal CONFIG_DATA   : std_logic_vector(15 downto 0) := (others => '0');
  signal CONFIG_EMPTY  : std_logic := '0';
  signal CONFIG_ADDR_TABLE : std_logic_vector(1 downto 0) := (others => '0');
  signal CONFIG_ADDR_ITEM  : std_logic_vector(10 downto 0) := (others => '0');
  signal CONFIG_WRITE  : std_logic := '0';

begin
  dut : entity work.filter
    generic map (
      KEY_WIDTH       => 128,
      DATA_WIDTH      => 16,
      TABLES          => 4,
      TABLE_SIZE      => 2048,
      INPUT_REGISTER  => true,
      OUTPUT_REGISTER => true,
      CONFIG_REGISTER => true
    )
    port map (
      CLK             => CLK,
      RESET           => RESET,
      INPUT_KEY       => INPUT_KEY,
      INPUT_VALID     => INPUT_VALID,
      OUTPUT_KEY      => OUTPUT_KEY,
      OUTPUT_KEY_FOUND => OUTPUT_KEY_FOUND,
      OUTPUT_DATA     => OUTPUT_DATA,
      OUTPUT_VALID    => OUTPUT_VALID,
      CONFIG_KEY      => CONFIG_KEY,
      CONFIG_DATA     => CONFIG_DATA,
      CONFIG_EMPTY    => CONFIG_EMPTY,
      CONFIG_ADDRESS_TABLE => CONFIG_ADDR_TABLE,
      CONFIG_ADDRESS_ITEM  => CONFIG_ADDR_ITEM,
      CONFIG_WRITE    => CONFIG_WRITE
    );
  
  INPUT_KEY          <= (others => '0');
  OUTPUT_KEY         <= (others => '0');
  OUTPUT_KEY_FOUND   <= '0';
  OUTPUT_DATA        <= (others => '0');
  OUTPUT_VALID       <= '0';
  CONFIG_KEY         <= (others => '0');
  CONFIG_DATA        <= (others => '0');
  CONFIG_EMPTY       <= '0';
  CONFIG_ADDR_TABLE  <= (others => '0');
  CONFIG_ADDR_ITEM   <= (others => '0');
  CONFIG_WRITE       <= '0';
  
  CLK <= not CLK after CLK_PERIOD/2;

  test: process
  begin
    RESET <= '1';
    wait for CLK_PERIOD;
    RESET <= '0';
    wait for CLK_PERIOD;

    INPUT_VALID <= '1';
    for i in 1 to 100 loop
      wait for CLK_PERIOD;
      assert OUTPUT_VALID = '0' report "OUTPUT_VALID raised after " & to_string(i) & " periods." severity failure;
    end loop;
  end process;

end architecture sim;
