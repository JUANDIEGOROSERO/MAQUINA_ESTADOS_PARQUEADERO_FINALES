library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity Parqueadero_Final is
    port (
			Password   			    	 	 : in std_logic_vector(3 downto 0);
			Parqueadero 			       : in std_logic_vector(7 downto 0);
			
			Selector					       : in std_logic;
			Front_Sensor, Back_Sensor   : in std_logic;
			
			Reset 		 					 : in std_logic;
			Clock    	  					 : in std_logic;
			
			Led_V, Led_R 			       : out std_logic;
			
			Display_Numero			       : out std_logic_vector(6 downto 0);
			Display_Pago                : out std_logic_vector(6 downto 0)
			);
end Parqueadero_Final; 

architecture Parqueadero_Arch of Parqueadero_Final is
    
   type State_Type is (Std_Inicial, Std_Contrasena,Std_Espera, Std_Estacionamiento);
   signal Estado_actual, Estado_sig : State_Type;

	signal Num_Parq 		  : integer range 1 to 8;
	signal contador_num 	  : integer range 1 to 9 := 1;
	
   signal Count_0 	     : integer range 0 to 8 :=8 ;
	
   signal Pago 	 		  : integer range 0 to 9;
	
   signal enable_P 		  : std_logic_vector(7 downto 0) := (Parqueadero);

-----------------------------------------------------------------------------
component Pago_Contador is
    Port ( Clock, Reset, Enable : in std_logic;
           Pagar : out integer
           );
end component;
	
	signal Pago_1 : integer;
	signal Pago_2 : integer;
	signal Pago_3 : integer;
	signal Pago_4 : integer;
	signal Pago_5 : integer;
	signal Pago_6 : integer;
	signal Pago_7 : integer;
	signal Pago_8 : integer;

-----------------------------------------------------------------------------
component Divisor_Frecuencia is
    Port ( clk : in STD_LOGIC;
           out_clk : out STD_LOGIC
           );
end component;

signal Div_Clk  	  : std_logic;

-----------------------------------------------------------------------------
component Correct_Contrasena is
	Port(Clock, Reset           : in std_logic;
		  Combinacion 		       : in std_logic_vector(3 downto 0);
		  Led_Verde, Led_Rojo    : out std_logic
		 );
end component; 
	
 signal l_verde  : std_logic;
 signal l_rojo   : std_logic;

begin
    
    

STATE_MEMORY: PROCESS (Clock, Reset)
   begin 
	if (Reset ='1') then 
		Estado_actual <= Std_Inicial;
	elsif (Clock'event and Clock='1') then 
		Estado_actual <= Estado_sig;
	end if;
   end process;
    

NEXT_STATE_LOGIC: PROCESS (Estado_actual, Front_Sensor, Back_Sensor)
    begin 
		CASE (Estado_actual) is 
			when Std_Inicial =>  if (Front_Sensor ='1' and Back_Sensor ='0') then
											Estado_sig<=Std_Contrasena;
											else 
												Estado_sig<=Std_Inicial;
										 end if;				
    
			when Std_Contrasena =>  if ( Back_Sensor ='1' and l_verde = '1'  ) then
												Estado_sig<=Std_Estacionamiento;
												else 
													Estado_sig<= Std_Espera;
											end if;
            
			when Std_Espera =>  if (Back_Sensor ='1' and l_verde = '1' ) then
														Estado_sig<=Std_Estacionamiento;
										else 
														Estado_sig<=Std_Espera;
										end if;	
							
         when Std_Estacionamiento =>  if (Front_Sensor ='0' and Back_Sensor ='0' ) then
													Estado_sig<=Std_Inicial;
													else 
														Estado_sig<=Std_Estacionamiento;
												   end if;
    
    
		when others => Estado_sig<=Std_Inicial;
    
        end case;
    end process;

 OUTPUT_LOGIC : process (Estado_actual, Front_Sensor, Back_Sensor)
	begin
		case (Estado_actual) is
			when Std_Inicial => 
				if (Front_Sensor = '0' and Back_Sensor = '0') then
					Led_V <= '0';
					Led_R <= '0';
				end if;
			when Std_Contrasena =>  
				if (Front_Sensor = '1' and Back_Sensor = '0') then
					Led_V <= l_verde;
					Led_R <= l_rojo;
				end if;
				
			when Std_Espera =>  if (Back_Sensor ='1' and l_verde = '1' ) then
					Led_V <= l_verde;
					Led_R <= l_rojo;
					end if;
					
			when Std_Estacionamiento =>  
				if (Back_Sensor = '1' and l_verde = '1') then
					enable_P <= Parqueadero;
					
				end if;
			when others => 
				Led_V <= '0';
				Led_R <= '0';
		end case;
	end process;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
Contrasena: Correct_Contrasena port map (Clock => Clock, Reset => Reset, Combinacion => Password, Led_Verde => l_verde, Led_Rojo => l_rojo);

--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
Divisor: Divisor_Frecuencia port map (clk => Clock, out_clk => Div_Clk);
	 --# 1
	
	P1 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(0),Pagar=>Pago_1);
	
	--# 2
	
	P2 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(1),Pagar=>Pago_2);
	
	--# 3
	
	P3 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(2), Pagar=>Pago_3);
	
	--# 4
	
	P4 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(3), Pagar=>Pago_4);
	
	--# 5
	
	P5 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(4), Pagar=>Pago_5);
	
	--# 6
	
	P6 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(5), Pagar=>Pago_6);
	
	--# 7
	
	P7 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, enable => Parqueadero(6), Pagar=>Pago_7);
	
	--# 8
	
	P8 : Pago_Contador port map (Clock => Div_Clk, Reset => Reset, Enable => Parqueadero(7), Pagar=>Pago_8);

	 
--------------------------------------------------------------------------------------------------

    process(Selector)
    begin
        if rising_edge(Selector) then
            if contador_num > 8 then
                contador_num <= 1;
            else
                contador_num <= contador_num + 1;
            end if;
        end if;
        Num_Parq <= contador_num;
    end process;

    with Num_Parq select
    Pago <= Pago_1 when 1,
            Pago_2 when 2,
            Pago_3 when 3,
            Pago_4 when 4,
            Pago_5 when 5,
            Pago_6 when 6,
            Pago_7 when 7,
            Pago_8 when 8;
            
----------------------------------------------------------------------------------------------

	process (Pago) begin
		case Pago is 
			when 0 =>Display_Pago<= "0000001";
			when 1 =>Display_Pago<= "1001111";
			when 2 =>Display_Pago<= "0010010";
			when 3 =>Display_Pago<= "0000110";
			when 4 =>Display_Pago<= "1001100";
			when 5 =>Display_Pago<= "0100100";
			when 6 =>Display_Pago<= "0100000";
			when 7 =>Display_Pago<= "0001111";
			when 8 =>Display_Pago<= "0000000";
			when 9 =>Display_Pago<= "0000100";
			when others  =>Display_Pago<= "1111111";
		end case;
	end process;

    process (Num_Parq) begin
		case Num_Parq is 
			when 1 =>Display_Numero<= "1001111";
			when 2 =>Display_Numero<= "0010010";
			when 3 =>Display_Numero<= "0000110";
			when 4 =>Display_Numero<= "1001100";
			when 5 =>Display_Numero<= "0100100";
			when 6 =>Display_Numero<= "0100000";
			when 7 =>Display_Numero<= "0001111";
			when 8 =>Display_Numero<= "0000000";
			when others  =>Display_Numero<= "1111111";
		end case;
	end process;
 
end Parqueadero_Arch ;