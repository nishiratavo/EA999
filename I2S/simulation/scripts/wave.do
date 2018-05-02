onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/enable
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/shift_L
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/shift_R
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/strobe
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/WS
add wave -noupdate -radix unsigned /testbench_i2s/DUT/b2v_inst2/count
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/clk_12M
add wave -noupdate /testbench_i2s/DUT/b2v_inst2/rst_n_12M
add wave -noupdate /testbench_i2s/DUT/b2v_inst_Shift_L/par_i
add wave -noupdate /testbench_i2s/DUT/b2v_inst_Shift_L/ser_o
add wave -noupdate /testbench_i2s/DUT/b2v_inst_Shift_R/par_i
add wave -noupdate /testbench_i2s/DUT/b2v_inst_Shift_R/ser_o
add wave -noupdate /testbench_i2s/DUT/DACDAT_s_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23738 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 357
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {23457 ns} {24229 ns}
