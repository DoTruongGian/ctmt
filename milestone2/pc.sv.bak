module pc (
  input logic i_clk,
  input logic i_rst_n, en,
  input logic [31:0] PC_i,
  output logic [31:0] PC_o
);
  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      PC_o <= 0;
    end
    else if (en) begin
      PC_o <= PC_i;
    end
  end

endmodule