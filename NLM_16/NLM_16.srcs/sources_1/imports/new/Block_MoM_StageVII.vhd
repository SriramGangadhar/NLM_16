----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2018 12:43:19
-- Design Name: 
-- Module Name: Block_MoM_StageVII - Behavioral
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



entity Block_MoM_StageVII is
	generic (Width_In : integer := 24);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   MoM 		: out signed (Width_In - 1 downto 0)
--		   inp7     :out STD_LOGIC;
--		   cs7 :out  unsigned (2 downto 0) := (others => '0');
--                 cb7 : out unsigned (2 downto 0) := (others => '0')
--		                          check : out std_logic;
--		                          m5o1: out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                                m5o2: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0)
--                                m5o3: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--                                m5o4: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--                                m5o5: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0)
		 ); 
end Block_MoM_StageVII;

architecture Behavioral of Block_MoM_StageVII is
	
	component Median_5 is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   Median	: out signed (Width_In - 1 downto 0)
--			                          m5o1: out STD_LOGIC_VECTOR (Width_In - 1 downto 0);
--                                    m5o2: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0)
--                                    m5o3: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--                                    m5o4: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0);
--                                    m5o5: out STD_LOGIC_VECTOR  (Width_In - 1 downto 0)
			 ); 
	end component;
	
	component Median_2 is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   Median 	: out signed (Width_In - 1 downto 0)
--			               m2o1: out std_logic_vector (Width_In - 1 downto 0);
--                         m2o2: out std_logic_vector (Width_In - 1 downto 0)
			   
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
			
	type StateType is (Sel_Med_5_State, Sel_Med_2_State, Wait_State, Wait_state2);
	signal PrState 	: StateType := Sel_Med_5_State; 
    signal NxState	: StateType := Sel_Med_5_State;
	
	signal Count_Membr	: unsigned (2 downto 0) := (others => '0');
	signal Count_Block 	: unsigned (2 downto 0) := (others => '0');
	signal Cnt_Mem_Dn,start_ctrl	: STD_LOGIC := '0';
	signal Cnt_Dn_Buf	: STD_LOGIC := '0';
	signal En_Cnt_Blk	: STD_LOGIC := '0';
	signal Start_Med	: STD_LOGIC := '0';
	signal Sel			: STD_LOGIC := '0';
	signal Sel_Buff		: STD_LOGIC := '0';
	signal Sel_Buff2	: STD_LOGIC := '0';
	signal En_Med_5		: STD_LOGIC := '0';
	signal En_Med_2		: STD_LOGIC := '0';
	signal Start_Med_5	: STD_LOGIC := '0';
	signal Start_Med_2	: STD_LOGIC := '0';
	signal Valid_Med_5	: STD_LOGIC := '0';
	signal Valid_Med_2	: STD_LOGIC := '0';
	signal Input_Med_5	: signed (Input'length - 1 downto 0) := (others => '0');
	signal Input_Med_2	: signed (Input'length - 1 downto 0) := (others => '0');
	signal MoM_Med_5	: signed (MoM'length - 1 downto 0) := (others => '0');
	signal MoM_Med_2	: signed (MoM'length - 1 downto 0) := (others => '0');
--	signal cs7 :  unsigned (2 downto 0) := (others => '0');
--          signal           cb7 :  unsigned (1 downto 0) := (others => '0')
	
begin
--inp7 <= Start_Med_2;
--cs7 <= Count_Membr;
--cb7 <=Count_Block;
--------------------------- Controller -------------------------------------------------------------------------- 
Cnt_Mem:
	Counter
		generic map (Width_Count => 3, MaxCount => 4)
		port map (CLK => CLK, CE => CE, RST => RST, SCLR => Start, Q => Count_Membr);
	
Cnt_Blk:
	Counter
		generic map (Width_Count => 3, MaxCount => 6)
		port map (CLK => CLK, CE => En_Cnt_Blk, RST => RST, SCLR => Start, Q => Count_Block);	
	
	En_Cnt_Blk 	<= Cnt_Mem_Dn and not(Cnt_Dn_Buf);
	Start_Med 	<= Start or start_ctrl;
	
Del_Cnt_Dn: --1 clock cycle delay 
	Bit_Delay
		generic map (Depth => 1)
		port map (CLK => CLK, CE => '1', RST => RST, Input => Cnt_Mem_Dn, Output => Cnt_Dn_Buf);		
--Value of Cnt_mem_dn is obtained from Dn_Sel 

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
			En_Med_2 	<= '0';		
			Input_Med_2	<= (others => '0');
			
			En_Med_5 	<= CE;
			Start_Med_5	<= Start_Med;
			Input_Med_5	<= Input;			
		else
			En_Med_2 	<= CE;
			Input_Med_2	<= Input;
			
			En_Med_5 	<= '0';
			Start_Med_5	<= '0';
			Input_Med_5	<= (others => '0');	
		end if;
	end process;	
	
Dn_Sel:
	process (Count_Membr, Sel_Buff)
	begin
		if (Sel_Buff = '0') then
			if (Count_Membr = 4) then
				Cnt_Mem_Dn <= '1';
			else	
				Cnt_Mem_Dn <= '0';
			end if;
			
			 if (Count_Membr = 0) then
                  start_ctrl <= '1';    
              else 
                  start_ctrl <= '0';
              end if;
		else
			if (Count_Membr = 3) then
				Cnt_Mem_Dn <= '1';
			else	
				Cnt_Mem_Dn <= '0';
			end if;
		end if;	
	end process;	
	
Valid_Sel:
	process (Sel_Buff2, Valid_Med_5, MoM_Med_5, MoM_Med_2, Valid_Med_2)
	begin
		if (Sel_Buff2 = '0') then
			MoM 	<= MoM_Med_5;
			Valid	<= Valid_Med_5; 
		else
			MoM 	<= MoM_Med_2;
			Valid	<= Valid_Med_2;	
		end if;	
	end process;	

FSM:
	process(PrState, Count_Membr, Count_Block, En_Med_2)
    begin
        case PrState is
            when Sel_Med_5_State => 
				Sel		 	<= '0';
				Start_Med_2	<= '0';
				
                if (Count_Block = 3 and Count_Membr = 0) then
                    NxState	<= Sel_Med_2_State;
                else
                    NxState <= Sel_Med_5_State;
                end if; 
			
			when Sel_Med_2_State => 
				Sel		 	<= '1';
				Start_Med_2	<= '1';
				
				if (En_Med_2 = '1') then
                    NxState	<= Wait_State;
                else
                    NxState <= Sel_Med_2_State;
                end if;
			
			when Wait_State => 
				Sel		 	<= '1';
				Start_Med_2	<= '0';
				
				if (Count_Block = 6) then
                    NxState	<=  Wait_state2;
                else
                    NxState <= Wait_State;
                end if;	
						
			when Wait_state2 =>
                       Sel <= '1';
                      
                --       if (Count_Membr = 1) then
                --                                    Start_Med_4<='1';
                                              
                                                  
                --       else
                        Start_Med_2<='0';
                --        end if;
                      
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
--check<=Valid_Med_2;	
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
			Valid => Valid_Med_5, Median => MoM_Med_5); -- ,m5o1 => m5o1,m5o2 => m5o2,m5o3 => m5o3,m5o4 => m5o4,m5o5 => m5o5

Med3:
	Median_2 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => En_Med_2, RST => RST, Start => Start_Med_2, Input => Input_Med_2,
			Valid => Valid_Med_2, Median => MoM_Med_2);		--, m2o1=>m5o1,m2o2=>m5o2

end Behavioral;
