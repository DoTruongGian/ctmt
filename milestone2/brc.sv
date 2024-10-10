module brc (
  input logic [31:0] rs1_data,   // First input data (A)
  input logic [31:0] rs2_data,   // Second input data (B)
  input logic br_unsigned,        // Flag to indicate if comparison is unsigned
  output logic br_less,          // Output: true if rs1_data < rs2_data
  output logic br_equal          // Output: true if rs1_data == rs2_data
);

  logic [31:0] eq_bits;          // Bits indicating equality for each bit position
  logic [31:0] les_bits;         // Bits indicating less-than condition for each bit position
  logic [32:0] sub_result;

  // Generate equality bits: eq_bits[i] is true if rs1_data[i] == rs2_data[i]
  assign eq_bits = ~(rs1_data ^ rs2_data); 
  // br_equal is true if all bits are equal (AND reduction of eq_bits)
  assign br_equal = &eq_bits;  

  // Combinational logic to determine less-than condition
  always_comb begin
    // Perform subtraction using two's complement
    sub_result = {1'b0, rs1_data} + {1'b0, (~rs2_data + 1)};

    if (br_unsigned) begin
      br_less = !sub_result[32];
    end else begin
      br_less = (rs1_data[31] ^ rs2_data[31]) ? rs1_data[31] : sub_result[31];
    end
  end
endmodule