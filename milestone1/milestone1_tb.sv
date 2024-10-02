module milestone1_tb;

  // Testbench signals
  logic i_clk;
  logic i_dime;
  logic i_nickel;
  logic i_quarter;
  logic o_soda;
  logic [2:0] o_change;

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
    forever #30 i_clk = ~i_clk; // Generate clock with a period of 10 time units
  end

  // Testbench stimuli
  initial begin
    // Initialize inputs
    i_dime = 0;
    i_nickel = 0;
    i_quarter = 0;
        
    // Apply stimulus
    #100 i_dime = 1; // Insert dime
    #60 i_dime = 0; i_quarter = 1;
    #60 i_quarter = 0;   
    #120 i_nickel = 1;
    #60 i_nickel = 0; i_dime = 1;
    #60 i_dime = 0; i_quarter = 1;
    #60 i_quarter = 0;

    #1000 $stop; // Stop simulation
  end
endmodule: milestone1_tb