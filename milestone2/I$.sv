module I$ (
  input logic [31:0] PC,
  output logic [31:0] instr
);
  logc [31:0] instructions_value [255:0];

  initial begin
    $readmemh("instruction.txt", instructions_value);
  end

  always_comb begin
    instr = instructions_value[PC[31:2]];
  end
endmodule