module pc_adder (
  input logic pc,
  output logic pcp
)

assign pcp = pc + 4;

endmodule: pc_adder