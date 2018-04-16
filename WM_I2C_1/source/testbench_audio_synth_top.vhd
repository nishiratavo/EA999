-------------------------------------------
-- Block code:  testbench_audio_synth_top.vhd
-- History: 	22.Mar.2017 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: Testbench for audio_synth_top in DTP2 project - Milestone-1
--           
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY testbench_audio_synth_top IS
  
END testbench_audio_synth_top ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_audio_synth_top IS

	-- Components Declaration
COMPONENT audio_synth
	PORT
	(
    	CLOCK_50		: IN   	std_logic;		-- DE2 clock from xtal 50MHz
		AUD_XCK	: OUT  	std_LOGIC;
		KEY				: IN   	std_logic_vector(1 downto 0);  -- DE2 low_active input buttons
		SW				: IN		std_LOGIC_VECTOR(1 downto 0);
		I2C_SCLK		: OUT	std_logic;		-- clock from I2C master block
		I2C_SDAT		: INOUT std_logic		-- data  from I2C master block
	);
END COMPONENT;

COMPONENT i2c_slave_bfm 
	GENERIC(	verbose     : boolean := false );
	PORT(		sda_io		: inout std_logic := 'H';
				scl_io		: inout std_logic := 'H' );
END COMPONENT;
		
	-- Signals & Constants Declaration 
	-- Inputs
	SIGNAL tb_clock_50 	: std_logic;
	SIGNAL tb_reset_n 	: std_logic;
	SIGNAL tb_init_n	: std_logic;

	-- Outputs & InOut
	SIGNAL tb_aud_xck	: std_logic;
	SIGNAL tb_i2c_sclk	: std_logic;
	SIGNAL tb_i2c_sdat	: std_logic;	
	
	-- Constants
	CONSTANT CLK_50M_HALFP 	: time := 10 ns;  		-- Half-Period of Clock 50MHz
	
	-- Auxiliary Signals for internal probes
	SIGNAL data	: std_logic_vector(15 downto 0); -- to check DUT-internal signal
	SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);	
	
BEGIN
  -- Instantiations
  DUT: audio_synth
  PORT MAP 
  (
	CLOCK_50		=>	tb_clock_50,
	AUD_XCK => tb_aud_xck,
	SW(0) => tb_select_mode(0),
	SW(1) => tb_select_mode(1),
   	KEY(0)			=>	tb_reset_n,
	KEY(1)  			=> tb_init_n,
   	I2C_SCLK			=>	tb_i2c_sclk,
   	I2C_SDAT			=>	tb_i2c_sdat
  )	;

-- instantiation of i2c_slave
	inst_codec: i2c_slave_bfm
	PORT MAP (
	sda_io		=> 	tb_i2c_sdat,
	scl_io		=> 	tb_i2c_sclk
	);
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock_50 <= '1';
		wait for CLK_50M_HALFP;	
		tb_clock_50 <= '0';
		wait for CLK_50M_HALFP;
	END PROCESS generate_clock;
	
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";
		tb_init_n 	<= '0';
		tb_reset_n <= '1';
		----------------
		wait for 80 * clk_50M_halfp; 
		tb_reset_n <= '0';
		wait for 8 * clk_50M_halfp; 
		tb_reset_n <= '1';
		tb_select_mode <= "00";
		tb_init_n 	<= '1';
		wait for 8 * clk_50M_halfp; 
		--tb_init_n <= '0';
		--tb_reset_n <= '1';
		--wait for 1 us;  -- pause before starting 1st I2C TX
		
		-- STEP 1
		report "Start I2C TX of mode 000 Analog-Loop Basic";	
		
		wait for 200_000 * clk_50M_halfp;
		
		-- stop simulation
		assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

