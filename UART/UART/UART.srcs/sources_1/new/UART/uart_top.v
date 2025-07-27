// Copyright 2017 ETH Zurich and University of Bologna.
// -- Adaptable modifications made for hbirdv2 SoC. -- 
// Copyright 2020 Nuclei System Technology, Inc.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License�?); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS�? BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module uart_top#(
    parameter                          baudrate = 115200
)(
    input  wire                        CLK,
    input  wire                        RSTN,
    
    input  wire                        rx_i,     // Receiver input
    output wire                        tx_o      // Transmitter output

);

    localparam  baud_div = 434 ;

    // receive buffer register, read only
    wire [7:0]  rx_data;
    wire [7:0]  tx_data;
    // parity error
    wire        parity_error;
    wire [3:0]  IIR_o;
    reg  [3:0]  clr_int;
    // tx flow control
    wire        tx_ready;
    // rx flow control

    wire        rx_valid;


    reg         fifo_tx_valid;
    reg         tx_valid;
    wire        fifo_rx_valid;
    reg         fifo_rx_ready;
    wire        rx_ready;

    wire        fifo_wren;
    wire        fifo_rden;
    wire        fifo_full;
    wire        fifo_empty;


    uart_rx u_uart_rx(
        .clk_i            ( CLK                                                      ),
        .rstn_i           ( RSTN                                                     ),
        .rx_i             ( rx_i                                                     ),
        .cfg_en_i         ( 1'b1 ),     // 串口模块使能
        .cfg_div_i        ( 16'd0431 ), // 每一位数据接收需要的周期�?
        .cfg_parity_en_i  ( 1'b0 ),     // 奇偶校验使能
        .cfg_parity_sel_i ( 2'b00 ),    // 奇偶校验类型使能
        .cfg_bits_i       ( 2'b11 ),    // 数据位�?�择�?2'b00 -> 5bit, 2'b01 -> 6bit, 2'b10 -> 7bit, 2'b11 -> 8bit
        // .cfg_stop_bits_i    ( regs_q[(LCR * 8) + 2]                               ),
        .busy_o           (                                                          ),
        .err_o            ( parity_error                                             ),
        .err_clr_i        ( 1'b0                                                     ),
        .rx_data_o        ( rx_data                                                  ),
        .rx_valid_o       ( rx_valid                                                 ),
        .rx_ready_i       ( rx_ready                                                 )
    );

    uart_tx u_uart_tx(
        .clk_i            ( CLK                                                      ),
        .rstn_i           ( RSTN                                                     ),
        .tx_o             ( tx_o                                                     ),
        .busy_o           (                                                          ),
        .cfg_en_i         ( 1'b1 ),     // 串口模块使能
        .cfg_div_i        ( 16'd0431 ), // 每一位数据接收需要的周期�?
        .cfg_parity_en_i  ( 1'b0 ),     // 奇偶校验使能
        .cfg_parity_sel_i ( 2'b00 ),    // 奇偶校验类型使能
        .cfg_bits_i       ( 2'b11 ),    // 数据位�?�择�?2'b00 -> 5bit, 2'b01 -> 6bit, 2'b10 -> 7bit, 2'b11 -> 8bit
        .cfg_stop_bits_i  ( 1'b1 ),     // 是否有停止位
        .tx_data_i        ( tx_data                                                  ),
        .tx_valid_i       ( tx_valid                                                 ),
        .tx_ready_o       ( tx_ready                                                 )
    );

    // loop

    fifo_8b u_fifo_8b (
        .clk(CLK),      // input wire clk
        .srst(~RSTN),    // input wire srst
        .din(rx_data),      // input wire [7 : 0] din
        .wr_en(fifo_wren),  // input wire wr_en
        .rd_en(fifo_rden),  // input wire rd_en
        .dout(tx_data),    // output wire [7 : 0] dout
        .full(fifo_full),    // output wire full
        .empty(fifo_empty)  // output wire empty
    );

    // your code here
    assign fifo_wren = rx_valid && ~fifo_full;
    assign fifo_rden = ~fifo_empty && tx_ready;
    always @(posedge CLK or negedge RSTN)
        if (!RSTN)
            tx_valid <= 1'b0;
        else
            tx_valid <= fifo_rden;
    assign rx_ready = ~fifo_full;
    // your code end

endmodule