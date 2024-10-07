module ImmGen (
  input logic [31:0] instr,
  output logic [31:0] imm
);

  always_comb begin
    case (instr[6:0])
      7'b0010011, 7'b0000011, 7'b1100111:
        imm = {{20{instr[31]}}, instr[31:20]}; // Sign-extend bits [31:20]
      7'b0100011:
        imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // Sign-extend S-type
      7'b1100011:
        imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // Sign-extend B-type
      7'b0110111, 7'b0010111:
        imm = {instr[31:12], 12'b0}; // Zero-extend U-type
      7'b1101111:
        imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0}; // Sign-extend J-type
      default:
        imm = 32'b0;
    endcase
  end

endmodule