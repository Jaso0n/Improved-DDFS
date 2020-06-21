`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 18:52:47
// Design Name: 
// Module Name: DDS_SIM
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


module DDS_SIM();
    reg clk;
	reg [31:0] fcw;
	reg rstn;
	reg dctrl;
	reg [31:0] seed1;
	reg [31:0] seed2;
	wire [15:0] sin_data;
	wire [15:0] cosine_data;
//	wire [10:0] debug_addr;
//    wire [31:0] debug_LFSR_U2;
//    wire [31:0] debug_LFSR_U3;
//    wire [15:0] debug_sine;
//    wire debug_amp_flag,debug_pha_flag;
    
	initial begin
		clk = 0;
		rstn = 0;
		fcw = 32'h0033_3333;
		dctrl = 0;
        seed1 = 32'd1234567;
        seed2 = 32'd7654321;
		#10 rstn = 1;
		#100000 fcw = 32'h0013_3333;
	end
	
	always #5 clk = ~clk;
	
//	always @ (posedge clk or negedge rstn)
//		if(!rstn)
//			fcw = 0;
//		else fcw = 32'h0333_3333;
	
	DDS_TOP #(
	   .LFSR_D_BITS(19),
	   .ACC_BITS(32),
	   .QUANTIZER_BITS(16),
	   .ROM_ADDR_BITS(11) ) u1(
		.CLK(clk),
		.FCW(fcw),
		.RSTN(rstn),
		.dither_ctrl(dctrl),
		.seed1(seed1),
		.seed2(seed2),
		
		.data_o_sine(sin_data),
		.data_o_cosine(cosine_data)
		//debug
//		.debug_addr(debug_addr),
//        .debug_LFSR_U2(debug_LFSR_U2),
//        .debug_LFSR_U3(debug_LFSR_U3),
//        .debug_sine(debug_sine),
//        .debug_amp_flag(debug_amp_flag),
//        .debug_pha_flag(debug_pha_flag)
	);
	   
//     integer file1;
//      initial file1 = $fopen("F:/matlabworkspace/dds_exp4_ip/DDFS_DATA_TEMP.dat","w");
//      always@(posedge clk)
//      begin
//        if(rstn == 1)
//         $fwrite (file1,"%h\n",sin_data);
//      end
endmodule
