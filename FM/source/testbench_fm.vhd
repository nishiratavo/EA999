LIBRARY ieee;
use ieee.std_logic_1164.all;
USE work.tone_gen_pkg.all;
USE work.fm_pkg.all;

-- Entity Declaration 
ENTITY testbench_fm IS
  
END testbench_fm ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_fm IS

	-- Components Declaration
COMPONENT FM
	PORT
	(
  	clk,reset_n	: 	in	std_logic;	
	tone_cmd    :   in  std_logic_vector(N_MIDI_DATA-1 downto 0);
	tone_on     :   in  std_logic;
	strobe		: 	in std_logic;	
	fm_ratio    :   in std_logic_vector(N_RATIO-1 downto 0);
	fm_depth    :   in std_logic_vector(N_DEPTH-1 downto 0);
	data_g		:	out	std_logic_vector(N_AUDIO-1 downto 0)
	);
END COMPONENT;



		
	-- Signals & Constants Declaration 
	
	SIGNAL tb_strobe	: std_logic;
	SIGNAL tb_clock_12 	: std_logic;
	SIGNAL tb_rst_n_12 	: std_logic;
	SIGNAL tb_tone_cmd : std_logic_vector(N_MIDI_DATA-1 downto 0);
	SIGNAL tb_tone_on   : std_logic;
	SIGNAL tb_data_g  : std_logic_vector(15 downto 0);
	SIGNAL tb_fm_ratio : std_logic_vector(N_RATIO-1 downto 0);
	SIGNAL tb_fm_depth  : std_logic_vector(N_DEPTH-1 downto 0);
		
	-- Constants
	CONSTANT CLK_12M_HALFP 	: time := 40 ns;  		-- Half-Period of Clock 12.5MHz
	CONSTANT STROBE_CLK		: time := 21 us;
	CONSTANT BCLK			: time := 0.16 us;
	
	-- Auxiliary Signals for internal probes
	--SIGNAL data	: std_logic_vector(15 downto 0); -- to check DUT-internal signal
	--SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);	
	
BEGIN
  -- Instantiations	
  DUT: FM
  PORT MAP 
  (
	clk => tb_clock_12,
	reset_n	=> tb_rst_n_12,
	tone_cmd => tb_tone_cmd,
	tone_on	=>	tb_tone_on,
	fm_ratio => tb_fm_ratio,
	fm_depth => tb_fm_depth,
	data_g =>	tb_data_g,
	strobe => tb_strobe
  )	;
		
  -- Clock Generation Process	
	generate_clock: PROCESS
	BEGIN
		tb_clock_12 <= '1';
		wait for CLK_12M_HALFP;	
		tb_clock_12 <= '0';
		wait for CLK_12M_HALFP;
	END PROCESS generate_clock;
	

	generate_strobe: PROCESS
	BEGIN
		tb_strobe <= '1';
		wait for BCLK;	
		tb_strobe <= '0';
		wait for STROBE_CLK;
	END PROCESS generate_strobe;
	
	
  -- Stimuli Process
	stimuli: PROCESS
	BEGIN
		-- STEP 0
		report "Initialise: define constants and pulse reset on/off";
		--tb_init_n 	<= '0';
		tb_rst_n_12 <= '0';
--		tb_s_i <= '0';
		----------------;
		wait for 4 * CLK_12M_HALFP; 
		tb_rst_n_12 <= '1';
		
		tb_fm_ratio <= "00100000"; -- 0.125
		tb_fm_depth <= "0110000000"; -- 3
		tb_tone_cmd <= "1000101";  -- MIDI note -> 69 -> 440Hz
		tb_tone_on <= '1';
		

		
		wait for 800000*CLK_12M_HALFP;
		

		tb_tone_on <= '0';
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

