module convertseg7 (
  input logic [31:0]ld_data,
  input logic [31:0]i_lsu_addr ,
  output logic [31:0]o_ld_data
);

always_comb begin
  if (i_lsu_addr[31:4] == 32'h0702) begin
		case (ld_data[6:0])
		7'b1000000: o_ld_data = 0; // 0
      7'b1111001: o_ld_data = 1; // 1
      7'b0100100: o_ld_data = 2; // 2
      7'b0110000: o_ld_data = 3; // 3
      7'b0011001: o_ld_data = 4; // 4
      7'b0010010: o_ld_data = 5; // 5
      7'b0000010: o_ld_data = 6; // 6
      7'b1111000: o_ld_data = 7; // 7
      7'b0000000: o_ld_data = 8; // 8
      7'b0010000: o_ld_data = 9; // 9
      7'b0001000: o_ld_data = 10; // A
      7'b0000011: o_ld_data = 11; // B
      7'b1000110: o_ld_data = 12; // C
      7'b0100001: o_ld_data = 13; // D
      7'b0000110: o_ld_data = 14; // E
      7'b0001110: o_ld_data = 15; // F
      default: o_ld_data = 0; // Blank display if input is invalid
		endcase
  end
  else 
      o_ld_data = ld_data;
end
endmodule
