library verilog;
use verilog.vl_types.all;
entity ImmGen is
    port(
        instr           : in     vl_logic_vector(31 downto 0);
        imm             : out    vl_logic_vector(31 downto 0)
    );
end ImmGen;
