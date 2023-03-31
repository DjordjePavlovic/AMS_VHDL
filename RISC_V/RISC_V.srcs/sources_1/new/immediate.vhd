library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity immediate is
port (instruction_i : in std_logic_vector (31 downto 0);
immediate_extended_o : out std_logic_vector (31 downto 0));

end entity;