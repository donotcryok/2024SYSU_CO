onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib inst_mem_opt

do {wave.do}

view wave
view structure
view signals

do {inst_mem.udo}

run -all

quit -force
