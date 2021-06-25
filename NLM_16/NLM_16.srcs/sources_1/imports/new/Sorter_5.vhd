----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varghese
-- 
-- Create Date: 01.05.2018 14:34:11
-- Design Name: 
-- Module Name: Sorter_5 - Behavioral
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

--this function arranges 5 values at a time in ascending order by using a FSM and repeated reaaranging of terms by chnaging 
-- the inputs to the sorter group function

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Sorter_5 is
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
end Sorter_5;

architecture Behavioral of Sorter_5 is
	
	component Sorter_Group_Signed is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC;  
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
	--                         0           1                    2                    3                 4
	type StateType is (Sel_Input_State, Recur_Set1_State, Recur_Set2_State, Recur_Set1_Rpt_State, Recur_Set2_Rpt_State,ext_stage);
	-- state type is enumerated 
	signal PrState 	: StateType := Sel_Input_State; --0
    signal NxState	: StateType := Sel_Input_State;--0
		
	signal Sort_In1	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In2	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In3	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In4	: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In5	: signed (Width_In - 1 downto 0) := (others => '0');
	
	signal Sort_Out1: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out2: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out3: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out4: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out5: signed (Width_In - 1 downto 0) := (others => '0');
	
	signal Input_Select : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
	signal En_Sort		: STD_LOGIC := '0';

begin

Srt:
	Sorter_Group_Signed 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => En_Sort, RST => RST, Input1 => Sort_In1, Input2 => Sort_In2,
			Input3 => Sort_In3, Input4 => Sort_In4, Input5 => Sort_In5, Output1 => Sort_Out1,
			Output2 => Sort_Out2, Output3 => Sort_Out3, Output4 => Sort_Out4, Output5 => Sort_Out5);
	
	
	
	Output1 <= Sort_Out1;
	Output2 <= Sort_Out2;
	Output3 <= Sort_Out3;
	Output4 <= Sort_Out4;
	Output5 <= Sort_Out5;
	
Validate:
	Bit_Delay
		generic map (Depth => 5)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Start, Output => Valid);
		
---------------------------- Controller ------------------------------------------------------------------------
Sel:
	process(Start, Input_Select, Input1, Input2, Input3, Input4, Input5, Sort_Out1, 
		Sort_Out2, Sort_Out3, Sort_Out4, Sort_Out5)
    begin
		if (Start = '1') then
			Sort_In1 <= Input1;
			Sort_In2 <= Input2;
			Sort_In3 <= Input3;
			Sort_In4 <= Input4;
			Sort_In5 <= Input5;
		elsif (Input_Select = "01") then
			Sort_In1 <= Sort_Out5;
			Sort_In2 <= Sort_Out1;
			Sort_In3 <= Sort_Out2;
			Sort_In4 <= Sort_Out3;
			Sort_In5 <= Sort_Out4;
		else
			Sort_In1 <= Sort_Out2;
			Sort_In2 <= Sort_Out3;
			Sort_In3 <= Sort_Out4;
			Sort_In4 <= Sort_Out5;
			Sort_In5 <= Sort_Out1;
		end if;			        
	end process;
	
FSM:
--there are 5 states and hence a 5 clock cycle delay
--sorting happens in sorter group only when en_sort is = 1
	process(PrState, Start)
    begin
        case PrState is
            when Sel_Input_State => --0
				Input_Select <= "00";
				En_Sort		 <= Start;	
				
                if (Start = '1') then
                    NxState	<= Recur_Set1_State; --1
                else
                    NxState <= Sel_Input_State; --0
                end if; 
			
			when Recur_Set1_State => --1
				Input_Select <= "01";
				En_Sort		 <= '1';
					
				NxState <= Recur_Set2_State;--2			
			
			when Recur_Set2_State => --2
				Input_Select <= "10";
				En_Sort		 <= '1';			
				
				NxState <= Recur_Set1_Rpt_State;	--3
				
			when Recur_Set1_Rpt_State => 
				Input_Select <= "01";
				En_Sort		 <= '1';	
				
				NxState <= Recur_Set2_Rpt_State;	
				
			when Recur_Set2_Rpt_State => 
				Input_Select <= "10";
				En_Sort		 <= '1';	
				
				NxState <= Sel_Input_State;	
				
--		    when ext_stage =>
--		        Input_Select <= "01";
--                En_Sort         <= '1'; 
                   
--                NxState <= Sel_Input_State;    

			when others =>		
				Input_Select <= "00";
				En_Sort		 <= Start;	
				
				NxState <= Sel_Input_State;
		end case;
	end process;	

	-- FF process
FF:
	process(CLK, RST)
    begin
        if (RST = '1') then
            PrState <= Sel_Input_State;--0
        elsif rising_edge(CLK) then
			if (Start = '1') then
				PrState <= Recur_Set1_State;--1
			else
				PrState <= NxState;
			end if;
		end if;	
    end process;

end Behavioral;
