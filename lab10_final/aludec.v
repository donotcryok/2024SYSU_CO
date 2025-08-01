`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:27:24
// Design Name: 
// Module Name: aludec
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



module aludec(
	input wire[5:0] funct,
	input wire[1:0] aluop,
	output reg[2:0] alucontrol
    );
	// add your code here
		// add your code here
	always@(*)begin
	  if(aluop==2'b00) begin
	       alucontrol<=3'b010;
	   end 
	   else if(aluop==2'b01) begin
	       alucontrol<=3'b110;
	   end 
	   else if(aluop==2'b10) begin
	       case(funct) 
               6'b100000:alucontrol<=3'b010;
               6'b100010:alucontrol<=3'b110;
               6'b100100:alucontrol<=3'b000;
               6'b100101:alucontrol<=3'b001;
               6'b101010:alucontrol<=3'b111;
	       endcase
	   end 
    end
endmodule


	

