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
        .d0(aluout),//32bits
        .d1(readdata),//32bits
        .s(memtoreg),//select signal,1bits
        .y(result)//32bits
    );
    
    //mux2_Writereg//select write to which reg
    mux2  #(.WIDTH (5))mux2_Writereg(
        .d0(instr[20:16]),//5bits
        .d1(instr[15:11]),//5bits
        .s(regdst),//select signal,1bits
        .y(write_reg)//5bits
    );
    
    //adder//pc plus 4
    adder adder_PCplus(
        .a(pc), //32bits
        .b(32'd4),//32bits
        .y(PC_plus_4)//32bits
    );
    
    //adder//pc plus imm
    adder adder_PCbranch(
        .a(sign_sl2), //32bits
        .b(PC_plus_4),//32bits
        .y(PC_branch)//32bits
    );
    
    //alu
    alu alu_do(
        .a(srcA),//32bits
        .b(srcB),//32bits
        .op(alucontrol),//3bits
        .y(aluout),//32bits
        .overflow(overflow),
        .zero(zero)
    );
    
    //PC
//    PC pc_count(
//        .clk(clk),
//        .Proc_run_en(),
//        .Proc_reset(),
//        .pc_o()//32bits
//    );


    
    //regfile
    regfile regfile_do(
        .clk(clk),
        .we3(regwrite),
        .ra1(instr[25:21]),//5bits
        .ra2(instr[20:16]),//5bits
        .wa3(write_reg),//5bits
        .wd3(result),//32bits
        .rd1(srcA),//32bits
        .rd2(writedata),//32bits
        //add one more port here
        .ra_debug(ra_debug),//5bits
        .ra_debug_data(ra_debug_data)//32bits
    );
    //signext
    signext SIGNEXT(
        .a(instr[15:0]),//16bits
        .y(sign_imm)//32bit
    );
    //sl2
    sl2 SL2_1(
        .a(sign_imm),//32bit
        .y(sign_sl2)//32bit
    );

endmodule
