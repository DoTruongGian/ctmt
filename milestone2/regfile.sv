module regfile (
  input logic clk_i,             // Positive clock
  input logic rst_ni,            // Active-low reset
  input logic [4:0] rs1_addr,    // Read address for rs1
  input logic [4:0] rs2_addr,    // Read address for rs2
  input logic [4:0] rd_addr,     // Write address for rd
  input logic [31:0] rd_data,    // Write data for rd
  input logic rd_wren,           // Write enable for rd
  output logic [31:0] rs1_data,  // Output data for rs1
  output logic [31:0] rs2_data    // Output data for rs2
);

  // 32 32-bit registers, with register 0 hard-wired to 0
  logic [31:0] regfile [0:31];

  // Asynchronous read logic
  assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regfile[rs1_addr];
  assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regfile[rs2_addr];

  // Synchronous write logic
  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Reset all registers to 0, register 0 stays 0 by design
      for (int i = 0; i < 32; i++) begin
        regfile[i] <= 32'b0;
      end
    end else if (rd_wren && (rd_addr != 5'b0)) begin
      // Write to the register if write enable is set and rd_addr is not 0
      regfile[rd_addr] <= rd_data;
    end
  end

endmodule
