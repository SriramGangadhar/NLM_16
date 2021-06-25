----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2018 12:59:23
-- Design Name: 
-- Module Name: Block_MoM - Behavioral
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



entity Block_MoM is
	generic (Width_In : integer := 24);	
	Port ( CLK		: in STD_LOGIC;
		   CE		: in STD_LOGIC; 
		   Start	: in STD_LOGIC;	
		   RST		: in STD_LOGIC;  	
		   Input 	: in signed (Width_In - 1 downto 0);
		   Valid	: out STD_LOGIC;
		   MoM 		: out signed (Width_In - 1 downto 0)
--		   countsmall : out unsigned (2 downto 0) := (others => '0');
--           countbig :out unsigned (6 downto 0)  := (others => '0');
--		   valid5       : out STD_LOGIC;
--		   valid6       : out STD_LOGIC;
--		   valid7       : out STD_LOGIC;
--		   start6       : out STD_LOGIC;
--		   mom5 		: out signed (Width_In - 1 downto 0)
--		   mom6 		: out signed (Width_In - 1 downto 0);
--		   mom7 		: out signed (Width_In - 1 downto 0);
--		    bcs: out unsigned (2 downto 0) := (others => '0');
--                     bcb :out unsigned (2 downto 0)  := (others => '0')

		   
		 ); 
end Block_MoM;

architecture Behavioral of Block_MoM is


    component Block_MoM_StageIV is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   MoM 		: out signed (Width_In - 1 downto 0)
			 ); 
	end component;
	
	component Block_MoM_StageV is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   MoM 		: out signed (Width_In - 1 downto 0)
			 ); 
	end component;	
	
	component Block_MoM_StageVI is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   MoM   : out signed (Width_In - 1 downto 0)
--               inp6   :  out STD_LOGIC;
--                   cs :out  unsigned (2 downto 0) := (others => '0');
--                     cb : out unsigned (4 downto 0) := (others => '0')
			 ); 
	end component;	
	
	component Block_MoM_StageVII is
		generic (Width_In : integer := 24);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   MoM 		: out signed (Width_In - 1 downto 0)
--              inp7     :out STD_LOGIC;
--              cs7 :out  unsigned (2 downto 0) := (others => '0');
--              cb7 : out unsigned (2 downto 0) := (others => '0')
			 ); 
	end component;	
	
	component Median_4_stageVIII is
		generic (Width_In : integer := 19);	
		Port ( CLK		: in STD_LOGIC;
			   CE		: in STD_LOGIC; 
			   Start	: in STD_LOGIC;	
			   RST		: in STD_LOGIC;  	
			   Input 	: in signed (Width_In - 1 downto 0);
			   Valid	: out STD_LOGIC;
			   Median 	: out signed (Width_In - 1 downto 0)
			 ); 
	end component;
	
	component Level_To_Pluse is
		Port ( CLK 		: in STD_LOGIC;
			   CE 		: in STD_LOGIC;
			   RST 		: in STD_LOGIC;			   		
			   Level 	: in STD_LOGIC;
			   Pulse 	: out STD_LOGIC
			 );
	end component;
	
	 component Bit_Delay is
     generic (Depth   : integer := 2);
     Port ( CLK   : in STD_LOGIC;
         CE    : in STD_LOGIC;
         RST   : in STD_LOGIC;          
         Input  : in STD_LOGIC;
         Output  : out STD_LOGIC
       );
    end component;
	
	 component Counter is
     generic ( Width_Count : integer := 13;
         MaxCount      : integer := 8192); -- log2(MaxCount)
     Port ( CLK   : in STD_LOGIC;
         CE   : in STD_LOGIC;
         RST   : in STD_LOGIC;
         SCLR  : in STD_LOGIC;
         Q   : out unsigned (Width_Count - 1 downto 0));
    end component;
	
	type StateType is (StageIV_State,  StageV_Started_State, StageVI_Started_State, StageVII_Started_State, Final_Stage_Started_State);
	--state type is enumeration with stageV=0 , stageVI= 1,etc 
	signal PrState 	: StateType := StageIV_State; 
    signal NxState	: StateType := StageIV_State;
    -- present and next state are of enumerated datatype Statetype and the initial value is StageV=0
	
	signal Valid_StageIV 	: STD_LOGIC := '0';
    signal MoM_StageIV        : signed (Input'length - 1 downto 0) := (others => '0');
    
    signal Start_StageV 	: STD_LOGIC := '0';
	signal Valid_StageV 	: STD_LOGIC := '0';
	signal MoM_StageV		: signed (Input'length - 1 downto 0) := (others => '0');

--	signal Gate_StageVI  	: STD_LOGIC := '0';
	signal Start_StageVI 	: STD_LOGIC := '0';
	signal Valid_StageVI 	: STD_LOGIC := '0';
	signal MoM_StageVI		: signed (Input'length - 1 downto 0) := (others => '0');
	
--	signal Gate_StageVII 	: STD_LOGIC := '0'; --,inp6,inp7
	signal Start_StageVII 	: STD_LOGIC := '0';
	signal Valid_StageVII 	: STD_LOGIC := '0';
	signal MoM_StageVII		: signed (Input'length - 1 downto 0) := (others => '0');
	
--	signal Gate_StageVIII  	: STD_LOGIC := '0';
	signal Start_StageVIII : STD_LOGIC := '0';
	signal Cnt_Dn_Buf	,Cnt_Mem_Dn , En_Cnt_Blk: STD_LOGIC := '0';

    signal Count_small : unsigned (2 downto 0) := (others => '0');
    signal Count_big :unsigned (8 downto 0)  := (others => '0');

begin

---------------------------- Median finding --------------------------------------------------------------------------

Cnt_small:
 Counter
  generic map (Width_Count => 3, MaxCount => 4)
  port map (CLK => CLK, CE => CE, RST => RST, SCLR => Start, Q => Count_small);
  
  Cnt_big:
   Counter
    generic map (Width_Count => 9, MaxCount => 430)
    port map (CLK => CLK, CE => En_Cnt_Blk, RST => RST, SCLR =>  Start, Q => Count_big); 
   -- en_cnt_blk goes 1 every 5 clock cycles and start is always zero hence count block
   -- increments every 5 cycles
   
   En_Cnt_Blk  <= Cnt_Mem_Dn and not(Cnt_Dn_Buf) ;


process (Count_small,clk)
 begin
  
   if (Count_small = 4 ) then
    Cnt_Mem_Dn <= '1';
    
   else 
    Cnt_Mem_Dn <= '0';
   end if;
   
end process; 


Del_Cnt_Dn:
 Bit_Delay
  generic map (Depth => 1)
  port map (CLK => CLK, CE => '1', RST => RST, Input => Cnt_Mem_Dn, Output => Cnt_Dn_Buf); 
  

StageIV:
	Block_MoM_StageIV 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => CE, RST => RST, Start => start, Input => Input, 
			Valid => Valid_StageIV, MoM => MoM_StageIV);
  
StageV:
	Block_MoM_StageV 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => Valid_StageIV, RST => RST, Start => Start_StageV, Input => MoM_StageIV, 
			Valid => Valid_StageV, MoM => MoM_StageV);

StageVI:
	Block_MoM_StageVI 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => Valid_StageV, RST => RST, Start => Start_StageVI, Input => MoM_StageV, 
			Valid => Valid_StageVI, MoM => MoM_StageVI); --,inp6 => inp6,cs => open, cb => open

StageVII:
	Block_MoM_StageVII 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => Valid_StageVI, RST => RST, Start => Start_StageVII, Input => MoM_StageVI, 
			Valid => Valid_StageVII, MoM => MoM_StageVII); --,inp7 => inp7,cs7 => bcs, cb7 => bcb

StageVIII:
	Median_4_stageVIII 
		generic map (Width_In => Width_In)
		port map (CLK => CLK, CE => Valid_StageVII, RST => RST, Start => Start_StageVIII, Input => MoM_StageVII, 
			Valid => Valid, Median => MoM);	

---------------------------- Controller --------------------------------------------------------------------------
	

--valid5 <= Valid_stageV ;
--valid6 <= Valid_stageVI;
--valid7 <= Valid_stageVII;
--start6 <= Start_StageVII;
--mom5 <= MoM_StageV;
--mom6 <= MoM_StageVI;
--mom7 <= MOM_StageVII;
--countsmall <=Count_small;
--Countbig<=Count_big;

StageV_Strt:
--	Level_To_Pluse
--		port map (CLK => CLK, CE => Gate_StageVI, RST => RST, Level => Valid_StageV, Pulse => Start_StageVI);
    process(count_small,count_big)
    begin
    if(count_small = 4 and count_big = 1) then
        Start_StageV <='1';
    else
        Start_StageV <='0';
    end if;
    end process;

StageVI_Strt:
--	Level_To_Pluse
--		port map (CLK => CLK, CE => Gate_StageVI, RST => RST, Level => Valid_StageV, Pulse => Start_StageVI);
    process(count_small,count_big)
    begin
    if(count_small = 0 and count_big = 6) then
        Start_StageVI <='1';
    else
        Start_StageVI <='0';
    end if;
    end process;
    
    
StageVII_Strt:
    --    Level_To_Pluse
    --        port map (CLK => CLK, CE => Gate_StageVI, RST => RST, Level => Valid_StageV, Pulse => Start_StageVI);
        process(count_small,count_big)
        begin
        if(count_small = 0 and count_big = 27) then
            Start_StageVII <='1';
        else
            Start_StageVII <='0';
        end if;
        end process;


StageVIII_Strt:
--	Level_To_Pluse
--		port map (CLK => CLK, CE => Gate_StageVIII, RST => RST, Level => Valid_StageVII, Pulse => Start_StageVIII);	

      process(count_small,count_big)
        begin
        if(count_small = 2 and count_big = 129) then
            Start_StageVIII <='1';
        else
            Start_StageVIII <='0';
        end if;
        end process;


FSM:
            process(PrState, Start_StageV,Start_StageVI, Start_StageVII, Start_StageVIII, Start)
            begin
                case PrState is
                
                    when StageIV_State => 
        --                Gate_StageVI     <= '1';
        --                Gate_StageVII     <= '1';
        --                Gate_StageVIII     <= '1';
                        
                        if (Start_StageV = '1') then
                            NxState    <= StageV_Started_State;
                        else
                            NxState <= StageIV_State;
                        end if;    
                
                    when StageV_Started_State => 
        --                Gate_StageVI     <= '1';
        --                Gate_StageVII     <= '1';
        --                Gate_StageVIII     <= '1';
                        
                        if (Start_StageVI = '1') then
                            NxState    <= StageVI_Started_State;
                        else
                            NxState <= StageV_Started_State;
                        end if;    
                        
                    when StageVI_Started_State => 
        --                Gate_StageVI     <= '0';
        --                Gate_StageVII     <= '1';
        --                Gate_StageVIII     <= '1';
                        
                        if (Start_StageVII = '1') then
                            NxState    <= StageVII_Started_State;
                        else
                            NxState <= StageVI_Started_State;
                        end if;    
                        
                    when StageVII_Started_State => 
        --                Gate_StageVI     <= '0';
        --                Gate_StageVII     <= '0';
        --                Gate_StageVIII     <= '1';
                        
                        if (Start_StageVIII = '1') then
                            NxState    <= Final_Stage_Started_State;
                        else
                            NxState <= StageVII_Started_State;
                        end if;
        
                    when Final_Stage_Started_State => 
        --                Gate_StageVI     <= '0';
        --                Gate_StageVII     <= '0';
        --                Gate_StageVIII     <= '0';
                        
                        if (Start = '1') then
                            NxState    <= StageIV_State;
                        else
                            NxState <= Final_Stage_Started_State;
                        end if;    
                                            
                    when others =>
        --                Gate_StageVI     <= '0';
        --                Gate_StageVII     <= '0';
        --                Gate_StageVIII     <= '0';
                        
                        NxState    <= StageIV_State;
                end case;
            end process;    
        
            -- FF process
        FF:
            process(CLK, RST)
            begin
                if (RST = '1') then
                    PrState <= StageIV_State;
                elsif rising_edge(CLK) then
                    if (Start = '1') then
                        PrState <= StageIV_State;
                    else
                        PrState <= NxState;
                    end if;
                end if;    
            end process;        

end Behavioral;
