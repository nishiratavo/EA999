-------------------------------------------
-- Block code:  bclk_gen.vhd
-- History: 	13.Mar.2018 - 1st version (nishiratavo)
--                 <date> - <changes>  (<author>)
-- Function: Generates baud rate. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY bclk_gen IS
	PORT (  
    rst_n_12M  : IN    std_logic;
		clk_in    : IN    std_logic;
		clk_out    : OUT   std_logic
	);
END bclk_gen;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bclk_gen IS
	
SIGNAL 		count: 	unsigned(1 downto 0):= to_unsigned(0,2);
SIGNAL		next_count:		unsigned(1 downto 0):= to_unsigned(0,2);
SIGNAL		clk_slow: std_logic;
SIGNAL    next_clk_slow : std_logic;


-- Begin Architecture
-------------------------------------------
BEGIN
  
  --------------------------------------------------
  -- PROCESS FOR FULL PERIOD
  --------------------------------------------------
  full_period_logic: PROCESS(count, next_count, clk_slow)
  BEGIN
 
    next_count <= to_unsigned(0,2);
    clk_slow <= '0';

  	IF(count < 1) THEN
  		next_count <= count + 1;
  		clk_slow <= '0';

  	ELSIF (count = 1) THEN
      next_count <= to_unsigned(0,2);
  		clk_slow <= '1';

  	END IF;

  END PROCESS full_period_logic;
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_in,rst_n_12M)
  BEGIN	
  	IF rst_n_12M = '0' THEN
  		count <= to_unsigned(0,2);
  	--	half_count <= to_unsigned(1600,width);

    ELSIF rising_edge(clk_in) THEN
		--half_count <= next_half_count;
		count <= next_count;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
   clk_out <= clk_slow;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;
	