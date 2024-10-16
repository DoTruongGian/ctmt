module brc (
  input logic [31:0] i_rs1_data,   // Data from the first register
  input logic [31:0] i_rs2_data,   // Data from the second register
  input logic i_br_un,             // Comparison mode: 1 if signed, 0 if unsigned
  output logic o_br_less,          // Output is 1 if rs1 < rs2
  output logic o_br_equal          // Output is 1 if rs1 == rs2
);

  logic [31:0] eq_bits;            // Bits indicating equality for each bit position
  logic [32:0] sub_result;         // Subtraction result for comparison

  // Generate equality bits: eq_bits[i] is true if i_rs1_data[i] == i_rs2_data[i]
  assign eq_bits = ~(i_rs1_data ^ i_rs2_data);
  
  // o_br_equal is true if all bits are equal (AND reduction of eq_bits)
  assign o_br_equal = &eq_bits;

  // Combinational logic to determine less-than condition
  always_comb begin
    // Perform subtraction using two's complement
    sub_result = {1'b0, i_rs1_data} + {1'b0, (~i_rs2_data + 1)};

    if (i_br_un) begin
      // Unsigned comparison: check the carry out (sub_result[32] == 0)
      o_br_less = !sub_result[32];
    end else begin
      // Signed comparison: check the sign bit of the operands or the result
      o_br_less = (i_rs1_data[31] ^ i_rs2_data[31]) ? i_rs1_data[31] : sub_result[31];
    end
  end
endmodule
