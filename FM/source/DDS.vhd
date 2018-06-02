
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05/13/2018 
-- Design Name: 
-- Module Name:    DDS-top
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

entity DDS is 
	port(
	clk,reset_n	: 	in	std_logic;		
	phi_incr	:	in 	std_logic_vector(N_CUM-1 downto 0);
	tone_on		:	in 	std_logic;
	data_g		:	out	std_logic_vector(N_AUDIO-1 downto 0);
	strobe		: 	in std_logic
	);
end DDS;

architecture bdf of DDS is

component phase_cumulator
	port(
		clk,reset_n		: IN		std_logic;
		tone_on_i		: IN		std_logic;
		strobe_i		: IN		std_logic;
		phi_incr_i		: IN		std_logic_vector(N_CUM-1 downto 0);
		count_o     	: OUT   	std_logic_vector(N_CUM-1 downto 0)
   	);
end component phase_cumulator;


component DDS_LUT
  PORT( 
  clk,reset_n		: IN		std_logic;
  lut_index : in std_logic_vector	(N_CUM-1 downto 0);
  DACDAT_dds_o : out	std_logic_vector (N_AUDIO-1 downto 0)
  );
end component DDS_LUT;

signal clock_intern 	: std_logic;
signal rst_intern 		: std_logic;
signal lut_index_intern	: std_logic_vector	(N_CUM-1 downto 0);

begin

	b2v_inst1 : phase_cumulator
	port map (
	clk 			=> clock_intern,
	reset_n		=> rst_intern,
	tone_on_i 	=> tone_on,
	strobe_i   	=> strobe,
	phi_incr_i 	=> phi_incr,
	count_o 		=> lut_index_intern
	);


	
	b2v_inst3 : dds_LUT
	port map (
	clk 			=> clock_intern,
	reset_n		=> rst_intern,
	lut_index 	=> lut_index_intern,
	DACDAT_dds_o => data_g
	);
	
	
	clock_intern <= clk;
	rst_intern <= reset_n;
	
end bdf;