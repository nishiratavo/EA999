-------------------------------------------------------------------------------
-- Project     : audio_top
-- Description : Constants and LUT for tone generation with DDS
--

-------------------------------------------------------------------------------
-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in Design of Block fm.vhd and fm_sel.vhd :
--   use work.fm_pkg.all;
-------------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package fm_pkg is


    -------------------------------------------------------------------------------
	-- CONSTANT DECLARATION FOR SEVERAL BLOCKS (DDS, TONE_GENERATOR, ...)
	-------------------------------------------------------------------------------
    constant  N_RATIO : natural := 8;
	constant  N_DEPTH : natural := 10;
	
	-------------------------------------------------------------------------------		
end package;
