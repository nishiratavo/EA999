LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;




ENTITY midi_receiver IS
	PORT (
		clk, reset  	: IN   std_logic;
		data  			: IN   std_logic_vector(7 downto 0);
		new_data		: IN   std_logic;
		controller_num 	: OUT std_logic_vector(6 downto 0);
		controller_data : OUT std_logic_vector(6 downto 0);
		note_out 		: OUT  std_logic_vector(6 downto 0);
		note_on			: OUT  std_logic;
		velocity		: OUT  std_logic_vector(6 downto 0)
	);
END midi_receiver;

ARCHITECTURE rtl OF midi_receiver IS
	TYPE t_state IS (s_wait_status, s_wait_data1, s_wait_data2);		-- declaration of new datatype
	SIGNAL s_state, s_nextstate :  t_state; -- 2 signals of the new datatype
	SIGNAL data1, next_data1 : std_logic_vector(6 downto 0);
	SIGNAL data2, next_data2 : std_logic_vector(6 downto 0);
	SIGNAL status, next_status : std_logic_vector(3 downto 0);
	SIGNAL next_note_on_intern, note_on_intern : std_logic;
	SIGNAL next_note_out_intern, note_out_intern : std_logic_vector(6 downto 0);
	SIGNAL next_controller_num_intern, controller_num_intern : std_logic_vector(6 downto 0);
	SIGNAL next_controller_data_intern, controller_data_intern : std_logic_vector(6 downto 0);
	SIGNAL data_valid : std_logic;
	SIGNAL process_data, next_process_data : std_logic;

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  fsm : PROCESS (s_state, data, data_valid, new_data, status, data1, data2)
  BEGIN
  	-- Default Statement
  	s_nextstate <= s_state;
  	next_status <= status;
  	next_data1 <= data1;
  	next_data2 <= data2;
    next_process_data <= '0';
  	--process_data <= '0';

  
  	CASE s_state IS

  		WHEN s_wait_status => 
  			IF (data(7) = '1') THEN
  				next_status <= data(7 downto 4);
          next_process_data <= '0';
  				s_nextstate <= s_wait_data1;
  			ELSE
  				s_nextstate <= s_state;
  			END IF;

  		WHEN s_wait_data1 => 
  			IF (new_data = '1') THEN
  				next_data1 <= data(6 downto 0);
          next_process_data <= '0';
  				s_nextstate <= s_wait_data2;
  			ELSE
  				s_nextstate <= s_wait_data1;
  			END IF;
  			
  		WHEN s_wait_data2 => 
  			IF (new_data = '1') THEN
  				next_data2 <= data(6 downto 0);
  				next_process_data <= '1';
  				s_nextstate <= s_wait_status;
  			ELSE
  				s_nextstate <= s_wait_data2;
  			END IF;
  		
  	END CASE;



  END PROCESS fsm;


  decoder : PROCESS(status, data1, data2, note_out_intern, note_on_intern, controller_num_intern, controller_data_intern, process_data)
  BEGIN

  	next_note_out_intern <= note_out_intern;
  	next_note_on_intern <= note_on_intern;
  	velocity <= "0000000";
  	next_controller_num_intern <= controller_num_intern;
  	next_controller_data_intern <= controller_data_intern;

  	CASE status IS   ------------------------------------------------------- saving data in register it shouldnt save
  		WHEN "1001" => -- NOTE ON
  			IF (process_data = '1') THEN
  			next_note_out_intern <= std_logic_vector(data1);
  			velocity <= std_logic_vector(data2);
  			next_note_on_intern <= '1';
  			END IF;
  		WHEN "1000" => -- NOTE OFF
  			IF (process_data = '1') THEN
  			next_note_out_intern <= std_logic_vector(data1);
  			velocity <= std_logic_vector(data2);
  			next_note_on_intern <= '0';
  			END IF;
  		WHEN "1011" => -- CONTROL CHANGE
  			IF (process_data = '1') THEN
  			next_controller_num_intern <= std_logic_vector(data1);
  			next_controller_data_intern <= std_logic_vector(data2);
  			END IF;
  		WHEN OTHERS =>
  			--next_note_out_intern <= note_out_intern;
		  	--next_note_on_intern <= note_on_intern;
		  	--velocity <= "0000000";
		  	--controller_num <= "0000000";
		  	--controller_data <= "0000000";

  	END CASE;

  END PROCESS decoder;
 
 
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  ff : PROCESS (clk, reset)
  BEGIN
  	IF (reset = '0') THEN
  		s_state <= s_wait_status;
  		status <= "0000";
  		data1 <= "0000000";
  		data2 <= "0000000";
  		note_on_intern <= '0';
  		note_out_intern <= "0000000";
  		controller_data_intern <= "0000000";
  		controller_num_intern <= "0000000";
      process_data <= '0';
    ELSIF rising_edge(clk) THEN
  	 	s_state <= s_nextstate;
  	 	status <= next_status;
  	 	data1 <= next_data1;
  	 	data2 <= next_data2;
  	 	note_on_intern <= next_note_on_intern;
  	 	note_out_intern <= next_note_out_intern;
  	 	controller_num_intern <= next_controller_num_intern;
  	 	controller_data_intern <= next_controller_data_intern;
      process_data <= next_process_data;
    END IF;
  END PROCESS ff;

note_on <= note_on_intern;
note_out <= note_out_intern;
controller_num <= controller_num_intern;
controller_data <= controller_data_intern;
  
  END rtl;
