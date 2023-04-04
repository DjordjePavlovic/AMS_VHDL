library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all_pkg.all;

entity data_path is
port(
-- sinhronizacioni signali
clk : in std_logic;
reset : in std_logic;
-- interfejs ka memoriji za instrukcije
instr_mem_address_o : out std_logic_vector (31 downto 0);
instr_mem_read_i : in std_logic_vector(31 downto 0);
instruction_o : out std_logic_vector(31 downto 0);
-- interfejs ka memoriji za podatke
data_mem_address_o : out std_logic_vector(31 downto 0);
data_mem_write_o : out std_logic_vector(31 downto 0);
data_mem_read_i : in std_logic_vector (31 downto 0);
-- kontrolni signali
mem_to_reg_i : in std_logic;
alu_op_i : in std_logic_vector (4 downto 0);
alu_src_b_i : in std_logic;
pc_next_sel_i : in std_logic;
rd_we_i : in std_logic;
branch_condition_o : out std_logic;
-- kontrolni signali za prosledjivanje operanada u ranije faze protocneobrade
alu_forward_a_i : in std_logic_vector (1 downto 0);
alu_forward_b_i : in std_logic_vector (1 downto 0);
branch_forward_a_i : in std_logic;
branch_forward_b_i : in std_logic;
-- kontrolni signal za resetovanje if/id registra
if_id_flush_i : in std_logic;
-- kontrolni signali za zaustavljanje protocne obrade
pc_en_i : in std_logic;
if_id_en_i : in std_logic);
end entity;

architecture Behavioral of data_path is

	   --*********  INSTRUCTION FETCH  **************
	   
   signal pc_reg_if_s             : std_logic_vector (31 downto 0);
   signal pc_next_if_s            : std_logic_vector (31 downto 0);
   signal pc_adder_if_s           : std_logic_vector (31 downto 0);

   --*********  INSTRUCTION DECODE **************
   signal pc_adder_id_s           : std_logic_vector (31 downto 0);
   signal pc_reg_id_s             : std_logic_vector (31 downto 0);
   signal rs1_data_id_s           : std_logic_vector (31 downto 0);
   signal rs2_data_id_s           : std_logic_vector (31 downto 0);
   signal immediate_extended_id_s : std_logic_vector (31 downto 0);
   signal rs1_address_id_s        : std_logic_vector (4 downto 0);
   signal rs2_address_id_s        : std_logic_vector (4 downto 0);
   signal rd_address_id_s         : std_logic_vector (4 downto 0);
   signal if_id_reg_flush_s       : std_logic;

   --*********       EXECUTE       **************
   signal pc_adder_ex_s           : std_logic_vector (31 downto 0);
   signal pc_reg_ex_s             : std_logic_vector (31 downto 0);
   signal immediate_extended_ex_s : std_logic_vector (31 downto 0);
   signal alu_forward_a_ex_s      : std_logic_vector(31 downto 0);
   signal alu_forward_b_ex_s      : std_logic_vector(31 downto 0);
   signal alu_zero_ex_s           : std_logic;
   signal alu_of_ex_s             : std_logic;
   signal b_ex_s, a_ex_s          : std_logic_vector(31 downto 0);
   signal alu_result_ex_s         : std_logic_vector(31 downto 0);
   signal rs1_data_ex_s           : std_logic_vector (31 downto 0);
   signal rs2_data_ex_s           : std_logic_vector (31 downto 0);
   signal rd_address_ex_s         : std_logic_vector (4 downto 0);

   --*********       MEMORY        **************
   signal pc_adder_mem_s          : std_logic_vector (31 downto 0);
   signal alu_result_mem_s        : std_logic_vector(31 downto 0);
   signal rd_address_mem_s        : std_logic_vector (4 downto 0);
   signal rs2_data_mem_s          : std_logic_vector (31 downto 0);

   --*********      WRITEBACK      **************
   signal pc_adder_wb_s           : std_logic_vector (31 downto 0);
   signal alu_result_wb_s         : std_logic_vector(31 downto 0);
   signal extended_data_wb_s      : std_logic_vector (31 downto 0);
   signal rd_data_wb_s            : std_logic_vector (31 downto 0);
   signal rd_address_wb_s         : std_logic_vector (4 downto 0);

begin

   --***********  Sequential logic  ******************
   --Program Counter
   pc_proc : process (clk) is
   begin
      if (rising_edge(clk) ) then
         if (reset = '0')then
            pc_reg_if_s <= (others => '0');
         elsif (pc_en_i = '1') then
            pc_reg_if_s <= pc_next_if_s;
         end if;
      end if;
   end process;

   --IF/ID register
   if_id : process (clk) is
   begin
      if (rising_edge(clk) ) then
         if(if_id_en_i = '1')then
            if (reset = '0' or if_id_flush_i = '1')then
               pc_reg_id_s   <= (others => '0');
               pc_adder_id_s <= (others => '0');
            else
               pc_reg_id_s   <= pc_reg_if_s;
               pc_adder_id_s <= pc_adder_if_s;
            end if;
         end if;
      end if;
   end process;

   --ID/EX register
   id_ex : process (clk) is
   begin
      if (rising_edge(clk) ) then
         if (reset = '0' )then
            pc_adder_ex_s           <= (others => '0');
            rs1_data_ex_s           <= (others => '0');
            rs2_data_ex_s           <= (others => '0');
            immediate_extended_ex_s <= (others => '0');
            rd_address_ex_s         <= (others => '0');
         else
            pc_adder_ex_s           <= pc_adder_id_s;
            rs1_data_ex_s           <= rs1_data_id_s;
            rs2_data_ex_s           <= rs2_data_id_s;
            immediate_extended_ex_s <= immediate_extended_id_s;
            rd_address_ex_s         <= rd_address_id_s;
         end if;
      end if;
   end process;

   --EX/MEM register
   ex_mem : process (clk) is
   begin
      if (rising_edge(clk) ) then
         if (reset = '0')then
            alu_result_mem_s <= (others => '0');
            rs2_data_mem_s   <= (others => '0');
            pc_adder_mem_s   <= (others => '0');
            rd_address_mem_s <= (others => '0');
            pc_reg_ex_s      <= (others => '0');
         else
            alu_result_mem_s <= alu_result_ex_s;
            rs2_data_mem_s   <= alu_forward_b_ex_s;
            pc_adder_mem_s   <= pc_adder_ex_s;
            rd_address_mem_s <= rd_address_ex_s;
            pc_reg_ex_s      <= pc_reg_id_s;
         end if;
      end if;
   end process;

   --MEM/WB register
   mem_wb : process (clk) is
   begin
      if (rising_edge(clk) ) then
         if (reset = '0')then
            alu_result_wb_s <= (others => '0');
            pc_adder_wb_s   <= (others => '0');
            rd_address_wb_s <= (others => '0');
         else
            alu_result_wb_s <= alu_result_mem_s;
            pc_adder_wb_s   <= pc_adder_mem_s;
            rd_address_wb_s <= rd_address_mem_s;
         end if;
      end if;
   end process;




   --***********  Combinational logic  ***************


   --pc_adder_s update
   pc_adder_if_s <= std_logic_vector(unsigned(pc_reg_if_s) + to_unsigned(4, 32));



--   --branch condition 
--   branch_condition_o <='1' when ((signed(alu_forward_a_ex_s) = signed(alu_forward_b_ex_s)) and branch_op_i = "00") else
--                        '1' when ((signed(alu_forward_a_ex_s) < signed(alu_forward_b_ex_s)) and branch_op_i = "10") else
--                        '1' when ((signed(alu_forward_a_ex_s) > signed(alu_forward_b_ex_s)) and branch_op_i = "11") else
--                        '0';
   --pc_next mux
   with pc_next_sel_i select
      pc_next_if_s <=   pc_adder_if_s when '0',
								alu_result_ex_s when others;

--   --forwarding muxes
--   alu_forward_a_ex_s <= rd_data_wb_s when alu_forward_a_i = fwd_a_from_wb else
--                         alu_result_mem_s when alu_forward_a_i = fwd_a_from_mem else
--                         rs1_data_ex_s;
--   alu_forward_b_ex_s <= rd_data_wb_s when alu_forward_b_i = fwd_b_from_wb else
--                         alu_result_mem_s when alu_forward_b_i = fwd_b_from_mem else
--                         rs2_data_ex_s;

   -- update alu inputs
   b_ex_s <= immediate_extended_ex_s when alu_src_b_i = '1' else
             alu_forward_b_ex_s;

--   a_ex_s <= (others => '0') when set_a_zero_i = '1' else
--             pc_reg_ex_s when alu_src_a_i = '1' else
--             alu_forward_a_ex_s;

   -- reg_bank rd_data update
--	with mem_to_reg_i select
--		rd_data_wb_s <= pc_adder_wb_s when "01",
--							extended_data_wb_s when "10",
--							alu_result_wb_s when others;

   -- extend data based on type of load instruction
--   with load_type_i select
--      extended_data_wb_s <= (31 downto 8 => data_mem_read_i(7)) & data_mem_read_i(7 downto 0)   when "000",
--      (31 downto 16                      => data_mem_read_i(15)) & data_mem_read_i(15 downto 0) when "001",
--      std_logic_vector(to_unsigned(0, 24)) & data_mem_read_i(7 downto 0)                        when "100",
--      std_logic_vector(to_unsigned(0, 16)) & data_mem_read_i(15 downto 0)                       when "101",
--      data_mem_read_i                                                                           when others;

   -- izvlacenje adresa iz instrukcija
   rs1_address_id_s <= instr_mem_read_i(19 downto 15);
   rs2_address_id_s <= instr_mem_read_i(24 downto 20);
   rd_address_id_s  <= instr_mem_read_i(11 downto 7);




   --------------Instance----------------
--   --Register_bank
--   rb-1 : entity work.register_bank
--      generic map (
--         WIDTH => 32)
--      port map (
--         clk           => clk,
--         ce            => ce,
--         reset         => reset,
--         rd_we_i       => rd_we_i,
--         rs1_address_i => rs1_address_id_s,
--         rs2_address_i => rs2_address_id_s,
--         rs1_data_o    => rs1_data_id_s,
--         rs2_data_o    => rs2_data_id_s,
--         rd_address_i  => rd_address_wb_s,
--         rd_data_i     => rd_data_wb_s);

--   --Immediate
--   imm-1 : entity work.immediate
--      port map (
--         instruction_i        => instr_mem_read_i,
--         immediate_extended_o => immediate_extended_id_s);

   --ALU
--   ALU-1 : entity work.ALU
--      generic map (
--         WIDTH => 32)
--      port map (
--         a_i    => a_ex_s,
--         b_i    => b_ex_s,
--         op_i   => alu_op_i,
--         res_o  => alu_result_ex_s);
         
	

   --------------------Izlazi-------------------
   --From instruction memory
   instr_mem_address_o <= pc_reg_if_s;
   --To data memory
   data_mem_address_o  <= alu_result_mem_s;
   data_mem_write_o    <= rs2_data_mem_s;

end architecture;