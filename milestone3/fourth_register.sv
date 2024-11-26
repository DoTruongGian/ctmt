module fourth_register (
    input logic i_clk,
    input logic i_rst_n,
    input logic StallW,
    input logic FlushW,
    input logic [31:0] instrM,
    input logic [31:0] alu_dataM,
    input logic [31:0] ld_dataM,
    input logic [4:0] rd_addrM,
    input logic [31:0] PCPlus4M,
    input logic rd_wrenM,
    input logic [1:0] wb_selM,
    output logic [31:0] instrW,
    output logic [31:0] alu_dataW,
    output logic [31:0] ld_dataW,
    output logic [4:0] rd_addrW,
    output logic [31:0] PCPlus4W,
    output logic rd_wrenW,
    output logic [1:0] wb_selW
);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            instrW <= 32'd0;
            alu_dataW <= 32'd0;
            ld_dataW <= 32'd0;
            rd_addrW <= 5'd0;
            PCPlus4W <= 32'd0;
            rd_wrenW <= 1'b0;
            wb_selW <= 2'd0;
        end else if (StallW) begin
            // Retain values during stall
        end else if (FlushW) begin
            instrW <= 32'd0;
            alu_dataW <= 32'd0;
            ld_dataW <= 32'd0;
            rd_addrW <= 5'd0;
            PCPlus4W <= 32'd0;
            rd_wrenW <= 1'b0;
            wb_selW <= 2'd0;
        end else begin
            instrW <= instrM;
            alu_dataW <= alu_dataM;
            ld_dataW <= ld_dataM;
            rd_addrW <= rd_addrM;
            PCPlus4W <= PCPlus4M;
            rd_wrenW <= rd_wrenM;
            wb_selW <= wb_selM;
        end
    end

endmodule
