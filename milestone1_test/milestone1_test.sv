// Module definition for the vending machine
module milestone1_test(
  input logic clk_i,         // Clock input signal
  input logic rst_i,         // Active-low reset input signal
  input logic dime_i,        // Input signal for a dime coin (10 cents)
  input logic nickle_i,      // Input signal for a nickel coin (5 cents)
  input logic quarter_i,     // Input signal for a quarter coin (25 cents)
  output logic soda_o,       // Output signal indicating if soda is dispensed
  output logic [2:0] change_o // Output signal representing change to be given
                               // 000 = 0 cents, 001 = 5 cents, 010 = 10 cents, 011 = 15 cents, 100 = 20 cents
);

// State definitions for the vending machine
parameter s0 = 2'b00; // State 0: 0 cents
parameter s1 = 2'b01; // State 1: 5 cents
parameter s2 = 2'b10; // State 2: 10 cents
parameter s3 = 2'b11; // State 3: 15 cents

logic [1:0] c_state, n_state; // Current state and next state registers
logic c_soda_o;
logic [2:0] c_change_o;
// Sequential block for state transition
always_ff @(posedge clk_i or negedge rst_i) begin
  if (!rst_i) begin
    // Reset the state to s0
    c_state <= s0;
  end else begin
    // Update the current state to the next state
    c_state <= n_state;
	 soda_o <= c_soda_o;
	 change_o <= c_change_o;
  end
end

// Combinational block for state transition logic
always_comb begin
  case (c_state)
    s0: begin
      if (nickle_i) begin
        n_state = s1; // Transition to state 1 if nickel is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end else if (dime_i) begin
        n_state = s2; // Transition to state 2 if dime is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end else if (quarter_i) begin
        n_state = s0; // Remain in state 0 if quarter is inserted (unexpected case)
		  c_change_o = 3'b001; // Change = 5 cents
		  c_soda_o = 1'b1;    // Soda dispensed
      end else begin
        n_state = s0; // Remain in state 0 if no coin is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end
    end
    s1: begin
      if (nickle_i) begin
        n_state = s2; // Transition to state 2 if nickel is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end else if (dime_i) begin
        n_state = s3; // Transition to state 3 if dime is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end else if (quarter_i) begin
        n_state = s0; // Return to state 0 if quarter is inserted (unexpected case)
		  c_change_o = 3'b010; // Change = 10 cents
		  c_soda_o = 1'b1;    // Soda dispensed
      end else begin
        n_state = s1; // Remain in state 1 if no coin is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end
    end
    s2: begin
      if (nickle_i) begin
        n_state = s3; // Transition to state 3 if nickel is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // Soda dispensed
      end else if (dime_i) begin
        n_state = s0; // Return to state 0 if dime is inserted (unexpected case)
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b1;    // Soda dispensed
      end else if (quarter_i) begin
        n_state = s0; // Return to state 0 if quarter is inserted (unexpected case)
		  c_change_o = 3'b011; // Change = 15 cents
		  c_soda_o = 1'b1;    // Soda dispensed
      end else begin
        n_state = s2; // Remain in state 2 if no coin is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end
    end
    s3: begin
      if (nickle_i) begin
        n_state = s0; // Return to state 0 if nickel is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b1;    // Soda dispensed
      end else if (dime_i) begin
        n_state = s0; // Return to state 0 if dime is inserted
		  c_change_o = 3'b001; // Change = 5 cents
		  c_soda_o = 1'b1;    // Soda dispensed
      end else if (quarter_i) begin
        n_state = s0; // Return to state 0 if quarter is inserted
		  c_change_o = 3'b100; // Change = 20 cents
		  c_soda_o = 1'b1;    // Soda dispensed
      end else begin
        n_state = s3; // Remain in state 3 if no coin is inserted
		  c_change_o = 3'b000; // No change
		  c_soda_o = 1'b0;    // No soda
      end
    end
  endcase
end

endmodule: milestone1_test
