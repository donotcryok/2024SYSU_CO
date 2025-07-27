`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/02 15:12:22
// Design Name: 
// Module Name: datapath
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


module datapath(
	input wire clk,rst,
	input wire memtoreg,pcsrc,
	input wire alusrc,regdst,
	input wire regwrite,jump,
	input wire[2:0] alucontrol,
	output wire overflow,zero,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata,
	//
	input wire[4:0] ra_debug,
	output wire[31:0] ra_debug_data
    );
	
	//add your code here
	wire [31:0]PC_plus_4;
	wire [31:0]PC_branch;
	wire [31:0]PC_next;
	wire [31:0]PC_next_n;
	wire [31:0]PC_jump;
	
	wire [31:0]sign_imm;
	wire [31:0]sign_sl2;
	
	wire [4:0]write_reg;
	
	wire [31:0]result;
	
	
	wire [31:0]srcA;
	wire [31:0]srcB;
	
	assign PC_jump={PC_plus_4[31:28],instr[25:0],2'b00};
	
	flopr #(.WIDTH (32))flopr_do(
        .clk(clk),
        .rst(rst),
        .d(PC_next_n),//32bits
        .q(pc)//32bits
    );
	//mux_PC_branch  
    mux2  #(.WIDTH (32))mux2_PC(
        .d0(PC_plus_4),//32bits
        .d1(PC_branch),//32bits
        .s(pcsrc),//select signal,1bits
        .y(PC_next)//32bits
    );
    
    //mux_PC_jump  
    mux2  #(.WIDTH (32))mux2_PC_2(
        .d0(PC_next),//32bits
        .d1(PC_jump),//32bits
        .s(jump),//select signal,1bits
        .y(PC_next_n)//32bits
    );
    
    //mux_SELECTdataB_to_ALU
    mux2  #(.WIDTH (32))mux2_SrcB(
        .d0(writedata),//32bits
        .d1(sign_imm),//32bits
        .s(alusrc),//select signal,1bits
        .y(srcB)//32bits
    );
    
    //mux2_result
    mux2  #(.WIDTH (32))mux2_result(
        .d0(aluout)