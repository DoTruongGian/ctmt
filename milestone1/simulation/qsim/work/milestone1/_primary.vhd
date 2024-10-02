library verilog;
use verilog.vl_types.all;
entity milestone1 is
    port(
        i_clk           : in     vl_logic;
        i_dime          : in     vl_logic;
        i_nickel        : in     vl_logic;
        i_quarter       : in     vl_logic;
        o_soda          : out    vl_logic;
        o_change        : out    vl_logic_vector(2 downto 0)
    );
end milestone1;
