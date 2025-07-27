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
    input clk,       // 输入信号 `clk`，表示时钟信号，FSM 状态将在每个时钟上升沿更新
    input rst,       // 输入信号 `rst`，表示复位信号，当 `rst` 为高时，FSM 会被复位到初始状态
    input x,         // 输入信号 `x`，表示FSM的输入，控制状态的转换
    output reg bool  // 输出 `bool`
);
    
    localparam A=0,  B=1, C=2,  D=3,  E=4;  //  FSM 中的五个状态：A, B, C, D, E
    
    reg [2:0] state, nxtstate;  //定义两个 3 位的寄存器表示5个状态
   
always @ (posedge clk) begin
    if(rst) begin
        state<=A;  // 如果 `rst` 信号有效（高电平），FSM 被复位到初始状态 `A`
    end 
    else begin
        state <=nxtstate; // 否则，FSM 会在时钟上升沿将 `nxtstate` 更新为当前状态 `state`
    end
end

      
always@ (*) begin
    bool=0;  // 默认情况下，`bool` 输出被设置为 0

    case(state)
    A: if(x) nxtstate=B;  
        else nxtstate=A;// 如果当前状态是 A 且输入信号 `x` 为 1，则下一个状态为 B；否则保持在状态 A
    B: if(x) nxtstate=B;  
        else nxtstate=C;// 如果当前状态是 B 且 `x` 为 1，则保持在 B 状态；否则，进入状态 C
    C: if(x) nxtstate=D;  
        else nxtstate=A;// 如果当前状态是 C 且 `x` 为 1，则进入状态 D；否则，返回状态 A
    D: if(x) nxtstate=E;  
        else nxtstate=C;// 如果当前状态是 D 且 `x` 为 1，则进入状态 E；否则，返回状态 C
    E: begin
        bool=1;// 当进入状态 E 时，`lock` 信号被激活为 1（表示锁定状态）
        if(x) nxtstate=B;  
        else nxtstate=C;  // 如果 `x` 为 1，则下一个状态为 B，否则下一个状态为 C
    end
    default: begin 
        bool=1'bX;  // 如果状态意外出错，`lock` 被设置为未知值 X
        nxtstate=3'bX;// 如果状态意外出错，`nxtstate` 被设置为未知值 X
    end
    endcase
end
endmodule
