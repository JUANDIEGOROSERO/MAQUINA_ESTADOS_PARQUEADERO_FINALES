library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Pago_Contador is
    Port ( Clock, Reset, Enable : in std_logic;
           Pagar : out integer
           );
end Pago_Contador;

architecture Pago_Arch of Pago_Contador is
    signal count_reg : integer range 0 to 9;
   
begin
    process (Clock, Reset)
    begin
        if Reset = '0' then
            count_reg <= 0;
            
        elsif rising_edge(Clock) then
            if Enable = '1' then
                count_reg <= count_reg + 1;
                if count_reg = 9 then
                    count_reg <= 0;
                    
                end if;
            end if;
        end if;
    end process;
    
    Pagar <= count_reg;
    
end Pago_Arch;