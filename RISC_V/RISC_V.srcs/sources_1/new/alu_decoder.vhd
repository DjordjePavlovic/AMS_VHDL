library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.alu_ops_pkg.all;

entity alu_decoder is
    port (
--******** Controlpath ulazi *********
        alu_2bit_op_i : in std_logic_vector(1 downto 0);
--******** Polja instrukcije *******
        funct3_i : in std_logic_vector (2 downto 0);
        funct7_i : in std_logic_vector (6 downto 0);
--******** Datapath izlazi ********
alu_op_o : out std_logic_vector(4 downto 0));
end entity;