library verilog;
use verilog.vl_types.all;
entity pipeline_vlg_check_tst is
    port(
        ForwardAE_check : in     vl_logic_vector(1 downto 0);
        ForwardBE_check : in     vl_logic_vector(1 downto 0);
        alu_data_M_check: in     vl_logic_vector(31 downto 0);
        checker2        : in     vl_logic_vector(31 downto 0);
        checker3        : in     vl_logic_vector(31 downto 0);
        checker4        : in     vl_logic_vector(31 downto 0);
        ldStall_check   : in     vl_logic;
        o_insn_vld      : in     vl_logic;
        o_io_hex0       : in     vl_logic_vector(6 downto 0);
        o_io_hex1       : in     vl_logic_vector(6 downto 0);
        o_io_hex2       : in     vl_logic_vector(6 downto 0);
        o_io_hex3       : in     vl_logic_vector(6 downto 0);
        o_io_hex4       : in     vl_logic_vector(6 downto 0);
        o_io_hex5       : in     vl_logic_vector(6 downto 0);
        o_io_hex6       : in     vl_logic_vector(6 downto 0);
        o_io_hex7       : in     vl_logic_vector(6 downto 0);
        o_io_lcd        : in     vl_logic_vector(31 downto 0);
        o_io_ledg       : in     vl_logic_vector(31 downto 0);
        o_io_ledr       : in     vl_logic_vector(31 downto 0);
        o_pc_debug      : in     vl_logic_vector(31 downto 0);
        rs1_data_HE_check: in     vl_logic_vector(31 downto 0);
        rs2_data_HE_check: in     vl_logic_vector(31 downto 0);
        rs2_data_HM_check: in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end pipeline_vlg_check_tst;
