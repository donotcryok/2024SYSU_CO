`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 10:57:24
// Design Name: 
// Module Name: clk_div
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

module clk_div(
    input clk,
    input rst,
    output reg div_clki
);
    reg [5:0] count;        // ������
    reg rst_sync;           // ͬ����ĸ�λ�ź�

    // ��λͬ���߼�
    always @(posedge clk) begin
        rst_sync <= rst;    // ����λ�ź�ͬ����ʱ����
    end

    // ��ʱ���߼�
    always @(posedge clk) begin
        if (~rst_sync) begin
            count <= 0;     // ���������
            div_clki <= 0;   // �����Ƶ�ź�
        end else begin
            if (count == 24) begin
                div_clki <= ~div_clki; // ��ת��Ƶ�ź�
                count <= 0;         // ���������
            end else begin
                count <= count + 1; // ����������
            end
        end
    end
endmodule

