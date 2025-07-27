`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 20:53:35
// Design Name: 
// Module Name: tb_datapath
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


module tb_datapath(   
    );
    reg clk;
	reg rst;
	wire memtoreg,pcsrc;
	wire alusrc,regdst;
	wire regwrite,jump;
	wire[2:0] alucontrol;
	wire overflow,zero;
	wire[31:0] pc;
	wire[31:0] instr;
	wire[31:0] aluout,writedata;
	wire[31:0] readdata;
	//
	wire[4:0] ra_debug;
	wire[31:0] ra_debug_data;
	
    datapath tb(
	.clk(clk),
	.rst(rst),
	.memtoreg(memtoreg),
	.pcsrc(pcsrc),
	.alusrc(),
	.regdst(),
	.regwrite(),
	.jump(),
	.alucontrol(),
	.overflow(),
	.zero(),
	.pc(pc),
	.instr(),
	.aluout(),
	.writedata(),
	.readdata(),
	//
	.ra_debug(),
	.ra_debug_data()
    );
    initial begin 
		rst <= 1;
		#200;
		rst <= 0;
	end

	always begin
		clk <= 1;
		#10;
		clk <= 0;
		#10;
	
	end
endmodule
