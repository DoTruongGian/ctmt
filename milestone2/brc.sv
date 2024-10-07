module brc (
  input logic [31:0] rs1_data,
  input logic [31:0] rs2_data,
  input logic br_unsigned,
  output logic br_less,
  output logic br_equal
);

  logic [31:0] eq_bits;
  logic [31:0] les_bits;

  // Instantiate 32 1-bit comparators
  genvar i;
  generate
    for (i = 0; i < 32; i++) begin
      br_1bit br_cmp(
        .a(rs1_data[i]),
        .b(rs2_data[i]),
        .eq(eq_bits[i]),
        .les(les_bits[i])
      );
    end
  endgenerate

  // Check for equality: all eq_bits must be true
  assign br_equal = &eq_bits;  // AND all equality bits together

  // Compute less-than comparison for unsigned mode by OR-ing les_bits
  assign br_less = br_unsigned ? (|les_bits) : (rs1_data[31] ^ rs2_data[31]) ? rs1_data[31] : (|les_bits);

endmodule: brc