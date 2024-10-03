module alu (
  input logic [31:0] operand_a,  // rs1
  input logic [31:0] operand_b,  // rs2 or immediate
  input logic [3:0] alu_op,      // ALU operation selection
  output logic [31:0] alu_data   // ALU result
);

  logic [32:0] sub_result;

  always_comb begin
    sub_result = {1'b0, operand_a} + {1'b0, (~operand_b + 1)}; // Subtraction using complement

    case (alu_op)
      4'b0000: begin // ADD
        alu_data = operand_a + operand_b;
      end
      4'b0001: begin // SUB
        alu_data = sub_result[31:0];
      end
      4'b0010: begin // SLT (Set Less Than, signed)
        alu_data = (operand_a[31] ^ operand_b[31]) ? operand_a[31] : sub_result[31];
      end
      4'b0011: begin // SLTU (Set Less Than Unsigned)
        alu_data = !sub_result[32];
      end
      4'b0100: begin // XOR
        alu_data = operand_a ^ operand_b;
      end
      4'b0101: begin // OR
        alu_data = operand_a | operand_b;
      end
      4'b0110: begin // AND
        alu_data = operand_a & operand_b;
      end
      4'b0111: begin // SLL (Shift Left Logical)
        alu_data = operand_a << operand_b[4:0];
      end
      4'b1000: begin // SRL (Shift Right Logical)
        alu_data = operand_a >> operand_b[4:0];
      end
      4'b1001: begin // SRA (Shift Right Arithmetic)
        alu_data = operand_a >>> operand_b[4:0];
      end
      default: begin // Default case
        alu_data = 32'b0;
      end
    endcase
  end
endmodule
