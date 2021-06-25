----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 25.04.2018 23:15:34
-- Design Name: 
-- Module Name: Bit_Delay - Behavioral
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
--depth is equal to 5 and this causes a 5-bit delay
--make reset 1 once every 5 cycles.
--initially shift reg is 5 0s. with ouput being valid and input being start
--in bit delay values keep getting shifted left and once every 5 cycles, valid becomes 1 in the sorter_5 function


--output is delayed by depth-1 clock cycles
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Bit_Delay is
	generic (Depth   : integer := 2);
    Port ( CLK 		: in STD_LOGIC;
		   CE  		: in STD_LOGIC;
           RST 		: in STD_LOGIC;           
		   Input 	: in STD_LOGIC;
           Output 	: out STD_LOGIC
		 );
end Bit_Delay;

architecture Behavioral of Bit_Delay is
    signal ShftReg	: STD_LOGIC_VECTOR (Depth - 1 downto 0) := (others =>'0');

begin
    -- Dealy process.
RegL:
	process(CLK, RST)
    begin
        if (RST = '1') then
            ShftReg <= (others =>'0');
        elsif rising_edge(CLK) then
            if (CE = '1') then
                ShftReg(Depth - 1 downto 1)	<= ShftReg(Depth - 2 downto 0);
                ShftReg(0)      	 		<= Input;
            end if;           
        end if;
    end process; 
	
    Output <= ShftReg(Depth - 1);   

end Behavioral;
