----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 25.04.2018 22:59:54
-- Design Name: 
-- Module Name: SPI - Behavioral
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


entity SPI is
	generic ( Width_In : integer := 26;
			  Depth    : integer := 2);
    Port ( CLK 		: in STD_LOGIC;
		   CE  		: in STD_LOGIC;
           RST 		: in STD_LOGIC;           
		   Input 	: in STD_LOGIC_VECTOR (Width_In - 1 downto 0);
           Output 	: out STD_LOGIC_VECTOR (Depth * Width_In - 1 downto 0));
end SPI;

architecture Behavioral of SPI is
	constant L_Shift: integer := Depth * Width_In; --120
    signal ShftReg	: STD_LOGIC_VECTOR (L_Shift - 1 downto 0) := (others =>'0'); ---119 downto 0

begin
    -- Delay process.
RegL:process(CLK, RST)
    begin
        if (RST = '1') then
            ShftReg <= (others =>'0');
        elsif rising_edge(CLK) then
            if (CE = '1') then
                ShftReg(L_Shift - 1 downto Width_In)	<= ShftReg(L_Shift - Width_In - 1 downto 0);
                ShftReg(Width_In - 1 downto 0)      	<= Input;
            end if;           
        end if;
    end process; 
    Output <= ShftReg;   

end Behavioral;