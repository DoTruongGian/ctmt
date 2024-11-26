module pc_adder (
  input logic [31:0] pc,
  output logic [31:0] pcp
);

  assign pcp = pc + 4;

endmodule