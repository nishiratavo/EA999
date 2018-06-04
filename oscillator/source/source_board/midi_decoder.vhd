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
ENTITY midi_decoder IS
	PORT (  
    SWITCH      : IN    std_logic_vector(1 downto 0);
		MIDI_NOTE   : OUT   std_logic_vector(6 downto 0)
	); 
END midi_decoder;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF midi_decoder IS


	


-- Begin Architecture
-------------------------------------------
BEGIN
  
  --------------------------------------------------
  -- PROCESS FOR FULL PERIOD
  --------------------------------------------------
  decoder: PROCESS(SWITCH)
  BEGIN 
  
  case SWITCH is
  
  
    when "00" => 
      MIDI_NOTE <= std_logic_vector(to_unsigned(69,7)); --A3
    when "01" => 
      MIDI_NOTE <= std_logic_vector(to_unsigned(72,7)); --C4
    when "10" => 
      MIDI_NOTE <= std_logic_vector(to_unsigned(76,7)); -- E4
    when "11" => 
      MIDI_NOTE <= std_logic_vector(to_unsigned(79,7)); -- G4
      
    end case;
      
  END PROCESS decoder;     
    
 -- End Architecture 
------------------------------------------- 
END rtl;
	