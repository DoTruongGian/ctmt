library verilog;
use verilog.vl_types.all;
entity milestone1_test_vlg_check_tst is
    port(
        change_o        : in     vl_logic_vector(2 downto 0);
        soda_o          : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end milestone1_test_vlg_check_tst;
