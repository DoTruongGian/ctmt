module milestone1_test_tb;

  // Testbench signals
  logic clk_i;
  logic rst_i;
  logic dime_i;
  logic nickle_i;
  logic quarter_i;
  logic soda_o;
  logic [2:0] change_o;

  // Instantiate the DUT (Design Under Test)
  milestone1_test dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .dime_i(dime_i),
    .nickle_i(nickle_i),
    .quarter_i(quarter_i),
    .soda_o(soda_o),
    .change_o(change_o)
  );

  // Clock generation
  initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i; // Generate clock with a period of 10 time units
  end

  // Testbench stimuli
  initial begin
    // Initialize inputs
    rst_i = 0;
    dime_i = 0;
    nickle_i = 0;
    quarter_i = 0;
    
    // Reset the design
    #10 rst_i = 1;
    
    // Apply stimulus
    #10 dime_i = 1; // Insert dime
    #10 dime_i = 0;
    
    #20 nickle_i = 1; // Insert nickle
    #10 nickle_i = 0;
    
    #30 quarter_i = 1; // Insert quarter
    #10 quarter_i = 0;

    #100 $stop; // Stop simulation
  end
endmodule: milestone1_test_tb
