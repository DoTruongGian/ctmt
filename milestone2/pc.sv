module pc (
  input logic clk_i,
  input logic rst_ni,
  input logic [31:0] PC_i,
  output logic [31:0] PC_o
);

always_ff @(posedge clk_i or negedge rst_i) begin
  PC_o <= PC_i;
end

endmodule: pc