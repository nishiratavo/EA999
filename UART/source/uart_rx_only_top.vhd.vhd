-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Fri Mar 16 12:19:42 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart IS 
	PORT
	(
		CLOCK_50 :  IN  STD_LOGIC;
		GPIO_0 :  IN  STD_LOGIC_VECTOR(1 TO 1);
		SW :  IN  STD_LOGIC_VECTOR(0 TO 0);
		HEX0 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		HEX1 :  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END uart;

ARCHITECTURE bdf_type OF uart IS 

COMPONENT fsm_midi
	PORT(clk : IN STD_LOGIC;
		 data : IN STD_LOGIC;
		 tick : IN STD_LOGIC;
		 enable : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT tick_generator
GENERIC (width : INTEGER
			);
	PORT(enable : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 tick : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT rx_reg
	PORT(tick : IN STD_LOGIC;
		 serial_i : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 parallel_o : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT sync_n_edgedetector
	PORT(data_in : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_sync : OUT STD_LOGIC;
		 rise : OUT STD_LOGIC;
		 fall : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bus_divider
	PORT(data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data_outLSB : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data_outMSB : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT hex2sevseg_w_control
	PORT(blank_n_i : IN STD_LOGIC;
		 lamp_test_n_i : IN STD_LOGIC;
		 ripple_blank_n_i : IN STD_LOGIC;
		 hexa_i : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 ripple_blank_n_o : OUT STD_LOGIC;
		 seg_o : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	data_0 :  STD_LOGIC;
SIGNAL	data_parallel :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	enable_0 :  STD_LOGIC;
SIGNAL	high1 :  STD_LOGIC;
SIGNAL	high2 :  STD_LOGIC;
SIGNAL	LSB :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	MSB :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	tick_0 :  STD_LOGIC;


BEGIN 



b2v_inst : fsm_midi
PORT MAP(clk => CLOCK_50,
		 data => data_0,
		 tick => tick_0,
		 enable => enable_0);


b2v_inst10 : tick_generator
GENERIC MAP(width => 11
			)
PORT MAP(enable => enable_0,
		 clk => CLOCK_50,
		 tick => tick_0);


b2v_inst11 : rx_reg
PORT MAP(tick => tick_0,
		 serial_i => data_0,
		 clk => CLOCK_50,
		 parallel_o => data_parallel);


b2v_inst12 : sync_n_edgedetector
PORT MAP(data_in => GPIO_0(1),
		 clock => CLOCK_50,
		 reset_n => SW(0),
		 data_sync => data_0);


b2v_inst15 : bus_divider
PORT MAP(data_in => data_parallel,
		 data_outLSB => LSB,
		 data_outMSB => MSB);


b2v_inst18 : hex2sevseg_w_control
PORT MAP(blank_n_i => high1,
		 lamp_test_n_i => high1,
		 ripple_blank_n_i => high1,
		 hexa_i => MSB,
		 seg_o => HEX0);


b2v_inst19 : hex2sevseg_w_control
PORT MAP(blank_n_i => high2,
		 lamp_test_n_i => high2,
		 ripple_blank_n_i => high2,
		 hexa_i => LSB,
		 seg_o => HEX1);




high1 <= '1';
high2 <= '1';
END bdf_type;