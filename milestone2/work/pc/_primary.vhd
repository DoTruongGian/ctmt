library verilog;
use verilog.vl_types.all;
entity pc is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        PC_i            : in     vl_logic_vector(31 downto 0);
        PC_o            : out    vl_logic_vector(31 downto 0)
    );
end pc;
