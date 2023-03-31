library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity hazard_unit is
port (
-- ulazni signali
rs1_address_id_i : in std_logic_vector(4 downto 0);
rs2_address_id_i : in std_logic_vector(4 downto 0);
rs1_in_use_i : in std_logic;
rs2_in_use_i : in std_logic;
branch_id_i : in std_logic;
rd_address_ex_i : in std_logic_vector(4 downto 0);
mem_to_reg_ex_i : in std_logic;
rd_we_ex_i : in std_logic;
rd_address_mem_i : in std_logic_vector(4 downto 0);
mem_to_reg_mem_i : in std_logic;
-- izlazni kontrolni signali
-- pc_en_o je signal dozvole rada za pc registar
pc_en_o : out std_logic;
-- if_id_en_o je signal dozvole rada za if/id registar
if_id_en_o : out std_logic;
-- control_pass_o kontrolise da li ce u execute fazu biti prosledjeni
-- kontrolni signali iz ctrl_decoder-a ili sve nule
control_pass_o : out std_logic
);
end entity;