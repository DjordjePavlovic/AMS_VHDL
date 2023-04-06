library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all_pkg.all;
entity TOP_RISCV is
    generic (DATA_WIDTH : positive := 32);
    port(
-- ********* Globalna sinhronizacija ******************
        clk : in std_logic;
        reset : in std_logic;
-- ********* Interfejs ka Memoriji za instrukcije *****
        instr_mem_address_o : out std_logic_vector (31 downto 0);
        instr_mem_read_i : in std_logic_vector(31 downto 0);
-- ********* Interfejs ka Memoriji za podatke *********
        data_mem_we_o : out std_logic_vector(3 downto 0);
        data_mem_address_o : out std_logic_vector(31 downto 0);
        data_mem_write_o : out std_logic_vector(31 downto 0);
        data_mem_read_i : in std_logic_vector (31 downto 0));
end entity;

architecture structural of TOP_RISCV is
   signal mem_to_reg_s       : std_logic;
   signal alu_op_s           : std_logic_vector(4 downto 0);
   signal alu_src_b_s        : std_logic;
   signal rd_we_s            : std_logic;
   signal pc_next_sel_s      : std_logic;

   signal if_id_flush_s      : std_logic;

   signal alu_forward_a_s    : std_logic_vector (1 downto 0);
   signal alu_forward_b_s    : std_logic_vector (1 downto 0);
   signal branch_condition_s : std_logic;
   signal branch_forward_a_s : std_logic;
   signal branch_forward_b_s : std_logic;
   
   signal pc_en_s            : std_logic;
   signal if_id_en_s         : std_logic;
         
   
begin
   -- Data_path instance
   data_path_1: entity work.data_path
      port map (
         -- global synchronization signals
         clk                 => clk,
         reset               => reset,
         -- operands come from instruction memory
         instr_mem_address_o => instr_mem_address_o,
         instr_mem_read_i    => instr_mem_read_i,
         -- interface towards data memory
         data_mem_address_o  => data_mem_address_o,
         data_mem_write_o    => data_mem_write_o,
         data_mem_read_i     => data_mem_read_i,
         -- control signals come from control path
         mem_to_reg_i        => mem_to_reg_s,
         alu_op_i            => alu_op_s,
         alu_src_b_i         => alu_src_b_s,
         rd_we_i             => rd_we_s,
         pc_next_sel_i       => pc_next_sel_s,
         -- control signals for forwaring
         alu_forward_a_i     => alu_forward_a_s,
         alu_forward_b_i     => alu_forward_b_s,
         branch_condition_o  => branch_condition_s,
         branch_forward_a_i  => branch_forward_a_s,
         branch_forward_b_i  => branch_forward_b_s,
         
         -- control signals for flushing
         if_id_flush_i       => if_id_flush_s,
         -- control signals for stalling
         pc_en_i             => pc_en_s,
         if_id_en_i          => if_id_en_s); 



   -- Control_path instance
   control_path_1: entity work.control_path
      port map (
         -- global synchronization signals
         clk                 => clk,
         reset               => reset,
         -- instruction is read from memory
         instruction_i       => instr_mem_read_i,
         -- control signals are forwarded to data_path
         mem_to_reg_o        => mem_to_reg_s,
         alu_op_o            => alu_op_s,
         alu_src_b_o         => alu_src_b_s,
         rd_we_o             => rd_we_s,
         pc_next_sel_o       => pc_next_sel_s,
         -- control signals for forwarding
         alu_forward_a_o     => alu_forward_a_s,
         alu_forward_b_o     => alu_forward_b_s,
         branch_condition_i  => branch_condition_s,
         -- control signals for flushing
         data_mem_we_o       => data_mem_we_o,
         if_id_flush_o       => if_id_flush_s,
         -- control signals for stalling
         pc_en_o             => pc_en_s,
         if_id_en_o          => if_id_en_s);
   
   
end architecture;