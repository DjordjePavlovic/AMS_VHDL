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

architecture behavioral of hazard_unit is
   signal en_s        : std_logic := '0';
begin

   hazard_det: process (rs1_address_id_i, rs2_address_id_i, rd_address_ex_i, 
            mem_to_reg_ex_i, rs1_in_use_i, rs2_in_use_i,branch_id_i,rd_we_ex_i,
            rd_address_mem_i,mem_to_reg_mem_i) is
   begin
	   if(branch_id_i = '0')then
		  if(((rs1_address_id_i = rd_address_ex_i and rs1_in_use_i = '1') or
		  	 (rs2_address_id_i = rd_address_ex_i and rs2_in_use_i = '1')) and
			 mem_to_reg_ex_i = '1' and rd_we_ex_i = '1') then
			 en_s <= '0';
		  end if;
		elsif(branch_id_i = '1')then
		  if((rs1_address_id_i = rd_address_ex_i or rs2_address_id_i = rd_address_ex_i)
		      and rd_we_ex_i = '1')then
		      en_s <= '1'; 
		      elsif((rs1_address_id_i = rd_address_mem_i or rs2_address_id_i = rd_address_mem_i)
		          and mem_to_reg_mem_i = '1')then
		          en_s <= '0'; 
		  end if;
		end if;
   end process;

   pc_en_o        <= en_s;
	-- if '0' stalls if/id register and instruction memory
   if_id_en_o     <= en_s;
	-- when pipeline needs to stall this output if set to '0' 
   control_pass_o <= en_s;

end architecture;