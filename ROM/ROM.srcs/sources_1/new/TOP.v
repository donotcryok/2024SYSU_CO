`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/16 23:23:47
// Design Name: 
// Module Name: TOP
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
module TOP(
    input  wire                        clk_i,
    input  wire                        rst_n,
    
    input  wire                        rx_i,     // Receiver input
    output wire                        tx_o      // Transmitter output

);

    reg tx_valid, rx_ready;

    wire rx_valid, tx_ready;
    wire[7:0] rx_data;
    wire[31:0] tx_data;
   
    uart_top u_uart_top(
    .clk_i       (clk_i       ),
    .rst_n       (rst_n       ),
    .rx_i        (rx_i        ),
    .tx_o        (tx_o        ),
    .tx_valid_i  (tx_valid ),
    .tx_ready_o  (tx_ready    ),
    .tx_data_i   (tx_data     ),
    .rx_valid_o  (rx_valid  ),
    .rx_ready_i  (rx_ready    ),
    .rx_data_i   (rx_data     )
);

inst_rom tired(
  .clka(clk_i),    // input wire clka
  .ena(rst_n),      // input wire ena
  .addra(rx_data),  // input wire [7 : 0] addra
  .douta(tx_data)  // output wire [31 : 0] douta
);

always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) begin
            tx_valid <= 1'b0;
            rx_ready <= 1'b1; // 默认接收端准备好
        end else begin
            if (rx_valid) begin
                tx_valid <= 1'b1;  // 收到数据后准备发送
            end else if (tx_ready) begin
                tx_valid <= 1'b0;  // 发送完成后清除有效信号
            end
        end
    end

endmodule
