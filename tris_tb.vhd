library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity TB_TRIS is
end TB_TRIS;

architecture TEST of TB_TRIS is

	COMPONENT TOP_TRIS IS
	PORT (
		Input : in std_logic_vector (8 downto 0);
		clock, reset : in std_logic;
		ff_outA, ff_outB: out std_logic_vector (8 downto 0);
		turn_light : out std_logic
	);
	END COMPONENT;


	signal TB_RESET: std_logic := '1';
	signal TB_OUT_A, TB_OUT_B: std_logic_vector(8 downto 0):= "000000000";

  	constant Period: time := 1 ns; -- Clock period (1 GHz)
  	signal TB_CLK : std_logic :='0';
	
  	signal PRN_I: std_logic_vector(8 downto 0):= "000000000";

	SIGNAL TB_TURN_LED : std_logic := '0';

	begin
	
	U_fsm_tris: TOP_TRIS Port Map (PRN_I,TB_CLK,TB_RESET,TB_OUT_A,TB_OUT_B,TB_TURN_LED);

 	TB_CLK <= not TB_CLK after Period/2;
	
	STIMULUS1: process
	begin
		wait for 2 * PERIOD;
		
		TB_RESET <= '0';
		wait for 3 * PERIOD;
		
		TB_RESET <= '1';
		wait for 3 * PERIOD;

		PRN_I <= "000000001";
		wait for 4 * PERIOD;

		PRN_I <= "000000000";
		wait for 4 * PERIOD;

		PRN_I <= "000000010";
		wait for 4 * PERIOD;

		PRN_I <= "000000000";
		wait for 4 * PERIOD;

		PRN_I <= "000010000";
		wait for 4 * PERIOD;

		PRN_I <= "000000000";
		wait for 4 * PERIOD;
		
		PRN_I <= "000000100";
		wait for 4 * PERIOD;

		PRN_I <= "000000000";
		wait for 4 * PERIOD;

		PRN_I <= "100000000";
		wait for 4 * PERIOD;

		PRN_I <= "000000000";
		wait for 4 * PERIOD;

		wait for (65600 * PERIOD);
	end process STIMULUS1;


end TEST;
