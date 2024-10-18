module lsu (
  input  logic        i_clk,
  input  logic        i_rst_n,
  input  logic [31:0] i_lsu_addr,
  input  logic [31:0] i_st_data,
  input  logic        i_lsu_wren,
  input  logic [31:0] i_io_sw,
  input  logic [3:0]  i_io_btn,
  input  logic [1:0]  i_data_type,
  input  logic        i_unsigned,
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

  /*--------Data Memory------------*/
  logic [7:0] data_memory [255:0];        // 8KiB data memory

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

  // Address decoding
  logic is_input_peripheral;
  logic is_output_peripheral;
  logic is_data_memory;

  // index
  logic [3:0] data_be;
  assign i = i_lsu_addr[1:0];

  logic [31:0] rdata;

  assign is_input_peripheral = (i_lsu_addr >= 32'h07800 && i_lsu_addr <= 32'h0780F);
  assign is_output_peripheral = (i_lsu_addr >= 32'h07000 && i_lsu_addr <= 32'h0703F);
  assign is_data_memory = (i_lsu_addr >= 32'h02000 && i_lsu_addr <= 32'h03FFF);

  assign o_io_ledr = {red_leds[3], red_leds[2], red_leds[1], red_leds[0]};
  assign o_io_ledg = {green_leds[3], green_leds[2], green_leds[1], green_leds[0]};
  assign o_io_lcd = {lcd_control[3], lcd_control[2], lcd_control[1], lcd_control[0]};
  assign o_io_hex0 = seven_segment[0];
  assign o_io_hex1 = seven_segment[1];
  assign o_io_hex2 = seven_segment[2];
  assign o_io_hex3 = seven_segment[3];
  assign o_io_hex4 = seven_segment[4];
  assign o_io_hex5 = seven_segment[5];
  assign o_io_hex6 = seven_segment[6];
  assign o_io_hex7 = seven_segment[7];

  always_comb begin
    data_be = 4'b0000;
    case (i_data_type)
      w:
        data_be = 4'b1111;
      hw: begin
        data_be = 4'b0011;
      end
      b: begin
        data_be = 4'b0001;
      end
      default: data_be = 4'b0000;
    endcase
  end

  logic [12:0] mem_addr[3:0];
  assign mem_addr[0] = i_lsu_addr[12:0];
  assign mem_addr[1] = i_lsu_addr[12:0] + 13'd1;
  assign mem_addr[2] = i_lsu_addr[12:0] + 13'd2;
  assign mem_addr[3] = i_lsu_addr[12:0] + 13'd3;

  always_comb begin
    rdata = {{data_memory[mem_addr[3]]},
             {data_memory[mem_addr[2]]},
             {data_memory[mem_addr[1]]},
             {data_memory[mem_addr[0]]}} & {{8{data_be[3]}}, {8{data_be[2]}}, {8{data_be[1]}}, {8{data_be[0]}}};

    o_ld_data = 32'b0;
    // Read operation
    if (is_data_memory && !i_lsu_wren) begin
      if (i_unsigned || i_data_type == w) 
        o_ld_data = rdata;
      else begin
        if (i_data_type == hw) 
          o_ld_data = {{16{rdata[15]}}, rdata[15:0]};
        else if (i_data_type == b) 
          o_ld_data = {{24{rdata[7]}}, rdata[7:0]};
      end
    end else if (is_input_peripheral) begin
      o_ld_data = {switches[3], switches[2], switches[1], switches[0]};
    end else if (is_output_peripheral) begin
      case (i_lsu_addr[31:4]) 
        28'h0700: o_ld_data = {{red_leds[3]}, {red_leds[2]}, {red_leds[1]}, {red_leds[0]}};
        28'h0701: o_ld_data = {{green_leds[3]}, {green_leds[2]}, {green_leds[1]}, {green_leds[0]}};
        28'h0703: o_ld_data = {lcd_control[3], lcd_control[2], lcd_control[1], lcd_control[0]};
        28'h0702: begin
          case (i_lsu_addr[3:0])
            4'h0: o_ld_data = {24'b0, {seven_segment[0]}};
            4'h1: o_ld_data = {24'b0, {seven_segment[1]}};
            4'h2: o_ld_data = {24'b0, {seven_segment[2]}};
            4'h3: o_ld_data = {24'b0, {seven_segment[3]}};
            4'h4: o_ld_data = {24'b0, {seven_segment[4]}};
            4'h5: o_ld_data = {24'b0, {seven_segment[5]}};
            4'h6: o_ld_data = {24'b0, {seven_segment[6]}};
            4'h7: o_ld_data = {24'b0, {seven_segment[7]}};
          endcase 
        end
      endcase
    end
  end

  // write
  logic clk;
  assign clk = ~i_clk && i_lsu_wren;

  always_ff @(posedge clk or negedge i_rst_n) begin
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
    end else if (is_output_peripheral) begin
      case (i_lsu_addr)
        32'h07000: begin
          if (data_be[0]) 
            red_leds[0] <= i_st_data[7:0];
          if (data_be[1]) 
            red_leds[1] <= i_st_data[15:8];
          if (data_be[2]) 
            red_leds[2] <= i_st_data[23:16];
          if (data_be[3]) 
            red_leds[3] <= i_st_data[31:24];
        end
        32'h07010: begin
          if (data_be[0]) 
            green_leds[0] <= i_st_data[7:0];
          if (data_be[1]) 
            green_leds[1] <= i_st_data[15:8];
          if (data_be[2]) 
            green_leds[2] <= i_st_data[23:16];
          if (data_be[3]) 
            green_leds[3] <= i_st_data[31:24];
        end
        32'h07030: begin
          if (data_be[0]) 
            lcd_control[0] <= i_st_data[7:0];
          if (data_be[1]) 
            lcd_control[1] <= i_st_data[15:8];
          if (data_be[2]) 
            lcd_control[2] <= i_st_data[23:16];
          if (data_be[3]) 
            lcd_control[3] <= i_st_data[31:24];
        end
        32'h07020: begin
          case (i_lsu_addr[3:0])
            4'h0: seven_segment[0] <= i_st_data[7:0];
            4'h1: seven_segment[1] <= i_st_data[7:0];
            4'h2: seven_segment[2] <= i_st_data[7:0];
            4'h3: seven_segment[3] <= i_st_data[7:0];
            4'h4: seven_segment[4] <= i_st_data[7:0];
            4'h5: seven_segment[5] <= i_st_data[7:0];
            4'h6: seven_segment[6] <= i_st_data[7:0];
            4'h7: seven_segment[7] <= i_st_data[7:0];
          endcase
        end
      endcase
    end else if (is_data_memory) begin
      if (data_be[0]) 
        data_memory[mem_addr[0]] <= i_st_data[7:0];
      if (data_be[1]) 
        data_memory[mem_addr[1]] <= i_st_data[15:8];
      if (data_be[2]) 
        data_memory[mem_addr[2]] <= i_st_data[23:16];
      if (data_be[3]) 
        data_memory[mem_addr[3]] <= i_st_data[31:24];
    end
  end

always_ff @(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    // Reset logic for input peripherals, e.g., switches
    switches[0] <= 8'd0;
    switches[1] <= 8'd0;
    switches[2] <= 8'd0;
    switches[3] <= 8'd0;
  end else if (is_input_peripheral) begin
    // Input peripheral logic
    switches[0] <= i_io_sw[7:0];
    switches[1] <= i_io_sw[15:8];
    switches[2] <= i_io_sw[23:16];
    switches[3] <= i_io_sw[31:24];
  end
end

endmodule