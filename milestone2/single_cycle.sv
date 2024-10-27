module single_cycle (
  input logic i_clk,         // Global clock, active on the rising edge
  input logic i_rst_n,       // Global low active reset
  output logic [31:0] o_pc_debug,  // Debug program counter
  output logic o_insn_vld,        // Instruction valid
  output logic [31:0] o_io_ledr,  // Output for driving red LEDs
  output logic [31:0] o_io_ledg,  // Output for driving green LEDs
  output logic [6:0] o_io_hex0,   // Output for driving 7-segment LED display 0
  output logic [6:0] o_io_hex1,   // Output for driving 7-segment LED display 1
  output logic [6:0] o_io_hex2,   // Output for driving 7-segment LED display 2
  output logic [6:0] o_io_hex3,   // Output for driving 7-segment LED display 3
  output logic [6:0] o_io_hex4,   // Output for driving 7-segment LED display 4
  output logic [6:0] o_io_hex5,   // Output for driving 7-segment LED display 5
  output logic [6:0] o_io_hex6,   // Output for driving 7-segment LED display 6
  output logic [6:0] o_io_hex7,   // Output for driving 7-segment LED display 7
  output logic [31:0] o_io_lcd,   // Output for driving the LCD register
  input logic [31:0] i_io_sw,     // Input for switches
  input logic [3:0] i_io_btn,      // Input for buttons
  output logic [31:0] checker1,
  output logic [31:0] checker2,
  output logic [31:0] checker3,
  output logic [31:0] checker5,
  output logic [31:0] checker8,
  output logic br_lesss
);
wire [31:0] pc_next, pc_four, alu_data, pc, instr, wb_data, o_rs1_data, o_rs2_data, imm, operand_a, operand_b, ld_data;
wire pc_sel, rd_wren, br_un, br_equal, br_less, opa_sel, opb_sel, mem_wren, insn_vld, i_unsigned;
wire [1:0] wb_sel, i_data_type;
wire [3:0] alu_op;

mux_2to1 mux211 (
  .a(pc_four),
  .b(alu_data),
  .sel(pc_sel),
  .y(pc_next)
);

pc Pc (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .PC_i(pc_next),
  .PC_o(pc)
);

pc_adder adder (
  .pc(pc),
  .pcp(pc_four)
);

I$ i$ (
  .PC(pc),
  .instr(instr)
);

regfile regf(
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .i_rs1_addr(instr[19:15]),
  .i_rs2_addr(instr[24:20]),
  .i_rd_addr(instr[11:7]),
  .i_rd_data(wb_data),
  .i_rd_wren(rd_wren),
  .o_rs1_data(o_rs1_data),
  .o_rs2_data(o_rs2_data),
  .checker1(checker1),
  .checker2(checker2),
  .checker3(checker3),
  .checker5(checker5),
  .checker8(checker8)
);

ImmGen immgen (
  .instr(instr),
  .imm(imm)
);

brc Brc (
  .i_rs1_data(o_rs1_data),
  .i_rs2_data(o_rs2_data),
  .i_br_un(br_un),
  .o_br_less(br_less),
  .o_br_equal(br_equal)
);

mux_2to1 mux212 (
  .a(o_rs1_data),
  .b(pc),
  .sel(opa_sel),
  .y(operand_a)  
);

mux_2to1 mux213 (
  .a(imm),
  .b(o_rs2_data),
  .sel(opb_sel),
  .y(operand_b)  
);

alu Alu (
 .i_operand_a(operand_a),
 .i_operand_b(operand_b),
 .i_alu_op(alu_op),
 .o_alu_data(alu_data)
);

lsu Lsu (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .i_lsu_addr(alu_data),
  .i_st_data(o_rs2_data),
  .i_lsu_wren(mem_wren),
  .o_ld_data(ld_data),
  .o_io_ledr(o_io_ledr),
  .o_io_ledg(o_io_ledg),
  .o_io_hex0(o_io_hex0),
  .o_io_hex1(o_io_hex1),
  .o_io_hex2(o_io_hex2),
  .o_io_hex3(o_io_hex3),
  .o_io_hex4(o_io_hex4),
  .o_io_hex5(o_io_hex5),
  .o_io_hex6(o_io_hex6),
  .o_io_hex7(o_io_hex7),
  .o_io_lcd(o_io_lcd),
  .i_io_sw(i_io_sw),
  .i_data_type(i_data_type),
  .i_unsigned(i_unsigned),
  .i_io_btn(i_io_btn)
);

mux_3to1 mux31 (
  .a(ld_data),
  .b(alu_data),
  .c(pc_four),
  .sel(wb_sel),
  .y(wb_data)
);

pc_debug pc_de(
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .pc(pc),
  .o_pc_debug(o_pc_debug)
);

insn_vld ins_vld (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .insn_vld(insn_vld),
  .o_insn_vld(o_insn_vld)
);

ctrl_unit ctrl (
  .instr(instr),
  .br_less(br_less),
  .br_equal(br_equal),
  .rd_wren(rd_wren),
  .insn_vld(insn_vld),
  .br_un(br_un),
  .pc_sel(pc_sel),
  .opa_sel(opa_sel),
  .opb_sel(opb_sel),
  .alu_op(alu_op),
  .mem_wren(mem_wren),
  .wb_sel(wb_sel),
  .i_unsigned(i_unsigned),
  .i_data_type(i_data_type)
);
assign br_lesss = br_less;
endmodule
