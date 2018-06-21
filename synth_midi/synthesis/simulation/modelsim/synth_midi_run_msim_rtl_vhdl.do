transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/fm_pkg.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/tone_gen_pkg.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2c/audio_synth_top.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2c/clk_div.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2c/i2c_master.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2c/reg_table_pkg.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/bclk_gen.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/DACDAT_o_MUX.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/frame_decoder.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/i2s.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/shiftreg_p2s.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2s/shiftreg_s2p.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_midi/midi_controller.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_midi/midi_decoder.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_midi/midi_receiver.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/uart_source/fsm_MIDI.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/uart_source/Rx_reg.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/uart_source/tick_generator.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/uart_source/uart.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/uart_source/sync_n_edgeDetector.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/DDS.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/DDS_lut.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/FM.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/fm_sel.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/phase_cumulator.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_fm/tone_decoder.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/source_i2c/i2c_ctrl.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/midi_fm.vhd}
vcom -2008 -work work {/home/gustavo/Documents/EA999/synth_midi/source/synth_midi.vhd}

