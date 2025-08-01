`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 10:58:03
// Design Name: 
// Module Name: mips
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


module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata,
	//add debug port 
	input wire[4:0] ra_debug,
	output wire[31:0] ra_debug_data
    );
	
	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,overflow;
	wire[2:0] alucontrol;

	controller c(instr[31:26],instr[5:0],zero,memtoreg,
		memwrite,pcsrc,alusrc,regdst,regwrite,jump,alucontrol);
	//datapath dp(clk,rst,memtoreg,pcsrc,alusrc,
	//	regdst,regwrite,jump,alucontrol,overflow,zero,pc,instr,aluout,writedata,readdata);
	datapath dp(clk,rst,memtoreg,pcsrc,alusrc,
		regdst,regwrite,jump,alucontrol,overflow,zero,pc,instr,aluout,writedata,readdata,ra_debug,ra_debug_data);
endmodule
