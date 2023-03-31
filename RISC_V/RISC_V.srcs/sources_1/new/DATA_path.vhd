library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.datapath_signals_pkg.all;

entity data_path is
port(
-- sinhronizacioni signali
clk : in std_logic;
reset : in std_logic;
-- interfejs ka memoriji za instrukcije
instr_mem_address_o : out std_logic_vector (31 downto 0);
instr_mem_read_i : in std_logic_vector(31 downto 0);
instruction_o : out std_logic_vector(31 downto 0);
-- interfejs ka memoriji za podatke
data_mem_address_o : out std_logic_vector(31 downto 0);
data_mem_write_o : out std_logic_vector(31 downto 0);
data_mem_read_i : in std_logic_vector (31 downto 0);
-- kontrolni signali
mem_to_reg_i : in std_logic;
alu_op_i : in std_logic_vector (4 downto 0);
alu_src_b_i : in std_logic;
pc_next_sel_i : in std_logic;
rd_we_i : in std_logic;
branch_condition_o : out std_logic;
-- kontrolni signali za prosledjivanje operanada u ranije faze protocneobrade
alu_forward_a_i : in std_logic_vector (1 downto 0);
alu_forward_b_i : in std_logic_vector (1 downto 0);
branch_forward_a_i : in std_logic;
branch_forward_b_i : in std_logic;
-- kontrolni signal za resetovanje if/id registra
if_id_flush_i : in std_logic;
-- kontrolni signali za zaustavljanje protocne obrade
pc_en_i : in std_logic;
if_id_en_i : in std_logic);
end entity;

architecture Behavioral of data_path is 

signal pc_reg_if_s             : std_logic_vector (31 downto 0);
signal pc_next_if_s            : std_logic_vector (31 downto 0);


begin

pc_process: process (clk) is 
begin 
    if(rising_edge(clk)) then
        if (reset = '0')then
            pc_reg_if_s<= (others => '0');
        else
            pc_reg_if_s <= pc_next_if_s;
        end if;
    end if;
    end process;


end architecture;