`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:50:53
// Design Name: 
// Module Name: top
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


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite,
	output wire[31:0] pc,
	output wire[31:0] instr,
	input wire[4:0] ra_debug,
	output wire[31:0] ra_debug_data
    );

	wire[31:0] readdata;

	//mips mips(clk,rst,pc,instr,memwrite,dataadr,writedata,readdata);
	mips mips(clk,rst,pc,instr,memwrite,dataadr,writedata,readdata,ra_debug,ra_debug_data);
    //create imem and dmem by yourself
	inst_mem imem(clk,pc[7:2],instr);
	data_mem dmem(~clk,memwrite,dataadr,writedata,readdata);
endmodule
