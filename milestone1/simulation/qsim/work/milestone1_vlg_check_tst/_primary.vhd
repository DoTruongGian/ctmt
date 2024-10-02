library verilog;
use verilog.vl_types.all;
entity milestone1_vlg_check_tst is
    port(
        o_change        : in     vl_logic_vector(2 downto 0);
        o_soda          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end milestone1_vlg_check_tst;
