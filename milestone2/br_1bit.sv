module br_1bit (
  input logic a,
  input logic b,
  output logic eq,
  output logic les
)

assign eq = ~(a ^ b);
assign les = ~a & b;

endmodule: br_1bit