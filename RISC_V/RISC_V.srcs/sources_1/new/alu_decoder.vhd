library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all_pkg.all;

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


architecture behavioral of alu_decoder is
	signal funct7_5_s : std_logic;
begin

 	funct7_5_s <= funct7_i(5);
   alu_dec : process(alu_2bit_op_i, funct3_i,funct7_i, funct7_5_s)is
   begin
      --default
      alu_op_o <= "00010"; --add
      case alu_2bit_op_i is
         when "00" =>
            alu_op_o <= "00010"; --add
         when others =>
            case funct3_i is
               when "000" =>
                  alu_op_o <= "00010"; --add
                  if(alu_2bit_op_i = "10" and funct7_i(5) = '1') then
                        alu_op_o <= "00110"; --sub
                  end if;
               when "110" =>
                  alu_op_o <= "00001"; --or
               when others =>
                  alu_op_o <= "00000"; --and
            end case;
      end case;
   end process;

end architecture;