module pipeline (
  input logic i_clk,         // Global clock, active on the rising edge
  input logic i_rst_n,       // Global low active reset
  input logic [31:0] i_io_sw,     // Input for switches
  input logic [3:0] i_io_btn,      // Input for buttons
  output logic [31:0] checker8,
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
  output logic [31:0] o_io_lcd   // Output for driving the LCD register
);
logic [31:0] PCPlus4_F, alu_data_E, PCnext_F, PC_F, instr_F, instr_D, PC_D, PCPlus4_D, wb_data_W, rs1_data_D, rs2_data_D, imm_D, PC_E, PCPlus4_E, instr_E, rs1_data_E, rs2_data_E, imm_E, operand_a_E, operand_b_E, instr_M, alu_data_M, rs2_data_M, PCPlus4_M, ld_data_M, alu_data_W, ld_data_W, PCPlus4_W;
logic [4:0] rd_addr_W, rd_addr_E, rd_addr_M;
logic [3:0] alu_op_D, alu_op_E;
logic [1:0] mem_wren_D, data_type_D, wb_sel_D, mem_wren_E, wb_sel_E, data_type_E, mem_wren_M, wb_sel_M, data_type_M, wb_sel_W;
logic pc_sel_E, rd_wren_W, br_un_D, br_less_D, br_equal_D, rd_wren_D, ins_vld_D, pc_sel_D, opa_sel_D, opb_sel_D, unsigned_D, rd_wren_E, opa_sel_E, opb_sel_E, unsigned_E, rd_wren_M, unsigned_M;
mux_2to1 muxPCsel (
  .a(PCPlus4_F),
  .b(alu_data_E),
  .sel(pc_sel_E),
  .y(PCnext_F)
);

pc Pc (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .en(1),
  .PC_i(PCnext_F),
  .PC_o(PC_F)
);

pc_adder adder (
  .pc(PC_F),
  .pcp(PCPlus4_F)
);

I$ i$ (
  .PC(PC_F),
  .instr(instr_F)
);

first_register firstDff (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .StallD(),
  .FlushD(),
  .instrF(instr_F),
  .PCF(PC_F),
  .PCPlus4F(PCPlus4_F),
  .instrD(instr_D),
  .PCD(PC_D),
  .PCPlus4D(PCPlus4_D)
);

regfile regf(
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .i_rs1_addr(instr_D[19:15]),
  .i_rs2_addr(instr_D[24:20]),
  .i_rd_addr(rd_addr_W),
  .i_rd_data(wb_data_W),
  .i_rd_wren(rd_wren_W),
  .o_rs1_data(rs1_data_D),
  .o_rs2_data(rs2_data_D),
  .checker8(checker8)
);

ImmGen immgen (
  .instr(instr_D),
  .imm(imm_D)
);

brc Brc (
  .i_rs1_data(rs1_data_D),
  .i_rs2_data(rs2_data_D),
  .i_br_un(br_un_D),
  .o_br_less(br_less_D),
  .o_br_equal(br_equal_D)
);

ctrl_unit ctrl (
  .instr(instr_D),
  .br_less(br_less_D),
  .br_equal(br_equal_D),
  .rd_wren(rd_wren_D),
  .insn_vld(ins_vld_D),
  .br_un(br_un_D),
  .pc_sel(pc_sel_D),
  .opa_sel(opa_sel_D),
  .opb_sel(opb_sel_D),
  .alu_op(alu_op_D),
  .mem_wren(mem_wren_D),
  .i_data_type(data_type_D),
  .i_unsigned(unsigned_D),
  .wb_sel(wb_sel_D)
);

second_register secondDff (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .StallE(),
  .FlushE(),
  .PCD(PC_D),
  .PCPlus4D(PCPlus4_D),
  .instrD(instr_D),
  .rs1_dataD(rs1_data_D),
  .rs2_dataD(rs2_data_D),
  .rd_addrD(instr_D[11:7]),
  .immD(imm_D),
  .pc_selD(pc_sel_D),
  .rd_wrenD(rd_wren_D),
  .opa_selD(opa_sel_D),
  .opb_selD(opb_sel_D),
  .alu_opD(alu_op_D),
  .mem_wrenD(mem_wren_D),
  .wb_selD(wb_sel_D),
  .i_unsignedD(unsigned_D),
  .i_data_typeD(data_type_D),
  .PCE(PC_E),
  .PCPlus4E(PCPlus4_E),
  .instrE(instr_E),
  .rs1_dataE(rs1_data_E),
  .rs2_dataE(rs2_data_E),
  .rd_addrE(rd_addr_E),
  .immE(imm_E),
  .pc_selE(pc_sel_E),
  .rd_wrenE(rd_wren_E),
  .opa_selE(opa_sel_E),
  .opb_selE(opb_sel_E),
  .alu_opE(alu_op_E),
  .mem_wrenE(mem_wren_E),
  .wb_selE(wb_sel_E),
  .i_unsignedE(unsigned_E),
  .i_data_typeE(data_type_E)
);

mux_2to1 muxOperandasel (
  .a(rs1_data_E),
  .b(PC_E),
  .sel(opa_sel_E),
  .y(operand_a_E)  
);

mux_2to1 muxOperandbsel (
  .a(imm_E),
  .b(rs2_data_E),
  .sel(opb_sel_E),
  .y(operand_b_E)  
);

alu Alu (
 .i_operand_a(operand_a_E),
 .i_operand_b(operand_b_E),
 .i_alu_op(alu_op_E),
 .o_alu_data(alu_data_E)
);

third_register thirdDff (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .StallM(),
  .FlushM(),
  .instrE(instr_E),
  .alu_dataE(alu_data_E),
  .rs2_dataE(rs2_data_E),
  .rd_addrE(rd_addr_E),
  .PCPlus4E(PCPlus4_E),
  .rd_wrenE(rd_wren_E),
  .mem_wrenE(mem_wren_E),
  .wb_selE(wb_sel_E),
  .i_unsignedE(unsigned_E),
  .i_data_typeE(data_type_E),
  .instrM(instr_M),
  .alu_dataM(alu_data_M),
  .rs2_dataM(rs2_data_M),
  .rd_addrM(rd_addr_M),
  .PCPlus4M(PCPlus4_M),
  .rd_wrenM(rd_wren_M),
  .mem_wrenM(mem_wren_M),
  .wb_selM(wb_sel_M),
  .i_unsignedM(unsigned_M),
  .i_data_typeM(data_type_M)
);

lsu Lsu (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .i_lsu_addr(alu_data_M),
  .i_st_data(rs2_data_M),
  .i_lsu_wren(mem_wren_M),
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

fourth_register fourthDff (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .StallW(),
  .FlushW(),
  .instrM(instr_M),
  .alu_dataM(alu_data_M),
  .ld_dataM(ld_data_M),
  .rd_addrM(rd_addr_M),
  .PCPlus4M(PCPlus4_M),
  .rd_wrenM(rd_wren_M),
  .wb_selM(wb_sel_M),
  .alu_dataW(alu_data_W),
  .ld_dataW(ld_data_W),
  .rd_addrW(rd_addr_W),
  .PCPlus4W(PCPlus4_W),
  .rd_wrenW(rd_wren_W),
  .wb_selW(wb_sel_W)
);

mux_3to1 muxWBsel (
  .a(ld_data_W),
  .b(alu_data_W),
  .c(PCPlus4_W),
  .sel(wb_sel_W),
  .y(wb_data_W)
);

pc_debug pc_de(
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .pc(PC_D),
  .o_pc_debug(o_pc_debug)
);

insn_vld ins_vld (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .insn_vld(ins_vld_D),
  .o_insn_vld(o_insn_vld)
);

endmodule
