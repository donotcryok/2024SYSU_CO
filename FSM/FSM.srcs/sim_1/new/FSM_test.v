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
 );//实例化
 
initial clk=0;  // 初始化时钟信号 `clk` 为 0
always #5 clk=~clk;  // 每 5 个时间单位翻转一次 `clk` 信号，生成时钟信号

 initial begin
    rst=1;  // 初始化复位信号 `rst` 为 1
    #10;  
    rst=0;  // 在 10 个时间单位后，复位信号 `rst` 设为 0

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
    #200;// 等待 200 个时间单位，观察结果
    $stop;  // 停止仿真
    end
endmodule
