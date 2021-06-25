----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 02.05.2018 16:17:30
-- Design Name: 
-- Module Name: Median_2 - Behavioral
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


entity Median_2 is
	generic (Width_In : integer := 37);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   Median 	: out signed (Width_In - 1 downto 0)
--		   m2o1: out std_logic_vector (Width_In - 1 downto 0);
--		   m2o2: out std_logic_vector (Width_In - 1 downto 0)
		 ); 		   
end Median_2;

architecture Behavioral of Median_2 is
	
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
	

	
	signal Buf1	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0'); 
	signal Buf2	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');
	signal Buf3	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');
	signal Buf4	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');
	signal Buf5	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');
	signal Buf6	: STD_LOGIC_VECTOR (Width_In - 1 downto 0) := (others => '0');
	signal M1	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal M2	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Temp : signed (Width_In downto 0) := (others => '0'); 
	
	signal Buffr_Full	: STD_LOGIC := '0';
	signal Buffr_Temp	: STD_LOGIC := '0';
	signal Count		: unsigned (0 downto 0) := (others => '0');	
	

begin

---------------------------- Input Buffer and Shifter ------------------------------------------------------------------------

Buf:	
	SPI
		generic map (Width_In => Width_In, Depth => 2)
		port map(CLK => CLK, CE => CE, RST => RST, Input => STD_LOGIC_VECTOR (Input), 
			Output(Width_In * 2 - 1 downto Width_In) => Buf1,
			Output(Width_In - 1 downto 0) => Buf2);	
	
---------------------------- Finding median ------------------------------------------------------------------------
	M1 <= signed (Buf1);
	M2 <= signed (Buf2);	
	Temp 	<= resize(M1, Temp'length) + resize(M2, Temp'length);
	Median 	<= Temp (Temp'length - 1 downto 1); 
	
--m2o1 <= Buf1;
--m2o2 <= Buf2;
---------------------------- Controller ------------------------------------------------------------------------
Cnt:
	process(CLK, Start, CE)
    begin
        if rising_edge(CLK) then
			if (Start = '1') then
				Count <= (others => '0');
			elsif (CE = '1') then
				if (Count = 1) then
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
		if (Count = 1) then
			Buffr_Full <= '1';
		else
			Buffr_Full <= '0';
		end if;
	end process;
	
Tem:
	Bit_Delay
		generic map (Depth => 5) -- Depth changed to 5 in order to make sure BLock MOM VII produces a valid signal at the right point
		port map (CLK => CLK, CE => '1', RST => RST, Input => Buffr_Full, Output => Buffr_Temp);	

	Valid <= Buffr_Full and not(Buffr_Temp);		
	
end Behavioral;