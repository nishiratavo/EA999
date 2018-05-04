-------------------------------------------
-- Block code:  shiftreg_s2p.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: shift-register working as a parallel to serial converter.
--			The block has a load( or shift_n) control input, plus a parallel data input.
--			If load is high the parallel data is loaded, and if load is low the data is shifted towards the LSB.
--			During shift the MSB gets the value of '1'.
--			The serial output is the LSB of the shiftregister.  
--			Can be used as P2S in a serial interface, where inactive value (or rest_value)  equals '1'.
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY shiftreg_s2p IS
  PORT( clk,set_n	: IN    std_logic;			-- Attention, this block has a set_n input for initialisation!!
  		shift			: IN    std_logic;
      enable    : IN    std_logic;
  		ser_i			  : IN    std_logic;
    	par_o     	: OUT   std_logic_vector(15 downto 0)
      );
END shiftreg_s2p;

ARCHITECTURE rtl OF shiftreg_s2p IS
-- Signals & Constants Declaration
-------------------------------------------
	SIGNAL 		shiftreg, next_shiftreg: 	std_logic_vector(15 downto 0);

BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATIONAL LOGIC
  --------------------------------------------------
  shift_comb: PROCESS(shift,ser_i,next_shiftreg,shiftreg,enable)
  BEGIN	
	IF (shift = '1') AND (enable = '1') THEN			  -- carrega dado serial no LSB e desloca vetor em direcao ao MSB

     next_shiftreg(15 downto 0) <= shiftreg(14 downto 0) & ser_i;
	  
  
  ELSE							  
  		next_shiftreg <= shiftreg;	
  END IF;
	
  END PROCESS shift_comb;   
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  shift_dffs : PROCESS(clk, set_n)
  BEGIN	
  	IF set_n = '0' THEN
		shiftreg <= (others=>'0');
    ELSIF rising_edge(clk) THEN
		shiftreg <= next_shiftreg ;
    END IF;
  END PROCESS shift_dffs;		
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take MSB of shiftreg as serial output
  par_o <= shiftreg;
  
END rtl;

