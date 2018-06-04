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
USE ieee.numeric_std.all;
USE work.tone_gen_pkg.all;
USE work.fm_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity synth_fm is
  port(
   CLOCK_50 : in std_logic;
   KEY   : in std_logic_vector(1 downto 0);
   SW     : in std_logic_vector(4 downto 0);

   AUD_XCK : out std_logic;
   I2C_SCLK  : out   STD_LOGIC;
   I2C_SDAT  : inout STD_LOGIC;


   AUD_DACDAT : out  std_logic;
   AUD_BCLK   : out  std_logic;
   AUD_DACLRCK : out std_logic;
   AUD_ADCLRCK : out std_logic

  );
end synth_fm;

architecture bdf of synth_fm is



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

component DDS_top
  port(
    clk         :   in  std_logic; 
    reset_n     :   in  std_logic;   
    MIDI_note   :   in  std_logic_vector(N_MIDI_DATA-1 downto 0);
    Note_ON     :   in  std_logic;
    tone_out    :   out std_logic_vector(N_AUDIO-1 downto 0);
    strobe      :   in std_logic

  );
end component;

component FM
  port(
  clk,reset_n :   in  std_logic;  
  tone_cmd    :   in  std_logic_vector(N_MIDI_DATA-1 downto 0);
  tone_on     :   in  std_logic;
  strobe      :   in std_logic; 
  fm_ratio    :   in std_logic_vector(N_RATIO-1 downto 0);
  fm_depth    :   in std_logic_vector(N_DEPTH-1 downto 0);
  data_g      :   out std_logic_vector(N_AUDIO-1 downto 0)
  );
end component;

component board_interface
  port(
  CLOCK_12M : in   STD_LOGIC;
  SW        : in std_logic_vector(2 downto 0);
  MIDI_NOTE : out std_logic_vector(6 downto 0);
  NOTE_ON   : out std_logic;
  FM_RATIO    : out    std_logic_vector(N_RATIO-1 downto 0);
  FM_DEPTH    : out    std_logic_vector(N_DEPTH-1 downto 0)

  );
end component;


signal clock_50_intern : std_logic;
signal aud_xck_intern	: std_logic;
signal reset_intern : std_logic;
signal parallel_data_intern : std_logic_vector(15 downto 0);
signal aud_adcdat_intern : std_logic;
signal aud_dacdat_intern  : std_logic;
signal aud_bclk_intern : std_logic;
signal rst_intern : std_logic;
signal ws_intern : std_logic;
signal strobe_intern : std_logic;

signal midi_note_intern : std_logic_vector(6 downto 0);
signal note_on_intern : std_logic;
signal fm_depth_intern : std_logic_vector(N_DEPTH-1 downto 0);
signal fm_ratio_intern : std_logic_vector(N_RATIO-1 downto 0);

signal key_intern : std_logic_vector(1 downto 0);
signal sw_intern  : std_logic_vector(4 downto 0);
signal i2c_sclk_intern : std_logic;
signal i2c_sdat_intern : std_logic;

--signal ;



begin

b2v_inst1 : i2s
  port map (
    CLOCK_12M  => aud_xck_intern,
    RST_N_12M  => reset_intern,

    DACDAT_pl_i => parallel_data_intern,
    DACDAT_pr_i => parallel_data_intern,
    ADCDAT_s_i  => aud_adcdat_intern,
    ADCDAT_pl_o => open,
    ADCDAT_pr_o => open,
    DACDAT_s_o  => aud_dacdat_intern,
    BCLK_o      => aud_bclk_intern,  
    WS_o        => ws_intern, 
    STROBE      => strobe_intern
  );

b2v_inst2 : audio_synth
  port map (
    CLOCK_50  => clock_50_intern,
    AUD_XCK   => aud_xck_intern,
    RESET     => reset_intern,
    KEY       => key_intern,
    SW(0)     => sw_intern(0),
    SW(1)     => sw_intern(1),
    I2C_SCLK  => i2c_sclk_intern,
    I2C_SDAT  => I2C_SDAT

	);  

b2v_inst3 : FM
  port map (
    clk       => aud_xck_intern,
    reset_n   => reset_intern,
    tone_cmd => midi_note_intern,
    tone_on   => note_on_intern,
    data_g  => parallel_data_intern,
    strobe    => strobe_intern,
    fm_ratio => fm_ratio_intern,
    fm_depth => fm_depth_intern

  );  

b2v_inst4 : board_interface
  port map (
    CLOCK_12M => aud_xck_intern,
    SW(0)     => sw_intern(2),
    SW(1)     => sw_intern(3),
    SW(2)     => sw_intern(4),
    MIDI_NOTE => midi_note_intern,
    NOTE_ON   => note_on_intern,
    FM_RATIO => fm_ratio_intern,
    FM_DEPTH => fm_depth_intern

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
aud_adcdat_intern <= '0'; 





end bdf;