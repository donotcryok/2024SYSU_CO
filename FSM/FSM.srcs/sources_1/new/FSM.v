`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 11:35:07
// Design Name: 
// Module Name: FSM
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


module FSM(
    input clk,       // �����ź� `clk`����ʾʱ���źţ�FSM ״̬����ÿ��ʱ�������ظ���
    input rst,       // �����ź� `rst`����ʾ��λ�źţ��� `rst` Ϊ��ʱ��FSM �ᱻ��λ����ʼ״̬
    input x,         // �����ź� `x`����ʾFSM�����룬����״̬��ת��
    output reg bool  // ��� `bool`
);
    
    localparam A=0,  B=1, C=2,  D=3,  E=4;  //  FSM �е����״̬��A, B, C, D, E
    
    reg [2:0] state, nxtstate;  //�������� 3 λ�ļĴ�����ʾ5��״̬
   
always @ (posedge clk) begin
    if(rst) begin
        state<=A;  // ��� `rst` �ź���Ч���ߵ�ƽ����FSM ����λ����ʼ״̬ `A`
    end 
    else begin
        state <=nxtstate; // ����FSM ����ʱ�������ؽ� `nxtstate` ����Ϊ��ǰ״̬ `state`
    end
end

      
always@ (*) begin
    bool=0;  // Ĭ������£�`bool` ���������Ϊ 0

    case(state)
    A: if(x) nxtstate=B;  
        else nxtstate=A;// �����ǰ״̬�� A �������ź� `x` Ϊ 1������һ��״̬Ϊ B�����򱣳���״̬ A
    B: if(x) nxtstate=B;  
        else nxtstate=C;// �����ǰ״̬�� B �� `x` Ϊ 1���򱣳��� B ״̬�����򣬽���״̬ C
    C: if(x) nxtstate=D;  
        else nxtstate=A;// �����ǰ״̬�� C �� `x` Ϊ 1�������״̬ D�����򣬷���״̬ A
    D: if(x) nxtstate=E;  
        else nxtstate=C;// �����ǰ״̬�� D �� `x` Ϊ 1�������״̬ E�����򣬷���״̬ C
    E: begin
        bool=1;// ������״̬ E ʱ��`lock` �źű�����Ϊ 1����ʾ����״̬��
        if(x) nxtstate=B;  
        else nxtstate=C;  // ��� `x` Ϊ 1������һ��״̬Ϊ B��������һ��״̬Ϊ C
    end
    default: begin 
        bool=1'bX;  // ���״̬�������`lock` ������Ϊδֵ֪ X
        nxtstate=3'bX;// ���״̬�������`nxtstate` ������Ϊδֵ֪ X
    end
    endcase
end
endmodule
