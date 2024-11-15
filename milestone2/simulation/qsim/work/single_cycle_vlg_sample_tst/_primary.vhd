library verilog;
use verilog.vl_types.all;
entity single_cycle_vlg_sample_tst is
    port(
        SRAM_DQ         : in     vl_logic_vector(15 downto 0);
        i_clk           : in     vl_logic;
        i_io_btn        : in     vl_logic_vector(3 downto 0);
        i_io_sw         : in     vl_logic_vector(31 downto 0);
        i_rst_n         : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end single_cycle_vlg_sample_tst;
