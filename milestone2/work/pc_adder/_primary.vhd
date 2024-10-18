library verilog;
use verilog.vl_types.all;
entity pc_adder is
    port(
        pc              : in     vl_logic_vector(31 downto 0);
        pcp             : out    vl_logic_vector(31 downto 0)
    );
end pc_adder;
