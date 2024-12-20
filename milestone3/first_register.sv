module first_register (
    input logic i_clk,
    input logic i_rst_n,
    input logic StallD,
    input logic FlushD,
    input logic [31:0] instrF,
    input logic [31:0] PCF,
    input logic [31:0] PCPlus4F,
    output logic [31:0] instrD, 
    output logic [31:0] PCD,
    output logic [31:0] PCPlus4D
);

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            instrD <= 32'd0;
            PCD <= 32'd0;
            PCPlus4D <= 32'd0;
        end
        else if (StallD) begin
            // No change during stall
        end
        else if (FlushD) begin
            instrD <= 32'd0;
            PCD <= 32'd0;
            PCPlus4D <= 32'd0;
        end
        else begin
            instrD <= instrF;
            PCD <= PCF;
            PCPlus4D <= PCPlus4F;
        end
    end
endmodule

