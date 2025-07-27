`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/11/07 13:54:42
// Design Name: 
// Module Name: testbench
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


module testbench();

	localparam 			period = 10;

	reg 				clk;
	reg 				rst_n;

	reg 				pc_run_en;
	reg 				pc_clr;

	reg  				pc_run_hold;

	wire 	[31:0]		pc;
	wire 				pc_ov;

	wire  	[31:0]		instr_num;

	wire   	[10:0]		monitor_list;
	wire 	[31:0]		instr;
	wire [31:0]pc_plus4;
	wire [31:0]pc_next;
	wire [31:0]pc_jump;
	wire [31:0]pc_next_n;
	wire jump;
	wire [31:0]pc_branch;
	wire[31:0]instr;
	wire pcsrc;
	wire branch;
	wire zero;
	wire [2:0]alucontrol;
	wire [31:0]srcA,srcB;
	wire memtoreg;
	
	assign memtoreg=dut.u_mips.memtoreg;
	
	assign alucontrol=dut.u_mips.u_datapath.alucontrol_i;
	assign srcA=dut.u_mips.u_datapath.SrcA;
	assign srcB=dut.u_mips.u_datapath.SrcB;
	assign zero=dut.u_mips.zero;
	
	assign pcsrc=dut.u_mips.u_datapath.pcsrc_i;
	assign branch=dut.u_mips.u_controller.branch;
    assign instr=dut.instr;
	assign jump=dut.u_mips.u_datapath.jump_i;
	assign pc_next=dut.u_mips.u_datapath.pc_next;
	assign pc_next_n=dut.u_mips.u_datapath.pc_next_n;
	assign pc_plus4=dut.u_mips.u_datapath.pc_plus4;
	assign pc_jump=dut.u_mips.u_datapath.PC_jump;
	assign pc_branch=dut.u_mips.u_datapath.pc_branch;
	assign instr_num = 32'h12;

	top dut(
		.clk_i             (clk               ),
		.rst_n             (rst_n             ),
		.pc_run_en_i       (pc_run_hold),
		.pc_clr_i          (pc_clr),
		.pc_o              (pc),
		.monitor_list_o    (monitor_list),
		.instr_o           (instr),
		.ra_debug_i        (5'h0),
		.ra_debug_data_o   (),
		.uart_reg_i        (32'h12345678),
		.mem_debug_rden_i  (1'b0),
		.mem_debug_addr_i  (14'h0),
		.mem_debug_rdata_o ()
	);
	

	initial begin 
		clk = 1'b1;
		rst_n = 1'b1;
		pc_run_en = 1'b0;
		pc_clr = 1'b0;		
		pc_run_en = 1'b1;
		#25;
		rst_n = 1'b0;

		#(period*2)


		#(period*20)
		pc_run_en = 1'b0;
		pc_clr = 1'b1;

		#(period)
		pc_clr = 1'b0;

	end

	always #(period/2) clk = ~clk;

	assign pc_ov = (pc[31:2] == instr_num[29:0]);

	always @(posedge clk or negedge rst_n) begin
        if(rst_n) begin
            pc_run_hold	<= 'b0;
        end else begin
            casex({pc_ov, pc_run_en})
                2'b00:
                    pc_run_hold <= pc_run_hold;
                2'b01:
                    pc_run_hold	<= 1'b1;
                2'b1x:
                    pc_run_hold	<= 1'b0;
            endcase
        end
    end


endmodule
