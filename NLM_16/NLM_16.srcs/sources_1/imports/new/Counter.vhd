----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 17.03.2018 14:33:51
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use ieee.numeric_std.ALL;


entity Counter is
	generic ( Width_Count	: integer := 13;
			  MaxCount      : integer := 8192); -- log2(MaxCount)
    Port ( CLK 		: in STD_LOGIC;
           CE 		: in STD_LOGIC;
		   RST		: in STD_LOGIC;
           SCLR 	: in STD_LOGIC;
		   Q 		: out unsigned (Width_Count - 1 downto 0)); 
end Counter;

architecture Behavioral of Counter is
	signal PrVal : unsigned (Width_Count - 1 downto 0) := (others => '0');

begin

Reg:
    process (CLK, RST)
    begin
		if (RST = '1') then
			PrVal <= (others => '0');
		elsif (CLK'event and CLK = '1') then
			if (SCLR = '1') then
				PrVal <= (others => '0');
			elsif (CE = '1') then
				if (PrVal = MaxCount) then
					PrVal <= (others => '0');
				else	
					PrVal <= PrVal + 1;	
				end if;	
			end if;	
		end if;	
    end process;
	Q <= PrVal;	
end Behavioral;
