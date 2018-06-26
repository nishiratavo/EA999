----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:22:47 04/04/2018 
-- Design Name: 
-- Module Name:    DSVF - RTL 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.DSVF_pkg.all;


entity DSVF is
  port(
      clk         : in    std_logic;
      reset_n     : in    std_logic;
      strobe      : in    std_logic;

      data_in     : in    std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12
      data_out    : out   std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12

      resson      : in    std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em uint16, Q1.15
      freq        : in    std_logic_vector(N_DATA_RESOL-1 downto 0);     -- representacao em uint16, Q1.15

		data_test1	: out   std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12
		data_test2	: out   std_logic_vector(N_DATA_RESOL-1 downto 0);    -- representacao em int16, Q3.12
		data_test3	: out   std_logic_vector(N_DATA_RESOL-1 downto 0);
		data_test4	: out   std_logic_vector(N_DATA_RESOL-1 downto 0)    -- representacao em int16, Q3.12
	);

end DSVF;

architecture rtl of DSVF is

-- Signals & Constants Declaration
-------------------------------------------

SIGNAL Yh_0, next_Yh_0  : signed(N_DATA_RESOL-1 downto 0) := to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12

SIGNAL Yb_0, next_Yb_0 	: signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12
SIGNAL Yb_1				   : signed(N_DATA_DOUBLE_RESOL-1 downto 0):= to_signed(0,N_DATA_DOUBLE_RESOL);   -- representacao em int32, Q4.27
SIGNAL Yb_1_low         : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12          
SIGNAL Yb_2             : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12
SIGNAL next_Yl_0, delay_Yl_0	: signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12

SIGNAL next_Fb_0, delay_Fb_0	: signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12
SIGNAL Fb_1             : signed(N_DATA_DOUBLE_RESOL-1 downto 0):= to_signed(0,N_DATA_DOUBLE_RESOL);   -- representacao em int32, Q4.27
SIGNAL Fb_1_low         : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12
SIGNAL Fb_2             : signed(N_DATA_DOUBLE_RESOL-1 downto 0):= to_signed(0,N_DATA_DOUBLE_RESOL);   -- representacao em int32, Q4.27
SIGNAL Fb_2_low         : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12
SIGNAL Fb_3, next_Fb_3  : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL);          -- representacao em int16, Q3.12

SIGNAL next_delay_Fb_0 	: signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL); 
SIGNAL next_delay_Yl_0  : signed(N_DATA_RESOL-1 downto 0):= to_signed(0,N_DATA_RESOL); 

CONSTANT init_val       		: signed(N_DATA_RESOL-1 downto 0) := to_signed(0,N_DATA_RESOL);
CONSTANT init_val_double      : signed(N_DATA_DOUBLE_RESOL-1 downto 0) := to_signed(0,N_DATA_DOUBLE_RESOL);
  
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------

  SVF_routing : PROCESS (all)
  BEGIN
    
    -----------------------------------------------------------------------
    -- Default Statement, mostly keep current value
    -----------------------------------------------------------------------
   Yh_0 <= signed(data_in) - (Fb_3);
   Yb_0 <= ((Yh_0) + (delay_Fb_0));
   Yb_1 <= ((Yb_0) * signed(freq));
   Yb_2 <= ((Yb_1_low) + (delay_Yl_0));
   
   Fb_2 <= ((delay_Yl_0) * signed(freq));
   Fb_1 <= ((delay_Fb_0) * signed(resson));
   Fb_3 <= ((Fb_1_low) + (Fb_2_low));
--	next_Fb_3 <= (Fb_1_low);

   Yb_1_low <= Yb_1(N_DATA_DOUBLE_RESOL-1) & Yb_1(29 downto 15);
   Fb_1_low <= Fb_1(N_DATA_DOUBLE_RESOL-1) & Fb_1(29 downto 15);
   Fb_2_low <= Fb_2(N_DATA_DOUBLE_RESOL-1) & Fb_2(29 downto 15);

  END PROCESS SVF_routing;
  
  SVF_delay : PROCESS (all)
  BEGIN
    IF (strobe = '1')  THEN
    next_delay_Fb_0 <= Yb_0;
    next_delay_Yl_0 <= Yb_2;
  ELSE
    next_delay_Fb_0 <= delay_Fb_0;
    next_delay_Yl_0 <= delay_Yl_0;
  END IF;

  END PROCESS SVF_delay;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  PROCESS (clk, reset_n)
  BEGIN
	 IF (reset_n = '0') THEN
    
    delay_Fb_0 		<= init_val;   -- "0"
    delay_Yl_0 		<= init_val;   -- "0"
--	 Yh_0 		<= init_val;
--	 Yb_0 		<= init_val;
--	 Yb_1 		<= init_val_double;
--	 Yb_1_low 	<= init_val;
--	 Yb_2 		<= init_val;
--	 Fb_1 		<= init_val_double;
--	 Fb_1_low 	<= init_val;
--	 Fb_2 		<= init_val_double;
--	 Fb_2_low 	<= init_val;
--
--	 Fb_3 		<= init_val;
--	 next_Fb_3 	<= init_val;
--	 next_Fb_0 	<= init_val;
--	 next_Yl_0 	<= init_val;

   ELSIF rising_edge(clk) THEN
    
	 delay_Fb_0 <= next_delay_Fb_0;
    delay_Yl_0 <= next_delay_Yl_0;
	 
   -- Fb_3 <= next_Fb_3;
	 
	-- Yh_0 <= next_Yh_0;
	-- Yb_0 <= next_Yb_0;
	 
    END IF;
  
  END PROCESS;

  -----------------------------------------------------------------------
  -- Concurrent Assignments for Output Signals                                                      
  -----------------------------------------------------------------------
    data_out <= std_logic_vector(delay_Yl_0);
 	 data_test1 <= std_logic_vector(Yb_2);
	 data_test2 <= std_logic_vector(next_delay_Yl_0);
	 data_test3 <= std_logic_vector(Yb_1_low);
	 data_test4 <= std_logic_vector(next_Fb_0);
  -----------------------------------------------------------------------

end rtl;