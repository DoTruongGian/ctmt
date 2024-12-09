module third_register (
    input logic i_clk,
    input logic i_rst_n,
    input logic StallM,
    input logic FlushM,
    input logic [31:0] instrE,
    input logic [31:0] alu_dataE,
    input logic [31:0] rs2_dataHE,
    input logic [4:0] rd_addrE,
    input logic [31:0] PCE,
    input logic [31:0] PCPlus4E,
    input logic rd_wrenE,
    input logic [1:0] mem_wrenE,
    input logic [1:0] wb_selE,
    input logic i_unsignedE,
    input logic [1:0] i_data_typeE,
    output logic [31:0] instrM,
    output logic [31:0] alu_dataM,
    output logic [31:0] rs2_dataHM,
    output logic [4:0] rd_addrM,
    output logic [31:0] PCM,
    output logic [31:0] PCPlus4M,
    output logic rd_wrenM,
    output logic [1:0] mem_wrenM,
    output logic [1:0] wb_selM,
    output logic i_unsignedM,
    output logic [1:0] i_data_typeM
);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            instrM <= 32'd0;
            alu_dataM <= 32'd0;
            rs2_dataHM <= 32'd0;
            rd_addrM <= 5'd0;
            PCPlus4M <= 32'd0;
            rd_wrenM <= 1'b0;
            mem_wrenM <= 2'b0;
            wb_selM <= 2'd0;
            i_unsignedM <= 1'b0;
            i_data_typeM <= 2'b0;
            PCM <= 0;
        end else if (StallM) begin
            // Retain values during stall
        end else if (FlushM) begin
            instrM <= 32'd0;
            alu_dataM <= 32'd0;
            rs2_dataHM <= 32'd0;
            rd_addrM <= 5'd0;
            PCPlus4M <= 32'd0;
            rd_wrenM <= 1'b0;
            mem_wrenM <= 2'b0;
            wb_selM <= 2'd0;
            i_unsignedM <= 1'b0;
            i_data_typeM <= 2'b0;
            PCM <= 0;
        end else begin
            instrM <= instrE;
            alu_dataM <= alu_dataE;
            rs2_dataHM <= rs2_dataHE;
            rd_addrM <= rd_addrE;
            PCPlus4M <= PCPlus4E;
            rd_wrenM <= rd_wrenE;
            mem_wrenM <= mem_wrenE;
            wb_selM <= wb_selE;
            i_unsignedM <= i_unsignedE;
            i_data_typeM <= i_data_typeE;
            PCM <= PCE;
        end
    end

endmodule
