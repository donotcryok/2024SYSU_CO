vlib work
vlib activehdl

vlib activehdl/blk_mem_gen_v8_4_4
vlib activehdl/xil_defaultlib

vmap blk_mem_gen_v8_4_4 activehdl/blk_mem_gen_v8_4_4
vmap xil_defaultlib activehdl/xil_defaultlib

vlog -work blk_mem_gen_v8_4_4  -v2k5 \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../ROM.srcs/sources_1/ip/inst_rom/sim/inst_rom.v" \


vlog -work xil_defaultlib \
"glbl.v"

