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
	input		[5:0] 	funct_i,
	input		[2:0] 	aluop_i,
	output reg	[3:0] 	alucontrol_o
    );
	// add your code here
    always @(*) begin
        case (aluop_i) 
            3'b000: alucontrol_o=4'b0010;   //addi
            3'b001: alucontrol_o=4'b0110;   //sub
            3'b010:
             begin
                case (funct_i)
                    6'b100000: alucontrol_o=4'b0010;  //add
                    6'b100010: alucontrol_o=4'b0110;  //sub
                    6'b100100: alucontrol_o=4'b0000;  //and
                    6'b100101: alucontrol_o=4'b0001;  //or
                    6'b101010: alucontrol_o=4'b0111;  //slt
                    6'b000100: alucontrol_o=4'b0011;  //sll
                    6'b000111: alucontrol_o=4'b0100;  //sra
                    default: alucontrol_o=4'b0101;    //xor
                endcase
            end
           3'b011: alucontrol_o=4'b1000;  //lui
           3'b100: alucontrol_o=4'b1001;  //ori
           3'b101: alucontrol_o=4'b0000;  //andi
        endcase
    end

	

endmodule
