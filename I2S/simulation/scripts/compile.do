# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../source/frame_decoder.vhd
vcom -2008 -explicit -work work ../../source/bclk_gen.vhd
vcom -2008 -explicit -work work ../../source/shiftreg_p2s.vhd
vcom -2008 -explicit -work work ../../source/shiftreg_s2p.vhd
vcom -2008 -explicit -work work ../../source/DACDAT_o_MUX.vhd
vcom -2008 -explicit -work work ../../source/i2s.vhd
vcom -2008 -explicit -work work ../../source/testbench_i2s.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.testbench_i2s

do ../scripts/wave.do
run 30000.0 us 

