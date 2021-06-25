----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 25.04.2018 17:39:59
-- Design Name: 
-- Module Name: Two_Input_Sorter_Signed - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
--to sort the two 24-bit pixel value by finding the difference 
--op1 < op2

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Two_Input_Sorter_Signed_2 is
	generic (Width_In : integer := 19);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC;
		   RST		: in STD_LOGIC;   
		   Input1_2 	: in signed (Width_In - 1 downto 0);
		   Input2_2 	: in signed (Width_In - 1 downto 0);
		   Output1_2 	: out signed (Width_In - 1 downto 0);
		   --smaller value
		   Output2_2 	: out signed (Width_In - 1 downto 0));
		   -- bigger value
end Two_Input_Sorter_Signed_2;

architecture Behavioral of Two_Input_Sorter_Signed_2 is

	signal Temp1 : signed (Input1_2'length - 1 downto 0) := (others => '0');
	signal Temp2 : signed (Input2_2'length - 1 downto 0) := (others => '0');
	
begin

Compare:
	process (Input1_2, Input2_2)
	begin
		if (Input1_2 > Input2_2) then
			Temp1 <= Input2_2;
			Temp2 <= Input1_2;
		else
			Temp1 <= Input1_2;
			Temp2 <= Input2_2;
		end if;
	end process;
	
Reg1:
	process(CLK, RST, CE)
    begin
        if (RST = '1') then
            Output1_2 <= (others => '0');
        elsif rising_edge(CLK) then
			if (CE = '1') then
				Output1_2 <= Temp1;
			end if;	
        end if;
    end process;	
	
Reg2:
	process(CLK, RST, CE)
    begin
        if (RST = '1') then
            Output2_2 <= (others => '0');
        elsif rising_edge(CLK) then
			if (CE = '1') then
				Output2_2 <= Temp2;
			end if;	
        end if;
    end process;

end Behavioral;
