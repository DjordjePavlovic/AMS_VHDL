library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.controlpath_signals_pkg.all;
entity control_path is
port (
-- sinhronizacija
clk : in std_logic;
reset : in std_logic;
-- instrukcija dolazi iz datapah-a
instruction_i : in std_logic_vector (31 downto 0);
-- Statusni signaln iz datapath celine
branch_condition_i : in std_logic;
-- kontrolni signali koji se prosledjiuju u datapath
mem_to_reg_o : out std_logic;
alu_op_o : out std_logic_vector(4 downto 0);
alu_src_b_o : out std_logic;
rd_we_o : out std_logic;
pc_next_sel_o : out std_logic;
data_mem_we_o : out std_logic_vector(3 downto 0);
-- kontrolni signali za prosledjivanje operanada u ranije faze protocneobrade
alu_forward_a_o : out std_logic_vector (1 downto 0);
alu_forward_b_o : out std_logic_vector (1 downto 0);
branch_forward_a_o : out std_logic; -- mux a
branch_forward_b_o : out std_logic; -- mux b
-- kontrolni signal za resetovanje if/id registra
if_id_flush_o : out std_logic;
-- kontrolni signali za zaustavljanje protocne obrade
pc_en_o : out std_logic;
if_id_en_o : out std_logic
);
end entity;