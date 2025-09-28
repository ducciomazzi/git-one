LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TOP_TRIS IS
PORT (
	Input : in std_logic_vector (8 downto 0);
	clock, reset : in std_logic;
	ff_outA, ff_outB: out std_logic_vector (8 downto 0);
	turn_light : out std_logic
	);
END TOP_TRIS;


ARCHITECTURE structural OF TOP_TRIS IS
	
	COMPONENT TRIS_FSM
	PORT (
		ff_inputA, ff_inputB : in std_logic_vector (8 downto 0);
		clock, reset : in std_logic;
		ff_enableA, ff_enableB: out std_logic;
		turn_light : out std_logic
		);
	END COMPONENT;
	
	COMPONENT FLIPFLOP
	port(
		CK: in std_logic;
		RN: in std_logic;
		WR: in std_logic;
		RD: out std_logic;
		RDN: out std_logic);
	end COMPONENT;
	
	SIGNAL OutputFFA, OutputFFB : std_logic_vector (8 downto 0);
	SIGNAL ff_en_A, ff_en_B : std_logic;
	SIGNAL clk_ff_A, clk_ff_B : std_logic;
	
	BEGIN
	
	clk_ff_A <= clock AND ff_en_A;
	clk_ff_B <= clock AND ff_en_B;
	
	gen_ffa : for I in 1 to 9 generate
		FFIA : FLIPFLOP port map (clk_ff_A, reset, Input(I-1), OutputFFA(I-1));
	end generate;
	
	gen_ffb : for I in 1 to 9 generate
		FFIB : FLIPFLOP port map (clk_ff_B, reset, Input(I-1), OutputFFB(I-1));
	end generate;
	
	fsm : TRIS_FSM port map (OutputFFA, OutputFFB, clock, reset, ff_en_A, ff_en_B, turn_light);
			
	ff_outA <= OutputFFA;
	ff_outB <= OutputFFB;
	
	
END structural;
