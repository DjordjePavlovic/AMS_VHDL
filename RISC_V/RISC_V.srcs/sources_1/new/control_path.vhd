library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity control_path is
port (clk : in std_logic;
reset : in std_logic;
-- ********* Interfejs za prihvat instrukcije iz datapath-a*********
instruction_i : in std_logic_vector (31 downto 0);
-- ********* Kontrolni intefejs *************************************
mem_to_reg_o : out std_logic;
alu_op_o : out std_logic_vector(4 downto 0);
pc_next_sel_o : out std_logic;
alu_src_o : out std_logic;
rd_we_o : out std_logic;
--********** Ulazni Statusni interfejs**************************************
branch_condition_i : in std_logic;
--********** Izlazni Statusni interfejs**************************************
data_mem_we_o : out std_logic_vector(3 downto 0)
);
end entity;