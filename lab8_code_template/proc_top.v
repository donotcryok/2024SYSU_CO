`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/24 19:04:27
// Design Name: 
// Module Name: proc_top
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


module proc_top(
    input   clk_i,
    input   rst_n,

    input   rx_i,
    output  tx_o
);

    wire            clk_run;

    wire     [31:0]  pc;

    wire            pc_run_en;
    wire            pc_clr;

    wire            pcsrc;
    wire            jump;

    wire    [10:0]  monitor_list;
    wire            pc_ov;

    wire            branch;

    wire    [2:0]   alucontrol;
    wire            alusrc;
    wire            zero;
    
    wire            regwrite;
    wire            regdst;
    wire            memtoreg;

    wire            memwrite;
    
    wire   [31:0]   instr;

    // clk divide
    clk_div divi(
        .clk(clk_i),
        .rst(rst_n),
        .div_clki(clk_run)
    );
    

    // PC
    assign branch=0;
    assign zero=0;
    PC pc_count(
        .clk(clk_run),
        .Proc_run_en(pc_run_en),
        .Proc_reset(pc_clr),
        .pc_o(pc)
    );

    

    // inst rom
    inst_rom ROM (
      .clka(clk_run),    // input wire clka
      .ena(pc_run_en),      // input wire ena
      .addra(pc[7:2]),  // input wire [5: 0] addra
      .douta(instr)  // output wire [31 : 0] douta
    );


    // controller
    controller damn(
	.op_i(instr[31:26]),
	.funct_i(instr[5:0]),//[5:0]	
	.zero_i(zero),
	.memtoreg_o(memtoreg),
	.memwrite_o(memwrite),
	.pcsrc_o(pcsrc),
	.alusrc_o(alusrc),
	.regdst_o(regdst),
	.regwrite_o(regwrite),
	.jump_o(jump),
	.alucontrol_o(alucontrol)//[2:0]
);

    // ALU

    // uart monitor

    assign monitor_list = {memtoreg, memwrite, pcsrc, alusrc, regdst, regwrite, jump, branch, alucontrol};

    sys_monitor #(
        .monitor_len            (11),   // monitor list length
        .RX_byte                (1),    // RX recvice length
        .TX_byte                (4)     // TX send length
    )u_sys_monitor(
        .clk_i                  (clk_i                  ),  // 50Mhz clock, from board
        .rst_n                  (rst_n                  ),  // Reset, low active
        .clk_run_i              (clk_run                ),  // User define clock, from clk_div
        .rx_i                   (rx_i                   ),  
        .tx_o                   (tx_o                   ),
        .monitor_list_i         (monitor_list           ),  // monitor list
        .pc_i                   (pc[7:0]                ),  // PC point, use low 8 bit
        .proc_cur_inst_i        (instr                  ),  // current instrction(not used)
        .proc_inst_print_req_o  (                       ),  // request print instruction(not used)
        .proc_run_en_o          (pc_run_en              ),  // process run enable, high active
        .proc_reset_o           (pc_clr                 ),  // PC reset, high active
        .pc_ov_i                (pc_ov                  ),  // PC overflow, high active
        .proc_break_point_set_o (                       ),  // break point set(not used)
        .proc_break_point_pc_o  (                       )   // break point point(not used)
    );
    
    // watchdog
    assign pc_ov = (pc[7:2] == 6'h12);  // set PC overflow point, same as instruction num

endmodule
