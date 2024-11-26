module insn_vld (
  input logic i_clk,
  input logic i_rst_n,
  input logic insn_vld,
  output logic o_insn_vld
);

  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      o_insn_vld <= 1'b0;
    end else begin
      o_insn_vld <= insn_vld;
    end
  end

endmodule