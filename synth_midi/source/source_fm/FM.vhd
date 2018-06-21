
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05/13/2018 
-- Design Name: 
-- Module Name:    FM
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.tone_gen_pkg.all;
USE work.fm_pkg.all;

entity FM is 
	port(
	clk,reset_n	: 	in	std_logic;	
	tone_cmd    :   in  std_logic_vector(N_MIDI_DATA-1 downto 0);
	tone_on     :   in  std_logic;
	strobe		: 	in std_logic;	
	fm_ratio    :   in std_logic_vector(N_RATIO-1 downto 0);
	fm_depth    :   in std_logic_vector(N_DEPTH-1 downto 0);
	data_g		:	out	std_logic_vector(N_AUDIO-1 downto 0)
	);
end FM;

architecture bdf of FM is

component tone_decoder
  PORT( 
  midi_note_in	: in std_logic_vector (N_MIDI_DATA-1 downto 0); 
  phi_incr_out : out std_logic_vector	(N_CUM-1 downto 0)
  );
end component;

component fm_sel

  PORT( 
  	clk,reset_n    : IN		std_logic;
  	mod_data	   : IN		std_logic_vector(N_AUDIO-1 downto 0);
    tone_on        : IN		std_logic;
	M_fsig	       : IN		std_logic_vector(N_CUM-1 downto 0);
    fm_ratio       : IN   std_logic_vector(N_RATIO-1 downto 0);
    fm_depth       : IN   std_logic_vector(N_DEPTH-1 downto 0);
    mod_on         : OUT  std_logic;
    mod_M          : OUT  std_logic_vector(N_CUM-1 downto 0);
    car_on         : OUT  std_logic;
    car_M     	   : OUT  std_logic_vector(N_CUM-1 downto 0)
   );
END component;

component DDS 
	port(
	clk,reset_n	: 	in	std_logic;		
	phi_incr	:	in 	std_logic_vector(N_CUM-1 downto 0);
	tone_on		:	in 	std_logic;
	data_g		:	out	std_logic_vector(N_AUDIO-1 downto 0);
	strobe		: 	in std_logic
	);
end component;


signal clock_intern 	: std_logic;
signal rst_intern 		: std_logic;
signal phi_incr_intern  : std_logic_vector(N_CUM-1 downto 0);
signal tone_on_intern   : std_logic;
signal strobe_intern    : std_logic;
signal fm_ratio_intern  : std_logic_vector(N_RATIO-1 downto 0);
signal fm_depth_intern  : std_logic_vector(N_DEPTH-1 downto 0);
signal mod_on_intern    : std_logic;
signal car_on_intern    : std_logic;
signal mod_data_intern  : std_logic_vector(N_AUDIO-1 downto 0);
signal mod_m_intern     : std_logic_vector(N_CUM-1 downto 0);
signal car_m_intern     : std_logic_vector(N_CUM-1 downto 0);
signal data_g_intern    : std_logic_vector(N_AUDIO-1 downto 0);

begin

	midi : tone_decoder
	port map (
	midi_note_in  =>  tone_cmd,
  	phi_incr_out  =>  phi_incr_intern
	);


	
	b2v_inst3 : fm_sel
	port map (
	clk            =>  clock_intern,
	reset_n        =>  rst_intern,
  	mod_data	   =>  mod_data_intern,
    tone_on        =>  tone_on_intern,
	M_fsig	       =>  phi_incr_intern,
    fm_ratio       =>  fm_ratio_intern,
    fm_depth       =>  fm_depth_intern,
    mod_on         =>  mod_on_intern,
    mod_M          =>  mod_m_intern,
    car_on         =>  car_on_intern,
    car_M     	   =>  car_m_intern
	);

	mod_dds : DDS
	port map (
	clk      	=>   clock_intern,
	reset_n	 	=>   rst_intern,		
	phi_incr	=>   mod_m_intern,
	tone_on		=>   mod_on_intern,
	data_g		=>   mod_data_intern,
	strobe		=>   strobe_intern
	);


	car_dds : DDS
	port map (
	clk      	=>   clock_intern,
	reset_n	 	=>   rst_intern,		
	phi_incr	=>   car_m_intern,
	tone_on		=>   car_on_intern,
	data_g		=>   data_g_intern,
	strobe		=>   strobe_intern
	);
	
	
	clock_intern <= clk;
	rst_intern <= reset_n;
	tone_on_intern <= tone_on;
	strobe_intern <= strobe;
	fm_ratio_intern <= fm_ratio;
	fm_depth_intern <= fm_depth;
	data_g <= data_g_intern;
	
end bdf;