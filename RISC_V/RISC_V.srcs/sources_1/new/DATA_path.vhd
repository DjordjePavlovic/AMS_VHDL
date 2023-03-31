library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_path is
generic (DATA_WIDTH : positive := 32);
port(
-- ********* Globalna sinhronizacija ******************
clk : in std_logic;
reset : in std_logic;
-- ********* Interfejs ka Memoriji za instrukcije *****
instr_mem_address_o : out std_logic_vector(31 downto 0);
instr_mem_read_i : in std_logic_vector(31 downto 0);
instruction_o : out std_logic_vector(31 downto 0);
-- ********* Interfejs ka Memoriji za podatke *****
data_mem_address_o : out std_logic_vector(31 downto 0);
data_mem_write_o : out std_logic_vector(31 downto 0);
data_mem_read_i : in std_logic_vector(31 downto 0);
-- ********* Kontrolni signali ************************
mem_to_reg_i : in std_logic;
alu_op_i : in std_logic_vector(4 downto 0);
pc_next_sel_i : in std_logic;
alu_src_i : in std_logic;
rd_we_i : in std_logic;
-- ********* Statusni signali *************************
branch_condition_o : out std_logic
-- ******************************************************
);
end entity;

architecture Behavioral of DATA_path is

begin


end Behavioral;
