`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/26 23:04:42
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
//    input rst,
    input Proc_run_en,
    input Proc_reset,
    output reg [31:0] pc_o
    );
    initial begin
        pc_o<=32'b0;
    end
    
    always @(posedge clk or posedge Proc_reset) begin
        if(Proc_reset==1) pc_o<=32'b0;
        else if(Proc_run_en==1) pc_o<=pc_o+4;
    end
endmodule
