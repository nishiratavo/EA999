LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.tone_gen_pkg.all;
USE work.fm_pkg.all;

entity midi_fm is 
	port(
	clk,reset		  : IN	 std_logic;	
	data              : IN   std_logic_vector(7 downto 0);
  	new_data          : IN   std_logic;
  	strobe 			  : IN   std_logic;
	audio			  :	OUT	 std_logic_vector(N_AUDIO-1 downto 0)
	);
end midi_fm;

architecture bdf of midi_fm is


component FM
	port(
	clk,reset_n	: 	in	std_logic;	
	tone_cmd    :   in  std_logic_vector(N_MIDI_DATA-1 downto 0);
	tone_on     :   in  std_logic;
	strobe		: 	in std_logic;	
	fm_ratio    :   in std_logic_vector(N_RATIO-1 downto 0);
	fm_depth    :   in std_logic_vector(N_DEPTH-1 downto 0);
	data_g		:	out	std_logic_vector(N_AUDIO-1 downto 0)
	);
end component;

component midi_controller 
  port(
  clk, reset        : IN   std_logic;
  data              : IN   std_logic_vector(7 downto 0);
  new_data          : IN   std_logic;
  fm_depth          : OUT  std_logic_vector(6 downto 0);
  fm_ratio          : OUT  std_logic_vector(6 downto 0);
  note_out          : OUT  std_logic_vector(6 downto 0);
  note_on           : OUT  std_logic
  );
end component;

signal clock_intern 	: std_logic;
signal rst_intern 		: std_logic;
signal data_intern  	: std_logic_vector(7 downto 0);
signal new_data_intern  : std_logic;
signal strobe_intern    : std_logic;
signal audio_intern     : std_logic_vector(N_AUDIO-1 downto 0);
signal fm_ratio_intern  : std_logic_vector(N_RATIO-1 downto 0);
signal fm_depth_intern  : std_logic_vector(N_DEPTH-1 downto 0);
signal note_out_intern  : std_logic_vector(6 downto 0);
signal note_on_intern 	: std_logic;

begin




	midi : midi_controller
	port map (
	  clk              => clock_intern,
	  reset            => rst_intern,
	  data             => data_intern,
	  new_data         => new_data_intern,
	  fm_depth         => fm_depth_intern,
	  fm_ratio         => fm_ratio_intern,
	  note_out         => note_out_intern,
	  note_on          => note_on_intern
	);


	
	fm_synth : FM
	port map (
	clk         => clock_intern,
	reset_n	    => rst_intern,	
	tone_cmd    => note_out_intern,
	tone_on     => note_on_intern,
	strobe		=> strobe_intern,	
	fm_ratio    => fm_ratio_intern,
	fm_depth    => fm_depth_intern,
	data_g		=> audio_intern
	);
	
	
	clock_intern <= clk;
	rst_intern <= reset;
	data_intern <= data;
	new_data_intern <= new_data;
	strobe_intern <= strobe;
	audio <= audio_intern;
	
end bdf;