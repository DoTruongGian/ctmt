library verilog;
use verilog.vl_types.all;
entity single_cycle is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        checker1        : out    vl_logic_vector(31 downto 0);
        checker2        : out    vl_logic_vector(31 downto 0);
        checker3        : out    vl_logic_vector(31 downto 0);
        alu_data_check  : out    vl_logic_vector(32 downto 0);
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
        o_io_lcd        : out    vl_logic_vector(31 downto 0);
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        i_io_btn        : in     vl_logic_vector(3 downto 0)
    );
end single_cycle;
