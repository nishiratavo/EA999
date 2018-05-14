
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

entity DDS_top is 
	port(
	MIDI_note	:	in 	std_logic_vector(6 downto 0);
	Note_ON		:	in 	std_logic;
	tone_out		:	out	std_logic_vector;
	);
end DDS_top;

architecture bdf of DDS_top is

component phase_cumulator
	port(
		clk,reset_n		: IN		std_logic;
		tone_on_i		: IN		std_logic;
		strobe_i			: IN		std_logic;
		phi_incr_i		: IN		std_logic_vector(N_CUM-1 downto 0);
		count_o     	: OUT   	std_logic_vector(N_ADDR_LUT_DDS-1 downto 0)
   );
component	decoder
	port(
		
	)



end bdf;