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


entity audio_synth is
  port(
	  CLOCK_50  : in  	STD_LOGIC;
	  AUD_XCK : OUT STD_LOGIC;
    KEY 		  : in  	STD_LOGIC_VECTOR(1 downto 0);
	  SW		  : in std_logic_vector(1 downto 0);
    I2C_SCLK  : out   STD_LOGIC;
    I2C_SDAT  : inout	STD_LOGIC

	);
			  
end audio_synth;

ARCHITECTURE bdf_type OF audio_synth IS 


COMPONENT clk_div
  port
  (
    clk_in  : in std_logic;
    clk_out : out std_logic
  );

end COMPONENT;


COMPONENT i2c_ctrl 
  port(
    clk           : in    std_logic;
	  reset 			  : in 	  std_LOGIC;
    ctrl_init     : in    std_logic; 
    select_mode   : in    std_logic_vector(1 downto 0);
    write_o       : out   std_logic;
    write_data_o  : out   std_logic_vector(15 downto 0);
    write_done_i  : in    std_logic;
    ack_error_i   : in    std_logic
  );
        
end COMPONENT;

COMPONENT i2c_master
    port(
      clk         : in    std_logic;
      reset_n     : in    std_logic;

      write_i     : in    std_logic;
      write_data_i: in  std_logic_vector(15 downto 0);
      
      sda_io      : inout std_logic;
      scl_o       : out   std_logic;
      
      write_done_o: out std_logic;
      ack_error_o : out std_logic
        );
end COMPONENT;

COMPONENT sync_n_edgeDetector 
  PORT( 
		data_in 	: IN    std_logic;
		clock		  : IN    std_logic;
		reset_n		: IN    std_logic;
		data_sync	: OUT	std_logic; 
    rise    	: OUT   std_logic;
		fall     	: OUT   std_logic
    	);
END COMPONENT;



SIGNAL  clk50 :  STD_LOGIC;
SIGNAL  clk1 :  STD_LOGIC;
SIGNAL reset1 : STD_LOGIC;
SIGNAL  write1 :  STD_LOGIC;
SIGNAL  write_data1 :  STD_LOGIC_VECTOR(15 downto 0);
SIGNAL  write_done :  STD_LOGIC;
SIGNAL  ack1 :  STD_LOGIC;
SIGNAL  sda1 :  STD_LOGIC;
SIGNAL  scl1 :  STD_LOGIC;
SIGNAL  vcc1 :  STD_LOGIC;
SIGNAL  rise1 : STD_LOGIC;
--SIGNAL  key1 :  STD_LOGIC;
SIGNAL  select_mode1  : STD_LOGIC_VECTOR(1 downto 0);


BEGIN 


b2v_inst1 : clk_div
PORT MAP
  (
    clk_in => clk50,
    clk_out => clk1

  );


b2v_inst2 : i2c_ctrl
PORT MAP(
     clk => clk1,
	  reset => reset1,
     ctrl_init => rise1,
     select_mode => select_mode1,
     write_o => write1,
     write_data_o => write_data1,
     write_done_i => write_done,
     ack_error_i => ack1
     );


b2v_inst3 : i2c_master
PORT MAP(
     clk => clk1,
     reset_n => reset1,
     write_i => write1,
     write_data_i => write_data1,
     sda_io => I2C_SDAT,
     scl_o => I2C_SCLK,
     write_done_o => write_done,
     ack_error_o => ack1
     );
	  
b2v_inst4 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> KEY(0),
		clock		=> clk1,
		reset_n	=> vcc1,
		data_sync	=>  reset1,
		rise => open,
		fall => open
	);
	
b2v_inst5 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> KEY(1),
		clock		=> clk1,
		reset_n	=> vcc1,
		data_sync => open,
		rise	=>  rise1,
		fall => open
	);
	
b2v_inst6 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> SW(0),
		clock		=> clk1,
		reset_n	=> vcc1,
		data_sync	=>  select_mode1(0),
		rise => open,
		fall => open
	);
	
b2v_inst7 : sync_n_edgeDetector 
PORT MAP
	(
		data_in 	=> SW(1),
		clock		=> clk1,
		reset_n	=> vcc1,
		data_sync	=>  select_mode1(1),
		rise => open,
		fall => open
	);


clk50 <= CLOCK_50;
AUD_XCK <= clk1;
vcc1 <= '1';


END bdf_type;

