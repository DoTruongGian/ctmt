module hazard_unit (
    input logic [31:0] instr_D,
    input logic [31:0] instr_E,
    input logic [31:0] instr_M,
    input logic [31:0] instr_W,
    input logic rd_wren_D,
    input logic rd_wren_E,
    input logic rd_wren_M,
    input logic rd_wren_W,
    output logic StallF,
    output logic StallD,
    output logic FlushD,
    output logic StallE,
    output logic FlushE,
    output logic StallM,
    output logic FlushM,
    output logic StallW,
    output logic FlushW,
    output logic [1:0] ForwardAE,
    output logic [1:0] ForwardBE
);
logic [4:0] rs1_addr_D, rs2_addr_D, rs1_addr_E, rs2_addr_E, rd_addr_E, rd_addr_M, rd_addr_W;
assign rs1_addr_D = instr_D [19:15];
assign rs2_addr_D = instr_D [24:20];
assign rs1_addr_E = instr_E [19:15];
assign rs2_addr_E = instr_E [24:20];
assign rd_addr_E = instr_E [11:7];
assign rd_addr_M = instr_M [11:7];
assign rd_addr_W = instr_W [11:7];
always_comb begin
    StallF = 1'b0;
    StallD = 1'b0;
    FlushD = 1'b0; 
    StallE = 1'b0;
    FlushE = 1'b0; 
    StallM = 1'b0;
    FlushM = 1'b0; 
    StallW = 1'b0;
    FlushW = 1'b0;  
    ForwardAE = 2'b00;
    ForwardBE = 2'b00;
    if (((rs1_addr_E == rd_addr_W) && rd_wren_W) && (rs1_addr_E != 0)) begin
        ForwardAE = 2'b01;
    end else if (((rs1_addr_E == rd_addr_M) && rd_wren_M) && (rs1_addr_E != 0)) begin
        ForwardAE = 2'b10;
    end
    if (((rs2_addr_E == rd_addr_W) && rd_wren_W) && (rs2_addr_E != 0)) begin
        ForwardBE = 2'b01;
    end else if (((rs2_addr_E == rd_addr_M) && rd_wren_M) && (rs2_addr_E != 0)) begin
        ForwardBE = 2'b10;
    end
end
endmodule