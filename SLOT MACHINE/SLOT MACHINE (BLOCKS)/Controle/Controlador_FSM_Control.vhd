library ieee; 
use ieee.std_logic_1164.all; 
USE IEEE.NUMERIC_STD.ALL;

entity Controlador_FSM_Control is

 port(-- Entradas  declaradas
 
		SEM_CREDITO: in std_logic;
		INIT_STOP: in std_logic;
		
		CLOCK: in std_logic;
		RST: in std_logic;
		
		-- Saidas declaradas
		
		C1: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		C2: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		C3: out std_logic;									-- SAIDA PRO SEQUENCIADOR
		
		CREDITO_23: out std_logic;							-- SAIDA PRO CONTADOR DE CREDITO
		HABILITA_CREDITO: out std_logic;					-- SAIDA PRO COMPARADOR	
		RESET_CONTADOR: out std_logic;					-- SAIDA PRO CONTADOR DE CREDITO			
		RODADAS:  out std_logic_vector (3 downto 0); -- SAIDA PRO DECOD
		ESTADOS:  out std_logic_vector (3 downto 0)
		
		-- Saidas Adicionais
		
);  
end Controlador_FSM_Control; 

--------------------------------------------------------------------------

architecture ARCH of Controlador_FSM_Control is

	type STATES is (E0, E1, E2, E3, E4, E5, E6);
	signal EA, PE : STATES;
	SIGNAL INCREMENTA_RODADAS: std_logic_vector (3 downto 0);
	
	
	begin
		process(CLOCK, RST)
			begin
				if RST = '0' then
					EA <= E0;

				elsif rising_edge(CLOCK) then
					EA <= PE;
				end if;
		end process;

		process(EA, INIT_STOP)
			begin

				case EA is

				when E0 =>
					
					if (INIT_STOP = '0') then
						RESET_CONTADOR <= '1';
						HABILITA_CREDITO <= '0';
						C1 <= '0';
						C2 <= '0';
						C3 <= '0';
					
						PE <= E1;
					
					else
					
						PE <= E0;
					
					end if;
				
				when E1 =>
						RESET_CONTADOR <= '0';
						CREDITO_23 <= '1';
						
						INCREMENTA_RODADAS <= "0000";
					
						PE <= E2;
				
				when E2 =>		--ESPERA
				
					if (INIT_STOP = '0') then
						CREDITO_23 <= '0';
						C1 <= '1';
						C2 <= '1';
						C3 <= '1';
						HABILITA_CREDITO <= '0';
						
						PE <= E3;
					
					else
					
						PE <= E2;
					
					end if;
					
				when E3 =>		-- SEQ 1
					if (INIT_STOP = '0') then
						C1 <= '0';
						C2 <= '1';
						C3 <= '1';
					
						PE <= E4;
					
					else
					
						PE <= E3;
					
					end if;
					
				when E4 =>		-- SEQ 2
					if (INIT_STOP = '0') then
						C1 <= '0';
						C2 <= '0';
						C3 <= '1';
						PE <= E5;
					
					else
					
						PE <= E4;
					
					end if;
					
				when E5 =>		-- SEQ 3
				
				if (INIT_STOP = '0') then
					
					C1 <= '0';
					C2 <= '0';
					C3 <= '0';
					
					PE <= E6;
					
					else
					
						PE <= E5;
					
					end if;
					
				when E6 =>		-- TESTE
					
					INCREMENTA_RODADAS <= std_logic_vector(unsigned(INCREMENTA_RODADAS) + 1);
					
					HABILITA_CREDITO <= '1';
					
					if (INCREMENTA_RODADAS = "1010" or SEM_CREDITO = '1') then
						
						PE <= E0;
						
					else
					
						PE <= E2;
						
					end if;
					
			end case;
			
 end process;
						RODADAS <= INCREMENTA_RODADAS;
						
end ARCH;