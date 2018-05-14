-------------------------------------------
-- Block code:  tone_decoder.vhd
-- History: 	12.May.2018 - 1st version (dqtm)
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
entity tone_decoder is
  PORT( 
  note_on_in	: in std_logic_vector (N_MIDI_DATA-1 downto 0);
  midi_note_in	: in std_logic_vector (N_MIDI_DATA-1 downto 0);
  vecity_in		: in std_logic_vector (N_MIDI_DATA-1 downto 0);
  
  note_on_out	: out std_logic;
  phi_incr_out : out std_logic_vector	(N_CUM-1 downto 0);
  velocity_out	: out std_logic_vector 	(N_MIDI_DATA-1 downto 0)
  );
end tone_decoder;

-- Architecture Declaration
-------------------------------------------
architecture rtl of tone_decoder is
-- Signals & Constants Declaration
-------------------------------------------


-- Begin Architecture
-------------------------------------------
BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS()
	variable midi_note :	unsigned(N_MIDI_DATA-1 downto 0);
  BEGIN	
	midi_note := unsigned(note_on_in);
	
	case midi_note is
	
		when 12 => 
			phi_incr_out <= C0_DO;
		when 13 => 
			phi_incr_out <= C0S_DOS;
		when 14 => 
			phi_incr_out <= D0_RE;
		when 15 => 
			phi_incr_out <= D0S_RES;
		when 16 => 
			phi_incr_out <= E0_MI;
		when 17 => 
			phi_incr_out <= F0_FA;
		when 18 => 
			phi_incr_out <= F0S_FAS;
		when 19 => 
			phi_incr_out <= G0_SOL;
		when 20 => 
			phi_incr_out <= G0S_SOLS;
		when 21 => 
			phi_incr_out <= A0_LA;
		when 22 => 
			phi_incr_out <= A0S_LAS;
		when 23 => 
			phi_incr_out <= B0S_SI;	
	
	
		when 24 => 
			phi_incr_out <= C1_DO;
		when 25 => 
			phi_incr_out <= C1S_DOS;
		when 26 => 
			phi_incr_out <= D1_RE;
		when 27 => 
			phi_incr_out <= D1S_RES;
		when 28 => 
			phi_incr_out <= E1_MI;
		when 29 => 
			phi_incr_out <= F1_FA;
		when 30 => 
			phi_incr_out <= F1S_FAS;
		when 31 => 
			phi_incr_out <= G1_SOL;
		when 32 => 
			phi_incr_out <= G1S_SOLS;
		when 33 => 
			phi_incr_out <= A1_LA;
		when 34 => 
			phi_incr_out <= A1S_LAS;
		when 35 => 
			phi_incr_out <= B1S_SI;	
	
		when 36 => 
			phi_incr_out <= C2_DO;
		when 37 => 
			phi_incr_out <= C2S_DOS;
		when 38 => 
			phi_incr_out <= D2_RE;
		when 39 => 
			phi_incr_out <= D2S_RES;
		when 40 =>
			phi_incr_out <= E2_MI;
		when 41 => 
			phi_incr_out <= F2_FA;
		when 42 => 
			phi_incr_out <= F2S_FAS;
		when 43 => 
			phi_incr_out <= G2_SOL;
		when 44 => 
			phi_incr_out <= G2S_SOLS;
		when 45 => 
			phi_incr_out <= A2_LA;
		when 46 => 
			phi_incr_out <= A2S_LAS;
		when 47 => 
			phi_incr_out <= B2S_SI;		
	
		when 48 => 
			phi_incr_out <= C3_DO;
		when 49 => 
			phi_incr_out <= C3S_DOS;
		when 50 => 
			phi_incr_out <= D3_RE;
		when 51 => 
			phi_incr_out <= D3S_RES;
		when 52 => 
			phi_incr_out <= E3_MI;
		when 53 => 
			phi_incr_out <= F3_FA;
		when 54 => 
			phi_incr_out <= F3S_FAS;
		when 55 => 
			phi_incr_out <= G3_SOL;
		when 56 => 
			phi_incr_out <= G3S_SOLS;
		when 57 => 
			phi_incr_out <= A3_LA;
		when 58 => 
			phi_incr_out <= A3S_LAS;
		when 59 => 
			phi_incr_out <= B3S_SI;	
	
		when 60 => 
			phi_incr_out <= C4_DO;
		when 61 => 
			phi_incr_out <= C4S_DOS;
		when 62 => 
			phi_incr_out <= D4_RE;
		when 63 => 
			phi_incr_out <= D4S_RES;
		when 64 => 
			phi_incr_out <= E4_MI;
		when 65 => 
			phi_incr_out <= F4_FA;
		when 66 => 
			phi_incr_out <= F4S_FAS;
		when 67 => 
			phi_incr_out <= G4_SOL;
		when 68 => 
			phi_incr_out <= G4S_SOLS;
		when 69 => 
			phi_incr_out <= A4_LA;
		when 70 => 
			phi_incr_out <= A4S_LAS;
		when 71 => 
			phi_incr_out <= B4S_SI;
			
		when 72 => 
			phi_incr_out <= C5_DO;
		when 73 => 
			phi_incr_out <= C5S_DOS;
		when 74 => 
			phi_incr_out <= D5_RE;
		when 75 => 
			phi_incr_out <= D5S_RES;
		when 76 => 
			phi_incr_out <= E5_MI;
		when 77 => 
			phi_incr_out <= F5_FA;
		when 78 => 
			phi_incr_out <= F5S_FAS;
		when 79 => 
			phi_incr_out <= G5_SOL;
		when 80 => 
			phi_incr_out <= G5S_SOLS;
		when 81 => 
			phi_incr_out <= A5_LA;
		when 82 => 
			phi_incr_out <= A5S_LAS;
		when 83 => 
			phi_incr_out <= B5S_SI;

		when 84 => 
			phi_incr_out <= C6_DO;
		when 85 => 
			phi_incr_out <= C6S_DOS;
		when 86 => 
			phi_incr_out <= D6_RE;
		when 87 => 
			phi_incr_out <= D6S_RES;
		when 88 => 
			phi_incr_out <= E6_MI;
		when 89 => 
			phi_incr_out <= F6_FA;
		when 90 => 
			phi_incr_out <= F6S_FAS;
		when 91 => 
			phi_incr_out <= G6_SOL;
		when 92 => 
			phi_incr_out <= G6S_SOLS;
		when 93 => 
			phi_incr_out <= A6_LA;
		when 94 => 
			phi_incr_out <= A6S_LAS;
		when 95 => 
			phi_incr_out <= B6S_SI;	
			
		when 96 => 
			phi_incr_out <= C7_DO;
		when 97 => 
			phi_incr_out <= C7S_DOS;
		when 98 => 
			phi_incr_out <= D7_RE;
		when 99 => 
			phi_incr_out <= D7S_RES;
		when 100 => 
			phi_incr_out <= E7_MI;
		when 101 => 
			phi_incr_out <= F7_FA;
		when 102 => 
			phi_incr_out <= F7S_FAS;
		when 103 => 
			phi_incr_out <= G7_SOL;
		when 104 => 
			phi_incr_out <= G7S_SOLS;
		when 105 => 
			phi_incr_out <= A7_LA;
		when 106 => 
			phi_incr_out <= A7S_LAS;
		when 107 => 
			phi_incr_out <= B7S_SI;	
			
  END PROCESS comb_logic;   
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(clk, reset_n)
  BEGIN	
  	IF reset_n = '0' THEN

    ELSIF rising_edge(clk) THEN

    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------

  
  
 -- End Architecture 
------------------------------------------- 
END rtl;