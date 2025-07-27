`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/19 11:16:10
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
    input[31:0] A_i,  //32位
    input[31:0] B_i,  //32位
    input[2:0] op_i, //3位
    output reg[31:0] result_o, //32位
    output Z,       //结果为0输出1
    output C,       //CARRY：Set to 1 if a carry or borrow occurs; otherwise, it is 0.
    output V,       //OVERFLOW:Set to 1 if the operation results in a signed overflow, meaning the result is too large to be represented in the available number of bits; otherwise, it is 0.
    output N      // Set to 1 if the result of the operation is negative; otherwise, it is 0.
    );
        reg z;   
    always@(*) begin
        case(op_i)  
        3'b000: result_o=A_i+B_i;
        3'b001: result_o=A_i-B_i;
        3'b010: result_o=A_i & B_i;
        3'b011: result_o=A_i | B_i;
        3'b100: result_o=~A_i;
        3'b101: result_o=($signed(A_i) < $signed(B_i)) ? 1'b1 : 1'b0;
        default: result_o= 0;
        endcase
        if(result_o) z<=0;
        else z<=1;
      end
      assign Z=z;
endmodule
