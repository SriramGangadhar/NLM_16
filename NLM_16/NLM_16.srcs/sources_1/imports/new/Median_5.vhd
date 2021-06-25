----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 25.04.2018 18:36:05
-- Design Name: 
-- Module Name: Median_5 - Behavioral
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
--calculates the median for 5 elements at once over 5 clock cycles by using a counter that counts to 4
--SPI is used to store values and act as a buffer and sned i

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Median_5 is
	generic (Width_In : integer := 19);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   Median 	: out signed (Width_In - 1 downto 0)
--		   m5o1: out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--		   m5o2: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--		   m5o3: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--		   m5o4: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--		   m5o5: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0)
		   --valid and median outputted by sorter component
		 ); 		   
end Median_5;

architecture Behavioral of Median_5 is
	
	component SPI is
		generic ( Width_In : integer := 26;
				  Depth    : integer := 2);
		Port ( CLK 		: in STD_LOGIC;
			   CE  		: in STD_LOGIC;
			   RST 		: in STD_LOGIC;           
			   Input 	: in STD_LOGIC_VECTOR (Width_In - 1 downto 0);
			   Output 	: out STD_LOGIC_VECTOR (Depth * Width_In - 1 downto 0));
	end component;
	
	component Bit_Delay is
		generic (Depth   : integer := 2);
		Port ( CLK 		: in STD_LOGIC;
			   CE  		: in STD_LOGIC;
			   RST 		: in STD_LOGIC;           
			   Input 	: in STD_LOGIC;
			   Output 	: out STD_LOGIC
			 );
	end component;
	
	component Sorter_5 is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   Start	: in STD_LOGIC; -- There should be 5 CLK interval between Starts, otherwise retrigers	
			   RST		: in STD_LOGIC;  	
			   Input1 	: in signed (Width_In - 1 downto 0);
			   Input2 	: in signed (Width_In - 1 downto 0);
			   Input3 	: in signed (Width_In - 1 downto 0);
			   Input4 	: in signed (Width_In - 1 downto 0);
			   Input5 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC; -- 5 CLK delay from start
			   Output1 	: out signed (Width_In - 1 downto 0);
			   Output2 	: out signed (Width_In - 1 downto 0);
			   Output3 	: out signed (Width_In - 1 downto 0);
			   Output4 	: out signed (Width_In - 1 downto 0);
			   Output5 	: out signed (Width_In - 1 downto 0));
	end component;
	
	signal Buf1	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf2	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf3	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf4	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf5	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');	

	signal Buffr_Full	: STD_LOGIC := '0';
	signal Start_Sort	: STD_LOGIC := '0';
	signal Buffr_Temp	: STD_LOGIC := '0';
	signal Count		: unsigned (2 downto 0) := (others => '0');	
	

begin

---------------------------- Input Buffer and Shifter ------------------------------------------------------------------------

Buf:	
	SPI
		generic map (Width_In => Width_In, Depth => 5)
		port map(CLK => CLK, CE => CE, RST => RST, Input => STD_LOGIC_VECTOR (Input), --converting to type stdlogic
			Output(Width_In * 5 - 1 downto Width_In * 4) => Buf1,
			Output(Width_In * 4 - 1 downto Width_In * 3) => Buf2,
			Output(Width_In * 3 - 1 downto Width_In * 2) => Buf3,
			Output(Width_In * 2 - 1 downto Width_In) => Buf4,
			Output(Width_In - 1 downto 0) => Buf5);	
			
			
--m5o1<=Buf1;
--m5o2<=Buf2;
--m5o3<=Buf3;
--m5o4<=Buf4;
--m5o5<=Buf5;
---------------------------- Sorting ------------------------------------------------------------------------
Sort:
-- median of 5 values is the 3rd value and hence all but output 3 are open
	Sorter_5 
		generic map (Width_In => Width_In)
		--sorting starts when buffer becomes full;;; buffer becomes full when count is equal to 4
		port map (CLK => CLK, RST => RST, Start => Start_Sort, Input1 => signed (Buf1), Input2 => signed (Buf2),
			Input3 => signed (Buf3), Input4 => signed (Buf4), Input5 => signed (Buf5), Valid => Valid, Output1 => open,
			Output2 => open, Output3 => Median, Output4 => open, Output5 => open);

---------------------------- Controller ------------------------------------------------------------------------
Cnt:
	process(CLK, Start, CE)
    begin
        if rising_edge(CLK) then
			if (Start = '1') then
				Count <= (others => '0');
			elsif (CE = '1') then
				if (Count = 4) then
					Count <= (others => '0');
				else	
					Count <= Count + 1;
				end if;	
			end if;	
        end if;
    end process;

Initiate:
	process (Count)
	begin
		if (Count = 4) then
			Buffr_Full <= '1';
		else
			Buffr_Full <= '0';
		end if;
	end process;

--start sort becomes 1 every 5 clock cycles	
Tem:
	Bit_Delay
		generic map (Depth => 1)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Buffr_Full, Output => Buffr_Temp);	

	Start_Sort <= Buffr_Full and not(Buffr_Temp);	
--	Start_Sort <= Buffr_Full ;
	--sorting starts when buffer becomes full
end Behavioral;
