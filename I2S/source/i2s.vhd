
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:42 04/25/2018 
-- Design Name: 
-- Module Name:    I2S_Master - bdf 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity i2s is
  port(
  CLOCK_12M   : in    std_logic;
  RST 		  : in    std_logic;

  DACDAT_pl_i : in   std_logic_vector(15 downto 0);
  DACDAT_pr_i : in  std_logic_vector(15 downto 0);
  -- ADCDAT_s_i  : in  std_logic;
  --ADCDAT_pl_o : out   std_logic_vector(15 downto 0);
  --ADCDAT_pr_o : out   std_logic_vector(15 downto 0);
  DACDAT_s_o  : out   std_logic;
  BCLK_o      : out   std_logic;
  WS_o        : out   std_logic;
  STROBE      : out   STD_LOGIC
  );
end i2s;

architecture bdf of i2s is



component bclk_gen
  port (  
    clk_in  : IN    std_logic;
    clk_out   : OUT   std_logic;
    rst_n_12M : IN    std_logic
  );
end component;

component	frame_decoder
  port(
    clk_12M   	: in    std_logic;
	 rst_n_12M	: in	  std_logic;
    enable   	: in    std_logic; 
    shift_L   	: out   std_logic;
    shift_R   	: out   std_logic;
    strobe    	: out   std_logic;
	 WS        	: out	  std_logic
	);
end component;
	

component	shiftreg_p2s
  port( 
	clk,set_n	: IN    std_logic;			-- Attention, this block has a set_n input for initialisation!!
  load_i		: IN    std_logic;
  shift 		: IN 	std_logic;
  par_i			: IN    std_logic_vector(15 downto 0);
  ser_o   	: OUT   std_logic
	);	
end component;
	

component DACDAT_o_MUX
    port (
    SER_OUT_L   : IN    std_logic;
    SER_OUT_R   : IN    std_logic;
    WS          : IN    std_logic;
    DACDAT_s_o  : OUT   std_logic
    );
end component;

signal CLOCK_12M_intern	: std_logic;
signal bclk_intern : std_logic;
signal rst_intern : std_logic;
signal ws_intern : std_logic;
signal strobe_intern : std_logic;
signal shift_L_intern : std_logic;
signal shift_R_intern : std_logic;
signal SER_OUT_R_intern :std_logic;
signal SER_OUT_L_intern :std_logic;
signal DACDAT_s_o_intern : std_logic;
--signal ;



begin

b2v_inst1 : bclk_gen
  port map (
    clk_in    => CLOCK_12M_intern,
    clk_out   => bclk_intern,
    rst_n_12M => rst_intern
  );

b2v_inst2 : frame_decoder
	port map (
    clk_12M     => CLOCK_12M_intern,
    rst_n_12M   => rst_intern,
    enable      => bclk_intern, 
    shift_L     => shift_L_intern,
    shift_R     => shift_R_intern,
    strobe      => strobe_intern,
    WS          => ws_intern
	);  

b2v_inst3 : DACDAT_o_MUX
  port map (
    SER_OUT_L   => SER_OUT_L_intern,   
    SER_OUT_R   => SER_OUT_R_intern,
    WS          => ws_intern,
    DACDAT_s_o  => DACDAT_s_o_intern
  );

b2v_inst_Shift_R : shiftreg_p2s
	port map (
    clk   => CLOCK_12M_intern,
    set_n => rst_intern,
    shift  => shift_L_intern,
    load_i  => strobe_intern,
    par_i   => DACDAT_pr_i,
    ser_o   => SER_OUT_R_intern
	);

b2v_inst_Shift_L : shiftreg_p2s
	port map (
    clk   => CLOCK_12M_intern,
    set_n => rst_intern,
    shift  => shift_L_intern,
    load_i  => strobe_intern,
    par_i   => DACDAT_pl_i,
    ser_o   => SER_OUT_L_intern
	);



  -- ADCDAT_s_i
  -- ADCDAT_pl_o
  -- ADCDAT_pr_o
  rst_intern <= RST;
  CLOCK_12M_intern <= CLOCK_12M;
  DACDAT_s_o <= DACDAT_s_o_intern;
  BCLK_o     <= bclk_intern;
  WS_o       <= ws_intern;
  STROBE     <= strobe_intern;


end bdf;