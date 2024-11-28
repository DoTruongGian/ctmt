library verilog;
use verilog.vl_types.all;
entity pipeline is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        i_io_btn        : in     vl_logic_vector(3 downto 0);
        checker1        : out    vl_logic_vector(31 downto 0);
        checker2        : out    vl_logic_vector(31 downto 0);
        checker3        : out    vl_logic_vector(31 downto 0);
        checker4        : out    vl_logic_vector(31 downto 0);
        alu_data_M_check: out    vl_logic_vector(31 downto 0);
        rs2_data_HM_check: out    vl_logic_vector(31 downto 0);
        rs1_data_HE_check: out    vl_logic_vector(31 downto 0);
        rs2_data_HE_check: out    vl_logic_vector(31 downto 0);
        ldStall_check   : out    vl_logic;
        ForwardAE_check : out    vl_logic_vector(1 downto 0);
        ForwardBE_check : out    vl_logic_vector(1 downto 0);
        o_pc_debug      : out    vl_logic_vector(31 downto 0);
        o_insn_vld      : out    vl_logic;
        o_io_ledr       : out    vl_logic_vector(31 downto 0);
        o_io_ledg       : out    vl_logic_vector(31 downto 0);
        o_io_hex0       : out    vl_logic_vector(6 downto 0);
        o_io_hex1       : out    vl_logic_vector(6 downto 0);
        o_io_hex2       : out    vl_logic_vector(6 downto 0);
        o_io_hex3       : out    vl_logic_vector(6 downto 0);
        o_io_hex4       : out    vl_logic_vector(6 downto 0);
        o_io_hex5       : out    vl_logic_vector(6 downto 0);
        o_io_hex6       : out    vl_logic_vector(6 downto 0);
        o_io_hex7       : out    vl_logic_vector(6 downto 0);
        o_io_lcd        : out    vl_logic_vector(31 downto 0)
    );
end pipeline;
