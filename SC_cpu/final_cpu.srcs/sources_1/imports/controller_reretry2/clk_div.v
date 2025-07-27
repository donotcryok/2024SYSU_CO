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
    reg [5:0] count;        // 计数器
    reg rst_sync;           // 同步后的复位信号

    // 复位同步逻辑
    always @(posedge clk) begin
        rst_sync <= rst;    // 将复位信号同步到时钟域
    end

    // 主时钟逻辑
    always @(posedge clk) begin
        if (~rst_sync) begin
            count <= 0;     // 清零计数器
            div_clki <= 0;   // 清零分频信号
        end else begin
            if (count == 24) begin
                div_clki <= ~div_clki; // 翻转分频信号
                count <= 0;         // 清零计数器
            end else begin
                count <= count + 1; // 计数器递增
            end
        end
    end
endmodule

