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
ENTITY testbench_i2s IS
  
END testbench_i2s ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_i2s IS

	-- Components Declaration
COMPONENT i2s
	PORT
	(
    	CLOCK_12M  		: in  	std_logic;
    	RST_N_12M		: in    std_logic;
	    DACDAT_pl_i 	: in  	std_logic_vector(15 downto 0);
		DACDAT_pr_i		: in 	std_logic_vector(15 downto 0);
		ADCDAT_s_i		: in 	std_logic;
		ADCDAT_pl_o 	: out  	std_logic_vector(15 downto 0);
		ADCDAT_pr_o		: out 	std_logic_vector(15 downto 0);
		DACDAT_s_o 		: out  	std_logic;
		BCLK_o			: out 	std_logic;
		WS_o			: out 	std_logic;
	    STROBE  		: out   STD_LOGIC
	);
END COMPONENT;



		
	-- Signals & Constants Declaration 
	
	SIGNAL tb_clock_12 	: std_logic;
	SIGNAL tb_rst_n_12 	: std_logic;
	SIGNAL tb_pl_i		: std_logic_vector(15 downto 0);
	SIGNAL tb_pr_i		: std_logic_vector(15 downto 0);
	SIGNAL tb_s_o   	: std_logic;
	SIGNAL tb_enable 	: std_logic;
	SIGNAL tb_ws 		: std_logic;
	SIGNAL tb_strobe 	: std_logic;

		
	-- Constants
	CONSTANT CLK_12M_HALFP 	: time := 40 ns;  		-- Half-Period of Clock 50MHz
	
	-- Auxiliary Signals for internal probes
	--SIGNAL data	: std_logic_vector(15 downto 0); -- to check DUT-internal signal
	--SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);	
	
BEGIN
  -- Instantiations
  DUT: i2s
  PORT MAP 
  (
	CLOCK_12M  		=> tb_clock_12,
	RST_N_12M		=> tb_rst_n_12,
	DACDAT_pl_i 	=> tb_pl_i,
	DACDAT_pr_i		=> tb_pr_i,
	ADCDAT_s_i		=> tb_s_i,
	ADCDAT_pl_o 	=> tb_pl_o,
	ADCDAT_pr_o		=> tb_pr_o,
	DACDAT_s_o 		=> tb_s_o,
	BCLK_o			=> tb_bclk,
	WS_o			=> tb_ws,
	STROBE  		=> tb_strobe
  )	;
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock_12 <= '1';
		wait for CLK_12M_HALFP;	
		tb_clock_12 <= '0';
		wait for CLK_12M_HALFP;
	END PROCESS generate_clock;
	
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";
		--tb_init_n 	<= '0';
		tb_rst_n_12 <= '1';
		----------------
		wait for 5 * CLK_12M_HALFP; 
		tb_rst_n_12 <= '0';
		wait for 8 * CLK_12M_HALFP; 
		tb_rst_n_12 <= '1';
		wait for 2 * CLK_12M_HALFP; 
		wait until rising_edge(tb_strobe);
		tb_pl_i <= "1100010011101001";
		tb_pr_i <= "1100010011101000";
		
		wait for 50000*CLK_12M_HALFP
		
		--report "Start I2C TX of mode 000 Analog-Loop Basic";	
		
		--wait for 200_000 * CLK_12M_HALFP;
		
		-- stop simulation
		--assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

