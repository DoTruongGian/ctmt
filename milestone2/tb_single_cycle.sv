module single_cycle_tb;

// Inputs
logic i_clk;
logic i_rst_n;
logic [31:0] i_io_sw;
logic [3:0] i_io_btn;

// Outputs
logic [31:0] o_pc_debug;
logic o_insn_vld;
logic [31:0] o_io_ledr;
logic [31:0] o_io_ledg;
logic [6:0] o_io_hex0;
logic [6:0] o_io_hex1;
logic [6:0] o_io_hex2;
logic [6:0] o_io_hex3;
logic [6:0] o_io_hex4;
logic [6:0] o_io_hex5;
logic [6:0] o_io_hex6;
logic [6:0] o_io_hex7;
logic [31:0] o_io_lcd;

// Clock generation
always #5 i_clk = ~i_clk;

// Instantiate the DUT (Device Under Test)
single_cycle uut (
  .i_clk(i_clk),
  .i_rst_n(i_rst_n),
  .o_pc_debug(o_pc_debug),
  .o_insn_vld(o_insn_vld),
  .o_io_ledr(o_io_ledr),
  .o_io_ledg(o_io_ledg),
  .o_io_hex0(o_io_hex0),
  .o_io_hex1(o_io_hex1),
  .o_io_hex2(o_io_hex2),
  .o_io_hex3(o_io_hex3),
  .o_io_hex4(o_io_hex4),
  .o_io_hex5(o_io_hex5),
  .o_io_hex6(o_io_hex6),
  .o_io_hex7(o_io_hex7),
  .o_io_lcd(o_io_lcd),
  .i_io_sw(i_io_sw),
  .i_io_btn(i_io_btn)
);

initial begin
  // Initialize Inputs
  i_clk = 0;
  i_rst_n = 0;
  i_io_sw = 32'h0;
  i_io_btn = 4'h0;
  
  // Apply reset
  #10 i_rst_n = 1;

  // Load instructions from instructionset.txt file
  $readmemb("instructionset.txt", uut.i$.memory);  // Assuming instruction memory is in I$ module and accessible as 'memory'

  // Run the simulation for a specified time
  #2000;
  $finish;
end

initial begin
  $dumpfile("single_cycle_tb.vcd");  // For waveform generation
  $dumpvars(0, single_cycle_tb);
end

endmodule
