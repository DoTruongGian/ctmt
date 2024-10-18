library verilog;
use verilog.vl_types.all;
entity ctrl_unit is
    port(
        instr           : in     vl_logic_vector(31 downto 0);
        br_less         : in     vl_logic;
        br_equal        : in     vl_logic;
        rd_wren         : out    vl_logic;
        insn_vld        : out    vl_logic;
        br_un           : out    vl_logic;
        pc_sel          : out    vl_logic;
        opa_sel         : out    vl_logic;
        opb_sel         : out    vl_logic;
        alu_op          : out    vl_logic_vector(3 downto 0);
        mem_wren        : out    vl_logic;
        i_data_type     : out    vl_logic_vector(1 downto 0);
        i_unsigned      : out    vl_logic;
        wb_sel          : out    vl_logic_vector(1 downto 0)
    );
end ctrl_unit;
