




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity i2s is
  port(
	CLOCK_12M  		: in  	std_logic;
    DACDAT_pl_i 	: in  	std_logic_vector(5 downto 0);
	DACDAT_pr_i		: in 	std_logic_vector(5 downto 0);
	ADCDAT_s_i		: in 	std_logic;
	ADCDAT_pl_o 	: out  	std_logic_vector(5 downto 0);
	ADCDAT_pr_o		: out 	std_logic_vector(5 downto 0);
	DACDAT_s_o 		: out  	std_logic;
	BCLK_o			: out 	std_logic;
	WS_o			: out 	std_logic;
    STROBE  		: out   STD_LOGIC

	);
			  
end i2s;


ARCHITECTURE bdf_type OF i2s IS 



BEGIN




END bdf_type;