library verilog;
use verilog.vl_types.all;
entity insn_vld is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        insn_vld        : in     vl_logic;
        o_insn_vld      : out    vl_logic
    );
end insn_vld;
