module alu (
  input logic [31:0] i_operand_a,  // First operand for ALU operations
  input logic [31:0] i_operand_b,  // Second operand for ALU operations
  input logic [3:0] i_alu_op,      // ALU operation control signal
  output logic [31:0] o_alu_data   // Result of the ALU operation
);

  logic [32:0] sub_result;
  logic [31:0] shifted_data;    // Temporary variable for shifting
  logic [4:0] shift_amount;     // Store the shift amount for left/right shifts
  logic sign_bit;               // Sign bit (MSB) for arithmetic shift right

  always_comb begin
    // Default assignments to avoid latches
    o_alu_data = 32'b0;
    sub_result = 33'b0;
    shifted_data = 32'b0;
    shift_amount = 5'b0;
    sign_bit = i_operand_a[31];  // Sign bit assigned based on i_operand_a

    // Perform subtraction using two's complement
    sub_result = {1'b0, i_operand_a} + {1'b0, (~i_operand_b + 1)};

    // Main ALU operation selection
    case (i_alu_op)
      4'b0000: begin // ADD (R-type and I-type)
        o_alu_data = i_operand_a + i_operand_b;
      end
      4'b0001: begin // SUB (R-type)
        o_alu_data = sub_result[31:0];
      end
      4'b0010: begin // SLT (Set Less Than, signed, R-type and I-type)
        o_alu_data = (i_operand_a[31] ^ i_operand_b[31]) ? i_operand_a[31] : sub_result[31];
      end
      4'b0011: begin // SLTU (Set Less Than Unsigned, R-type and I-type)
        o_alu_data = !sub_result[32];
      end
      4'b0100: begin // XOR (R-type and I-type)
        o_alu_data = i_operand_a ^ i_operand_b;
      end
      4'b0101: begin // OR (R-type and I-type)
        o_alu_data = i_operand_a | i_operand_b;
      end
      4'b0110: begin // AND (R-type and I-type)
        o_alu_data = i_operand_a & i_operand_b;
      end

      // Shift Left Logical (SLL, R-type and I-type)
      4'b0111: begin
        shifted_data = i_operand_a;
        shift_amount = i_operand_b[4:0];  // Use lower 5 bits of i_operand_b for shift amount

        // Logical left shift
        if (shift_amount[0]) shifted_data = {shifted_data[30:0], 1'b0};   // Shift by 1 bit
        if (shift_amount[1]) shifted_data = {shifted_data[29:0], 2'b0};   // Shift by 2 bits
        if (shift_amount[2]) shifted_data = {shifted_data[27:0], 4'b0};   // Shift by 4 bits
        if (shift_amount[3]) shifted_data = {shifted_data[23:0], 8'b0};   // Shift by 8 bits
        if (shift_amount[4]) shifted_data = {shifted_data[15:0], 16'b0};  // Shift by 16 bits

        o_alu_data = shifted_data;
      end

      // Shift Right Logical (SRL, R-type and I-type)
      4'b1000: begin
        shifted_data = i_operand_a;
        shift_amount = i_operand_b[4:0];  // Use lower 5 bits of i_operand_b for shift amount

        // Logical right shift
        if (shift_amount[0]) shifted_data = {1'b0, shifted_data[31:1]};   // Shift by 1 bit
        if (shift_amount[1]) shifted_data = {2'b0, shifted_data[31:2]};   // Shift by 2 bits
        if (shift_amount[2]) shifted_data = {4'b0, shifted_data[31:4]};   // Shift by 4 bits
        if (shift_amount[3]) shifted_data = {8'b0, shifted_data[31:8]};   // Shift by 8 bits
        if (shift_amount[4]) shifted_data = {16'b0, shifted_data[31:16]}; // Shift by 16 bits

        o_alu_data = shifted_data;
      end

      // Shift Right Arithmetic (SRA, R-type and I-type)
      4'b1001: begin
        shifted_data = i_operand_a;
        shift_amount = i_operand_b[4:0];  // Use lower 5 bits of i_operand_b for shift amount

        // Arithmetic right shift
        if (shift_amount[0]) shifted_data = {sign_bit, shifted_data[31:1]};   // Shift by 1 bit
        if (shift_amount[1]) shifted_data = {{2{sign_bit}}, shifted_data[31:2]};   // Shift by 2 bits
        if (shift_amount[2]) shifted_data = {{4{sign_bit}}, shifted_data[31:4]};   // Shift by 4 bits
        if (shift_amount[3]) shifted_data = {{8{sign_bit}}, shifted_data[31:8]};   // Shift by 8 bits
        if (shift_amount[4]) shifted_data = {{16{sign_bit}}, shifted_data[31:16]}; // Shift by 16 bits

        o_alu_data = shifted_data;
      end

      4'b1111: begin
        o_alu_data = i_operand_b;
      end
      default: begin // Default case
        o_alu_data = 32'b0;
      end
    endcase
  end
endmodule
