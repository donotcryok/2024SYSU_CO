`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/15 11:01:18
// Design Name: 
// Module Name: lab_1
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


module lab_1(
    input        clk  ,
    input        rstn ,
    input         sw1,
    output[2:0]  led
    );
 
    reg[2:0]     r_led;
    assign led = r_led;
    reg[24:0]    cnt  ;
 
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cnt <= 0;
        else if(cnt == 25_000_000-1)
            cnt <= 0;
        else
            cnt <= cnt + 1'd1;
        
    end
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            r_led <= 3'b001;
        else if(cnt ==  25_000_000-1)
            if(sw1)
            r_led <= {r_led[1:0],r_led[2]};
            else if(~sw1)
            r_led <= {r_led[0],r_led[2:1]};
        else
            r_led <= r_led;
    end
endmodule
