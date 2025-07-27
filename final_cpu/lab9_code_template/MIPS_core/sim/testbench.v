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
	reg clk;
	reg rst;

    wire clk_run;
	wire[31:0] writedata,dataadr;
	wire memwrite;
	wire [31:0]pc;
	wire [31:0]instr;
    reg[4:0] ra_debug;
	wire[31:0] ra_debug_data;
	
	top dut(clk_run,rst,writedata,dataadr,memwrite,pc,instr,ra_debug,ra_debug_data);
	
    clk_div divi(
        .clk(clk),
        .rst(~rst),
        .div_clki(clk_run)
    );
	initial begin 
	    ra_debug<=5'b00010;
		rst <= 1;
		#5;
		rst <= 0;
		#2000 $stop;
	end

	always begin
		clk <= 1;
		#2;
		clk <= 0;
		#2;
	
	end

	always @(negedge clk) begin
		if(memwrite) begin
			if(dataadr === 84 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end
		end
	end
endmodule
