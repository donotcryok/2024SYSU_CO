`timescale 1ns / 1ps

module proc_top(
    input   clk_i,
    input   rst_n,

    input   rx_i,
    output  tx_o
);

    wire            clk_run;

    wire     [31:0]  pc;
    wire     [31:0]  instr;

    wire            pc_run_en;
    wire            pc_clr;

//    wire            pcsrc;
//    wire            jump;

    wire    [31:0]  monitor_list;   // need to revise //1
    wire    pc_ov;
    wire    [4:0]  ra_debug;
    wire    [31:0]  ra_debug_data;

    // instance your MIPS core here
    top(
    .clk(clk_run),
    .rst(pc_clr),
    .writedata(),
    .dataadr(),
    .memwrite(),
    .pc(pc),
    .instr(instr),
    //add the debug port for register file 
    .ra_debug(ra_debug),
    .ra_debug_data(ra_debug_data)
    );
    
    clk_div divi(
        .clk(clk_i),
        .rst(rst_n),
        .div_clki(clk_run)
    );

    //add your monitor singal reg_rdata_o
    assign monitor_list = {ra_debug_data};

    sys_monitor #(
        .monitor_len            (32),
        .RX_byte                (1),
        .TX_byte                (4)
    )u_sys_monitor(
        .clk_i                  (clk_i),
        .rst_n                  (rst_n),
        .clk_run_i              (clk_run),
        .rx_i                   (rx_i),
        .tx_o                   (tx_o),
        .monitor_list_i         (monitor_list),
        .pc_i                   (pc),
        .proc_cur_inst_i        (instr),
        .proc_run_en_o          (pc_run_en),
        .proc_reset_o           (pc_clr),
        .pc_ov_i                (pc_ov),
        .reg_addr_o             (ra_debug), // regfile read address
        .reg_rdata_o            (ra_debug_data)  // regfile read data
    );

    assign pc_ov = pc[7:2] == 6'h12; //need to revise the value according to your instruction length 

endmodule
