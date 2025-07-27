`timescale 1ns / 1ps

module axi_uartlite_0_exdes_tb;
//uart_top  aa(
//.CLK(clk),
//.RSTN(rst_n),
//.rx_i(rx_data),
//.tx_o(tx_data)
//);
    // Internal signals
    parameter clk_freq = 10;
    
    reg             clk;
    reg             rst_n;

    reg             tx_release;

    reg     [7:0]   rx_data;
    reg             rx_valid;
    wire            rx_ready;
    wire    [7:0]   tx_data;
    reg             tx_valid;
    reg             tx_ready;

    wire            fifo_wren;
    wire            fifo_rden;
    wire            fifo_full;
    wire            fifo_empty;
    
    // Clock process to generate clock signals
    always begin
        # (clk_freq / 2) clk = ~clk;
    end

    // Reset signals
    initial begin
        clk = 1'b1;
        rst_n = 1'b0;
        #50 rst_n = 1'b1;
    end

    // DUT instantiation
    fifo_8b u_fifo_8b (
        .clk(clk),      // input wire clk
        .srst(~rst_n),    // input wire srst
        .din(rx_data),      // input wire [7 : 0] din
        .wr_en(fifo_wren),  // input wire wr_en
        .rd_en(fifo_rden),  // input wire rd_en
        .dout(tx_data),    // output wire [7 : 0] dout
        .full(fifo_full),    // output wire full
        .empty(fifo_empty)  // output wire empty
    );

    // simulation code
    initial begin
        rx_data = 8'h25;
        rx_valid = 1'b0;
        tx_ready = 1'b1;
        tx_release = 1'b0;
        // oper after rst release
        #80 tx_release = 1'b0;

        // your code here
        #10;
        rx_valid = 1'b1;
        rx_data = 8'h12;
        #10;
        rx_valid = 1'b0;
        #10;
        // your code end

        // this signal used for release tx_ready
        #80 tx_release = 1'b1;
        #10 tx_release = 1'b0;
    end 

    always @(posedge clk) begin
        if(tx_valid)
            tx_ready <= 1'b0;
        else if (tx_release)
            tx_valid <= fifo_rden;
    end

    // loop code here
    assign fifo_wren = rx_valid && ~fifo_full;
    assign fifo_rden = ~fifo_empty && tx_ready;
    always @(posedge clk or negedge rst_n)
        if (!rst_n)
            tx_valid <= 1'b0;
        else
            tx_valid <= fifo_rden;
    assign rx_ready = ~fifo_full;
    // loop code end

endmodule
