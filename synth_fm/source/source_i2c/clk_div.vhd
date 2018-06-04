-------------------------------------------
-- Block code:  clk_div.vhd
-- History: 	13.Mar.2018 - 1st version (nishiratavo)
--                 <date> - <changes>  (<author>)
-- Function: Generates baud rate. 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY clk_div IS
GENERIC (width : positive := 12);
	PORT (  
    --enable  : IN    std_logic;
		clk_in    : IN    std_logic;
		clk_out    : OUT   std_logic
	);
END clk_div;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF clk_div IS
	
--SIGNAL 		half_count: 	unsigned(width-1 downto 0):= to_unsigned(1600,width);
--SIGNAL		next_half_count:	unsigned(width-1 downto 0):= to_unsigned(0,width);
SIGNAL 		count: 	unsigned(width-1 downto 0):= to_unsigned(0,width);
SIGNAL		next_count:		unsigned(width-1 downto 0):= to_unsigned(0,width);
--SIGNAL		half_period: std_logic:= '0';
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

  	IF(count < 2) THEN
  		next_count <= count + 1;
  		clk_slow <= '1';

  	--ELSIF (count < 3) THEN
  	--	clk_out <= '0';
  	--	next_count <= count + 1;

  	--ELSIF (count > 3199) AND (half_period = '1') THEN
  	--	clk_out <= '0';
  	--	next_count <= to_unsigned(0,width);

  	ELSIF (count > 1) AND (count < 3) THEN
      next_count <= count + 1;
  		clk_slow <= '0';

    ELSE
      clk_slow <= '0';
  		next_count <= to_unsigned(0,width);

  	END IF;

  END PROCESS full_period_logic;
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_in)
  BEGIN	
  	--IF enable = '0' THEN
  	--	count <= to_unsigned(0,width);
  	--	half_count <= to_unsigned(1600,width);

    IF rising_edge(clk_in) THEN
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
	