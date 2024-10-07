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
    for (i = 0; i < 32; i++) begin : br_cmp
      br_1bit br_cmp_inst(
        .a(rs1_data[i]),
        .b(rs2_data[i]),
        .eq(eq_bits[i]),
        .les(les_bits[i])
      );
    end
  endgenerate

  // Check for equality: all eq_bits must be true
  assign br_equal = &eq_bits;  // AND all equality bits together

  // Compute less-than comparison based on unsigned/signed mode
  always_comb begin
    br_less = 1'b0;
    if (br_unsigned) begin
      for (int i = 31; i >= 0; i--) begin  // Corrected loop condition
        if (les_bits[i]) begin
          br_less = 1'b1;
          break;
        end
      end
    end else begin
      if (rs1_data[31] ^ rs2_data[31]) begin
        br_less = rs1_data[31];  // Set to 1 if rs1_data is negative
      end else begin
        for (int i = 30; i >= 0; i--) begin  // Corrected loop condition
          if (les_bits[i]) begin
            br_less = 1'b1;
            break;
          end
        end
      end
    end
  end
endmodule
