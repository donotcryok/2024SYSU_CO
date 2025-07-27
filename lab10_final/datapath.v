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

	input  				pc_run_en_i,//�����������
	input  				pc_clr_i,//

	input 				memtoreg_i,
	input 				pcsrc_i, 
	input				alusrc_i,
	input				regdst_i,
	input				regwrite_i,
	input				jump_i,
	input		[2:0] 	alucontrol_i,
	output				overflow_o,
	output				zero_o,
	output		[31:0] 	pc_o,
	input		[31:0] 	instr_i,
	output		[31:0] 	aluout_o,
	output		[31:0] 	writedata_o,
	input		[31:0] 	readdata_i,
	//
	input		[4:0] 	ra_debug_i,
	output		[31:0] 	ra_debug_data_o
	
//	 input wire [31:0] memaddr_actual,  // ʵ�ʷ��ʵ��ڴ��ַ
//    input wire [31:0] memrdata,        // �����ݴ洢����ȡ������
//    output wire [31:0] memrdata_actual,// ����Muxѡ����ʵ������
//    // 
//    output wire [31:0] uart_reg_o      // ���ڼĴ�����ֵ
    );
	
	//add your code here

	wire [31:0]pc_plus4;
	wire [31:0]pc_branch;
	wire [31:0]pc_next;
	wire [31:0]pc_next_n;
	wire [31:0]result;
	wire [31:0]SrcA;
	wire [31:0]SrcB;
	wire [4:0]writereg;
	wire [31:0]sign_imm;
	wire [31:0] sign_sl2;
	wire [31:0]sign_sl2_n;
	wire [31:0]PC_jump;
	//add your code here
	assign PC_jump={pc_plus4[31:28],instr_i[25:0],2'b00};
//PCģ�飺
 adder add_pc_4(//ʵ����adder,ʵ��pc+4��
    .A(pc_o),
    .B(32'd4), 
    .S(pc_plus4)
    );
    
 adder add_pc_branch(//ʵ����adder,ʵ��pc branch
     .A(sign_sl2),
     .B(pc_plus4),
     .S(pc_branch)
     );
//regfileģ�飺
regfile registers(
	.clk_i(clk_i),
	.ra1_i(instr_i[25:21]),
	.ra2_i(instr_i[20:16]),
	.wa3_i(writereg),
    .we3_i(regwrite_i),
    .wd3_i(result),
    .rd1_o(SrcA),
    .rd2_o(writedata_o),
	. ra_dbg_i(ra_debug_i),
	.rd_dbg_o(ra_debug_data_o)
	);
	
//	regfile extern_register(
//	.clk_i(clk_i),
//	.ra1_i(instr_i[25:21]),
//	.ra2_i(instr_i[20:16]),
//	.wa3_i(writereg),
//    .we3_i(regwrite_i),
//    .wd3_i(result),
//    .rd1_o(SrcA),
//    .rd2_o(writedata_o),
//	.wa_dbg_i(ra_debug_i),
//	.wd_dbg_i(ra_debug_data_o)
//	);
	
//aluģ�飺
alu ALU(
    .zero(zero_o),
    .overflow(overflow_o),
    .a(SrcA),
    .b(SrcB),
    .y( aluout_o),
    .op( alucontrol_i)
 );

 //PC'->PC
 flopr #(.WIDTH (32)) F(
    .clk_i(clk_i),
    .rst_n(rst_n),
    .d(pc_next),
    .q(pc_o)
 );
//sign extendģ��
signext sign(
     .a(instr_i[15:0]),
     .y(sign_imm)
 );
//muxģ��
mux2 #(.WIDTH (5))MUX_1(
    .din0(instr_i[20:16]),
    .din1(instr_i[15:11]),
    .dout(writereg),
    .sel_i(regdst_i)
);

mux2 #(.WIDTH (32))MUX_2(
    .din0(writedata_o),
    .din1(sign_imm),
    .dout(SrcB),
    .sel_i(alusrc_i)
);

mux2#(.WIDTH (32)) MUX_3(
    .din0( aluout_o),
    .din1(readdata_i),
    .dout(result),
    .sel_i( memtoreg_i)
);

 mux2 #(.WIDTH (32))MUX_4(
    .din0(pc_plus4),
    .din1(pc_branch),
    .dout(pc_next_n),
    .sel_i( pcsrc_i)
);
 mux2 #(.WIDTH (32))MUX_5(
    .din0(pc_next_n),
    .din1(PC_jump),
    .dout(pc_next),
    .sel_i( jump_i)
);

sl2 SL2(
     .a(sign_imm),
     .y(sign_sl2)
);     
    

endmodule

	

