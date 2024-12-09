module second_register (
    input logic i_clk,
    input logic i_rst_n,
    input logic StallE,
    input logic FlushE,
    input logic br_un_D,
    input logic [31:0] PCD,
    input logic [31:0] PCPlus4D,
    input logic [31:0] instrD,
    input logic [31:0] rs1_dataD,
    input logic [31:0] rs2_dataD,
    input logic [4:0] rd_addrD,
    input logic [31:0] immD,
    input logic pc_selD,
    input logic rd_wrenD,
    input logic opa_selD,
    input logic opb_selD,
    input logic [3:0] alu_opD,
    input logic [1:0] mem_wrenD,
    input logic [1:0] wb_selD,
    input logic i_unsignedD,
    input logic [1:0] i_data_typeD,
    output logic [31:0] PCE,
    output logic [31:0] PCPlus4E,
    output logic [31:0] instrE,
    output logic [31:0] rs1_dataE,
    output logic [31:0] rs2_dataE,
    output logic [4:0] rd_addrE,
    output logic [31:0] immE,
    output logic pc_selE,
    output logic rd_wrenE,
    output logic opa_selE,
    output logic opb_selE,
    output logic [3:0] alu_opE,
    output logic [1:0] mem_wrenE,
    output logic [1:0] wb_selE,
    output logic i_unsignedE,
    output logic br_un_E,
    output logic [1:0] i_data_typeE
);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            PCE <= 32'd0;
            PCPlus4E <= 32'd0;
            instrE <= 32'd0;
            rs1_dataE <= 32'd0;
            rs2_dataE <= 32'd0;
            rd_addrE <= 5'd0;
            immE <= 32'd0;
            pc_selE <= 1'b0;
            rd_wrenE <= 1'b0;
            opa_selE <= 1'b0;
            opb_selE <= 1'b0;
            alu_opE <= 4'd0;
            mem_wrenE <= 2'b0;
            wb_selE <= 2'd0;
            i_unsignedE <= 1'b0;
            i_data_typeE <= 2'b0;
            br_un_E <= 0;
        end else if (StallE) begin
            // Retain values during stall
        end else if (FlushE) begin
            PCE <= 32'd0;
            PCPlus4E <= 32'd0;
            instrE <= 32'd0;
            rs1_dataE <= 32'd0;
            rs2_dataE <= 32'd0;
            rd_addrE <= 5'd0;
            immE <= 32'd0;
            pc_selE <= 1'b0;
            rd_wrenE <= 1'b0;
            opa_selE <= 1'b0;
            opb_selE <= 1'b0;
            alu_opE <= 4'd0;
            mem_wrenE <= 2'b0;
            wb_selE <= 2'd0;
            i_unsignedE <= 1'b0;
            i_data_typeE <= 2'b0;
            br_un_E <= 0;
        end else begin
            PCE <= PCD;
            PCPlus4E <= PCPlus4D;
            instrE <= instrD;
            rs1_dataE <= rs1_dataD;
            rs2_dataE <= rs2_dataD;
            rd_addrE <= rd_addrD;
            immE <= immD;
            pc_selE <= pc_selD;
            rd_wrenE <= rd_wrenD;
            opa_selE <= opa_selD;
            opb_selE <= opb_selD;
            alu_opE <= alu_opD;
            mem_wrenE <= mem_wrenD;
            wb_selE <= wb_selD;
            i_unsignedE <= i_unsignedD;
            i_data_typeE <= i_data_typeD;
            br_un_E <= br_un_D;
        end
    end

endmodule
