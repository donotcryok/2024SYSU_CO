onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+u2r_cmd_fifo -L xpm -L fifo_generator_v13_2_5 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.u2r_cmd_fifo xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {u2r_cmd_fifo.udo}

run -all

endsim

quit -force
