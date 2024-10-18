library verilog;
use verilog.vl_types.all;
entity \I$\ is
    port(
        PC              : in     vl_logic_vector(31 downto 0);
        instr           : out    vl_logic_vector(31 downto 0)
    );
end \I$\;
