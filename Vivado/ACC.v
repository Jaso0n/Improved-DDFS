`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/03/31 16:47:14
// Design Name: 
// Module Name: ACC
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


module ACC(
input clk,
input[31:0] fcw,
input rstn,
output[31:0] phase
    );
    reg [31:0] cnt;
    assign phase = cnt;

    always@(posedge clk or negedge rstn)
    if(!rstn)
        cnt <= 0;
    else cnt <= cnt + fcw;
    
endmodule
