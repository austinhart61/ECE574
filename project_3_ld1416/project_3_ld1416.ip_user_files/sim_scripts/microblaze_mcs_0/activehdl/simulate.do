onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+microblaze_mcs_0 -L xil_defaultlib -L xpm -L microblaze_v11_0_1 -L lib_cdc_v1_0_2 -L proc_sys_reset_v5_0_13 -L lmb_v10_v3_0_9 -L lmb_bram_if_cntlr_v4_0_16 -L blk_mem_gen_v8_4_3 -L iomodule_v3_1_4 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.microblaze_mcs_0 xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {microblaze_mcs_0.udo}

run -all

endsim

quit -force
