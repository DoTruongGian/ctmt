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
  input logic [3:0] i_io_btn      // Input for buttons
  // ,
  // output logic [15:0]  SRAM_Q   ,
  // output logic [15:0]   SRAM_D   ,
  // output logic [17:0]   SRAM_ADDR,
  // output logic          SRAM_CE_N,
  // output logic          SRAM_WE_N,
  // output logic          SRAM_LB_N,
  // output logic          SRAM_UB_N,
  // output  logic         SRAM_OE_N
);

logic [31:0] pc_next, pc_four, alu_data, pc, instr, wb_data, o_rs1_data, o_rs2_data, imm, operand_a, operand_b, ld_data;
logic pc_sel, rd_wren, br_un, br_equal, br_less, opa_sel, opb_sel, insn_vld, i_unsigned;
logic [1:0] mem_wren, wb_sel, i_data_type;
logic [3:0] alu_op;
logic       o_pc_stall;
logic [15:0]   SRAM_Q, SRAM_D;
logic [17:0]   SRAM_ADDR;
logic          SRAM_CE_N;
logic          SRAM_WE_N;
logic          SRAM_LB_N;
logic          SRAM_UB_N;
logic          SRAM_OE_N;
// assign data_o = SRAM_D;
// assign data_i = SRAM_Q;

// assign t = {SRAM_UB_N, SRAM_LB_N};
assign t = i_data_type;
assign l = pc;
mux_2to1 mux211 (
  .a(pc_four),
  .b(alu_data),
  .sel(pc_sel),
  .y(pc_next)
);

pc Pc (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .en(1),
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
  .o_rs2_data(o_rs2_data)
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
  .i_io_sw(i_io_sw),
  .i_data_type(i_data_type),
  .i_unsigned(i_unsigned),
  .i_io_btn(i_io_btn),

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
  .o_io_lcd(o_io_lcd)
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
  .i_data_type(i_data_type),
  .i_unsigned(i_unsigned),
  .wb_sel(wb_sel)
);

endmodule
