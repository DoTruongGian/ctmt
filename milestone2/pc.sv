module pc (
  input logic clk_i,
  input logic rst_ni,
  input logic [31:0] PC_i,
  output logic [31:0] PC_o
);

  always_ff @(posedge clk_i or negedge rst_i) begin
    if (!rst_ni) begin
      PC_o <= 0;
    end
    else begin
      PC_o <= PC_i;
    end
  end

endmodule