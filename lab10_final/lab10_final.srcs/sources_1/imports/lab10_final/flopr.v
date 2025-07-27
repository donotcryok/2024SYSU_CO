`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:32:42
// Design Name: 
// Module Name: flopr
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


module flopr #(parameter WIDTH = 8)(
	input						clk_i,
	input                       pc_en,
	input                       pc_clr,
	input                       rst_n,
	input		[WIDTH-1:0] 	d,
	output	reg	[WIDTH-1:0] 	q
    );
	always @(posedge clk_i or posedge rst_n) begin
		if( ~rst_n|| pc_clr) begin
			q <= 0;
		end else if(pc_en)begin
			q <= d;
		end
	end
endmodule
