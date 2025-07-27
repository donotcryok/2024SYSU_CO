`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/10/23 15:21:30
// Design Name: 
// Module Name: maindec
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


module maindec(
	input		[5:0] 	op_i,

	output 	reg			memtoreg_o,
	output 	reg			memwrite_o,
	output	reg			branch_o,
	output	reg			alusrc_o,
	output 	reg			regdst_o,
	output 	reg			regwrite_o,
	output 	reg			jump_o,
	output 	reg	[1:0] 	aluop_o
    );
	//add your code here according to lab 7
  
//    reg regwrite_o;
//    reg regdst_o;
//    reg alusrc_o;
//    reg branch_o;
//    reg memwrite_o;
//    reg memtoreg_o;
//    reg jump_o;
//    reg [1:0]aluop_o;
     always @(*)begin
       if(op_i==6'b000000)begin  //R-type
          regwrite_o<=1'b1;
          regdst_o<=1'b1;
          alusrc_o<=1'b0;
          branch_o<=1'b0;
          memwrite_o<=1'b0;
          memtoreg_o<=1'b0;
          aluop_o<=2'b10;
          jump_o<=0;
       end else if(op_i==6'b100011)begin  //lw
          regwrite_o<=1'b1;
          regdst_o<=1'b0;
          alusrc_o<=1'b1;
          branch_o<=1'b0;
          memwrite_o<=1'b0;
          memtoreg_o<=1'b1;
          aluop_o<=2'b00;
          jump_o<=0;
       end else if(op_i==6'b101011)begin  //sw
          regwrite_o<=1'b0;
          alusrc_o<=1'b1;
          branch_o<=1'b0;
          memwrite_o<=1'b1;
          aluop_o<=2'b00;
          jump_o<=0;
       end else if(op_i==6'b000100)begin  //beq
          regwrite_o<=1'b0;
          alusrc_o<=1'b0;
          branch_o<=1'b1;
          memwrite_o<=1'b0;
          aluop_o<=2'b01;
          jump_o<=0;
       end else if(op_i==6'b001000)begin  //addi
          regwrite_o<=1'b1;
          regdst_o<=1'b0;
          alusrc_o<=1'b1;
          branch_o<=1'b0;
          memwrite_o<=1'b0;
          memtoreg_o<=1'b0;
          aluop_o<=2'b00;
          jump_o<=0;
       end else if(op_i==6'b000010)begin  //j
          regwrite_o<=1'b0;
          memwrite_o<=1'b0;
          jump_o<=1;
       end
    end 
//    assign regwrite=regwrite_o;
//    assign regdst=regdst_o;
//    assign alusrc=alusrc_o;
//    assign branch=branch_o;
//    assign memwrite=memwrite_o;
//    assign memtoreg=memtoreg_o;
//    assign aluop=aluop_o;
//    assign jump=jump_o;


endmodule
