-- jenkins_final.vhd: Part of Jenkins hashing function based on https://burtleburtle.net/bob/c/lookup3.c
-- Copyright (C) 2019 FIT BUT
-- Author(s): Lukas Kekely <ikekely@fit.vutbr.cz>
--            David Mihola <xmihol00@stud.fit.vutbr.cz>
-- SPDX-License-Identifier: BSD-3-Clause



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;



entity jenkins_final is
  generic(
    -- Width of hashed key in 32-bit words.
    LENGTH          : natural := 1
  );
  port (
    -- Main clock signal and its synchronous reset.
    CLK             : in std_logic;
    RESET           : in std_logic;
    -- Input interface ---------------------------------------------------------
    INPUT_A         : in std_logic_vector(32-1 downto 0);
    INPUT_B         : in std_logic_vector(32-1 downto 0);
    INPUT_C         : in std_logic_vector(32-1 downto 0);
    INPUT_KEY       : in std_logic_vector(LENGTH*32-1 downto 0);
    INPUT_VALID     : in std_logic;
    -- Output interface --------------------------------------------------------
    OUTPUT_A        : out std_logic_vector(32-1 downto 0);
    OUTPUT_B        : out std_logic_vector(32-1 downto 0);
    OUTPUT_C        : out std_logic_vector(32-1 downto 0);
    OUTPUT_KEY      : out std_logic_vector(LENGTH*32-1 downto 0);
    OUTPUT_VALID    : out std_logic
  );
end entity;



architecture behavioral of jenkins_final is

  constant STAGES : integer := 7;

  function rot(x : std_logic_vector(32-1 downto 0); k : natural) return std_logic_vector is
  begin
    return x(32-k-1 downto 0) & x(32-1 downto 32-k);
  end function;

  type computation_stage is record
    a : std_logic_vector(32-1 downto 0);
    b : std_logic_vector(32-1 downto 0);
    c : std_logic_vector(32-1 downto 0);
    key : std_logic_vector(LENGTH*32-1 downto 0);
    valid : std_logic;
  end record;
  type computation_stage_array is array(natural range <>) of computation_stage;

  signal s : computation_stage_array(0 to STAGES);
  signal s_regs : computation_stage_array(0 to STAGES);

begin

  register_update: process (CLK)
  begin
    if rising_edge(CLK) then
      if RESET = '1' then
        for i in 0 to STAGES loop
          s_regs(i).a <= (others => '0');
          s_regs(i).b <= (others => '0');
          s_regs(i).c <= (others => '0');
          s_regs(i).key <= (others => '0');
          s_regs(i).valid <= '0';
        end loop;
      else
        s_regs <= s;
      end if;
    end if;
  end process;

  -- Input connections
  s(0).a <= INPUT_A;
  s(0).b <= INPUT_B;
  s(0).c <= INPUT_C;
  s(0).key <= INPUT_KEY;
  s(0).valid <= INPUT_VALID;

  -- Stage 1: c ^= b; c -= rot(b,14);
  s(1).a <= s_regs(0).a;
  s(1).b <= s_regs(0).b;
  s(1).c <= (s_regs(0).c xor s_regs(0).b) - rot(s_regs(0).b, 14);
  s(1).key <= s_regs(0).key;
  s(1).valid <= s_regs(0).valid;

  -- Stage 2: a ^= c; a -= rot(c,11);
  s(2).a <= (s_regs(1).a xor s_regs(1).c) - rot(s_regs(1).c, 11);
  s(2).b <= s_regs(1).b;
  s(2).c <= s_regs(1).c;
  s(2).key <= s_regs(1).key;
  s(2).valid <= s_regs(1).valid;


  -- Stage 3: b ^= a; b -= rot(a,25);
  s(3).a <= s_regs(2).a;
  s(3).b <= (s_regs(2).b xor s_regs(2).a) - rot(s_regs(2).a, 25);
  s(3).c <= s_regs(2).c;
  s(3).key <= s_regs(2).key;
  s(3).valid <= s_regs(2).valid;

  -- Stage 4: c ^= b; c -= rot(b,16);
  s(4).a <= s_regs(3).a;
  s(4).b <= s_regs(3).b;
  s(4).c <= (s_regs(3).c xor s_regs(3).b) - rot(s_regs(3).b, 16);
  s(4).key <= s_regs(3).key;
  s(4).valid <= s_regs(3).valid;

  -- Stage 5: a ^= c; a -= rot(c,4);
  s(5).a <= (s_regs(4).a xor s_regs(4).c) - rot(s_regs(4).c, 4);
  s(5).b <= s_regs(4).b;
  s(5).c <= s_regs(4).c;
  s(5).key <= s_regs(4).key;
  s(5).valid <= s_regs(4).valid;

  -- Stage 6: b ^= a; b -= rot(a,14);
  s(6).a <= s_regs(5).a;
  s(6).b <= (s_regs(5).b xor s_regs(5).a) - rot(s_regs(5).a, 14);
  s(6).c <= s_regs(5).c;
  s(6).key <= s_regs(5).key;
  s(6).valid <= s_regs(5).valid;

  -- Stage 7: c ^= b; c -= rot(b,24);
  s(7).a <= s_regs(6).a;
  s(7).b <= s_regs(6).b;
  s(7).c <= (s_regs(6).c xor s_regs(6).b) - rot(s_regs(6).b, 24);
  s(7).key <= s_regs(6).key;
  s(7).valid <= s_regs(6).valid;

  -- Output connections
  OUTPUT_A <= s_regs(STAGES).a;
  OUTPUT_B <= s_regs(STAGES).b;
  OUTPUT_C <= s_regs(STAGES).c;
  OUTPUT_KEY <= s_regs(STAGES).key;
  OUTPUT_VALID <= s_regs(STAGES).valid;

end architecture;