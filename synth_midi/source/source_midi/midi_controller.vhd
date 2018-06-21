LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity midi_controller is 
  port(
  clk, reset        : IN   std_logic;
  data              : IN   std_logic_vector(7 downto 0);
  new_data          : IN   std_logic;
  fm_depth          : OUT  std_logic_vector(6 downto 0);
  fm_ratio          : OUT  std_logic_vector(6 downto 0);
  note_out          : OUT  std_logic_vector(6 downto 0);
  note_on           : OUT  std_logic
  );
end midi_controller;

architecture bdf of midi_controller is

component midi_receiver is
  PORT(
    clk, reset      : IN   std_logic;
    data            : IN   std_logic_vector(7 downto 0);
    new_data        : IN   std_logic;
    controller_num  : OUT std_logic_vector(6 downto 0);
    controller_data : OUT std_logic_vector(6 downto 0);
    note_out        : OUT  std_logic_vector(6 downto 0);
    note_on         : OUT  std_logic;
    velocity        : OUT  std_logic_vector(6 downto 0)
  );
END component;

component midi_decoder is
  PORT (
    clk, reset        : IN   std_logic;
    controller_num    : IN std_logic_vector(6 downto 0);
    controller_data   : IN std_logic_vector(6 downto 0);
    note_out_in       : IN  std_logic_vector(6 downto 0);
    note_on_in        : IN  std_logic;
    velocity          : IN  std_logic_vector(6 downto 0);
    fm_depth          : OUT  std_logic_vector(6 downto 0);
    fm_ratio          : OUT  std_logic_vector(6 downto 0);
    note_out          : OUT  std_logic_vector(6 downto 0);
    note_on           : OUT  std_logic
  );
END component;



signal clock_intern           : std_logic;
signal rst_intern             : std_logic;
signal data_intern            : std_logic_vector(7 downto 0);
signal new_data_intern        : std_logic;
signal controller_num_intern  : std_logic_vector(6 downto 0);
signal controller_data_intern : std_logic_vector(6 downto 0);
signal note_out_intern1       : std_logic_vector(6 downto 0);
signal note_out_intern2       : std_logic_vector(6 downto 0);
signal note_on_intern1        : std_logic;
signal note_on_intern2        : std_logic;
signal velocity_intern        : std_logic_vector(6 downto 0);
signal fm_depth_intern        : std_logic_vector(6 downto 0);
signal fm_ratio_intern        : std_logic_vector(6 downto 0);

begin



  receiver : midi_receiver 
    port map(
    clk             => clock_intern, 
    reset           => rst_intern,
    data            => data_intern,
    new_data        => new_data_intern,
    controller_num  => controller_num_intern,
    controller_data => controller_data_intern,
    note_out        => note_out_intern1,
    note_on         => note_on_intern1,
    velocity        => velocity_intern
    );


  decoder : midi_decoder
    port map(
    clk               => clock_intern,
    reset             => rst_intern,
    controller_num    => controller_num_intern,
    controller_data   => controller_data_intern,
    note_out_in       => note_out_intern1,
    note_on_in        => note_on_intern1,
    velocity          => velocity_intern,
    fm_depth          => fm_depth_intern,
    fm_ratio          => fm_ratio_intern,
    note_out          => note_out_intern2,
    note_on           => note_on_intern2
    );
  
  
  clock_intern <= clk;
  rst_intern <= reset;
  data_intern <= data;
  new_data_intern <= new_data;
  fm_ratio <= fm_ratio_intern;
  fm_depth <= fm_depth_intern;
  note_on <= note_on_intern2;
  note_out <= note_out_intern2;
  
end bdf;