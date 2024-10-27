library verilog;
use verilog.vl_types.all;
entity regfile is
    port(
        i_clk           : in     vl_logic;
        i_rst_n         : in     vl_logic;
        i_rs1_addr      : in     vl_logic_vector(4 downto 0);
        i_rs2_addr      : in     vl_logic_vector(4 downto 0);
        i_rd_addr       : in     vl_logic_vector(4 downto 0);
        i_rd_data       : in     vl_logic_vector(31 downto 0);
        i_rd_wren       : in     vl_logic;
        o_rs1_data      : out    vl_logic_vector(31 downto 0);
        o_rs2_data      : out    vl_logic_vector(31 downto 0);
        checker4        : out    vl_logic_vector(31 downto 0);
        checker5        : out    vl_logic_vector(31 downto 0);
        checker6        : out    vl_logic_vector(31 downto 0);
        checker7        : out    vl_logic_vector(31 downto 0);
        checker8        : out    vl_logic_vector(31 downto 0)
    );
end regfile;
