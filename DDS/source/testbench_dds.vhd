LIBRARY ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY testbench_dds IS
  
END testbench_dds ;


-- Architecture Declaration 
ARCHITECTURE struct OF testbench_i2s IS

	-- Components Declaration
COMPONENT DDS_top
	PORT
	(
    clk,reset_n	: 	in	std_logic;		
	MIDI_note	:	in 	std_logic_vector(N_MIDI_DATA-1 downto 0);
	Note_ON		:	in 	std_logic;
	tone_out	:	out	std_logic_vector(15 downto 0);
	);
END COMPONENT;



		
	-- Signals & Constants Declaration 
	
	SIGNAL tb_clock_12 	: std_logic;
	SIGNAL tb_rst_n_12 	: std_logic;
	SIGNAL tb_midi_note : std_logic_vector(N_MIDI_DATA-1 downto 0);
	SIGNAL tb_note_on   : std_logic;
	SIGNAL tb_tone_out  : std_logic_vector(15 downto 0);
		
	-- Constants
	CONSTANT CLK_12M_HALFP 	: time := 40 ns;  		-- Half-Period of Clock 12.5MHz
	
	-- Auxiliary Signals for internal probes
	--SIGNAL data	: std_logic_vector(15 downto 0); -- to check DUT-internal signal
	--SIGNAL tb_reg0_lo	: std_logic_vector(3 downto 0);	
	
BEGIN
  -- Instantiations	
  DUT: DDS_top
  PORT MAP 
  (
	clk => tb_clock_12,
	reset_n	=> tb_rst_n_12,
	MIDI_note => tb_midi_note,
	Note_ON	=>	tb_note_on,
	tone_out =>	tb_tone_out
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
		tb_rst_n_12 <= '0';
		tb_s_i <= '0';
		----------------;
		wait for 4 * CLK_12M_HALFP; 
		tb_rst_n_12 <= '1';
		
		tb_midi_note <= "1000101";  -- MIDI note -> 69 -> 440Hz
		tb_note_on <= '1';
		

		
		wait for 50000*CLK_12M_HALFP;
		
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

