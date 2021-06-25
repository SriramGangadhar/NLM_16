----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 02.05.2018 10:40:34
-- Design Name: 
-- Module Name: Median_4 - Behavioral
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


entity Median_4 is
	generic (Width_In : integer := 37);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   Median 	: out signed (Width_In - 1 downto 0)
		   
		 ); 		   
end Median_4;

architecture Behavioral of Median_4 is
	
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
	
	component Sorter_4 is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   Start	: in STD_LOGIC; -- There should be 4 CLK interval between Starts, otherwise retrigers	
			   RST		: in STD_LOGIC;  	
			   Input1 	: in signed (Width_In - 1 downto 0);
			   Input2 	: in signed (Width_In - 1 downto 0);
			   Input3 	: in signed (Width_In - 1 downto 0);
			   Input4 	: in signed (Width_In - 1 downto 0);			   
			   Valid	: out STD_LOGIC; -- 5 CLK delay from start
			   Output1 	: out signed (Width_In - 1 downto 0);
			   Output2 	: out signed (Width_In - 1 downto 0);
			   Output3 	: out signed (Width_In - 1 downto 0);
			   Output4 	: out signed (Width_In - 1 downto 0)
			 );
	end component;
	
	signal Buf1	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf2	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf3	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf4	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf5	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal M1	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal M2	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Temp : signed (Width_In downto 0) := (others => '0'); 
	
	signal Buffr_Full	: STD_LOGIC := '0';
	signal Buffr_Temp	: STD_LOGIC := '0';
	signal Start_Sort	: STD_LOGIC := '0';
	signal Count	: unsigned (Width_In - 1 downto 0) := (others => '0');	
	

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
	
---------------------------- Sorting and median finding------------------------------------------------------------------------
Sort:
	Sorter_4 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, RST => RST, Start => Start_Sort, Input1 => signed (Buf1), Input2 => signed (Buf2),
			Input3 => signed (Buf3), Input4 => signed (Buf4), Valid =>Valid, Output1 => open,
			Output2 => M1, Output3 => M2, Output4 => open);
			
	Temp 	<= resize(M1, Temp'length) + resize(M2, Temp'length);
	Median 	<= Temp (Temp'length - 1 downto 1); 
--    Median  <= M2;
--    Median <= Count;
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
	
Tem:
	Bit_Delay
		generic map (Depth => 1)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Buffr_Full, Output => Buffr_Temp);	

	 Start_Sort <= Buffr_Full and not(Buffr_Temp);	
	 
end Behavioral;