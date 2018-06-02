-------------------------------------------
-- Block code:  DDS_LUT.vhd
-- History: 	18.May.2018 - 1st version
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
entity DDS_LUT is
  PORT( 
  clk,reset_n		: IN		std_logic;
  lut_index : in std_logic_vector	(N_CUM-1 downto 0);
  DACDAT_dds_o : out	std_logic_vector (N_AUDIO-1 downto 0)
  );
end DDS_LUT;

architecture rtl of DDS_LUT is

SIGNAL phicum_reg			:	unsigned(N_CUM-1 downto 0);
SIGNAL addr, next_addr	:	integer range 0 to L-1; 
SIGNAL dacdat_g_o			:	std_logic_vector(N_AUDIO -1 downto 0);

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(phicum_reg,addr)
  BEGIN	
  
  next_addr	<= to_integer( phicum_reg (N_CUM-1  downto  N_CUM - N_ADDR_LUT_DDS) );
  dacdat_g_o	<= std_logic_vector( to_signed (LUT_sen(addr) , N_AUDIO ) );

  END PROCESS comb_logic;
  
  
    --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN
		addr <= 0; 
    ELSIF rising_edge(clk) THEN
		addr <= next_addr ;
    END IF;
  END PROCESS flip_flops;		
  
    
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
	phicum_reg <= unsigned(lut_index);
	DACDAT_dds_o <= dacdat_g_o;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;
