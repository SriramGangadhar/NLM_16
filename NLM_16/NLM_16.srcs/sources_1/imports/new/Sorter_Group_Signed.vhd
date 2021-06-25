----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 25.04.2018 19:09:34
-- Design Name: 
-- Module Name: Sorter_Group_Signed - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


--op-1 is equal to inp-1 when clk is high
--inp2 inp3 are inputs to 2_sorter-1 and op2 and op3 are outputs ( op3>op2) 
--inp4 inp5 are inputs to 2_sorter-2 and op4 and op5 are outputs ( op5>op4)

entity Sorter_Group_Signed is
	generic (Width_In : integer := 19);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; -- This signal serves as start of conversion 
		   RST		: in STD_LOGIC;  	
		   Input1 	: in signed (Width_In - 1 downto 0);
		   Input2 	: in signed (Width_In - 1 downto 0);
		   Input3 	: in signed (Width_In - 1 downto 0);
		   Input4 	: in signed (Width_In - 1 downto 0);
		   Input5 	: in signed (Width_In - 1 downto 0);
		   Output1 	: out signed (Width_In - 1 downto 0);
		   Output2 	: out signed (Width_In - 1 downto 0);
		   Output3 	: out signed (Width_In - 1 downto 0);
		   Output4 	: out signed (Width_In - 1 downto 0);
		   Output5 	: out signed (Width_In - 1 downto 0));
end Sorter_Group_Signed;




architecture Behavioral of Sorter_Group_Signed is
	
	component Two_Input_Sorter_Signed is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC;
			   RST		: in STD_LOGIC;   
			   Input1 	: in signed (Width_In - 1 downto 0);
			   Input2 	: in signed (Width_In - 1 downto 0);
			   Output1 	: out signed (Width_In - 1 downto 0);
			   Output2 	: out signed (Width_In - 1 downto 0));
	end component;
	
	component Two_Input_Sorter_Signed_2 is
            generic (Width_In : integer := 19);    
            Port ( CLK        : in STD_LOGIC;
                   CE        : in STD_LOGIC;
                   RST        : in STD_LOGIC;   
                   Input1_2     : in signed (Width_In - 1 downto 0);
                   Input2_2     : in signed (Width_In - 1 downto 0);
                   Output1_2     : out signed (Width_In - 1 downto 0);
                   Output2_2     : out signed (Width_In - 1 downto 0));
        end component;

begin

Reg1:
	process(CLK, RST, CE)
    begin
        if (RST = '1') then
            Output1 <= (others => '0');
        elsif rising_edge(CLK) then
			if (CE = '1') then
				Output1 <= Input1;
			end if;	
        end if;
    end process;

S1:
	Two_Input_Sorter_Signed
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => CE, RST => RST, Input1 => Input2, Input2 => Input3,
			Output1 => Output2, Output2 => Output3);

S2:
	Two_Input_Sorter_Signed_2 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => CE, RST => RST, Input1_2 => Input4, Input2_2 => Input5,
			Output1_2 => Output4, Output2_2 => Output5);	

end Behavioral;
