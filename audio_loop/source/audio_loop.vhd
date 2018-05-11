----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:09:42 04/25/2018 
-- Design Name: 
-- Module Name:    audio_loop - bdf 
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

entity audio_loop is
  port(
   CLOCK_50 : in std_logic;
   KEY   : in std_logic_vector(1 downto 0);
   SW     : in std_logic_vector(1 downto 0);

   AUD_XCK : out std_logic;
   I2C_SCLK  : out   STD_LOGIC;
   I2C_SDAT  : inout STD_LOGIC;


   AUD_DACDAT : out  std_logic;
   AUD_BCLK   : out  std_logic;
   AUD_DACLRCK : out std_logic;
   AUD_ADCLRCK : out std_logic;
   AUD_ADCDAT : in std_logic

  );
end audio_loop;

architecture bdf of audio_loop is



component i2s
  port(
  CLOCK_12M   : in    std_logic;
  RST_N_12M   : in    std_logic;

  DACDAT_pl_i : in   std_logic_vector(15 downto 0);
  DACDAT_pr_i : in  std_logic_vector(15 downto 0);
  ADCDAT_s_i  : in  std_logic;
  ADCDAT_pl_o : out   std_logic_vector(15 downto 0);
  ADCDAT_pr_o : out   std_logic_vector(15 downto 0);
  DACDAT_s_o  : out   std_logic;
  BCLK_o      : out   std_logic;
  WS_o        : out   std_logic;
  STROBE      : out   std_logic
  );
end component;

component	audio_synth
  port(
    CLOCK_50  : in    STD_LOGIC;
    AUD_XCK : OUT STD_LOGIC;
    RESET   : out std_logic;
    KEY       : in    STD_LOGIC_VECTOR(1 downto 0);
    SW      : in std_logic_vector(1 downto 0);
    I2C_SCLK  : out   STD_LOGIC;
    I2C_SDAT  : inout STD_LOGIC

  );
end component;

signal clock_50_intern : std_logic;
signal aud_xck_intern	: std_logic;
signal reset_intern : std_logic;
signal parallel_data_intern_l : std_logic_vector(15 downto 0);
signal parallel_data_intern_r : std_logic_vector(15 downto 0);
signal aud_adcdat_intern : std_logic;
signal aud_dacdat_intern  : std_logic;
signal aud_bclk_intern : std_logic;
signal rst_intern : std_logic;
signal ws_intern : std_logic;

signal key_intern : std_logic_vector(1 downto 0);
signal sw_intern  : std_logic_vector(1 downto 0);
signal i2c_sclk_intern : std_logic;
signal i2c_sdat_intern : std_logic;

--signal ;



begin

b2v_inst1 : i2s
  port map (
    CLOCK_12M  => aud_xck_intern,
    RST_N_12M  => reset_intern,

    DACDAT_pl_i => parallel_data_intern_l,
    DACDAT_pr_i => parallel_data_intern_r,
    ADCDAT_s_i  => aud_adcdat_intern,
    ADCDAT_pl_o => parallel_data_intern_l,
    ADCDAT_pr_o => parallel_data_intern_r,
    DACDAT_s_o  => aud_dacdat_intern,
    BCLK_o      => aud_bclk_intern,  
    WS_o        => ws_intern, 
    STROBE      => open
  );

b2v_inst2 : audio_synth
  port map (
    CLOCK_50  => clock_50_intern,
    AUD_XCK   => aud_xck_intern,
    RESET     => reset_intern,
    KEY       => key_intern,
    SW        => sw_intern,
    I2C_SCLK  => i2c_sclk_intern,
    I2C_SDAT  => I2C_SDAT

	);  

clock_50_intern <= CLOCK_50;
key_intern      <= KEY;
sw_intern       <= SW;
AUD_XCK         <= aud_xck_intern;
I2C_SCLK        <= i2c_sclk_intern;
--I2C_SDAT        <= i2c_sdat_intern;
AUD_DACDAT      <= aud_dacdat_intern;
AUD_BCLK        <= aud_bclk_intern;
AUD_DACLRCK     <= ws_intern;
AUD_ADCLRCK     <= ws_intern;
aud_adcdat_intern <= AUD_ADCDAT; 





end bdf;