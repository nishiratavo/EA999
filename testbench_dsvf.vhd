LIBRARY ieee;
use ieee.std_logic_1164.all;
USE work.DSVF_pkg.all;

-- Entity Declaration 
ENTITY testbench_dds IS
  
END testbench_dds ;


-- Architecture Declaration
ARCHITECTURE struct OF testbench_dds IS

	-- Components Declaration
COMPONENT DSVF
	PORT
	(
      clk         : in    std_logic;
      reset_n     : in    std_logic;
      strobe      : in    std_logic;

      data_in     : in    std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12
      data_out    : out   std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12

      resson      : in    std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em uint16, Q1.15
      freq        : in    std_logic_vector(N_DATA_RESOL-1 downto 0);     -- representacao em uint16, Q1.15
		data_test1   : out   std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12
		data_test2   : out   std_logic_vector(N_DATA_RESOL-1 downto 0); 
		data_test3   : out   std_logic_vector(N_DATA_RESOL-1 downto 0);
		data_test4   : out   std_logic_vector(N_DATA_RESOL-1 downto 0)		
	);
END COMPONENT;



		
	-- Signals & Constants DeclarationÂ 
	

	SIGNAL tb_clock_12 	: std_logic;
	SIGNAL tb_rst_n_12 	: std_logic;
	SIGNAL tb_strobe 		: std_logic;
	SIGNAL tb_data_in			: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_data_out			: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_resson		: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_freq			: std_logic_vector(N_DATA_RESOL-1 downto 0);
	
	SIGNAL tb_data_test1	: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_data_test2	: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_data_test3	: std_logic_vector(N_DATA_RESOL-1 downto 0);
	SIGNAL tb_data_test4	: std_logic_vector(N_DATA_RESOL-1 downto 0);
	
	-- Constants
	CONSTANT CLK_12M_HALFP 	: time := 40 ns;  		-- Half-Period of Clock 12.5MHz
	CONSTANT STROBE_CLK		: time := 21 us;
	CONSTANT BCLK			: time := 0.08 us;
	
	-- Auxiliary Signals for internal probes

BEGIN
  -- Instantiations	
  DUT: DSVF
  PORT MAP 
  (
	clk => tb_clock_12,
	reset_n	=> tb_rst_n_12,
	strobe => tb_strobe,
	
	data_in => tb_data_in,
	data_out	=>	tb_data_out,
	data_test1	=>	tb_data_test1,
	data_test2	=>	tb_data_test2,
	data_test3	=>	tb_data_test3,
	data_test4	=>	tb_data_test4,
	resson => tb_resson,
	freq => tb_freq
  );
		
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

		tb_rst_n_12 <= '0';
		tb_freq <= "0111010100110000"; -- = 21066 - correspondente à	fc=5000Hz
		tb_resson <= "0000111100000001"; -- = 3841 - correspondente à Q=8.5324
		tb_data_in <= "0000000000000000";
		----------------;
		wait for 10 * CLK_12M_HALFP; 
		tb_rst_n_12 <= '1';
		wait for 4 * CLK_12M_HALFP;
		
		tb_data_in <= "0000001000000000";

		wait for 5 * STROBE_CLK;

		tb_data_in <= "0000000000000000";
		
		wait for 50000*CLK_12M_HALFP;
		


		
		--wait for 200_000 * CLK_12M_HALFP;
		
		-- stop simulation
		--assert false report "All tests passed!" severity failure;
		
	END PROCESS stimuli;
	
	-- Comments:
	-- remember to re-save wave.do after setting radix and time ranges
	-- use >wave>format>toggle leaf names  to display shorter names
	-- remark syntax with aux debug signal to track in TB internal DUT signals
  
END struct;

