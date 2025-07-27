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

	output 				memtoreg_o,
	output 				memwrite_o,
	output				branch_o,
	output				alusrc_o,
	output 				regdst_o,
	output 				regwrite_o,
	output 				jump_o,
	output 		[2:0] 	aluop_o
    );
    wire[5:0] op;
    reg regwrite,regdst,alusrc,branch,memwrite,memtoreg,jump;
    reg [2:0] aluop;
    assign op=op_i;
    assign regwrite_o=regwrite;
    assign regdst_o=regdst;
    assign alusrc_o=alusrc;
    assign branch_o=branch;
    assign memwrite_o=memwrite;
    assign memtoreg_o=memtoreg;
    assign jump_o=jump;
    assign aluop_o=aluop;
	//add your code here according to lab 7
        always @(*) begin
        case (op)
            6'b000000: begin
                regwrite        =      1;
                regdst          =      1;
                alusrc          =      0;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b010;
            end
            6'b100011: begin
                regwrite        =      1;
                regdst          =      0;
                alusrc          =      1;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      1;
                jump            =      0;
                aluop           =      3'b000;
            end 
            6'b101011: begin
                regwrite        =      0;
                regdst          =      0;
                alusrc          =      1;
                branch          =      0;
                memwrite        =      1;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b000;
            end
            6'b000100: begin
                regwrite        =      0;
                regdst          =      0;
                alusrc          =      0;
                branch          =      1;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b001;
            end
            6'b001000: begin
                regwrite        =      1;
                regdst          =      0;
                alusrc          =      1;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b000;
            end
            
            6'b001100: begin
                regwrite        =      1;
                regdst          =      0;
                alusrc          =      1;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b101;
            end
            6'b001111: begin
                regwrite = 1;
                regdst = 0;
                alusrc = 1;
                branch = 0;
                memwrite = 0;
                memtoreg = 0;
                jump = 0;
                aluop = 3'b011;
            end
            6'b001101: begin
                regwrite        =      1;
                regdst          =      0;
                alusrc          =      1;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      0;
                aluop           =      3'b100;
            end
            default: begin
                regwrite        =      0;
                regdst          =      0;
                alusrc          =      0;
                branch          =      0;
                memwrite        =      0;
                memtoreg        =      0;
                jump            =      1;
                aluop           =      3'b000;
            end
        endcase
	end



endmodule
