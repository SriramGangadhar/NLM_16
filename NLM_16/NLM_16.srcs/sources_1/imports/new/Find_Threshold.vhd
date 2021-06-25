----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 03.05.2018 16:19:23
-- Design Name: 
-- Module Name: Find_Threshold - Behavioral
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



entity Find_Threshold is
	generic (Width_In : integer := 24);	
	Port ( CLK			: in STD_LOGIC;
		   CE			: in STD_LOGIC; 
		   Start		: in STD_LOGIC;	
		   RST			: in STD_LOGIC;  	
		   Input 		: in signed (Width_In - 1 downto 0);
		   Valid		: out STD_LOGIC;
		   Threshold	: out signed (Width_In - 1 downto 0)
--		   valid5       : out STD_LOGIC;
--		   mom5 		: out signed (Width_In - 1 downto 0)
		   --threshold is sigma
--		   input_output : out signed (Width_In - 1 downto 0)
		   -- in_out is being made equal to input to probably hold the input for some reason
		 ); 
end Find_Threshold;

architecture Behavioral of Find_Threshold is

	component Block_MoM is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   MoM 		: out signed (Width_In - 1 downto 0)
--			   valid5       : out STD_LOGIC;
--                          mom5         : out signed (Width_In - 1 downto 0)
			 ); 
	end component;
	
	signal Valid_MoM	: STD_LOGIC := '0';
	signal MoM			: signed (Input'length - 1 downto 0) := (others => '0');
--	signal momm5 :signed (Width_In - 1 downto 0);
--	signal validd5: std_logic;

begin
--input_output <= Input;
--mom5<=momm5;
--valid5<=validd5;
Median:
	Block_MoM 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => CE, RST => RST, Start => Start, Input => Input, Valid => Valid_MoM, MoM => MoM);
	
Reg:process(CLK, RST)
    begin
        if (RST = '1') then
            Threshold <= (others =>'0');
        elsif rising_edge(CLK) then
            if (Valid_MoM = '1') then
                Threshold	<= MoM;--MoM'length is 24
                                                --- why resize??
            end if;           
        end if;
    end process; 
	
Reg1:process(CLK, RST)
    begin
        if (RST = '1') then
            Valid <= '0';
        elsif rising_edge(CLK) then
			Valid <= Valid_MoM;       
        end if;
    end process;	

end Behavioral;
