----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:22:47 04/04/2018 
-- Design Name: 
-- Module Name:    audio_synth_top - Behavioral 
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
use work.reg_table_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_synth_top is
  port(
		CLOCK_50  : in  	STD_LOGIC;
    KEY 		  : in  	STD_LOGIC_VECTOR (3 downto 0);
    SW 		    : in  	STD_LOGIC_VECTOR (9 downto 0);
    AUD_XCK   : out  	STD_LOGIC;
    I2C_SCLK  : out   STD_LOGIC;
    I2C_SDAT  : inout	STD_LOGIC
	);
			  
end audio_synth_top;

architecture rtl of audio_synth_top is

component i2c_master is
  port(
    clk         : in    std_logic;
    reset_n     : in    std_logic;
    write_i     : in    std_logic;
    write_data_i: in    std_logic_vector(15 downto 0); 
    sda_io      : inout std_logic;
    scl_o       : out   std_logic;  
    write_done_o: out   std_logic;
    ack_error_o : out   std_logic
  );
end component i2c_master;

component i2c_slave_bfm is
  port (
    sda_io    : inout std_logic := 'H';
    scl_io    : inout std_logic := 'H'
  );
end component i2c_slave_bfm;

-- Signals & Constants Declaration
-------------------------------------------
  SIGNAL    SW_DEBOUNCE : STD_LOGIC_VECTOR (9 downto 0);
  SIGNAL    counter     : NATURAL range 0 to 4 := 0;
  SIGNAL    CLOCK_12M5  : STD_LOGIC := 0;
  SIGNAL    Left_Volume : STD_LOGIC_VECTOR (6 downto 0) := "1111001";
  SIGNAL    Right_Volume: STD_LOGIC_VECTOR (6 downto 0) := "1111001";
  SIGNAL    new_event   : STD_LOGIC := 0;

begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATIONAL LOGIC
  --------------------------------------------------

  ------------- Processa os botoes -----------------
  check_key_1: PROCESS(KEY)
  BEGIN 
  IF rising_edge(KEY(1))  THEN 
    -- Aumenta o volume
    IF Left_Volume OR Right_Volume < "1111111" THEN
      Left_Volume = Left_Volume + 1;
      Right_Volume = Right_Volume + 1;

      new_event = 1;
      -- write_data_i <= '0000000' + 
    END IF;
    
    ELSE
    -- Não faz nada
    END IF;
  END PROCESS check_key_1;  

  check_key_2: PROCESS(KEY)
  BEGIN 
  IF rising_edge(KEY(2))  THEN 
    -- Diminui o volume
    IF Left_Volume OR Right_Volume > "0000000" THEN
      Left_Volume = Left_Volume - 1;
      Right_Volume = Right_Volume - 1;

      new_event = 1;
      -- write_data_i <= '0000000' + 
    ELSE
    -- Não faz nada
    END IF;
  END PROCESS check_key_2;  


  check_key_3: PROCESS(KEY)
  BEGIN 
  IF rising_edge(KEY(3))  THEN 
    
    new_event = 1;
    ELSE
    -- Não faz nada
    END IF;
  END PROCESS check_key_3;  


  check_key_4: PROCESS(KEY)
  BEGIN 
  IF rising_edge(KEY(4))  THEN 
  
    new_event = 1;
    ELSE
    -- Não faz nada
    END IF;
  END PROCESS check_key_4;  
--------------------------------------------------

------ Gera o clock de 12M5Hz para o CODEC -------
clock_divisor: PROCESS (CLOCK_50)
BEGIN
IF rising_edge(CLOCK_50) THEN
  IF (counter = 4) THEN
    CLOCK_12M5 <= NOT(CLOCK_12M5);
    counter <= 0;
  ELSE
    counter <= counter + 1;
  END IF;
END IF;  
END PROCESS clock_divisor;
--------------------------------------------------



end rtl;

