library verilog;
use verilog.vl_types.all;
entity lsu is
    generic(
        w               : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        hw              : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        b               : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        i_lsu_addr      : in     vl_logic_vector(31 downto 0);
        i_st_data       : in     vl_logic_vector(31 downto 0);
        i_lsu_wren      : in     vl_logic;
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        i_io_btn        : in     vl_logic_vector(3 downto 0);
        i_data_type     : in     vl_logic_vector(1 downto 0);
        i_unsigned      : in     vl_logic;
        o_ld_data       : out    vl_logic_vector(31 downto 0);
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
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of w : constant is 1;
    attribute mti_svvh_generic_type of hw : constant is 1;
    attribute mti_svvh_generic_type of b : constant is 1;
end lsu;
