`timescale 1ns / 1ps
//`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: SYSU
// Engineer: Kafuuchino
// 
// Create Date: 2024/11/18 17:25:17
// Design Name: 
// Module Name: alu
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

module alu(
	input wire[31:0] a,b,
	input wire[3:0] op,
	output reg[31:0] y,
	output reg overflow,
	output wire zero
    );

	wire[31:0] s,bout;
	assign bout = op[2] ? ~b : b;
	assign s = a + bout + op[2];
	always @(*) begin
		case (op[3:0])
			4'b0000: y <=( a & b );
			4'b0001: y <=( a | b );
			4'b0010: y <=( a + b );
		    4'b0110: y <= (a-b);
		    4'b0111: 
		         y <= ((a^(1<<31))<(b^(1<<31))); 
		    4'b0011: y <= (b<<a);
		    4'b0101: y <= (a^b);
		    4'b0100: 
		             y <= (b[31]==0) ? (b>>a) : ((b>>a) | (((1<<a)-1)<<(32-a)));
		    4'b1000:
		          y <= (b<<16);
		    4'b1001:
		          y <= (a|(b & ((1<<16)-1)));
			default : y <= 32'b0;
		endcase	
	end
	assign zero = (y == 32'b0);
/*
	always @(*) begin
		case (op[2:1])
			2'b01:overflow <= a[31] & b[31] & ~s[31] |
							~a[31] & ~b[31] & s[31];
			2'b11:overflow <= ~a[31] & b[31] & s[31] |
							a[31] & ~b[31] & ~s[31];
			default : overflow <= 1'b0;
		endcase	
	end*/
endmodule


    
