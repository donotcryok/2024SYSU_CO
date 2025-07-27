`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 11:36:08
// Design Name: 
// Module Name: FSM_test
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


module FSM_test( 
    );
    reg clk;
    reg rst;
    reg x;
    wire bool;
 FSM  test_t(
    .clk(clk),
    .rst(rst),
    .x(x),
    .bool(bool)
 );//ʵ����
 
initial clk=0;  // ��ʼ��ʱ���ź� `clk` Ϊ 0
always #5 clk=~clk;  // ÿ 5 ��ʱ�䵥λ��תһ�� `clk` �źţ�����ʱ���ź�

 initial begin
    rst=1;  // ��ʼ����λ�ź� `rst` Ϊ 1
    #10;  
    rst=0;  // �� 10 ��ʱ�䵥λ�󣬸�λ�ź� `rst` ��Ϊ 0

    #5  x=1;
    #10 x=1;
    #10 x=1;
    #10 x=0;
    #10 x=1;
    #10 x=1;
    #10 x=0;
    #10 x=1;
    #10 x=1;
    #10 x=0;
    #10 x=1;
    #10 x=1;
    #10 x=1;
    #10 x=0;
    #10 x=1;
    #10 x=1;
    #200;// �ȴ� 200 ��ʱ�䵥λ���۲���
    $stop;  // ֹͣ����
    end
endmodule
