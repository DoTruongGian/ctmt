module lsu (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [31:0] i_lsu_addr,
    input  logic [31:0] i_st_data,
    input  logic [1:0]  i_lsu_wren,
    input  logic [31:0] i_io_sw,
    input  logic [3:0]  i_io_btn,
    input  logic [1:0]  i_data_type,
    input  logic 		    i_unsigned,

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
    output logic [31:0] o_io_lcd,

    output logic          o_pc_stall,
    output logic [17:0]   SRAM_ADDR,
    inout  wire  [15:0]   SRAM_DQ  ,
    output logic          SRAM_CE_N,
    output logic          SRAM_WE_N,
    output logic          SRAM_LB_N,
    output logic          SRAM_UB_N,
    output logic          SRAM_OE_N
    // ,

    // output logic r, wr

    );

    parameter w = 2'b00, hw = 2'b01, b = 2'b10;
    
	
    // Address decoding
    parameter is_input_peripheral = 2'd0, is_output_peripheral = 2'd1, is_data_memory = 2'd2;

    // Memory mapping decoding
    logic [1:0] map; 


    /*-------Memory Controller------------*/
    logic [17:0]   i_ADDR   ;
    logic [31:0]   i_WDATA  ;
    logic [ 3:0]   i_BMASK  ;
    logic          i_WREN   ;
    logic          i_RDEN   ;
    logic [31:0]   o_RDATA  ;
    logic          o_ACK    ;
    
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
    logic [7:0] buttons  [15:0];

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
          w: data_be = 4'b1111;
          hw: data_be = 4'b0011;
          b: data_be = 4'b0001;
          default: data_be = 4'b0000;
      endcase
    end


    


    logic [3:0] i_bmask;
    always_comb begin : memory_mapping
        map = 2'b11; //default
        i_ADDR = 0;
        i_WDATA = 1'b0;
        i_WREN = 1'b0;
        i_RDEN = 1'b0;
		    i_bmask = 4'b0;
        if ((i_lsu_addr & 32'hFFFFF800) == 32'h02000) begin// Check range [0x02000, 0x03FFF]
            map = is_data_memory;
            i_ADDR = i_lsu_addr[17:0];
            i_WDATA = i_st_data;
            i_WREN = i_lsu_wren[0];
            i_RDEN = i_lsu_wren[1];
            i_bmask = data_be << i_lsu_addr[1:0];
        end if ((i_lsu_addr & 32'hFFFFFFC0) == 32'h07000) // Check range [0x07000, 0x0703F]
            map = is_output_peripheral;
        if ((i_lsu_addr & 32'hFFFFFFF0) == 32'h07800) // Check range [0x07800, 0x0780F]
            map = is_input_peripheral;
    end
    // assign r = i_RDEN;
    // assign wr = i_WREN;

    sram_IS61WV25616_controller_32b_3lr sram_ctrl (
        i_ADDR,
        i_WDATA,
        i_bmask,
        i_WREN,
        i_RDEN,
        o_RDATA,
        o_ACK,
        o_pc_stall,

        SRAM_ADDR,
        SRAM_DQ  ,
        SRAM_CE_N,
        SRAM_WE_N,
        SRAM_LB_N,
        SRAM_UB_N,
        SRAM_OE_N,

        i_clk,
        i_rst_n
    );
    
    logic [12:0] lsu_addr[3:0];
    assign lsu_addr[0]= i_lsu_addr[12:0];
    assign lsu_addr[1]= i_lsu_addr[12:0] + 13'd1;
    assign lsu_addr[2]= i_lsu_addr[12:0] + 13'd2;
    assign lsu_addr[3]= i_lsu_addr[12:0] + 13'd3;
    logic [31:0] ld_data;

    // assign o_ld_data = ld_data;
    always_comb begin : load_data
      ld_data = 'z;
        case(map)
            is_data_memory: begin
                case(i_lsu_addr[1:0]) 
                    2'b00: ld_data = o_RDATA;
                    2'b01: ld_data = {8'b0, o_RDATA[31:8]};
                    2'b10: ld_data = {16'b0, o_RDATA[31:16]};
                    2'b11: ld_data = {24'b0, o_RDATA[31:24]};
                endcase
            end
            is_input_peripheral: begin
                case (i_lsu_addr[31:4]) 
                    24'h0780:  ld_data = {switches[3], switches[2], switches[1], switches[0]};
                    24'h0781:  ld_data = {buttons[3], buttons[2], buttons[1], buttons[0]};
                    default: ld_data = 32'b0;
                endcase
            end
            is_output_peripheral: begin
                case (i_lsu_addr[31:4]) 
                    28'h0700: ld_data = {{red_leds[3]},{red_leds[2]},{red_leds[1]},{red_leds[0]}};
                    28'h0701: ld_data = {{green_leds[3]},{green_leds[2]},{green_leds[1]},{green_leds[0]}};
                    28'h0703: ld_data = {lcd_control[3], lcd_control[2], lcd_control[1], lcd_control[0]};
                    28'h0702: ld_data = {seven_segment[lsu_addr[3]], seven_segment[lsu_addr[2]], seven_segment[lsu_addr[1]], seven_segment[lsu_addr[0]]};
                    default: ld_data = 32'b0;
                endcase
            end
        endcase
    end

    always_comb begin: load_unit
      o_ld_data = 'z;
      if (i_lsu_wren[1]) begin
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
    end


    // // //STORE UNIT
    // logic [31:0] st_data, addr;
    // assign st_data = i_lsu_wren[0] ? i_st_data : st_data;
    // assign addr = i_lsu_wren[0] ? i_lsu_addr : addr;
    
    always_ff @(posedge i_clk or negedge i_rst_n) begin :output_buffer_store_unit
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
        end else if ((map==is_output_peripheral) && i_lsu_wren[0]) begin
            case (i_lsu_addr[31:4])
                28'h0700: begin
                    if (data_be[0]) 
                        red_leds[lsu_addr[0][2:0]] <= i_st_data[7:0];
                    if (data_be[1]) 
                        red_leds[lsu_addr[1][2:0]] <= i_st_data[15:8];
                    if (data_be[2]) 
                        red_leds[lsu_addr[2][2:0]] <= i_st_data[23:16];
                    if (data_be[3]) 
                        red_leds[lsu_addr[3][2:0]] <= i_st_data[31:24];
                end
                28'h0701: begin
                    if (data_be[0]) 
                        green_leds[lsu_addr[0][2:0]] <= i_st_data[7:0];
                    if (data_be[1]) 
                        green_leds[lsu_addr[1][2:0]] <= i_st_data[15:8];
                    if (data_be[2]) 
                        green_leds[lsu_addr[2][2:0]] <= i_st_data[23:16];
                    if (data_be[3]) 
                        green_leds[lsu_addr[3][2:0]] <= i_st_data[31:24];
                end
                28'h0702: begin
                    if (data_be[0]) 
                        seven_segment[lsu_addr[0][2:0]] <= i_st_data[7:0];
                    if (data_be[1]) 
                        seven_segment[lsu_addr[1][2:0]] <= i_st_data[15:8];
                    if (data_be[2]) 
                        seven_segment[lsu_addr[2][2:0]] <= i_st_data[23:16];
                    if (data_be[3]) 
                        seven_segment[lsu_addr[3][2:0]] <= i_st_data[31:24];
				        end
                28'h0703: begin
                    if (data_be[0]) 
                        lcd_control[lsu_addr[0][2:0]] <= i_st_data[7:0];
                    if (data_be[1]) 
                        lcd_control[lsu_addr[1][2:0]] <= i_st_data[15:8];
                    if (data_be[2]) 
                        lcd_control[lsu_addr[2][2:0]] <= i_st_data[23:16];
                    if (data_be[3]) 
                        lcd_control[lsu_addr[3][2:0]] <= i_st_data[31:24];
                end
            endcase
        end 
    end

    always_comb begin : input_buffer_store_unit
            switches[0] = i_io_sw[7:0];
            switches[1] = i_io_sw[15:8];
            switches[2] = i_io_sw[23:16];
            switches[3] = i_io_sw[31:24];
            buttons[0]  = {4'b0, i_io_btn};
    end
endmodule

module sram_IS61WV25616_controller_32b_3lr (
  input  logic [17:0]   i_ADDR   ,
  input  logic [31:0]   i_WDATA  ,
  input  logic [ 3:0]   i_BMASK  ,
  input  logic          i_WREN   ,
  input  logic          i_RDEN   ,
  output logic [31:0]   o_RDATA  ,
  output logic          o_ACK    ,
  output logic          o_pc_stall,

  output logic [17:0]   SRAM_ADDR,
  inout  wire  [15:0]   SRAM_DQ  ,
  output logic          SRAM_CE_N,
  output logic          SRAM_WE_N,
  output logic          SRAM_OE_N,
  output logic          SRAM_LB_N,
  output logic          SRAM_UB_N,

  input logic i_clk,
  input logic i_reset
);

  typedef enum logic [2:0] {
      StIdle
    , StWrite
    , StWriteAck
    , StRead0
    , StRead1
    , StReadW
    , StReadAck
  } sram_state_e;

  sram_state_e sram_state_d;
  sram_state_e sram_state_q;

  logic [17:0] addr_d;
  logic [17:0] addr_q;
  logic [31:0] wdata_d;
  logic [31:0] wdata_q;
  logic [31:0] rdata_d;
  logic [31:0] rdata_q;
  logic [ 3:0] bmask_d;
  logic [ 3:0] bmask_q;

  logic [15:0] DIN;
  logic [15:0] DOUT;

  always_comb begin : proc_detect_state
    case (sram_state_q)
      StIdle, StWriteAck, StReadAck: begin
        if (i_WREN ~^ i_RDEN) begin
          sram_state_d = StIdle;
          addr_d       = addr_q;
          wdata_d      = wdata_q;
          rdata_d      = rdata_q;
          bmask_d      = bmask_q;
          o_pc_stall   = 1'b0;
        end
        else begin
          sram_state_d = i_WREN ? StWrite : StRead0;
          addr_d       = i_ADDR & 18'h3FFFE;
          wdata_d      = i_WREN ? i_WDATA : wdata_q;
          rdata_d      = rdata_q;
          bmask_d      = i_BMASK;
          o_pc_stall   = 1'b1;
        end
      end
      StWrite: begin
        sram_state_d = StWriteAck;
        addr_d       = addr_q | 18'h1;
        wdata_d      = wdata_q >> 16;
        rdata_d      = rdata_q;
        bmask_d      = bmask_q;
        o_pc_stall   = 1'b0;
      end
      StRead0: begin
        sram_state_d = StRead1;
        addr_d       = addr_q | 18'h1;
        wdata_d      = wdata_q;
        rdata_d      = {rdata_q[31:16], DIN};
        bmask_d      = bmask_q;
        o_pc_stall   = 1'b1;
      end
      StRead1: begin
        sram_state_d = StReadW;
        addr_d       = addr_q;
        wdata_d      = wdata_q;
        rdata_d      = {DIN, rdata_q[15:0]};
        bmask_d      = bmask_q;
        o_pc_stall   = 1'b1;
      end
      StReadW: begin
        sram_state_d = StReadAck;
        addr_d       = addr_q;
        wdata_d      = wdata_q;
        rdata_d      = rdata_q[15:0];
        bmask_d      = bmask_q;
        o_pc_stall   = 1'b0;
      end
      default: begin
        sram_state_d = StIdle;
        addr_d       = '0;
        wdata_d      = '0;
        rdata_d      = '0;
        bmask_d      = '0;
        o_pc_stall   = '0;
      end
    endcase
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset) begin
      sram_state_q <= StIdle;
    end
    else begin
      sram_state_q <= sram_state_d;
    end
  end

  always_ff @(posedge i_clk) begin
    if (!i_reset) begin
      addr_q  <= '0;
      wdata_q <= '0;
      rdata_q <= '0;
      bmask_q <= 4'b0000;
    end
    else begin
      addr_q  <= addr_d;
      wdata_q <= wdata_d;
      rdata_q <= rdata_d;
      bmask_q <= bmask_d;
    end
  end

  always_comb begin : proc_output_to_sram
    SRAM_ADDR = addr_q;
    case (sram_state_q)
      StWrite: begin
        DOUT      = wdata_q[15:0];
        SRAM_WE_N = 1'b0;
        SRAM_OE_N = 1'b1;
        SRAM_CE_N = 1'b0;
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[1:0];
      end
      StWriteAck: begin
        DOUT      = wdata_q[15:0];
        SRAM_WE_N = 1'b0;
        SRAM_OE_N = 1'b1;
        SRAM_CE_N = 1'b0;
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[3:2];
      end
      StRead0: begin
        DOUT      = 'z;
        SRAM_WE_N = 1'b1;
        SRAM_OE_N = 1'b0;
        SRAM_CE_N = 1'b0;
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[1:0];
      end
      StRead1: begin
        DOUT      = 'z;
        SRAM_WE_N = 1'b1;
        SRAM_OE_N = 1'b0;
        SRAM_CE_N = 1'b0;
        {SRAM_UB_N, SRAM_LB_N} = ~bmask_q[3:2];
      end
      StReadAck, StReadW: begin
        DOUT      = 'z;
        SRAM_WE_N = 1'b1;
        SRAM_OE_N = 1'b1;
        SRAM_CE_N = 1'b1;
        {SRAM_UB_N, SRAM_LB_N} = 2'b11;
      end
      default: begin
        DOUT      = 'z;
        SRAM_WE_N = 1'b1;
        SRAM_OE_N = 1'b1;
        SRAM_CE_N = 1'b1;
        {SRAM_UB_N, SRAM_LB_N} = 2'b11;
      end
    endcase
  end

  assign  SRAM_DQ = DOUT;
  assign  DIN = SRAM_DQ;

  always_comb begin : proc_output_to_lsu
    o_RDATA = rdata_q;
    o_ACK  = (sram_state_q == StWriteAck) || (sram_state_q == StReadAck);
  end

endmodule : sram_IS61WV25616_controller_32b_3lr