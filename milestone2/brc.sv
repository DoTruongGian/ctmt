module brc (
  input logic [31:0] rs1_data,   // First input data (A)
  input logic [31:0] rs2_data,   // Second input data (B)
  input logic br_unsigned,        // Flag to indicate if comparison is unsigned
  output logic br_less,          // Output: true if rs1_data < rs2_data
  output logic br_equal          // Output: true if rs1_data == rs2_data
);

  logic [31:0] eq_bits;          // Bits indicating equality for each bit position
  logic [31:0] les_bits;         // Bits indicating less-than condition for each bit position
  logic sign_a;                  // Sign bit of rs1_data (A)
  logic sign_b;                  // Sign bit of rs2_data (B)

  // Generate equality bits: eq_bits[i] is true if rs1_data[i] == rs2_data[i]
  assign eq_bits = ~(rs1_data ^ rs2_data); 
  // br_equal is true if all bits are equal (AND reduction of eq_bits)
  assign br_equal = &eq_bits;  

  // Extract the sign bits for both inputs
  assign sign_a = rs1_data[31]; // Most significant bit of rs1_data
  assign sign_b = rs2_data[31]; // Most significant bit of rs2_data

  // Combinational logic to determine less-than condition
  always_comb begin
    br_less = 1'b0; // Default: Assume rs1_data is not less than rs2_data
    if (br_unsigned) begin
      // For unsigned comparison: check les_bits
      for (int i = 31; i >= 0; i--) begin
        les_bits[i] = ~rs1_data[i] & rs2_data[i]; // less if rs1_data[i] is 0 and rs2_data[i] is 1
        if (les_bits[i]) begin
          br_less = 1'b1; // If any bit indicates less-than, set br_less to true
          break; // Exit loop early if less-than condition is met
        end
      end
    end else begin
      // For signed comparison
      if (sign_a != sign_b) begin
        br_less = sign_a; // If sign bits differ, result is based on the sign of A
      end else begin
        // Both numbers have the same sign; check les_bits for the remaining bits
        for (int i = 30; i >= 0; i--) begin
          les_bits[i] = ~rs1_data[i] & rs2_data[i];
          if (les_bits[i]) begin
            br_less = 1'b1; // If any bit indicates less-than, set br_less to true
            break; // Exit loop early if less-than condition is met
          end
        end
      end
    end
  end
endmodule
