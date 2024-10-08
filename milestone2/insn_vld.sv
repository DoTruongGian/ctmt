module insn_vld (
  input logic clk_i,
  input logic rst_ni,
  input logic insn_vld,
  output logic o_insn_vld
);

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      o_insn_vld <= 1'b0;
    end else begin
      o_insn_vld <= insn_vld;
    end
  end

endmodule