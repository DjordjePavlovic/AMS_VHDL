library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ctrl_decoder is
port (
--************ Opcode polje instrukcije************
opcode_i : in std_logic_vector (6 downto 0);
--************ Kontrolni signali*******************
branch_o : out std_logic;
mem_to_reg_o : out std_logic;
data_mem_we_o : out std_logic;
alu_src_o : out std_logic;
rd_we_o : out std_logic;
alu_2bit_op_o : out std_logic_vector(1 downto 0)
);
end entity;