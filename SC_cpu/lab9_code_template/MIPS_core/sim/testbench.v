`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: testbench
//////////////////////////////////////////////////////////////////////////////////

module testbench();
    reg clk;
    reg rst;
    wire clk_run;
    wire [31:0] writedata, dataadr;
    wire memwrite;
    wire [31:0] pc;
    wire [31:0] instr;
    reg [4:0] ra_debug;
    wire [31:0] ra_debug_data;
    // 新增信号，用于仿真数据输出
    wire [31:0] PC_plus_4, PC_branch, PC_next, PC_next_n, PC_jump;
    wire [5:0] op, funct;
    wire [31:0] aluout, rd1, rd2;
    wire memtoreg, pcsrc, alusrc, regdst, regwrite, jump, zero, overflow;
    wire [2:0] alucontrol;
    // 实例化 DUT (顶层模块)
    top dut(
        .clk(clk_run),
        .rst(rst),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite),
        .pc(pc),
        .instr(instr),
        .ra_debug(ra_debug),
        .ra_debug_data(ra_debug_data)
    );

    // 时钟分频模块实例化
    clk_div divi(
        .clk(clk),
        .rst(~rst),
        .div_clki(clk_run)
    );

    // 提取 datapath 和 controller 内部信号
    assign PC_plus_4 = dut.mips.dp.PC_plus_4;
    assign PC_branch = dut.mips.dp.PC_branch;
    assign PC_next = dut.mips.dp.PC_next;
    assign PC_next_n = dut.mips.dp.PC_next_n;
    assign PC_jump = dut.mips.dp.PC_jump;
    assign aluout = dut.mips.dp.aluout;
    assign rd1 = dut.mips.dp.srcA; // 寄存器 rs 读取数据
    assign rd2 = dut.mips.dp.srcB; // 寄存器 rt 读取数据
    assign op = instr[31:26];
    assign funct = instr[5:0];

    // 从 controller 提取控制信号
    assign memtoreg = dut.mips.c.memtoreg;
    assign pcsrc = dut.mips.c.pcsrc;
    assign alusrc = dut.mips.c.alusrc;
    assign regdst = dut.mips.c.regdst;
    assign regwrite = dut.mips.c.regwrite;
    assign jump = dut.mips.c.jump;
    assign alucontrol = dut.mips.c.alucontrol;

    // 从 ALU 提取状态信号
    assign zero = dut.mips.dp.zero;
    assign overflow = dut.mips.dp.overflow;

    // 仿真初始化
    initial begin
        ra_debug <= 5'b00010; // 设置调试寄存器地址
        rst <= 1;             // 初始复位
        #5;
        rst <= 0;             // 取消复位
    end

    // 时钟信号生成
    always begin
        clk <= 1;
        #2;
        clk <= 0;
        #2;
    end

    // 在时钟下降沿输出仿真信号
    always @(negedge clk) begin
        $display("Time: %0t | PC: %h | Instr: %h | MemWrite: %b | DataAdr: %h | WriteData: %h", 
                 $time, pc, instr, memwrite, dataadr, writedata);
        $display("PC_plus_4: %h | PC_branch: %h | PC_next: %h | PC_next_n: %h | PC_jump: %h",
                 PC_plus_4, PC_branch, PC_next, PC_next_n, PC_jump);
        $display("ALUOut: %h | MemToReg: %b | PCSrc: %b | ALUSrc: %b | RegDst: %b | RegWrite: %b | Jump: %b",
                 aluout, memtoreg, pcsrc, alusrc, regdst, regwrite, jump);
        $display("ALUControl: %b | Zero: %b | Overflow: %b | RD1: %h | RD2: %h",
                 alucontrol, zero, overflow, rd1, rd2);
        $display("Opcode: %b | Funct: %b", op, funct);

        // 检测成功条件
        if (memwrite) begin
            if (dataadr === 84 & writedata === 7) begin
                $display("Simulation succeeded: DataAdr = %h | WriteData = %h", dataadr, writedata);
            end
        end
    end
endmodule
