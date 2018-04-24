----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:22:47 04/04/2018 
-- Design Name: 
-- Module Name:    i2c_ctrl - RTL 
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
use IEEE.NUMERIC_STD.ALL;
use work.reg_table_pkg.ALL;


entity i2c_ctrl is
  port(
    clk           : in    std_logic;
	 reset			: in	  std_logic;
    ctrl_init     : in    std_logic; 
    select_mode   : in    std_logic_vector(1 downto 0);
    write_o       : out   std_logic;
    write_data_o  : out   std_logic_vector(15 downto 0);
    write_done_i  : in    std_logic;
	ack_error_i   : in	  std_logic
	);
			  
end i2c_ctrl;

architecture rtl of i2c_ctrl is

-- Signals & Constants Declaration
-------------------------------------------

  CONSTANT address_bit_length       : natural := 7;
  CONSTANT register_array_length    : natural := 10;

  TYPE t_state IS (s_idle, s_send_data, s_send_wait);   -- declaration of new datatype
  SIGNAL s_state, s_nextstate       : t_state := s_idle; 
  SIGNAL reg_count, next_reg_count  : natural range 0 to (register_array_length-1); -- Contador e indexador para arrey de configuracao do WN
  SIGNAL write_data                 : std_logic_vector(15 downto 0);        -- Sequencia de bits a ser enviada
  SIGNAL send_data, next_send_data  : std_logic;                            -- Flag para enviar data
  --SIGNAL mode                       : std_logic_vector(8 downto 0);


BEGIN

  --------------------------------------------------
  -- PROCESS FOR COMB-INPUT LOGIC
  --------------------------------------------------

  fsm_drive : PROCESS (s_state, ctrl_init, write_done_i, send_data, reg_count, ack_error_i, select_mode)
  BEGIN
    
    -----------------------------------------------------------------------
    -- Default Statement, mostly keep current value
    -----------------------------------------------------------------------
    s_nextstate <= s_state;
    next_send_data <= '0';
    write_data <= "0000000000000000";
    next_reg_count <= reg_count;


  IF (select_mode = "00") THEN
    CASE s_state IS
      WHEN s_idle =>
        next_reg_count <= 0;
        IF (ctrl_init = '1') THEN
          s_nextstate <= s_send_data;
        ELSE 
          s_nextstate <= s_idle;
        END IF;


      WHEN s_send_data => 
        write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_BYPASS (reg_count);
        next_send_data <= '1';
        s_nextstate <= s_send_wait;

      WHEN s_send_wait =>
		   write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_BYPASS (reg_count);
        IF (write_done_i = '1') AND (reg_count < register_array_length-1) THEN
          next_reg_count <= reg_count + 1;
          s_nextstate <= s_send_data;

        ELSIF ((write_done_i = '1') AND (reg_count = register_array_length-1)) OR (ack_error_i = '1') THEN
          s_nextstate <= s_idle;
        END IF;
    END CASE;

  ELSIF (select_mode = "01") THEN

    CASE s_state IS
      WHEN s_idle =>
        next_reg_count <= 0;
        IF (ctrl_init = '1') THEN
          s_nextstate <= s_send_data;
        ELSE 
          s_nextstate <= s_idle;
        END IF;


      WHEN s_send_data => 
        write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_LEFT (reg_count);
        next_send_data <= '1';
        s_nextstate <= s_send_wait;

      WHEN s_send_wait =>
		  write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_LEFT (reg_count);
        IF (write_done_i = '1') AND (reg_count < register_array_length-1) THEN
          next_reg_count <= reg_count + 1;
          s_nextstate <= s_send_data;

        ELSIF ((write_done_i = '1') AND (reg_count = register_array_length-1)) OR (ack_error_i = '1') THEN
          s_nextstate <= s_idle;
        END IF;
    END CASE;

  ELSIF (select_mode = "10") THEN

    CASE s_state IS
      WHEN s_idle =>
        next_reg_count <= 0;
        IF (ctrl_init = '1') THEN
          s_nextstate <= s_send_data;
        ELSE 
          s_nextstate <= s_idle;
        END IF;


      WHEN s_send_data => 
        write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_RIGHT (reg_count);
        next_send_data <= '1';
        s_nextstate <= s_send_wait;

      WHEN s_send_wait =>
		  write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_RIGHT (reg_count);
        IF (write_done_i = '1') AND (reg_count < register_array_length-1) THEN
          next_reg_count <= reg_count + 1;
          s_nextstate <= s_send_data;

        ELSIF ((write_done_i = '1') AND (reg_count = register_array_length-1)) OR (ack_error_i = '1') THEN
          s_nextstate <= s_idle;
        END IF;
    END CASE;

  ELSIF (select_mode = "11") THEN

    CASE s_state IS
      WHEN s_idle =>
        next_reg_count <= 0;
        IF (ctrl_init = '1') THEN
          s_nextstate <= s_send_data;
        ELSE 
          s_nextstate <= s_idle;
        END IF;


      WHEN s_send_data => 
        write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_BOTH (reg_count);
        next_send_data <= '1';
        s_nextstate <= s_send_wait;

      WHEN s_send_wait =>
		  write_data <= std_logic_vector(to_unsigned(reg_count,address_bit_length)) & C_W8731_ANALOG_MUTE_BOTH (reg_count);
        IF (write_done_i = '1') AND (reg_count < register_array_length-1) THEN
          next_reg_count <= reg_count + 1;
          s_nextstate <= s_send_data;

        ELSIF ((write_done_i = '1') AND (reg_count = register_array_length-1)) OR (ack_error_i = '1') THEN
          s_nextstate <= s_idle;
        END IF;
    END CASE;
  END IF;


  END PROCESS fsm_drive;
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  PROCESS (clk, reset)
  BEGIN
	 IF (reset = '0') THEN
		s_state <= s_idle;
		reg_count <= 0;
		send_data <= '0';
    ELSIF rising_edge(clk) THEN
      s_state <= s_nextstate;
      reg_count <= next_reg_count;
      send_data <= next_send_data;
    END IF;
  END PROCESS;

  -----------------------------------------------------------------------
  -- Concurrent Assignments for Output Signals                                                      
  -----------------------------------------------------------------------

  write_data_o  <= write_data;
  write_o       <= send_data;

  -----------------------------------------------------------------------

end rtl;