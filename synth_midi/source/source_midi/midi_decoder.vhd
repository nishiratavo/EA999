LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;




ENTITY midi_decoder IS
	PORT (
		clk, reset  	    : IN   std_logic;
		controller_num 	  : IN std_logic_vector(6 downto 0);
		controller_data   : IN std_logic_vector(6 downto 0);
		note_out_in 		  : IN  std_logic_vector(6 downto 0);
		note_on_in			  : IN  std_logic;
		velocity		      : IN  std_logic_vector(6 downto 0);
    fm_depth          : OUT  std_logic_vector(6 downto 0);
    fm_ratio          : OUT  std_logic_vector(6 downto 0);
    note_out          : OUT  std_logic_vector(6 downto 0);
    note_on           : OUT  std_logic

	);
END midi_decoder;

ARCHITECTURE rtl OF midi_decoder IS

	SIGNAL  depth, next_depth : std_logic_vector(6 downto 0);
  SIGNAL  ratio, next_ratio : std_logic_vector(6 downto 0);

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  decoder : PROCESS (depth, ratio, controller_data, controller_num)
  BEGIN
  	-- Default Statement
  	
    next_depth <= depth;
    next_ratio <= ratio;

  
  	CASE controller_num IS

  		WHEN "0000001" => -- fm_depth
        next_depth <= controller_data;

  		WHEN "0000010" => 
  			next_ratio <= controller_data;
      WHEN OTHERS =>

  	END CASE;

  END PROCESS decoder;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  ff :PROCESS (clk, reset)
  BEGIN
  	IF (reset = '0') THEN
  		depth <= "0000000";
  		ratio <= "0000000";
    ELSIF rising_edge(clk) THEN
  	 	depth <= next_depth;
  	 	ratio <= next_ratio;
    END IF;
  END PROCESS ff;

    --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  note_on <= note_on_in;
  note_out <= note_out_in;
  fm_depth <= depth;
  fm_ratio <= ratio;

  
  END rtl;
