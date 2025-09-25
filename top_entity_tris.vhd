LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TOP_TRIS IS
PORT (
	Input : in std_logic_vector (8 downto 0);
	clock, reset : in std_logic;
	ff_outA, ff_outB: out std_logic_vector (8 downto 0);
	turn_light : out std_logic;
	);
END TRIS_FSM;


ARCHITECTURE FSM OF Tris_FSM IS
	
	BEGIN
			
	
END FSM;
