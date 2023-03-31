library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--***************OPIS MODULA*********************
--Registarska banka sa dva interfejsa za citanje
--podataka i jednim interfejsom za upis podataka.
--Broj registara u banci je 32.
--WIDTH je parametar koji odredjuje sirinu poda-
--data u registrima
--***********************************************
entity register_bank is
    generic (WIDTH : positive := 32);
    port (clk : in std_logic;
        reset : in std_logic;
-- Interfejs 1 za citanje podataka
        rs1_address_i : in std_logic_vector(4 downto 0);
        rs1_data_o : out std_logic_vector(WIDTH - 1 downto 0);
-- Interfejs 2 za citanje podataka
        rs2_address_i : in std_logic_vector(4 downto 0);
        rs2_data_o : out std_logic_vector(WIDTH - 1 downto 0);
-- Interfejs za upis podataka
        rd_we_i : in std_logic; -- port za dozvolu upisa
        rd_address_i : in std_logic_vector(4 downto 0);
        rd_data_i : in std_logic_vector(WIDTH - 1 downto 0));

end entity;