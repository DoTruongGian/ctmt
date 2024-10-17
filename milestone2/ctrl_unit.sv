module ctrl_unit (
  input logic [31:0] instr,
  input logic br_less,
  input logic br_equal,
  output logic rd_wren,
  output logic insn_vld,
  output logic br_un,
  output logic pc_sel,
  output logic opa_sel,
  output logic opb_sel,
  output logic [3:0] alu_op,
  output logic mem_wren,
  output logic [1:0] wb_sel
);

  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  assign funct7 = instr[31:25];

  always_comb begin
  rd_wren = 0;
  insn_vld = 0;
  br_un = 0;
  pc_sel = 0;
  opa_sel = 0;
  opb_sel = 0;
  alu_op = 4'b0000;
  mem_wren = 0;
  wb_sel = 2'b00;
  case (opcode)
    7'b0110011: begin  // R-type
      rd_wren = 1;
      insn_vld = 1;
      opb_sel = 1;
      wb_sel = 2'b01;
      case (funct3) 
        3'b000: alu_op = (funct7 == 7'b0000000) ? 4'b0000 : 4'b0001; 
        3'b001: alu_op = 4'b0111;
        3'b010: alu_op = 4'b0010;
        3'b011: alu_op = 4'b0011;
        3'b100: alu_op = 4'b0100;
        3'b101: alu_op = (funct7 == 7'b0000000) ? 4'b1000 : 4'b1001;
        3'b110: alu_op = 4'b0101;
        3'b111: alu_op = 4'b0110;
      endcase
    end
  
    7'b0010011: begin  // I-type 
      rd_wren = 1;
      insn_vld = 1;
      wb_sel = 2'b01;
      case (funct3)
        3'b000: alu_op = 4'b0000;
        3'b010: alu_op = 4'b0010;
        3'b011: alu_op = 4'b0011;
        3'b100: alu_op = 4'b0100;
        3'b110: alu_op = 4'b0101;
        3'b111: alu_op = 4'b0110;
      endcase
    end

    7'b0000011: begin // Load
      rd_wren = 1;
      insn_vld = 1;
      wb_sel = 2'b00;
      alu_op = 4'b0000;
    end

    7'b0100011: begin  // Store
      insn_vld = 1;
      alu_op = 4'b0000; // ADD for address calculation
      mem_wren = 1;
    end

    7'b1100011: begin // Branch
      insn_vld = 1;
      case (funct3)
        3'b000: begin
          if (br_equal) begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end else begin
            wb_sel = 2'b10;
          end
        end
        3'b001: begin
          if (br_equal) begin
            wb_sel = 2'b10;
          end else begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end
        end
        3'b100: begin
          if (br_less) begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end else begin
            wb_sel = 2'b10;
          end
        end
        3'b101: begin
          if (br_equal || (!br_equal && !br_less)) begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end else begin
            wb_sel = 2'b10;
          end
        end
        3'b110: begin
          br_un = 1'b1;
          if (br_less) begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end else begin
            wb_sel = 2'b10;
          end
        end
        3'b111: begin
          br_un = 1'b1;
          if (br_equal || (!br_equal && !br_less)) begin
            opa_sel = 1'b1;
            wb_sel = 2'b01;
          end else begin
            wb_sel = 2'b10;
          end
        end
      endcase
    end
  endcase
  end

endmodule