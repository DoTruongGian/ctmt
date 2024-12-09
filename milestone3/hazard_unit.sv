module hazard_unit (
    input logic [31:0] instr_D,
    input logic [31:0] instr_E,
    input logic [31:0] instr_M,
    input logic [31:0] instr_W,
    input logic [1:0] wb_sel_E,
    input logic rd_wren_D,
    input logic rd_wren_E,
    input logic rd_wren_M,
    input logic rd_wren_W,
	input logic pc_sel_E,
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
    output logic [1:0] ForwardBE,
    output logic ldStall_check
);
logic [4:0] rs1_addr_D, rs2_addr_D, rs1_addr_E, rs2_addr_E, rd_addr_E, rd_addr_M, rd_addr_W;
logic ldStall, brFlush;
assign ldStall_check = ldStall;
assign rs1_addr_D = instr_D [19:15];
assign rs2_addr_D = instr_D [24:20];
assign rs1_addr_E = instr_E [19:15];
assign rs2_addr_E = instr_E [24:20];
assign rd_addr_E = instr_E [11:7];
assign rd_addr_M = instr_M [11:7];
assign rd_addr_W = instr_W [11:7];
always_comb begin

    if  (((rs1_addr_E == rd_addr_M) && rd_wren_M) && (rs1_addr_E != 0)) begin
        ForwardAE = 2'b10;
    end else if (((rs1_addr_E == rd_addr_W) && rd_wren_W) && (rs1_addr_E != 0)) begin
        ForwardAE = 2'b01;
    end else begin
		ForwardAE = 2'b00;
	end

    if (((rs2_addr_E == rd_addr_M) && rd_wren_M) && (rs2_addr_E != 0))begin
        ForwardBE = 2'b10;
    end else if   (((rs2_addr_E == rd_addr_W) && rd_wren_W) && (rs2_addr_E != 0)) begin
        ForwardBE = 2'b01;
    end else begin
	    ForwardBE = 2'b00;
	end
    brFlush = ((instr_E[6:0] == 7'b1100011) & (pc_sel_E));
    ldStall = ((instr_E[6:0] == 7'b0000011) & ((rs1_addr_D == rd_addr_E) | (rs2_addr_D == rd_addr_E)));    
    StallD = ldStall;
    StallF = ldStall;
    FlushD = brFlush;
    FlushE = ldStall | brFlush;
end
endmodule