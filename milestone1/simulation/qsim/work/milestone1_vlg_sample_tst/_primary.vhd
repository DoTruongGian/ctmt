library verilog;
use verilog.vl_types.all;
entity milestone1_vlg_sample_tst is
    port(
        i_clk           : in     vl_logic;
        i_dime          : in     vl_logic;
        i_nickel        : in     vl_logic;
        i_quarter       : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end milestone1_vlg_sample_tst;
