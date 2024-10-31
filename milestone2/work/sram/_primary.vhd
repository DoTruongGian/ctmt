library verilog;
use verilog.vl_types.all;
entity sram is
    generic(
        depth           : integer := 64;
        width           : integer := 32
    );
    port(
        i_clk           : in     vl_logic;
        i_wren          : in     vl_logic;
        i_addr          : in     vl_logic_vector;
        i_data          : in     vl_logic_vector;
        o_data          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of depth : constant is 1;
    attribute mti_svvh_generic_type of width : constant is 1;
end sram;
