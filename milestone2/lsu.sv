module lsu (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [31:0] i_lsu_addr,
    input  logic [31:0] i_st_data,
    input  logic        i_lsu_wren,
    input  logic [31:0] i_io_sw,
    input  logic [3:0]  i_io_btn,
    input  logic [1:0]  i_data_type,
    input  logic 		i_unsigned,
    output logic [31:0] o_ld_data,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,
    output logic [6:0]  o_io_hex0,
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,
    output logic [31:0] o_io_lcd
    );

    parameter w = 2'b00, hw = 2'b01, b = 2'b10;
    
    // Address decoding
    parameter is_input_peripheral = 2'd0, is_output_peripheral = 2'd1, is_data_memory = 2'd2;

    // Memory mapping decoding
    logic [1:0] map; 


    /*--------Data Memory------------*/

    logic [31:0] mem_ld_data, mem_st_data;
    sram #(
        .depth(64),
        .width(32)
    ) data_memory (
        .i_clk(~i_clk),
        .i_wren((map == is_data_memory)&i_lsu_wren),
        .i_addr(i_lsu_addr[12:2]),
        .i_data(mem_st_data),
        .o_data(mem_ld_data)
    );

    /*--------Output Peripheral------------*/
	// LCD Control Registers
    logic [7:0] lcd_control [15:0];
    // Seven-segment LEDs
    logic [7:0] seven_segment [7:0];
    // Green LEDs
    logic [7:0] green_leds [15:0];
    // Red LEDs
    logic [7:0] red_leds [15:0];

    /*--------Input Peripheral------------*/
    logic [7:0] switches [15:0];

    //index
	logic [3:0] data_be;

    //
    assign o_io_ledr = {red_leds[3],red_leds[2],red_leds[1],red_leds[0]};
    assign o_io_ledg = {green_leds[3],green_leds[2],green_leds[1],green_leds[0]};
    // 
    assign o_io_lcd = {lcd_control[3],lcd_control[2],lcd_control[1],lcd_control[0]};
    //
    assign o_io_hex0 = seven_segment[0][6:0];
    assign o_io_hex1 = seven_segment[1][6:0];
    assign o_io_hex2 = seven_segment[2][6:0];
    assign o_io_hex3 = seven_segment[3][6:0];
    assign o_io_hex4 = seven_segment[4][6:0];
    assign o_io_hex5 = seven_segment[5][6:0];
    assign o_io_hex6 = seven_segment[6][6:0];
    assign o_io_hex7 = seven_segment[7][6:0];

    ///////////////////////////////// BE generation ////////////////////////////////
     always_comb begin: byte_address_enable
	    data_be = 4'b0000;
        case(i_data_type)
            w:
                data_be = 4'b1111;
            hw:begin
                data_be = 4'b0011;
            end
            b:begin
                data_be = 4'b0001;
            end
			default: data_be = 4'b0000;
        endcase
    end


    logic [12:0] lsu_addr[3:0];
    assign lsu_addr[0]= i_lsu_addr[12:0];
    assign lsu_addr[1]= i_lsu_addr[12:0] + 13'd1;
    assign lsu_addr[2]= i_lsu_addr[12:0] + 13'd2;
    assign lsu_addr[3]= i_lsu_addr[12:0] + 13'd3;


    always_comb begin : memory_mapping
        map = 2'b11; //default
        if (i_lsu_addr >= 32'h02000 && i_lsu_addr <= 32'h03FFF)
            map = is_data_memory;
        if (i_lsu_addr >= 32'h07000 && i_lsu_addr <= 32'h0703F)
            map = is_output_peripheral;
        if (i_lsu_addr >= 32'h07800 && i_lsu_addr <= 32'h0780F)
            map = is_input_peripheral;
    end

    logic [31:0] ld_data;
    always_comb begin : data_memory_load
        case(i_lsu_addr[1:0]) 
            2'b00: ld_data = mem_ld_data;
            2'b01: ld_data = {8'b0, mem_ld_data[31:8]};
            2'b10: ld_data = {16'b0, mem_ld_data[31:16]};
            2'b11: ld_data = {24'b0, mem_ld_data[31:24]};
        endcase
    end

    always_comb begin: load_unit
        o_ld_data = 32'b0;
        if (!i_lsu_wren) begin
            case(map)
                is_data_memory: begin
                    o_ld_data = ld_data;
                    if (i_unsigned) begin
                        if (i_data_type == hw) 
                            o_ld_data = {16'b0,ld_data[15:0]};
                        else if (i_data_type == b) 
                            o_ld_data = {24'b0,ld_data[7:0]};
                    end else begin 
                        if (i_data_type == hw) 
                            o_ld_data = {{16{ld_data[15]}},ld_data[15:0]};
                        else if (i_data_type == b) 
                            o_ld_data = {{24{ld_data[7]}},ld_data[7:0]};
                    end
                end
                is_input_peripheral: 
                    o_ld_data = {switches[3], switches[2], switches[1], switches[0]};
                is_output_peripheral: begin
                    case (i_lsu_addr[31:4]) 
                        28'h0700: o_ld_data = {{red_leds[3]},{red_leds[2]},{red_leds[1]},{red_leds[0]}};
                        28'h0701: o_ld_data = {{green_leds[3]},{green_leds[2]},{green_leds[1]},{green_leds[0]}};
                        28'h0703: o_ld_data = {lcd_control[3], lcd_control[2], lcd_control[1], lcd_control[0]};
                        28'h0702: begin
                            case(i_lsu_addr[3:0])
                                4'h0: o_ld_data = {24'b0,{seven_segment[0]}};
                                4'h1: o_ld_data = {24'b0,{seven_segment[1]}};
                                4'h2: o_ld_data = {24'b0,{seven_segment[2]}};
                                4'h3: o_ld_data = {24'b0,{seven_segment[3]}};
                                4'h4: o_ld_data = {24'b0,{seven_segment[4]}};
                                4'h5: o_ld_data = {24'b0,{seven_segment[5]}};
                                4'h6: o_ld_data = {24'b0,{seven_segment[6]}};
                                4'h7: o_ld_data = {24'b0,{seven_segment[7]}};
                            endcase
                        end
                    endcase
                end
                default: o_ld_data = 32'b0;
            endcase
        end
    end
    
    //STORE UNIT
   always_comb begin : data_memory_store_unit
        mem_st_data = mem_ld_data;
        case (i_lsu_addr[1:0])
            2'b00: begin
                if (data_be[0]) mem_st_data[7:0] = i_st_data[7:0];
                if (data_be[1]) mem_st_data[15:8] = i_st_data[15:8];
                if (data_be[2]) mem_st_data[23:16] = i_st_data[23:16];
                if (data_be[3]) mem_st_data[31:24] = i_st_data[31:24];
            end
            2'b01: begin
                if (data_be[0]) mem_st_data[15:8] = i_st_data[7:0];
                if (data_be[1]) mem_st_data[23:16] = i_st_data[15:8];
                if (data_be[2]) mem_st_data[31:24] = i_st_data[23:16];
            end
            2'b10: begin
                if (data_be[0]) mem_st_data[23:16] = i_st_data[7:0];
                if (data_be[1]) mem_st_data[31:24] = i_st_data[15:8];
            end
            2'b11: begin
                if (data_be[0]) mem_st_data[31:24] = i_st_data[7:0];
            end
        endcase
    end


    always_ff @(posedge ~i_clk or negedge i_rst_n) begin :output_buffer_store_unit
        if (!i_rst_n) begin
            // Reset all outputs
            red_leds[0] <= 0;
            red_leds[1] <= 0;
            red_leds[2] <= 0;
            red_leds[3] <= 0;
            green_leds[0] <= 0;
            green_leds[1] <= 0;
            green_leds[2] <= 0;
            green_leds[3] <= 0;
            lcd_control[0] <= 0;
            lcd_control[1] <= 0;
            lcd_control[2] <= 0;
            lcd_control[3] <= 0;
            seven_segment[0] <= 0;
            seven_segment[1] <= 0;
            seven_segment[2] <= 0;
            seven_segment[3] <= 0;
            seven_segment[4] <= 0;
            seven_segment[5] <= 0;
            seven_segment[6] <= 0;
            seven_segment[7] <= 0;
        end else if (is_output_peripheral & i_lsu_wren) begin
            case (i_lsu_addr[31:4])
                32'h0700: begin
                    if (data_be[0]) 
                        red_leds[0] <= i_st_data[7:0];
                    if (data_be[1]) 
                        red_leds[1] <= i_st_data[15:8];
                    if (data_be[2]) 
                        red_leds[2] <= i_st_data[23:16];
                    if (data_be[3]) 
                        red_leds[3] <= i_st_data[31:24];
                end
                32'h0701: begin
                    if (data_be[0]) 
                        green_leds[0] <= i_st_data[7:0];
                    if (data_be[1]) 
                        green_leds[1] <= i_st_data[15:8];
                    if (data_be[2]) 
                        green_leds[2] <= i_st_data[23:16];
                    if (data_be[3]) 
                        green_leds[3] <= i_st_data[31:24];
                end
                32'h0702: begin
                    if (data_be[0]) 
                        seven_segment[lsu_addr[0]] <= {1'b0, i_st_data[6:0]};
                    if (data_be[1]) 
                        seven_segment[lsu_addr[1]] <= {1'b0, i_st_data[14:8]};
                    if (data_be[2]) 
                        seven_segment[lsu_addr[2]] <= {1'b0, i_st_data[22:16]};
                    if (data_be[3]) 
                        seven_segment[lsu_addr[2]] <= {1'b0, i_st_data[30:24]};
                end 
                32'h0703: begin
                    if (data_be[0]) 
                        lcd_control[0] <= i_st_data[7:0];
                    if (data_be[1]) 
                        lcd_control[1] <= i_st_data[15:8];
                    if (data_be[2]) 
                        lcd_control[2] <= i_st_data[23:16];
                    if (data_be[3]) 
                        lcd_control[3] <= i_st_data[31:24];
                end
            endcase
        end 
    end

    always_ff @( posedge i_clk or negedge i_rst_n ) begin : input_buffer_store_unit
        if(!i_rst_n) begin
            switches[0] <= 8'b0;
            switches[1] <= 8'b0;
            switches[2] <= 8'b0;
            switches[3] <= 8'b0;
        end else begin
            switches[0] <= i_io_sw[7:0];
            switches[1] <= i_io_sw[15:8];
            switches[2] <= i_io_sw[23:16];
            switches[3] <= i_io_sw[31:24];
        end
    end
endmodule

module sram #(
    parameter depth = 64,
    parameter width = 32
) (
    input logic i_clk,
    input logic i_wren,
    input logic [$clog2(depth)-1:0] i_addr,
    input logic [width-1:0] i_data,
    output logic [width-1:0] o_data
) /* synthesis ramstyle = "block" */; // This is a synthesis directive to use block RAM

    logic [width-1:0] mem [depth-1:0];

    assign o_data = mem[i_addr];

    always_ff @(posedge i_clk) begin
        if (i_wren)
            mem[i_addr] <= i_data;
    end
endmodule















