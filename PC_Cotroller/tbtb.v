`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/27 20:48:13
// Design Name: 
// Module Name: tbtb
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


module tbtb(

    );
reg clk;
    reg rst;
    reg ena;
    reg rr;
//proc_top tb(
//    .clk_i(clk),
//    .rst_n(rst),
//    .rx_i(),
//    .tx_o()
//);
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
        .clk(clk),
        .rst(rst),
        .div_clki(clk_run)
    );
    
    assign branch=0;
    assign zero=0;
    // PC
    assign pc_run_en=ena;
    assign pc_clr=rr;
    PC pc_count(
        .clk(clk_run),
//        .rst(rst_n),
        .Proc_run_en(pc_run_en),
        .Proc_reset(pc_clr),
        .pc_o(pc)
    );

    

    // inst rom
    inst_rom ROM (
      .clka(clk_run),    // input wire clka
      .ena(pc_run_en),      // input wire ena
      .addra(pc[7:2]),  // input wire [5 : 0] addra
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
    assign pc_ov = (pc[7:2] == 6'h12);
always begin
        #1 clk = ~clk;
    end

initial begin
    clk = 0;
    rst = 0;
    ena = 0;
    rr = 0;
    #5 rst = 1;
    #5 rr = 1;
    #1 rr = 0;
    #5 ena = 1;
    #5000 $stop;
end

endmodule
