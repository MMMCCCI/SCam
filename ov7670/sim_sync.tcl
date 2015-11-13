vlib work

# compile files

vcom -93 -explicit sync.vhd 
vcom -93 -explicit tb_sync.vhd

# start simulation

vsim -novopt tb_sync
view wave

add wave tb_sync/s0/*

# run simulation
run 1000 ns 
