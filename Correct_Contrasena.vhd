library ieee ;
use ieee.std_logic_1164.all ;    
use ieee.numeric_std.all ;

entity Correct_Contrasena is
	Port(Clock, Reset           : in std_logic;
		 Combinacion 		    : in std_logic_vector(3 downto 0);
		 Led_Verde, Led_Rojo    : out std_logic
		 );
end Correct_Contrasena ; 

architecture Contrasena_Arch of Correct_Contrasena is

type State_Type is (Std_In,Std_Ingresa, Std_primer_int, Std_segundo_int, Std_tercer_int );
signal Estado_Actual, Estado_Siguiente : State_Type;

begin
STATE_MEMORY: process (Clock, Reset)

    begin 
	if (Reset ='1') then 
		Estado_Actual <= Std_In;
	elsif (Clock'event and Clock='1') then 
		Estado_Actual <= Estado_Siguiente;
	end if;
    end process;


NEXT_STATE_LOGIC: process (Estado_Actual, Combinacion)
begin 	
	CASE (Estado_Actual) is 
	    when Std_In =>  if (Combinacion="0110") then
					        Estado_Siguiente<=Std_Ingresa;
						else 
							Estado_Siguiente<=Std_primer_int;
						end if;
							
	    when Std_Ingresa => if (Combinacion="0110") then
							    Estado_Siguiente<=Std_In;
							else 
							    Estado_Siguiente<=Std_primer_int;
							end if;					
        when Std_primer_int =>  if (Combinacion="0110") then
							        Estado_Siguiente<=Std_Ingresa;
							    else 
							        Estado_Siguiente<=Std_segundo_int;
							    end if;
							
	    when Std_segundo_int => if (Combinacion="0110") then
							        Estado_Siguiente<=Std_Ingresa;
							    else 
							        Estado_Siguiente<=Std_tercer_int;
							    end if;

	    when Std_tercer_int =>  if (Combinacion="0110") then
							        Estado_Siguiente<=Std_Ingresa;
							    else 
							        Estado_Siguiente<=Std_In;
							    end if;
							
		when others => Estado_Siguiente<=Std_In;
    
end case;
end process;

OUTPUT_LOGIC : process (Estado_Actual, Combinacion)
	begin
			case (Estado_Actual) is
				when Std_In =>
					if (Combinacion="0110") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
					
				when Std_Ingresa =>  
                    if (Combinacion="0110") then
						Led_Verde<='1'; Led_Rojo<='0';
					else 
						Led_Verde<='0'; Led_Rojo<='1';
					end if;		
							
				when Std_primer_int => 	
					if (Combinacion="0110") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
				when Std_segundo_int  => 	
					if (Combinacion="0110") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
				when Std_tercer_int => 	
				    if (Combinacion="0110") then
					    Led_Verde <= '1'; Led_Rojo <= '0';
				    else
					    Led_Verde <= '0'; Led_Rojo <= '1';
				    end if;
				when others => Led_Verde <= '0'; Led_Rojo <= '0';
	end case;
	end process;

end Contrasena_Arch ;