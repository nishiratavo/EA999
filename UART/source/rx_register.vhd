-------------------------------------------
-- Block code:  rx_register.vhd
-- History: 	15.Mar.2018 - 1st version (nishiratavo)
--                 <date> - <changes>  (<author>)
-- Function: receives data. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY rx_register IS

	PORT (  data_in : IN std_logic;
      state : IN std_logic_vector;
      enable : IN std_logic;
      tick : IN std_logic;
			clk : IN std_logic;
			data_out : OUT std_logic_vector(7 downto 0)
	);
END rx_register;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF rx_register IS
	
SIGNAL    data:   unsigned(7 downto 0):= to_unsigned(0,8);

-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR HALF PERIOD
  --------------------------------------------------
  rx: PROCESS(enable,data_in, tick)
  BEGIN	
	-- load	
	IF (enable = '1') AND (tick = '1') AND (state = 1) THEN
		data(7 downto 1) <= data(6 downto 0);
    data(0) <= data_in;
  	END IF;
	
  END PROCESS rx;   

  --------------------------------------------------
  -- PROCESS FOR FULL PERIOD
  --------------------------------------------------
  full_period_logic: PROCESS(half_period, count, next_count, clk_out, enable)
  BEGIN


  END PROCESS full_period_logic;
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, enable)
  BEGIN	
  	IF enable = '0' THEN
  		count <= to_unsigned(0,width);
  		half_count <= to_unsigned(800,width);

    ELSIF rising_edge(clk) THEN
		half_count <= next_half_count;
		count <= next_count;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
   tick <= clk_out;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;
	