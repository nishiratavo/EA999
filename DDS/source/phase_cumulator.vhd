-------------------------------------------
-- Block code:  phase_cumulator.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: 
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.tone_gen_pkg.all;


-- Entity Declaration 
-------------------------------------------
ENTITY phase_cumulator IS
  PORT( 
  	clk,reset_n		: IN		std_logic;
  	tone_on_i		: IN		std_logic;
	strobe_i			: IN		std_logic;
	phi_incr_i		: IN		std_logic_vector(N_CUM-1 downto 0);
   count_o     	: OUT   	std_logic_vector(N_CUM-1 downto 0)
   );
END phase_cumulator;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF phase_cumulator IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT  	init_val: 			unsigned(N_CUM-1 downto 0):= to_unsigned(0,N_CUM);
-- SIGNAL 		count_status:		std_logic;
SIGNAL 		count, next_count: 	unsigned(N_CUM-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(tone_on_i,count,strobe_i,phi_incr_i)
  BEGIN	
	-- load	
	IF (tone_on_i = '0')  THEN
--		count_status <= '0';
		next_count <= init_val;
		
	ELSIF (strobe_i = '1') AND (tone_on_i = '1') THEN
--		count_status <= '1';
		next_count <= (count + unsigned(phi_incr_i));
	ELSE
		next_count <= count;
  	END IF;
	
  END PROCESS comb_logic;   
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= init_val; -- convert integer value 0 to unsigned with 4bits
--		count_status <= '0';
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  count_o <= std_logic_vector(count);
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;

