module brcomp (
  input logic [31:0] rs1_data,
  input logic [31:0] rs2_data,
  input logic br_unsigned,
  output logic br_less,
  output logic br_equal
)

logic [32:0] sub_result;

always_comb begin
  sub_result = {1'b0,rs1_data} + {1'b0,(~rs2_data + 1)};
  
  case(br_unsigned)
    1'b0: begin
      br_less = (rs1_data[31] ^ rs2_data[31]) ? rs1_data[31] : sub_result[31];
      br_equal = 
    end
    1'b1: begin
      br_less = !sub_result[32];
      br_equal = 
    end
  endcase
end

endmodule: brcomp