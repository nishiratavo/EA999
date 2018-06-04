-------------------------------------------
-- Block code:  DACDAT_o_MUX.vhd
-- History: 	27.Apr.2018 - 1st version ()
--                 <date> - <changes>  (<author>)
-- Function: 
-------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
ENTITY DACDAT_o_MUX IS
	PORT (  
    SER_OUT_L   : IN    std_logic;
		SER_OUT_R   : IN    std_logic;
    WS          : IN    std_logic;
		DACDAT_s_o  : OUT   std_logic
	); 
END DACDAT_o_MUX;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF DACDAT_o_MUX IS
	


-- Begin Architecture
-------------------------------------------
BEGIN
  
  --------------------------------------------------
  -- PROCESS FOR FULL PERIOD
  --------------------------------------------------
  MUX: PROCESS(SER_OUT_L,SER_OUT_R,WS)
  BEGIN

  	IF(WS = '1') THEN
    DACDAT_s_o <= SER_OUT_R;

  	ELSE
    DACDAT_s_o <= SER_OUT_L;

  	END IF;

  END PROCESS MUX;
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
    
 -- End Architecture 
------------------------------------------- 
END rtl;
	