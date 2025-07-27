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
	input				clk_i,
	input				rst_n,

	input  				pc_run_en_i,
	input  				pc_clr_i,

	input 				memtoreg_i,
	input 				pcsrc_i, 
	input				alusrc_i,
	input				regdst_i,
	input				regwrite_i,
	input				jump_i,
	input		[3:0] 	alucontrol_i,
	output				overflow_o,
	output				zero_o,
	output		[31:0] 	pc_o,
	input		[31:0] 	instr_i,
	output		[31:0] 	aluout_o,
	output		[31:0] 	writedata_o,
	input		[31:0] 	readdata_i,
	//
	input		[4:0] 	ra_debug_i,
	output		[31:0] 	ra_debug_data_o,
	
    output [31:0] inside
    );
	wire clk=clk_i;
	wire rst=rst_n;
	wire pc_run_en=pc_run_en_i;
	wire pc_clr=pc_clr_i;
	wire memtoreg=memtoreg_i;
	wire pcsrc=pcsrc_i;
	wire alusrc=alusrc_i;
	wire regdst=regdst_i;
	wire regwrite=regwrite_i;
	wire jump=jump_i;
	wire [3:0] alucontrol=alucontrol_i;
    wire zero;
    assign zero_o=zero;
    reg[31:0] pc;
    assign pc_o=pc;
    wire [31:0] instr=instr_i;
    wire [31:0] aluout;
    assign aluout_o=aluout;
    wire [31:0] writedata;
    assign writedata_o=writedata;
    wire [31:0] readdata=readdata_i;
    wire [4:0] ra_debug=ra_debug_i;
    wire [31:0] ra_debug_data;
    assign ra_debug_data_o=ra_debug_data;
	
	
	
	
	wire[31:0] pc_t,pcplus4;
    always @(negedge clk) begin
        if (rst==1) pc<=0;
        else begin
            if (pc_run_en==1)
               pc<=pc_t;
           
        end
    end  
    assign pcplus4=pc+4;
    wire[4:0] writereg;
    mux2 #(.WIDTH(5)) u2_mux2(
        .s(regdst),
        .d0(instr[20:16]),
        .d1(instr[15:11]),
        .y(writereg)
    );    
    
    wire[31:0] aluresult,result;
    mux2 #(.WIDTH(32)) u4_mux2(
        .s(memtoreg),
        .d0(aluresult),
        .d1(readdata),
        .y(result)
    );
    wire[31:0] srca,p_srcb;
    regfile u_regfile(
        .clk(clk),
        .we3(regwrite),
        .ra1(instr[25:21]),
        .ra2(instr[20:16]),
        .wa3(writereg),
        .wd3(result),
        .rd1(srca),
        .rd2(p_srcb),
        .ra_debug(ra_debug),
        .ra_debug_data(ra_debug_data)
    );
    assign writedata=p_srcb;
    wire[31:0] signimm;
    signext u_signext(
        .a(instr[15:0]),
        .y(signimm)
    );
    wire[31:0] srcb;
    mux2 #(.WIDTH(32)) u3_mux2(
        .s(alusrc),
        .d0(p_srcb),
        .d1(signimm),
        .y(srcb)
    );
    alu u_alu(
        .a(srca),
        .b(srcb),
        .op(alucontrol),
        .zero(zero),
        .y(aluresult)
    );
    assign inside=srcb;
    assign aluout=aluresult;
    
    wire[31:0] wire1;
    sl2 u_sl2(
        .a(signimm),
        .y(wire1)
    );
    wire[31:0] pcbranch;
    wire[31:0] pc_t1;
    assign pcbranch=wire1+pcplus4;
    mux2 #(.WIDTH(32)) u1_mux2 (
        .s(pcsrc),
        .d0(pcplus4),
        .d1(pcbranch),
        .y(pc_t1)
    );
    wire [31:0] jumps={4'b0000,((instr[25:0])<<2)};
    mux2 #(.WIDTH(32)) ux_mux2 (
        .s(jump),
        .d0(pc_t1),
        .d1(jumps),
        .y(pc_t)
    );

	

endmodule
