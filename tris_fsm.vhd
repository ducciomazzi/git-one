LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY TRIS_FSM IS
PORT (
	ff_inputA, ff_inputB : in std_logic_vector (8 downto 0);
	clock, reset : in std_logic;
	ff_enableA, ff_enableB: out std_logic;
	turn_light : out std_logic
	);
END TRIS_FSM;


ARCHITECTURE FSM OF Tris_FSM IS
	
	TYPE State_type IS (M_Reset, M_TurnA, M_TurnB, M_TurnA_Int, M_TurnB_Int, M_WinA, M_WinB);  --stati possibili della macchina a stati

	SIGNAL y_Q, Y_D : State_type := M_Reset; -- y_Q stato presente, Y_D stato futuro
	SIGNAL winA, winB : std_logic;
	
	BEGIN
	
	winA <= (ff_inputA(0) AND ff_inputA(1) AND ff_inputA(2)) OR
			(ff_inputA(3) AND ff_inputA(4) AND ff_inputA(5)) OR
			(ff_inputA(6) AND ff_inputA(7) AND ff_inputA(8)) OR
			(ff_inputA(0) AND ff_inputA(3) AND ff_inputA(6)) OR
			(ff_inputA(1) AND ff_inputA(4) AND ff_inputA(7)) OR
			(ff_inputA(2) AND ff_inputA(5) AND ff_inputA(8)) OR
			(ff_inputA(0) AND ff_inputA(4) AND ff_inputA(8)) OR
			(ff_inputA(2) AND ff_inputA(4) AND ff_inputA(6));

	winB <= (ff_inputB(0) AND ff_inputB(1) AND ff_inputB(2)) OR
			(ff_inputB(3) AND ff_inputB(4) AND ff_inputB(5)) OR
			(ff_inputB(6) AND ff_inputB(7) AND ff_inputB(8)) OR
			(ff_inputB(0) AND ff_inputB(3) AND ff_inputB(6)) OR
			(ff_inputB(1) AND ff_inputB(4) AND ff_inputB(7)) OR
			(ff_inputB(2) AND ff_inputB(5) AND ff_inputB(8)) OR
			(ff_inputB(0) AND ff_inputB(4) AND ff_inputB(8)) OR
			(ff_inputB(2) AND ff_inputB(4) AND ff_inputB(6));
			
			
	advance_state : PROCESS (clock) -- state flip-flops
	BEGIN
		IF falling_edge( clock) then    
			IF reset = '0' then
				y_Q <= M_Reset;           -- se si resetta, si torna allo stato di reset A
			ELSIF reset = '1' then
				y_Q <= y_D;     -- negli altri casi, si assegna lo stato successivo 
			END IF;				 -- allo stato corrente per essere usato nella FSM
		END IF;
	END PROCESS;

	next_state : PROCESS (y_Q, ff_inputA, ff_inputB) --determina il prossimo stato
		BEGIN
		CASE y_Q IS
			WHEN M_Reset => 
				y_D <= M_TurnA;
				
			WHEN M_TurnA =>
				IF (winA = '1') THEN
					y_D <= M_WinA;
				ELSIF (winB = '1') THEN
					y_D <= M_WinB;
				ELSIF (rising_edge(ff_inputA(0)) OR rising_edge(ff_inputA(1)) OR rising_edge(ff_inputA(2)) OR rising_edge(ff_inputA(3)) OR rising_edge(ff_inputA(4)) OR rising_edge(ff_inputA(5)) OR rising_edge(ff_inputA(6)) OR rising_edge(ff_inputA(7)) OR rising_edge(ff_inputA(8))) THEN
					y_D <=  M_TurnB;
				ELSE 
					y_D <=  M_TurnA;
				END IF;
			
			WHEN M_TurnB =>
				IF (winA = '1') THEN
					y_D <= M_WinA;
				ELSIF (winB = '1') THEN
					y_D <= M_WinB;
				ELSIF (rising_edge(ff_inputB(0)) OR rising_edge(ff_inputB(1)) OR rising_edge(ff_inputB(2)) OR rising_edge(ff_inputB(3)) OR rising_edge(ff_inputB(4)) OR rising_edge(ff_inputB(5)) OR rising_edge(ff_inputB(6)) OR rising_edge(ff_inputB(7)) OR rising_edge(ff_inputB(8))) THEN
					y_D <=  M_TurnA;
				ELSE 
					y_D <=  M_TurnB;
				END IF;
			
			WHEN M_WinA =>
				y_D <= M_WinA;				 
				
			WHEN M_WinB =>
				y_D <= M_WinB;	

			WHEN M_TurnA_Int =>
				IF (winA = '1') THEN
					y_D <= M_WinA;
				ELSIF (winB = '1') THEN
					y_D <= M_WinB;
				ELSIF (falling_edge(ff_inputA(0)) OR falling_edge(ff_inputA(1)) OR falling_edge(ff_inputA(2)) OR falling_edge(ff_inputA(3)) OR falling_edge(ff_inputA(4)) OR falling_edge(ff_inputA(5)) OR falling_edge(ff_inputA(6)) OR falling_edge(ff_inputA(7)) OR falling_edge(ff_inputA(8))) THEN
					y_D <=  M_TurnB;
				ELSE 
					y_D <=  M_TurnA_Int;
				END IF;
			
			WHEN M_TurnB_Int =>
				IF (winA = '1') THEN
					y_D <= M_WinA;
				ELSIF (winB = '1') THEN
					y_D <= M_WinB;
				ELSIF (falling_edge(ff_inputB(0)) OR falling_edge(ff_inputB(1)) OR falling_edge(ff_inputB(2)) OR falling_edge(ff_inputB(3)) OR falling_edge(ff_inputB(4)) OR falling_edge(ff_inputB(5)) OR falling_edge(ff_inputB(6)) OR falling_edge(ff_inputB(7)) OR falling_edge(ff_inputB(8))) THEN
					y_D <=  M_TurnA;
				ELSE 
					y_D <=  M_TurnB_Int;
				END IF;
		END CASE;
	END PROCESS;

	 
	state_outputs : PROCESS (y_Q) --output associati allo stato corrente
	BEGIN

	CASE y_Q IS
		WHEN M_Reset => ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '0';
						
		WHEN M_TurnA =>ff_enableA <= '1';
						ff_enableB <= '0';
						turn_light <= '0';
						
		WHEN M_TurnB =>ff_enableA <= '0';
						ff_enableB <= '1';
						turn_light <= '1';
						
		WHEN M_WinA =>	ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '0';
			
		WHEN M_WinB =>	ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '1';

		WHEN M_TurnA_Int =>ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '0';
						
		WHEN M_TurnB_Int =>ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '1';
						
			
		WHEN OTHERS =>	ff_enableA <= '0';
						ff_enableB <= '0';
						turn_light <= '0';
	END CASE;
END PROCESS;
	
END FSM;
