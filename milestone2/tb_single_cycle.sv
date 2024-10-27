module tb_single_cycle;

  // Clock and reset signals
  logic clk;
  logic rst_n;

  // Testbench outputs to monitor the DUT
  logic [31:0] pc_debug;
  logic insn_vld;
  logic [31:0] io_ledr;
  logic [31:0] io_ledg;
  logic [6:0] io_hex0;
  logic [6:0] io_hex1;
  logic [6:0] io_hex2;
  logic [6:0] io_hex3;
  logic [6:0] io_hex4;
  logic [6:0] io_hex5;
  logic [6:0] io_hex6;
  logic [6:0] io_hex7;
  logic [31:0] io_lcd;
  logic [31:0] checker4;
  logic [31:0] checker5;
  logic [31:0] checker6;
  logic [31:0] checker7;
  logic [31:0] checker8;

  // Inputs to the DUT
  logic [31:0] io_sw;
  logic [3:0] io_btn;

  // Instantiate the DUT (Device Under Test)
  single_cycle dut (
    .i_clk(clk),
    .i_rst_n(rst_n),
    .o_pc_debug(pc_debug),
    .o_insn_vld(insn_vld),
    .o_io_ledr(io_ledr),
    .o_io_ledg(io_ledg),
    .o_io_hex0(io_hex0),
    .o_io_hex1(io_hex1),
    .o_io_hex2(io_hex2),
    .o_io_hex3(io_hex3),
    .o_io_hex4(io_hex4),
    .o_io_hex5(io_hex5),
    .o_io_hex6(io_hex6),
    .o_io_hex7(io_hex7),
    .o_io_lcd(io_lcd),
    .i_io_sw(io_sw),
    .i_io_btn(io_btn),
    .checker4(checker4),
    .checker5(checker5),
    .checker6(checker6),
    .checker7(checker7),
    .checker8(checker8)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // Clock period is 10 units
  end

  // Reset and stimulus
  initial begin
    // Initialize signals
    rst_n = 0;
    io_sw = 32'h0;
    io_btn = 4'b0000;

    // Apply reset for 20 time units
    #10 rst_n = 1;

    // Test different switch and button inputs
    #20 io_sw = 32'hF0F0F0F0;  // Set switches to a test value
    #20 io_btn = 4'b1010;       // Set buttons to a test value

    // Observe the DUT behavior over time
    #1000;

    // End the simulation
    $finish;
  end

  // Monitor key outputs
  initial begin
    $monitor("Time: %0t, PC Debug: %h, LEDR: %h, LEDG: %h, Hex0: %h, Hex1: %h, LCD: %h",
              $time, pc_debug, io_ledr, io_ledg, io_hex0, io_hex1, io_lcd);
  end

endmodule
