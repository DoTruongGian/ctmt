module brc (
    input logic [31:0] rs1_data,   // Input A
    input logic [31:0] rs2_data,   // Input B
    input logic br_unsigned,        // Unsigned flag
    output logic br_less,          // Less than output
    output logic br_equal          // Equality output
);

    logic [31:0] eq_bits;          // Equality bits
    logic [31:0] les_bits;         // Less-than bits
    logic sign_a;                  // Sign bit of A
    logic sign_b;                  // Sign bit of B

    // Generate equality bits using NOT, AND gates
    assign eq_bits = ~(rs1_data ^ rs2_data); // eq_bits[i] = NOT(rs1_data[i] XOR rs2_data[i])

    // Check for equality: all eq_bits must be true
    assign br_equal = &eq_bits;  // AND all equality bits together

    // Calculate sign bits
    assign sign_a = rs1_data[31]; // Sign bit of A
    assign sign_b = rs2_data[31]; // Sign bit of B

    // Compute less-than comparison
    always_comb begin
        br_less = 1'b0; // Default to false
        if (br_unsigned) begin
            // For unsigned comparison, check les_bits using AND gates
            for (int i = 31; i >= 0; i--) begin
                les_bits[i] = ~rs1_data[i] & rs2_data[i]; // les_bits[i] = NOT(rs1_data[i]) AND rs2_data[i]
                if (les_bits[i]) begin
                    br_less = 1'b1; // If any les_bits is true, set br_less to true
                    break;
                end
            end
        end else begin
            // For signed comparison
            if (sign_a != sign_b) begin
                br_less = sign_a; // If sign bits differ, return true if rs1_data is negative
            end else begin
                // Both numbers have the same sign; use les_bits
                for (int i = 30; i >= 0; i--) begin
                    les_bits[i] = ~rs1_data[i] & rs2_data[i]; // les_bits[i] = NOT(rs1_data[i]) AND rs2_data[i]
                    if (les_bits[i]) begin
                        br_less = 1'b1; // If any les_bits is true, set br_less to true
                        break;
                    end
                end
            end
        end
    end
endmodule
