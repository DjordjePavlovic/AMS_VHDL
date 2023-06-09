LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;
use work.all_pkg.all;

ENTITY ALU IS
GENERIC(
WIDTH : NATURAL := 32);
PORT(
a_i : in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --prvi operand
b_i : in STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --drugi operand
op_i : in STD_LOGIC_VECTOR(4 DOWNTO 0); --port za izbor operacije
res_o : out STD_LOGIC_VECTOR(WIDTH-1 DOWNTO 0); --rezultat
zero_o : out STD_LOGIC; -- signal da je rezultat nula
of_o : out STD_LOGIC); -- signal da je doslo do prekoracenja opsega
END ALU;

architecture Behavioral of ALU is

    signal add_r,sub_r,or_r,and_r,res_s : STD_LOGIC_VECTOR(WIDTH-1 downto 0);
    
begin
    -- add
    add_r <= std_logic_vector(unsigned(a_i) + unsigned(b_i));
    -- sub
    sub_r <= std_logic_vector(unsigned(a_i) - unsigned(b_i));
    -- or
    or_r <= a_i or b_i;
    -- and
    and_r <= a_i and b_i;
    
    
    -- Select res
    res_o <= res_s;
    with op_i select
        res_s<= and_r when "00000", --and
        or_r when "00001",          --or
        add_r when "00010",         --add
        sub_r when "00110",         --sub
        (others => '1') when others;
    

end Behavioral;
