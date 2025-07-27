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
    input[31:0] A_i,  // 32位输入 A
    input[31:0] B_i,  // 32位输入 B
    input[2:0] op_i,  // 3位操作码
    output reg[31:0] result_o, // 32位输出结果
    output Z,       // 结果为0输出1
    output C,       // CARRY：产生进位或借位时为1，否则为0
    output V,       // OVERFLOW：有符号溢出时为1，否则为0
    output N        // 结果为负数时为1，否则为0
);

    reg z;
    reg c, v, n;

    always @(*) begin
        case (op_i)
            3'b010: begin  // 加法
                {c, result_o} = A_i + B_i; // 加法操作，考虑进位
            end
            3'b110: begin  // 减法
                {c, result_o} = A_i - B_i; // 减法操作，考虑借位
            end
            3'b000: begin  // 按位与
                result_o = A_i & B_i;
            end
            3'b001: begin  // 按位或
                result_o = A_i | B_i;
            end
            3'b111: begin  // 小于比较
                result_o = ($signed(A_i) < $signed(B_i)) ? 1'b1 : 1'b0;
            end
            3'b101: begin  // 逻辑右移（SRLV）
                result_o = A_i >> B_i[4:0]; // 取低5位作为移位位数
                c = A_i[31]; // CARRY标志取最高位
            end
            3'b100: begin  // 逻辑左移（SLLV）
                result_o = A_i << B_i[4:0]; // 取低5位作为移位位数
                c = A_i[31]; // CARRY标志取最高位
            end
            default: begin
                result_o = 32'b0; // 默认情况下输出0
            end
        endcase

        // 设置各标志位
        z = (result_o == 32'b0);  // Z标志：结果为0时为1
        n = result_o[31];  // N标志：结果最高位为1时为1，即结果为负数
        v = ((op_i == 3'b010 || op_i == 3'b110) && // 加法或减法操作
             (A_i[31] == B_i[31] && A_i[31] != result_o[31])); // 判断是否溢出

    end

    // 输出标志位
    assign Z = z;
    assign C = c;
    assign N = n;
    assign V = v;

endmodule
