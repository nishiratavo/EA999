-------------------------------------------
-- Block code:  fsm_example.vhd
-- History: 	23.Nov.2017 - 1st version (dqtm)
--                   <date> - <changes>  (<author>)
-- Function: fsm_example using enumerated type declaration. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY fsm_midi IS
	PORT (
		clk         : IN   std_logic;
		data, tick  : IN   std_logic;
		enable      : OUT  std_logic
		--start_bit   :	OUT  std_logic
	);
END fsm_midi;


ARCHITECTURE rtl OF fsm_midi IS
	TYPE t_state IS (s_null, s_data0, s_data1, s_data2, s_data3, s_data4, s_data5, s_data6, s_data7, s_end);		-- declaration of new datatype
	SIGNAL s_state, s_nextstate :  t_state; -- 2 signals of the new datatype

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------
  fsm_drive : PROCESS (s_state, data, tick)
  BEGIN
  	-- Default Statement
  	s_nextstate <= s_state;
  
  	CASE s_state IS
  		WHEN s_null => 
  			IF (data = '0') THEN
  				s_nextstate <= s_data1;
  				enable <= '1';
  				--start_bit <= '1';
			ELSE
				s_nextstate <= s_null;
				enable <= '0';
  			END IF;
  		WHEN s_data1 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data2;
				enable <= '1';
			ELSE
				s_nextstate <= s_data1;
				enable <= '1';
  			END IF;
  		WHEN s_data2 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data3;
				enable <= '1';
			ELSE
				s_nextstate <= s_data2;
				enable <= '1';
  			END IF;
  		WHEN s_data3 => 
  			IF (tick = '1') THEN
  				s_nextstate <= s_data4;
				enable <= '1';
			ELSE
				s_nextstate <= s_data3;
				enable <= '1';
  			END IF;
		WHEN s_data4 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data5;
				enable <= '1';
			ELSE
				s_nextstate <= s_data4;
				enable <= '1';
			END IF;
		WHEN s_data5 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data6;
				enable <= '1';
			ELSE
				s_nextstate <= s_data5;
				enable <= '1';
			END IF;
		WHEN s_data6 => 
			IF (tick = '1') THEN
				s_nextstate <= s_data7;
				enable <= '1';
				ELSE
				s_nextstate <= s_data6;
				enable <= '1';
			END IF;
		WHEN s_data7 => 
			IF (tick = '1') THEN
				s_nextstate <= s_end;
				enable <= '1';
			ELSE
				s_nextstate <= s_data7;
				enable <= '1';
			END IF;
		WHEN s_end => 
			IF ((tick = '1') AND (data = '1')) THEN
				s_nextstate <= s_null;
				enable <= '0';
			ELSE
				s_nextstate <= s_end;
				enable <= '1';
			END IF;
		WHEN OTHERS =>
			s_nextstate <= s_null;
			enable <= '0';
  	END CASE;

  	--if (start_bit = '1') THEN
  	--	start_bit <= '0';
  	--END IF;

  END PROCESS fsm_drive;
 
 
 
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
  	 	s_state <= s_nextstate;
    END IF;
  END PROCESS;
  
  END rtl;
