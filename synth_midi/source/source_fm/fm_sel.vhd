-------------------------------------------
-- Block code:  fm_sel.vhd
-- History: 	12.Nov.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: 
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.tone_gen_pkg.all;
USE work.fm_pkg.all;

--constant  N_RATIO : natural := 8;
--constant  N_DEPTH : natural := 10;
-- Entity Declaration 
-------------------------------------------
ENTITY fm_sel IS

  PORT( 
  	clk,reset_n    : IN		std_logic;
  	mod_data		   : IN		std_logic_vector(N_AUDIO-1 downto 0);
    tone_on        : IN		std_logic;
	  M_fsig		     : IN		std_logic_vector(N_CUM-1 downto 0);
    fm_ratio       : IN   std_logic_vector(N_RATIO-1 downto 0);
    fm_depth       : IN   std_logic_vector(N_DEPTH-1 downto 0);
    mod_on         : OUT  std_logic;
    mod_M          : OUT  std_logic_vector(N_CUM-1 downto 0);
    car_on         : OUT  std_logic;
    car_M     	   : OUT  std_logic_vector(N_CUM-1 downto 0)
   );
END fm_sel;

--constant  N_RATIO : natural := 8;
--constant  N_DEPTH : natural := 10;

-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF fm_sel IS
-- Signals & Constants Declaration
-------------------------------------------
--constant  N_RATIO : natural := 8;
--constant  N_DEPTH : natural := 10;

SIGNAL    mod_freq :  unsigned((N_CUM+N_RATIO)-1 downto 0);
SIGNAL    depth    :  signed(N_DEPTH downto 0);
--SIGNAL    mod_freq :  unsigned(N_CUM-1 downto 0);
SIGNAL    delta_freq : signed((N_AUDIO+N_DEPTH) downto 0);
SIGNAL    car_freq    : signed(N_CUM downto 0);
SIGNAL    f_sig      :  signed(N_CUM downto 0);


-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  modulator_frequency: PROCESS(M_fsig,fm_ratio)
  BEGIN	
	
  mod_freq <= unsigned(M_fsig)*unsigned(fm_ratio);
  --mod_freq <= to_unsigned(fix_mult, N_CUM);
	
  END PROCESS modulator_frequency;  

  carrier_frequency: PROCESS(M_fsig,fm_depth,mod_data, depth, delta_freq, f_sig) -- needs confirmation
  BEGIN
  depth <= '0' & signed(fm_depth);
  delta_freq <= signed(mod_data)*depth;
  f_sig <=  '0' & signed(M_fsig);
  car_freq <= delta_freq(N_AUDIO+N_DEPTH downto 4) + f_sig;


  END PROCESS carrier_frequency;  
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  car_M <= std_logic_vector(car_freq(N_CUM-1 downto 0));
  mod_M <= std_logic_vector(mod_freq((N_CUM+N_RATIO)-1 downto N_RATIO));
  mod_on <= tone_on;
  car_on <= tone_on;
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;
