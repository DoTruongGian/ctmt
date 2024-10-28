module top_fpga (
    input wire CLOCK_50,         // DE2 onboard 50MHz clock
    input wire [1:0] KEY,        // DE2 onboard push buttons for reset, etc.
    output wire [9:0] LEDR,      // DE2 red LEDs
    output wire [7:0] LEDG,      // DE2 green LEDs
    output wire [6:0] HEX0,      // DE2 7-segment display 0
    output wire [6:0] HEX1,      // DE2 7-segment display 1
    output wire [6:0] HEX2,      // DE2 7-segment display 2
    output wire [6:0] HEX3,      // DE2 7-segment display 3
    output wire [6:0] HEX4,      // DE2 7-segment display 4
    output wire [6:0] HEX5,      // DE2 7-segment display 5
    output wire [6:0] HEX6,      // DE2 7-segment display 6
    output wire [6:0] HEX7       // DE2 7-segment display 7
);

    // Internal signals for single_cycle connections
    wire clk;
    wire rst_n;
    wire [31:0] pc_debug;
    wire insn_vld;
    wire [31:0] io_ledr;
    wire [31:0] io_ledg;
    wire [6:0] io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;

    // Assign clock and reset signals
    assign clk = CLOCK_50;
    assign rst_n = KEY[0];  // Active-low reset from KEY[0] on DE2 board

    // Instantiate single_cycle module
    single_cycle u_single_cycle (
        .i_clk(clk),
        .i_rst_n(rst_n),
        .o_pc_debug(pc_debug),
        .o_insn_vld(insn_vld),
        .o_io_ledr(io_ledr),
        .o_io_ledg(io_ledg),
        .o_io_hex0(io_hex0),
        .o_io_hex1(io_hex1),
        .o_io_hex2(io_hex2),
        .o_io_hex3(io_hex3),
        .o_io_hex4(io_hex4),
        .o_io_hex5(io_hex5),
        .o_io_hex6(io_hex6),
        .o_io_hex7(io_hex7)
    );

    // Assign the outputs from single_cycle to the FPGA I/O pins
    assign LEDR = io_ledr[9:0];     // Map lower 10 bits to DE2 red LEDs
    assign LEDG = io_ledg[7:0];     // Map lower 8 bits to DE2 green LEDs
    assign HEX0 = io_hex0;
    assign HEX1 = io_hex1;
    assign HEX2 = io_hex2;
    assign HEX3 = io_hex3;
    assign HEX4 = io_hex4;
    assign HEX5 = io_hex5;
    assign HEX6 = io_hex6;
    assign HEX7 = io_hex7;

endmodule
