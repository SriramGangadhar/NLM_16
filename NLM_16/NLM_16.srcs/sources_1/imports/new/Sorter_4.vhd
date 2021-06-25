----------------------------------------------------------------------------------
-- Company: IISc Bangalore
-- Engineer: Rinson Varhgese
-- 
-- Create Date: 02.05.2018 10:50:55
-- Design Name: 
-- Module Name: Sorter_4 - Behavioral
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


entity Sorter_4 is
	generic (Width_In : integer := 19);	
	Port ( CLK		: in STD_LOGIC;
		   Start	: in STD_LOGIC; -- There should be 4 CLK interval between Starts, otherwise retrigers	
		   RST		: in STD_LOGIC;  	
		   Input1 	: in signed (Width_In - 1 downto 0);
		   Input2 	: in signed (Width_In - 1 downto 0);
		   Input3 	: in signed (Width_In - 1 downto 0);
		   Input4 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC; -- 4 CLK delay from start
		   Output1 	: out signed (Width_In - 1 downto 0);
		   Output2 	: out signed (Width_In - 1 downto 0);
		   Output3 	: out signed (Width_In - 1 downto 0);
		   Output4 	: out signed (Width_In - 1 downto 0)
		 );
end Sorter_4;

architecture Behavioral of Sorter_4 is
		
	component Bit_Delay is
		generic (Depth   : integer := 2);
		Port ( CLK 		: in STD_LOGIC;
			   CE  		: in STD_LOGIC;
			   RST 		: in STD_LOGIC;           
			   Input 	: in STD_LOGIC;
			   Output 	: out STD_LOGIC
			 );
	end component;
	
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
	--                    0               1          2                      3
	type StateType is (Sel_Input_State, Idle_State, Recur_State, Idle_Recur_State);
	signal PrState 	: StateType := Sel_Input_State; 
    signal NxState	: StateType := Sel_Input_State;
		
	
	signal Sort_In1: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In2: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In3: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_In4: signed (Width_In - 1 downto 0) := (others => '0'); 
	
	signal Sort_Out1: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out2: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out3: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Out4: signed (Width_In - 1 downto 0) := (others => '0'); 
	
	signal Sort_Temp1: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Temp2: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Temp3: signed (Width_In - 1 downto 0) := (others => '0'); 
	signal Sort_Temp4: signed (Width_In - 1 downto 0) := (others => '0');
	
	signal Start_0		: STD_LOGIC := '0';
	signal Start_1		: STD_LOGIC := '0';

begin

--------------------- Sort Group I----------------------------------------------------------
S1:
	Two_Input_Sorter_Signed 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => Start_0, RST => RST, Input1 => Sort_In1, Input2 => Sort_In2,
			Output1 => Sort_Temp1, Output2 => Sort_Temp2);

S2:
	Two_Input_Sorter_Signed 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => Start_0, RST => RST, Input1 => Sort_In3, Input2 => Sort_In4,
			Output1 => Sort_Temp3, Output2 => Sort_Temp4);
	
Buf1:
	process(CLK, RST, Start_1)
    begin
        if (RST = '1') then
            Sort_Out1 <= (others => '0');
        elsif rising_edge(CLK) then
			if (Start_1 = '1') then
				Sort_Out1 <= Sort_Temp1;
			end if;	
        end if;
    end process;
	
Buf2:
	process(CLK, RST, Start_1)
    begin
        if (RST = '1') then
            Sort_Out4 <= (others => '0');
        elsif rising_edge(CLK) then
			if (Start_1 = '1') then
				Sort_Out4 <= Sort_Temp4;
			end if;	
        end if;
    end process;

S3:
	Two_Input_Sorter_Signed 
		generic map (Width_In => Width_In) 
		port map (CLK => CLK, CE => Start_1, RST => RST, Input1 => Sort_Temp2, Input2 => Sort_Temp3,
			Output1 => Sort_Out2, Output2 => Sort_Out3);
			
	Output1 <= Sort_Out1;		
	Output2 <= Sort_Out2;		
	Output3 <= Sort_Out3;		
	Output4 <= Sort_Out4;		

Validate:
	Bit_Delay
		generic map (Depth => 5)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Start, Output => Valid);	

---------------------------- Controller ------------------------------------------------------------------------
Sel:
	process(Start, Input1, Input2, Input3, Input4, Sort_Out1, 
		Sort_Out2, Sort_Out3, Sort_Out4)
    begin
		if (Start = '1') then
			Sort_In1 <= Input1;
			Sort_In2 <= Input2;
			Sort_In3 <= Input3;
			Sort_In4 <= Input4;
		else
			Sort_In1 <= Sort_Out1;
			Sort_In2 <= Sort_Out2;
			Sort_In3 <= Sort_Out3;
			Sort_In4 <= Sort_Out4;  
		end if;		
	end process;
	
FSM:
	process(PrState, Start)
    begin
        case PrState is
            when Sel_Input_State => 
				Start_0		 <= Start;
				Start_1		 <= '0';
				
                if (Start = '1') then
                    NxState	<= Idle_State;
                else
                    NxState <= Sel_Input_State;
                end if; 
			
			when Idle_State => 
				Start_0		 <= '0';
				Start_1		 <= '1';
					
				NxState <= Recur_State;		
			
			when Recur_State =>
				Start_0		 <= '1';
				Start_1		 <= '0';
					
				NxState <= Idle_Recur_State;	
			
			when Idle_Recur_State => 
				Start_0		 <= '0';
				Start_1		 <= '1';
					
				if (Start = '1') then
                    NxState	<= Idle_State;
                else
                    NxState <= Sel_Input_State;
                end if; 		
			
			when others =>
				Start_0		 <= Start;
				Start_1		 <= '0';
				
				NxState <= Sel_Input_State;
		end case;
	end process;	

	-- FF process
FF:
	process(CLK, RST)
    begin
        if (RST = '1') then
            PrState <= Sel_Input_State;
        elsif rising_edge(CLK) then
			if (Start = '1') then
				PrState <= Idle_State;
			else
				PrState <= NxState;
			end if;
		end if;	
    end process;

end Behavioral;
