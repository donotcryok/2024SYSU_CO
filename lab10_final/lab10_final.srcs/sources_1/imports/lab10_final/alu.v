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
    input[31:0] A_i,  // 32λ���� A
    input[31:0] B_i,  // 32λ���� B
    input[2:0] op_i,  // 3λ������
    output reg[31:0] result_o, // 32λ������
    output Z,       // ���Ϊ0���1
    output C,       // CARRY��������λ���λʱΪ1������Ϊ0
    output V,       // OVERFLOW���з������ʱΪ1������Ϊ0
    output N        // ���Ϊ����ʱΪ1������Ϊ0
);

    reg z;
    reg c, v, n;

    always @(*) begin
        case (op_i)
            3'b010: begin  // �ӷ�
                {c, result_o} = A_i + B_i; // �ӷ����������ǽ�λ
            end
            3'b110: begin  // ����
                {c, result_o} = A_i - B_i; // �������������ǽ�λ
            end
            3'b000: begin  // ��λ��
                result_o = A_i & B_i;
            end
            3'b001: begin  // ��λ��
                result_o = A_i | B_i;
            end
            3'b111: begin  // С�ڱȽ�
                result_o = ($signed(A_i) < $signed(B_i)) ? 1'b1 : 1'b0;
            end
            3'b101: begin  // �߼����ƣ�SRLV��
                result_o = A_i >> B_i[4:0]; // ȡ��5λ��Ϊ��λλ��
                c = A_i[31]; // CARRY��־ȡ���λ
            end
            3'b100: begin  // �߼����ƣ�SLLV��
                result_o = A_i << B_i[4:0]; // ȡ��5λ��Ϊ��λλ��
                c = A_i[31]; // CARRY��־ȡ���λ
            end
            default: begin
                result_o = 32'b0; // Ĭ����������0
            end
        endcase

        // ���ø���־λ
        z = (result_o == 32'b0);  // Z��־�����Ϊ0ʱΪ1
        n = result_o[31];  // N��־��������λΪ1ʱΪ1�������Ϊ����
        v = ((op_i == 3'b010 || op_i == 3'b110) && // �ӷ����������
             (A_i[31] == B_i[31] && A_i[31] != result_o[31])); // �ж��Ƿ����

    end

    // �����־λ
    assign Z = z;
    assign C = c;
    assign N = n;
    assign V = v;

endmodule
