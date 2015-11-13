vlib work

# compile files

vcom -93 -explicit linebuffer.vhd 
vcom -93 -explicit tb_linebuffer.vhd

# start simulation

vsim -novopt tb_linebuffer
view wave

add wave tb_linebuffer/lb/*

# run simulation
run 200 ns 
