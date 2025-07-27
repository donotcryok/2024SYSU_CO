`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 14:44:10
// Design Name: 
// Module Name: mux2
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


module mux2 #(parameter WIDTH = 8)(
	input wire[WIDTH-1:0] d0,d1,
	input wire s,//0 take d0,1 take d1 
	output wire[WIDTH-1:0] y
    );
	//add your code here
	reg [WIDTH-1:0]yout;
	always@(*) begin
	   if(s) yout<=d1; 
	   else if(~s) yout<=d0;
    end
    assign y=yout;
endmodule
