library verilog;
use verilog.vl_types.all;
entity single_cycle_vlg_check_tst is
    port(
        SRAM_ADDR       : in     vl_logic_vector(17 downto 0);
        SRAM_CE_N       : in     vl_logic;
        SRAM_DQ         : in     vl_logic_vector(15 downto 0);
        SRAM_LB_N       : in     vl_logic;
        SRAM_OE_N       : in     vl_logic;
        SRAM_UB_N       : in     vl_logic;
        SRAM_WE_N       : in     vl_logic;
        checker1        : in     vl_logic_vector(31 downto 0);
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
        sampler_rx      : in     vl_logic
    );
end single_cycle_vlg_check_tst;
