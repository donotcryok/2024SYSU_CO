// Copyright 2017 ETH Zurich and University of Bologna.
// -- Adaptable modifications made for hbirdv2 SoC. -- 
// Copyright 2020 Nuclei System Technology, Inc.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.

module uart_top#(
    parameter                           baudrate = 115200
)(
    input  wire                         clk_i,
    input  wire                         rst_n,
    
    input  wire                         rx_i,     // Receiver input
    output wire                         tx_o,     // Transmitter output

    input  wire                         tx_valid_i,
    output wire                         tx_ready_o,
    input  wire [31:0]                  tx_data_i,

    output wire                         rx_valid_o,
    input  wire                         rx_ready_i,
    output wire [7:0]                   rx_data_i

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
    // wire        tx_ready;
    // rx flow control

    // wire        rx_valid;


    reg         fifo_tx_valid;
    reg         tx_valid;
    wire        fifo_rx_valid;
    reg         fifo_rx_ready;
    wire        rx_ready;

    wire        fifo_wren;
    wire        fifo_rden;
    wire        fifo_full;
    wire        fifo_empty;

    reg         inner_tx_valid;
    wire        inner_tx_ready;
    wire  [7:0] inner_tx_data;
    
//    uart_top u_uart_top(
//    .clk_i       (clk_i       ),
//    .rst_n       (rst_n       ),
//    .rx_i        (rx_i        ),
//    .tx_o        (tx_o        ),
//    .tx_valid_i  (tx_valid    ),
//    .tx_ready_o  (tx_ready    ),
//    .tx_data_i   (tx_data     ),
//    .rx_valid_o  (rx_valid    ),
//    .rx_ready_i  (rx_ready    ),
//    .rx_data_i   (rx_data     )
//);
//inst_rom tired(
//  .clka(clk_i),    // input wire clka
//  .ena(~rst_n),      // input wire ena
//  .addra(rx_data_i),  // input wire [7 : 0] addra
//  .douta(tx_data_i)  // output wire [31 : 0] douta
//);


    uart_rx u_uart_rx(
        .clk_i            ( clk_i                                                      ),
        .rstn_i           ( rst_n                                                     ),
        .rx_i             ( rx_i                                                     ),
        .cfg_en_i         ( 1'b1 ),     
        .cfg_div_i        ( 16'd0431 ), 
        .cfg_parity_en_i  ( 1'b0 ),     
        .cfg_parity_sel_i ( 2'b00 ),    
        .cfg_bits_i       ( 2'b11 ),    
        // .cfg_stop_bits_i    ( regs_q[(LCR * 8) + 2]                               ),
        .busy_o           (                                                          ),
        .err_o            ( parity_error                                             ),
        .err_clr_i        ( 1'b0                                                     ),
        .rx_data_o        ( rx_data_i                                                ),
        .rx_valid_o       ( rx_valid_o                                               ),
        .rx_ready_i       ( rx_ready_i                                               )
    );

    uart_tx u_uart_tx(
        .clk_i            ( clk_i                                                      ),
        .rstn_i           ( rst_n                                                     ),
        .tx_o             ( tx_o                                                     ),
        .busy_o           (                                                          ),
        .cfg_en_i         ( 1'b1 ),     
        .cfg_div_i        ( 16'd0431 ), 
        .cfg_parity_en_i  ( 1'b0 ),     
        .cfg_parity_sel_i ( 2'b00 ),    
        .cfg_bits_i       ( 2'b11 ),    
        .cfg_stop_bits_i  ( 1'b1 ),     
        .tx_data_i        ( inner_tx_data                                                ),
        .tx_valid_i       ( inner_tx_valid                                              ),
        .tx_ready_o       ( inner_tx_ready                                             )
    );

    assign fifo_wren = tx_ready_o & tx_valid_i;
    assign tx_ready_o = ~fifo_full;

    assign fifo_rden = ~fifo_empty & inner_tx_ready & ~inner_tx_valid;

    always @(posedge clk_i or negedge rst_n) begin
        if(~rst_n) begin
            inner_tx_valid	    <= 'b0;
        end else begin
            inner_tx_valid	    <= fifo_rden;
        end
    end

    fifo_32b_2_8b u_convert_fifo (
        .clk(clk_i),      // input wire clk
        .srst(~rst_n),    // input wire srst
        .din(tx_data_i),      // input wire [31 : 0] din
        .wr_en(fifo_wren),  // input wire wr_en
        .rd_en(fifo_rden),  // input wire rd_en
        .dout(inner_tx_data),    // output wire [7 : 0] dout
        .full(fifo_full),    // output wire full
        .empty(fifo_empty)  // output wire empty
    );

endmodule