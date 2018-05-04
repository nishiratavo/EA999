--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:22:47 04/04/2018 
-- Design Name: 
-- Module Name:    i2c_ctrl - RTL 
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


entity frame_decoder is
  port(
    clk_12M       : in    std_logic;
	  rst_n_12M			: in	  std_logic;
    enable        : in    std_logic; 
    shift_L       : out   std_logic;
    shift_R       : out   std_logic;
    strobe        : out   std_logic;
	  WS            : out	  std_logic
	);
			  
end frame_decoder;

architecture rtl of frame_decoder is

-- Signals & Constants Declaration
-------------------------------------------

CONSTANT    max_val:      unsigned(6 downto 0):= to_unsigned(127,7); -- convert integer value 4 to unsigned with 4bits
SIGNAL    count, next_count:  unsigned(6 downto 0);  


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR COUNTER'S COMB LOGIC
  --------------------------------------------------
  counter_comb_logic: PROCESS(enable,count)
  BEGIN
    -- increment
    IF (enable = '1') and (count < max_val) THEN
      next_count <= count + 1 ;
    
    -- restart
    ELSIF (enable = '1') and (count = max_val) THEN
      next_count <= to_unsigned(0,7);

    ELSE
      next_count <= count;
    END IF;
  
  END PROCESS counter_comb_logic;   



   --------------------------------------------------
  -- PROCESS FOR I2S DECODER'S COMB LOGIC
  ---------------------------------------------------

  i2s_decoder: PROCESS(count, rst_n_12M)
  BEGIN

    IF (count <= 63) AND (rst_n_12M = '1') THEN
      WS <= '0';
    ELSE
      WS <= '1';
    END IF;

    IF (count = 0) AND (rst_n_12M = '1') THEN
      strobe <= '1';
    ELSE
      strobe <= '0';
    END IF;

    IF (count > 0) and (count < 17) AND (rst_n_12M = '1') THEN
      shift_L <= '1';
    ELSE
      shift_L <= '0';
    END IF;

    IF (count > 64) and (count < 81) AND (rst_n_12M = '1') THEN
      shift_R <= '1';
    ELSE
      shift_R <= '0';
    END IF;

  END PROCESS i2s_decoder;
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk_12M, rst_n_12M)
  BEGIN 
    IF rst_n_12M = '0' THEN
    count <= to_unsigned(127,7); 
    ELSIF rising_edge(clk_12M) THEN
    count <= next_count ;
    END IF;
  END PROCESS flip_flops;   
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  
  
  
 -- End Architecture 

end rtl;