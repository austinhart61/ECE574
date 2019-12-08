vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/microblaze_v11_0_1
vlib modelsim_lib/msim/lib_cdc_v1_0_2
vlib modelsim_lib/msim/proc_sys_reset_v5_0_13
vlib modelsim_lib/msim/lmb_v10_v3_0_9
vlib modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_16
vlib modelsim_lib/msim/blk_mem_gen_v8_4_3
vlib modelsim_lib/msim/iomodule_v3_1_4

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap xpm modelsim_lib/msim/xpm
vmap microblaze_v11_0_1 modelsim_lib/msim/microblaze_v11_0_1
vmap lib_cdc_v1_0_2 modelsim_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 modelsim_lib/msim/proc_sys_reset_v5_0_13
vmap lmb_v10_v3_0_9 modelsim_lib/msim/lmb_v10_v3_0_9
vmap lmb_bram_if_cntlr_v4_0_16 modelsim_lib/msim/lmb_bram_if_cntlr_v4_0_16
vmap blk_mem_gen_v8_4_3 modelsim_lib/msim/blk_mem_gen_v8_4_3
vmap iomodule_v3_1_4 modelsim_lib/msim/iomodule_v3_1_4

vlog -work xil_defaultlib -64 -incr -sv \
"C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_1 -64 -93 \
"../../../ipstatic/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_0/sim/bd_fc5c_0_microblaze_I_0.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"../../../ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"../../../ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_1/sim/bd_fc5c_0_rst_0_0.vhd" \

vcom -work lmb_v10_v3_0_9 -64 -93 \
"../../../ipstatic/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_2/sim/bd_fc5c_0_ilmb_0.vhd" \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_3/sim/bd_fc5c_0_dlmb_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_16 -64 -93 \
"../../../ipstatic/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_4/sim/bd_fc5c_0_dlmb_cntlr_0.vhd" \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_5/sim/bd_fc5c_0_ilmb_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_3 -64 -incr \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 -incr \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_6/sim/bd_fc5c_0_lmb_bram_I_0.v" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_7/sim/bd_fc5c_0_second_dlmb_cntlr_0.vhd" \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_8/sim/bd_fc5c_0_second_ilmb_cntlr_0.vhd" \

vlog -work xil_defaultlib -64 -incr \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_9/sim/bd_fc5c_0_second_lmb_bram_I_0.v" \

vcom -work iomodule_v3_1_4 -64 -93 \
"../../../ipstatic/hdl/iomodule_v3_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/ip/ip_10/sim/bd_fc5c_0_iomodule_0_0.vhd" \

vlog -work xil_defaultlib -64 -incr \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/bd_0/sim/bd_fc5c_0.v" \
"../../../../project_3_ld1416.srcs/sources_1/ip/microblaze_mcs_0/sim/microblaze_mcs_0.v" \

vlog -work xil_defaultlib \
"glbl.v"

