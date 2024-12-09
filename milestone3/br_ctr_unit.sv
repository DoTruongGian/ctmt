module br_ctr_unit(
    input logic [31:0] instr_E,
    input logic br_less,
    input logic br_equal,
    output logic ctr_opa_sel_E,
    output logic opa_sel,
    output logic pc_sel
);
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  assign opcode = instr_E[6:0];
  assign funct3 = instr_E[14:12];
  assign funct7 = instr_E[31:25];
    always_comb begin
	 ctr_opa_sel_E = 0;
	 opa_sel = 0;
	 pc_sel = 0;
    if (opcode == 7'b1100011) begin // Branch
      ctr_opa_sel_E = 1;
      case (funct3)
        3'b000: begin
          if (br_equal) begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end else begin
            pc_sel = 1'b0;
          end
        end
        3'b001: begin
          if (br_equal) begin
            pc_sel = 1'b0;
          end else begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end
        end
        3'b100: begin
          if (br_less) begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end else begin
            pc_sel = 1'b0;
          end
        end
        3'b101: begin
          if (br_equal || (!br_equal && !br_less)) begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end else begin
            pc_sel = 1'b0;
          end
        end
        3'b110: begin
          if (br_less) begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end else begin
            pc_sel = 1'b0;
          end
        end
        3'b111: begin
          if (br_equal || (!br_equal && !br_less)) begin
            opa_sel = 1'b1;
            pc_sel = 1'b1;
          end else begin
            pc_sel = 1'b0;
          end
        end
      endcase
    end
    else ctr_opa_sel_E = 0;
    end
endmodule