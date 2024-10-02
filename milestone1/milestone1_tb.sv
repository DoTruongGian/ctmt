module milestone1_tb;

  // Testbench signals
  logic i_clk;             // Clock signal
  logic i_dime;            // Input signal for dime coin (10 cents)
  logic i_nickel;          // Input signal for nickel coin (5 cents)
  logic i_quarter;         // Input signal for quarter coin (25 cents)
  logic o_soda;            // Output signal indicating if soda is dispensed
  logic [2:0] o_change;    // Output signal representing change to be given

  // Instantiate the DUT (Design Under Test)
  milestone1 dut (
    .i_clk(i_clk),
    .i_dime(i_dime),
    .i_nickel(i_nickel),
    .i_quarter(i_quarter),
    .o_soda(o_soda),
    .o_change(o_change)
  );

  // Clock generation
  initial begin
    i_clk = 0;
    forever #30 i_clk = ~i_clk; // Generate clock with a period of 60 time units
  end

  // Testbench stimuli
  initial begin
    // Initialize inputs
    i_dime = 0;
    i_nickel = 0;
    i_quarter = 0;

    // Apply stimulus
    #100 i_dime = 1; // Insert dime
    #60 i_dime = 0; i_quarter = 1; // Insert quarter
    #60 i_quarter = 0;   
    #120 i_nickel = 1; // Insert nickel
    #60 i_nickel = 0; i_dime = 1; // Insert dime again
    #60 i_dime = 0; i_quarter = 1; // Insert quarter again
    #60 i_quarter = 0;

    #1000 $stop; // Stop simulation
  end
endmodule // milestone1_tb