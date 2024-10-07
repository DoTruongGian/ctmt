module alu (
  input logic [31:0] operand_a,  // rs1
  input logic [31:0] operand_b,  // rs2 or immediate
  input logic [3:0] alu_op,      // ALU operation selection
  output logic [31:0] alu_data   // ALU result
);

  logic [32:0] sub_result;
  logic [31:0] shifted_data;      // Temporary variable for shifting
  logic [4:0] shift_amount;       // Store the shift amount for left/right shifts

  always_comb begin
    // Perform subtraction using two's complement
    sub_result = {1'b0, operand_a} + {1'b0, (~operand_b + 1)};

    // Default value for alu_data
    alu_data = 32'b0;

    // Main ALU operation selection
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
        shifted_data = operand_a; // Initialize shifted data
        shift_amount = operand_b[4:0]; // Get shift amount
        for (int i = 0; i < shift_amount; i++) begin
          shifted_data[31:1] = shifted_data[30:0]; // Shift left
          shifted_data[0] = 1'b0; // LSB is set to 0
        end
        alu_data = shifted_data; // Assign shifted value to output
      end
      4'b1000: begin // SRL (Shift Right Logical)
        shifted_data = operand_a; // Initialize shifted data
        shift_amount = operand_b[4:0]; // Get shift amount
        for (int i = 0; i < shift_amount; i++) begin
          shifted_data[30:0] = shifted_data[31:1]; // Shift right
          shifted_data[31] = 1'b0; // MSB is set to 0 for logical shift
        end
        alu_data = shifted_data; // Assign shifted value to output
      end
      4'b1001: begin // SRA (Shift Right Arithmetic)
        shifted_data = operand_a; // Initialize shifted data
        shift_amount = operand_b[4:0]; // Get shift amount
        for (int i = 0; i < shift_amount; i++) begin
          shifted_data[30:0] = shifted_data[31:1]; // Shift right
          // Keep MSB (sign bit) unchanged for arithmetic shift
          shifted_data[31] = shifted_data[31]; // No change to MSB
        end
        alu_data = shifted_data; // Assign shifted value to output
      end
      default: begin // Default case
        alu_data = 32'b0;
      end
    endcase
  end
endmodule
