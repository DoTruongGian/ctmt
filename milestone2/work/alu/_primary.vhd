library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        i_operand_a     : in     vl_logic_vector(31 downto 0);
        i_operand_b     : in     vl_logic_vector(31 downto 0);
        i_alu_op        : in     vl_logic_vector(3 downto 0);
        o_alu_data      : out    vl_logic_vector(31 downto 0)
    );
end alu;
