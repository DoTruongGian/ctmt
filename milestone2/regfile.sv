module regfile (
  input logic i_clk,              // Global clock
  input logic i_rst_n,              // Global active reset
  input logic [4:0] i_rs1_addr,   // Address of the first source register
  input logic [4:0] i_rs2_addr,   // Address of the second source register
  input logic [4:0] i_rd_addr,    // Address of the destination register
  input logic [31:0] i_rd_data,   // Data to write to the destination register
  input logic i_rd_wren,          // Write enable for the destination register
  output logic [31:0] o_rs1_data, // Data from the first source register
  output logic [31:0] o_rs2_data, // Data from the second source register
  output logic [31:0] checker1,    // Checker to verify register content
  output logic [31:0] checker2,
  output logic [31:0] checker3,
  output logic [31:0] checker4,
  output logic [31:0] checker5,
  output logic [31:0] checker6
);

  // 32 32-bit registers, with register 0 hard-wired to 0
  logic [31:0] regfile [31:0];

  // Asynchronous read logic
  assign o_rs1_data = (i_rs1_addr == 5'b0) ? 32'b0 : regfile[i_rs1_addr];
  assign o_rs2_data = (i_rs2_addr == 5'b0) ? 32'b0 : regfile[i_rs2_addr];
  assign checker1 = regfile[1]; // Checker to monitor register 1
  assign checker2 = regfile[2]; // Checker to monitor register 2
  assign checker3 = regfile[3]; // Checker to monitor register 3
  assign checker4 = regfile[4]; // Checker to monitor register 4
  assign checker5 = regfile[5]; // Checker to monitor register 5
  assign checker6 = regfile[6]; // Checker to monitor register 6

  // Synchronous write logic
  always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
      // Reset all registers to 0, register 0 stays 0 by design     
      regfile[0] <= 32'b0;
		regfile[1] <= 32'b0;
		regfile[2] <= 32'b0;
		regfile[3] <= 32'b0;
		regfile[4] <= 32'b0;
		regfile[5] <= 32'b0;
		regfile[6] <= 32'b0;
		regfile[7] <= 32'b0;
		regfile[8] <= 32'b0;
		regfile[9] <= 32'b0;
		regfile[10] <= 32'b0;
		regfile[11] <= 32'b0;
		regfile[12] <= 32'b0;
		regfile[13] <= 32'b0;
		regfile[14] <= 32'b0;
		regfile[15] <= 32'b0;
		regfile[16] <= 32'b0;
		regfile[17] <= 32'b0;
		regfile[18] <= 32'b0;
		regfile[19] <= 32'b0;
		regfile[20] <= 32'b0;
		regfile[21] <= 32'b0;
		regfile[22] <= 32'b0;
		regfile[23] <= 32'b0;
		regfile[24] <= 32'b0;
		regfile[25] <= 32'b0;
		regfile[26] <= 32'b0;
		regfile[27] <= 32'b0;
		regfile[28] <= 32'b0;
		regfile[29] <= 32'b0;
		regfile[30] <= 32'b0;
		regfile[31] <= 32'b0;
    end else if (i_rd_wren && (i_rd_addr != 5'b0)) begin
      // Write to the register if write enable is set and rd_addr is not 0
      regfile[i_rd_addr] <= i_rd_data;
    end
  end

endmodule
