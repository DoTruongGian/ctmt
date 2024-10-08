module pc_debug (
  input logic clk_i,
  input logic rst_ni,
  input logic [31:0] pc,
  output logic [31:0] o_pc_debug
);

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      o_pc_debug <= 32'b0;
    end else begin
      o_pc_debug <= pc;
    end
  end

endmodule