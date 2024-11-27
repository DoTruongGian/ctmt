module pc_debug (
  input logic i_clk,
  input logic i_rst_n,
  input logic [31:0] pc,
  output logic [31:0] o_pc_debug
);

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_pc_debug <= 32'b0;
    end else begin
      o_pc_debug <= pc;
    end
  end

endmodule