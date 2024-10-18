library verilog;
use verilog.vl_types.all;
entity pc_debug is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        pc              : in     vl_logic_vector(31 downto 0);
        o_pc_debug      : out    vl_logic_vector(31 downto 0)
    );
end pc_debug;
