----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date: 13.05.2021 19:48:01
-- Design Name: 
-- Module Name: Block_MoM_StageIV - Behavioral
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



entity Block_MoM_StageIV is
	generic (Width_In : integer := 24);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   MoM 		: out signed (Width_In - 1 downto 0)
		   
--		   ext      : out unsigned (2 downto 0);
                      
--                      enb5     :out STD_LOGIC;
--                      cntb     : out unsigned (6 downto 0);  
--		   oo1 	: out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                        oo2     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                         oo3     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                          oo4     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                          oo5     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0)
		 ); 
end Block_MoM_StageIV;

architecture Behavioral of Block_MoM_StageIV is
	
	component Median_5 is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   Median 	: out signed (Width_In - 1 downto 0)
			   
--                          o1     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                           o2     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                            o3     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                             o4     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                              o5     : out STD_LOGIC_VECTOR (Width_In - 1 downto 0)
			 ); 
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
	
	component Counter is
		generic ( Width_Count	: integer := 13;
				  MaxCount      : integer := 8192); -- log2(MaxCount)
		Port ( CLK 		: in STD_LOGIC;
			   CE 		: in STD_LOGIC;
			   RST 		: in STD_LOGIC;
			   SCLR 	: in STD_LOGIC;
			   Q 		: out unsigned (Width_Count - 1 downto 0)); 
	end component;
			
	type StateType is (Sel_Med_5_State, Sel_Med_4_State, Wait_State, Wait_state2);
	signal PrState 	: StateType := Sel_Med_5_State; 
    signal NxState	: StateType := Sel_Med_5_State;
	
	
	
--	signal o1,o2,o3,o4 ,o5 : STD_LOGIC_VECTOR (Width_In - 1 downto 0):= (others => '0');
	signal Count_Membr	: unsigned (2 downto 0) := (others => '0');
	signal Count_Block 	: unsigned (8 downto 0) := (others => '0');
	signal Cnt_Mem_Dn,start_ctrl	: STD_LOGIC := '0';
	signal Cnt_Dn_Buf	: STD_LOGIC := '0';
	signal En_Cnt_Blk	: STD_LOGIC := '0';
	signal Start_Med	: STD_LOGIC := '0';
	signal Sel			: STD_LOGIC := '0';
	signal Sel_Buff		: STD_LOGIC := '0';
	signal Sel_Buff2	: STD_LOGIC := '0';
	signal En_Med_5		: STD_LOGIC := '0';
	signal Start_Med_5	: STD_LOGIC := '0';
	signal Valid_Med_5	: STD_LOGIC := '0';
	signal Input_Med_5	: signed (Input'length - 1 downto 0) := (others => '0');
	signal MoM_Med_5	: signed (MoM'length - 1 downto 0) := (others => '0');
	
begin

--------------------------- Controller -------------------------------------------------------------------------- 
Cnt_Mem:
	Counter
		generic map (Width_Count => 3, MaxCount => 4)
		port map (CLK => CLK, CE => CE, RST => RST, SCLR => Start, Q => Count_Membr);
		


	
Cnt_Blk:
	Counter
		generic map (Width_Count => 9, MaxCount => 420)
		port map (CLK => CLK, CE => En_Cnt_Blk, RST => RST, SCLR =>  Start, Q => Count_Block);	
	-- en_cnt_blk goes 1 every 5 clock cycles and start is always zero hence count block
	-- increments every 5 cycles
	
	En_Cnt_Blk 	<= Cnt_Mem_Dn and not(Cnt_Dn_Buf) ;
	Start_Med 	<= Start or start_ctrl;
	-- cnt_mem_dn  goes 1 every 5 clock cycles due to count_member
	
--	enb5 <=En_Med_5;
--	ext <= Count_Membr;
--	cntb <= Count_Block;
		
Del_Cnt_Dn:
	Bit_Delay
		generic map (Depth => 1)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Cnt_Mem_Dn, Output => Cnt_Dn_Buf);		

Sel_Buf:
	Bit_Delay
		generic map (Depth => 1)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Sel, Output => Sel_Buff);

Sel_Buf1:
	Bit_Delay
		generic map (Depth => 5)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Sel_Buff, Output => Sel_Buff2);		

In_Sel:
	process (Sel, CE, Start_Med, Input)
	begin
	
	   
	
		if (Sel = '0') then
			
			
			En_Med_5 	<= CE;
			
			
			 Start_Med_5	<= Start_Med;
			 
			
			Input_Med_5	<= Input;			
		else
			
			
			En_Med_5 	<= '0';
			Start_Med_5	<= '0';
			Input_Med_5	<= (others => '0');	
		end if;
	end process;	
	
Dn_Sel:
	process (Count_Membr, Sel_Buff)
	begin
		if (Sel_Buff = '0') then
			if (Count_Membr = 4 ) then
				Cnt_Mem_Dn <= '1';
				
			else	
				Cnt_Mem_Dn <= '0';
			end if;
			if (Count_Membr = 0) then
			    start_ctrl <= '1';
			   
			    else	
                                start_ctrl <= '0';
                            end if;
			   
		
		end if;	
	end process;	
	
Valid_Sel:
	process (Sel_Buff2, Valid_Med_5, MoM_Med_5)
	begin
		if (Sel_Buff2 = '0') then
			MoM 	<= MoM_Med_5;
			Valid	<= Valid_Med_5;
		
		end if;	
	end process;	

FSM:
	process(PrState, Count_Membr, Count_Block)
    begin
        case PrState is
            when Sel_Med_5_State => 
				Sel		 	<= '0';
				
                if (Count_Block = 85 and Count_Membr =4) then
                    NxState	<= Sel_Med_5_State;
                else
                    NxState <= Sel_Med_5_State;
                end if; 
			
			when Sel_Med_4_State => 
				Sel		 	<= '1';
				
				
			
			when Wait_State => 
				Sel		 	<= '1';
				
				if (Count_Membr = 4) then
                    NxState	<= Wait_state2;
                else
                    NxState <= Wait_State;
                end if;	
			
			when Wait_state2 =>
			    Sel <= '1';			    
			    
			    if (Count_Membr = 4) then
			        NxState <= Sel_Med_5_State;
			    else 
			        NxState <= Wait_State2;
			    end if;
							
			when others =>
				Sel		 <= '0';
				
				NxState <= Sel_Med_5_State;
		end case;
	end process;	

	-- FF process
FF:
	process(CLK, RST)
    begin
        if (RST = '1') then
            PrState <= Sel_Med_5_State;
        elsif rising_edge(CLK) then
			if (Start = '1') then
				PrState <= Sel_Med_5_State;
			else
				PrState <= NxState;
			end if;
		end if;	
    end process;
	
-------------------------- Finds median --------------------------------------------------------------------------

Med5:
	Median_5 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => En_Med_5, RST => RST, Start => Start_Med_5, Input => Input_Med_5, 
			Valid => Valid_Med_5, Median => MoM_Med_5); --,o1 => o1,o2 => o2,o3 => o3,o4 => o4, o5 =>o5
--oo1 <=o1;
--oo2 <=o2;
--oo3 <=o3;
--oo4 <=o4;
--oo5 <=o5;


end Behavioral;
