----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:22:47 04/04/2018 
-- Design Name: 
-- Module Name:    audio_synth_top - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.fm_pkg.all;


entity board_interface is
  port(
	CLOCK_12M  : in  	STD_LOGIC;
	SW		  : in std_logic_vector(2 downto 0);
	MIDI_NOTE : out std_logic_vector(6 downto 0);
    NOTE_ON   : out std_logic;
    FM_RATIO    : out    std_logic_vector(N_RATIO-1 downto 0);
    FM_DEPTH    : out    std_logic_vector(N_DEPTH-1 downto 0)

	);
			  
end board_interface;

ARCHITECTURE bdf_type OF board_interface IS 



COMPONENT sync_n_edgeDetector 
  PORT( 
		data_in 	: IN    std_logic;
		clock		: IN    std_logic;
		reset_n		: IN    std_logic;
		data_sync	: OUT	std_logic; 
    	rise    	: OUT   std_logic;
		fall     	: OUT   std_logic
    	);
END COMPONENT;

COMPONENT midi_decoder
	PORT (  
    SWITCH      : IN    std_logic_vector(1 downto 0);
	MIDI_NOTE   : OUT   std_logic_vector(6 downto 0);
	FM_RATIO    : OUT    std_logic_vector(N_RATIO-1 downto 0);
    FM_DEPTH    : OUT    std_logic_vector(N_DEPTH-1 downto 0)
	); 
END COMPONENT;



SIGNAL  clk12 :  STD_LOGIC;
SIGNAL reset1 : STD_LOGIC;
SIGNAL  vcc1 :  STD_LOGIC;
SIGNAL switch_intern : std_logic_vector(1 downto 0);
SIGNAL MIDI_NOTE_intern : std_logic_vector(6 downto 0);
SIGNAL fm_ratio_intern : std_logic_vector(N_RATIO-1 downto 0);
SIGNAL fm_depth_intern : std_logic_vector(N_DEPTH-1 downto 0);



BEGIN 

	  
b2v_inst6 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> SW(0),
		clock		=> clk12,
		reset_n		=> vcc1,
		data_sync	=>  switch_intern(0),
		rise 		=> open,
		fall 		=> open
	);
	
b2v_inst7 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> SW(1),
		clock		=> clk12,
		reset_n		=> vcc1,
		data_sync	=>  switch_intern(1),
		rise		=> open,
		fall 		=> open
	);

b2v_inst8 : sync_n_edgeDetector 
PORT MAP
  (
    data_in   => SW(2),
    clock   => clk12,
    reset_n => vcc1,
    data_sync =>  NOTE_ON,
    rise => open,
    fall => open
  );


b2v_inst9 : midi_decoder 
PORT MAP
  (
    SWITCH   => switch_intern,
    MIDI_NOTE => MIDI_NOTE_intern,
    FM_RATIO => fm_ratio_intern,
    FM_DEPTH => fm_depth_intern
  );



MIDI_NOTE <= MIDI_NOTE_intern;
FM_DEPTH <= fm_depth_intern;
FM_RATIO <= fm_ratio_intern;
clk12 <= CLOCK_12M;
vcc1 <= '1';


END bdf_type;