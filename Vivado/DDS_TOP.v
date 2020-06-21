`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 16:47:14
// Design Name: 
// Module Name: DDS_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DDS_TOP #(
    parameter LFSR_D_BITS = 19,
    parameter ACC_BITS = 32,
    parameter QUANTIZER_BITS = 16,
    parameter ROM_ADDR_BITS = 11)
    (
    input[31:0] FCW,
    input CLK,
    input RSTN,
    input dither_ctrl,
    input [31:0] seed1,
    input [31:0] seed2,
    
    output [15:0] data_o_sine,
    output [15:0] data_o_cosine
    
    //debug
//    output[10:0] debug_addr,
//    output[31:0] debug_LFSR_U2,
//    output[31:0] debug_LFSR_U3,
//    output[15:0] debug_sine,
//    output debug_amp_flag,
//    output debug_pha_flag
    );
 
    wire[ACC_BITS-1:0] PHASE;
    
    wire[ACC_BITS-1:0] LFSR_U2,LFSR_U3;
    
    reg[ACC_BITS-1:0] DITHER_PHASE;
    reg[QUANTIZER_BITS-1:0] sine;
    reg[QUANTIZER_BITS-1:0] cosine;
    reg[ROM_ADDR_BITS-1:0] addr;
    
    wire[QUANTIZER_BITS-1:0] sine_data;
    wire[QUANTIZER_BITS-1:0] cosine_data;
    wire amp_flag, pha_flag;
    
    assign amp_flag = DITHER_PHASE[ACC_BITS-1];
    assign pha_flag  = DITHER_PHASE[ACC_BITS-2];

    
    assign data_o_sine =  sine;
    assign data_o_cosine = cosine;
    
    //debug
//    assign debug_addr = addr;
//    assign debug_LFSR_U2 = LFSR_U2;
//    assign debug_LFSR_U3 = LFSR_U3;
//    assign debug_sine = sine;
//    assign debug_amp_flag = amp_flag;
//    assign debug_pha_flag = pha_flag;
    
//    always@(*)
//        if(!RSTN)
//                addr <= 0;
//        else begin
//               //DITHER_PHASE <= PHASE + LFSR_U2[LFSR_D_BITS-1:0] + LFSR_U3[LFSR_D_BITS-1:0];
//               //addr <= DITHER_PHASE[ACC_BITS-1:ACC_BITS-1-ROM_ADDR_BITS+1];
//               addr <= PHASE[ACC_BITS-1:ACC_BITS-1-ROM_ADDR_BITS+1];
//               sine <= sine_data;
//        end

    always@(*)
        if(!RSTN)
            addr <= 0;
        else begin
            if (dither_ctrl == 1)
                DITHER_PHASE <= PHASE + LFSR_U2[LFSR_D_BITS-1:0] + LFSR_U3[LFSR_D_BITS-1:0];
            else if (dither_ctrl == 0)
                DITHER_PHASE <= PHASE;
        case({amp_flag,pha_flag})
        2'b00:begin
            addr <= DITHER_PHASE[ACC_BITS-3:ACC_BITS-ROM_ADDR_BITS-2];
            sine <= sine_data;
            cosine <= cosine_data;
        end
        2'b01:begin
            addr <= ~DITHER_PHASE[ACC_BITS-3:ACC_BITS-ROM_ADDR_BITS-2];
            sine <= sine_data;
            cosine <= -cosine_data;
        end
        2'b10:begin
            addr <= DITHER_PHASE[ACC_BITS-3:ACC_BITS-ROM_ADDR_BITS-2];
            sine <= -sine_data;
            cosine <= -cosine_data;
        end
        2'b11:begin
            addr <= ~DITHER_PHASE[ACC_BITS-3:ACC_BITS-ROM_ADDR_BITS-2];
            sine <= -sine_data;
            cosine <= cosine_data;
        end
        endcase
        end

//    ACC U1(
//        .clk(CLK),
//        .rstn(RSTN),
//        .fcw(FCW),
//        .phase(PHASE)
//    );

    dds_compiler_0 U1(
        .s_axis_config_tdata(FCW),
        .s_axis_config_tvalid(RSTN),
        .aclk(CLK),
        .m_axis_phase_tdata(PHASE),
        .m_axis_phase_tvalid()
    );
    
    LFSR #(.NUM_BITS(LFSR_D_BITS) ) U2(
        .i_Clk(CLK),
        .i_Enable(dither_ctrl),
  
    // Optional Seed Value
        .i_Seed_DV(RSTN),
        .i_Seed_Data(seed1),
  
        .o_LFSR_Data(LFSR_U2),
        .o_LFSR_Done()
    );
    
    
    LFSR #(.NUM_BITS(LFSR_D_BITS) ) U3(
        .i_Clk(CLK),
        .i_Enable(dither_ctrl),

// Optional Seed Value
        .i_Seed_DV(RSTN),
        .i_Seed_Data(seed2),

        .o_LFSR_Data(LFSR_U3),
        .o_LFSR_Done()
    );
    
    
    SINE_ROM U4(
        .addra(addr),
        .clka(CLK),
        .douta(sine_data),
        .ena(1'b1)
    );
    
    COSINE_ROM U5(
        .addra(addr),
        .clka(CLK),
        .douta(cosine_data),
        .ena(1'b1)
    );

//       lut_data_0 U2(
//          .addra(addr),
//          .clka(CLK),
//          .douta(sine_data),
//          .ena(1'b1)
//       );
//       lut_data_1 U3(
//          .addra(addr),
//          .clka(CLK),
//          .douta(cosine_data),
//          .ena(1'b1)
//       );

//    dist_mem_gen_0 U4(
//        .a(addr),
//        .spo(sine_data)
//    );
    
endmodule
