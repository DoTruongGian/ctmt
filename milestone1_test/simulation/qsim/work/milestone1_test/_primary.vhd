library verilog;
use verilog.vl_types.all;
entity milestone1_test is
    port(
        clk_i           : in     vl_logic;
        rst_i           : in     vl_logic;
        dime_i          : in     vl_logic;
        nickle_i        : in     vl_logic;
        quarter_i       : in     vl_logic;
        soda_o          : out    vl_logic;
        change_o        : out    vl_logic_vector(2 downto 0)
    );
end milestone1_test;
