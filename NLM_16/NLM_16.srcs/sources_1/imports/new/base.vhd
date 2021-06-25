----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2020 11:31:39 AM
-- Design Name: 
-- Module Name: base - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

use work.nlmspackage.all;

entity base is
  Port ( clk        : in Std_logic:= '0';
         en_in      : in std_logic:= '0';
         rst        : in std_logic:= '0';
         img_input  : in std_logic_vector(15 downto 0):=(others => '0');
         img_output : out std_logic_vector(15 downto 0):=(others => '0');
         en_out     : out std_logic:= '0';
         tlast      : out std_logic:= '0'
--         count_pixel_in : out STD_LOGIC_VECTOR(16 downto 0);
--         count_pixel_out: out STD_LOGIC_VECTOR(16 downto 0);
--         h          : out std_logic_vector(18 downto 0):=(others => '0');
--         den_img    : out image_size_out := (others=>"0000000000000000");

--         rc :out std_logic_vector (6 downto 0);
--         cc :out std_logic_vector (6 downto 0);
--         test: out std_logic_vector(15 downto 0);
--         valid  : out std_logic     
         );
end base;

architecture Behavioral of base is

    component one_pixel_final is
         Port ( clk    : in STD_LOGIC;
                en_calc   : in STD_LOGIC;
                one_search: in search_window;
                en_out    : out std_logic;
                pixel_out : out STD_LOGIC_VECTOR(15 downto 0);
                h         : in STD_LOGIC_VECTOR(18 downto 0)
                );
    end component;
    
    component Find_Threshold is
        generic (Width_In : integer := 24);    
        Port ( CLK            : in STD_LOGIC;
               CE            : in STD_LOGIC; 
               Start        : in STD_LOGIC;    
               RST            : in STD_LOGIC;      
               Input         : in signed (Width_In - 1 downto 0);
               Valid        : out STD_LOGIC;
               Threshold    : out signed (Width_In - 1 downto 0)
               --threshold is sigma
             ); 
    end component;
    
    component dflipflop is
        Port ( clk  : in STD_LOGIC;
               en   : in STD_LOGIC;
               D    : in STD_LOGIC_VECTOR (15 downto 0);
               Q    : out STD_LOGIC_VECTOR (15 downto 0));
    end component;
    
type image_size is array(1 to P2) of std_logic_vector(15 downto 0);
type image_size_out is array(1 to N2) of std_logic_vector(15 downto 0);
type register_array is array( 1 to R2) of std_logic_vector(15 downto 0);
signal count_outpixel   : std_logic_vector(21 downto 0):=(others => '0');
signal count_inpixel    : std_logic_vector(21 downto 0):=(others => '0');
signal one_search       : search_window; 
constant width: integer:= 17;
signal CE_thresh,start,valid_thresh,en_ff        : std_logic;
signal sigma: signed (Width-1  downto 0);
signal h_temp   : std_logic_vector(18 downto 0);
signal first_in :std_logic_vector(15 downto 0);
signal reg: register_array:= (others => (others =>'0'));
signal diff       : std_logic_vector(15 downto 0):=(others => '0');
signal diff_temp      : std_logic_vector(16 downto 0):=(others => '0');
--signal image_out    : image_size_out := (others=>"0000000000000000");
--signal image        : image_size := (others=>"0000000000000000");
signal med1,med2 :std_logic_vector(15 downto 0);
signal en_calc, en_out1 :std_logic;
signal den_out: std_logic_vector(15 downto 0):= (others=>'0');
signal reg_counter      : integer := 0; -- counts number in every row


-------------------------------------------------------------------------------------

begin

bio:
    for jjj in 2 to (R2) generate
    bbc:   
        dflipflop port map(clk => clk, en => en_ff, D => reg(jjj-1), Q => reg(jjj));
    end generate;
    bbd:dflipflop port map(clk => clk, en => en_ff, D =>first_in, Q => reg(1));

a1:for aaaa in 1 to M generate
b1:for bbbb in 1 to M generate
c1:for cccc in 1 to L generate
d1:for dddd in 1 to L generate
    one_search((aaaa-1)*M + bbbb)((cccc-1)*L + dddd) <= reg((reg_size-aaaa-cccc+1)*P + (P-bbbb-dddd+2));
end generate;
end generate;
end generate;
end generate;

--window<=one_search;

--count_pixel_in <= count_inpixel;
--count_pixel_out <= count_outpixel;

--valid<=valid_thresh;

h_temp<="100" * std_logic_vector(sigma(15 downto 0))+"111";
--h<=h_temp;
--h<="001" * std_logic_vector(sigma(15 downto 0));
--test<=diff;
--valid<=CE_thresh;
diff_temp <= '0' & diff;
start<='0';

Median_calc: 
    Find_Threshold 
        generic map(Width_In => Width)
        port map(CLK => clk, CE => CE_thresh, Start => start, RST => rst, Input => signed(diff_temp),Valid =>valid_thresh, Threshold => sigma);

output_map: 
    one_pixel_final 
        port map(clk => clk , en_calc => en_calc , one_search => one_search , en_out => en_out1, pixel_out => den_out, h => h_temp);

en_calc <= '1' when count_inpixel>=reg_size*P and count_outpixel<=N2 and reg_counter<=N and reg_counter>=1 else '0';
en_ff <= '1' when count_inpixel>=1 and count_outpixel<=N2 and rst='0' else '0';
tlast<='1' when count_outpixel=N2-1 else '0';
--en_out<='1' when count_inpixel>=R2+4 and count_outpixel<=N2+1 and reg_counter<=P-4 and reg_counter>=3 else '0';

Thresh_control:
    process(clk,count_inpixel)
    begin
      if(count_inpixel > 2157 or count_inpixel < 3 ) then
           ce_thresh <='0';
      else
           ce_thresh <='1';
      end if;
    end process;

--rc<=row_count;
--cc<=col_count;
--test<=image_out(2);


cnt_inpix:
process(clk)
begin 
   if (rising_edge(clk)) then
       if (rst='1' or count_outpixel = N2) then
            count_inpixel<=(others => '0');
       elsif (count_inpixel<=P2 and en_in='1') then
            count_inpixel<=count_inpixel+1;
       end if;
    end if;
end process;

ip_control_process: 
    process(clk,count_outpixel)
    begin
            if(rising_edge(clk)) then
                if (rst='1' ) then --RESET HIGH
                    first_in <=(others => '0');
                else           
                if (en_in='1') then
--                            image(conv_integer(count_inpixel)) <= img_input; 
                            first_in <= img_input;
                            med1 <= img_input;
                            med2 <= med1;
                            --Computing the difference for median
                            
                            if(med1>med2) then
                                diff <= med1-med2;
                            else
                                diff <= med2-med1;
                            end if;
                            

                end if; --ending if (en_in='1')              
               end if; -- ending if(rst='1')
           end if;--ending if(rising_edge(clk))           
        
    end process;


op_control_process: 
process(clk)
begin
    if(rising_edge(clk)) then
        if (rst='1' or count_outpixel=N2) then
            count_outpixel <= (others => '0');
            img_output<= (others=>'0');
            en_out<='0';
        else
            if(en_out1='1') then
--                image_out(conv_integer(count_outpixel)) <= den_out ;
                img_output <= den_out;   
                en_out<='1';
                if (count_outpixel <= N2) then--N2
                    count_outpixel <= count_outpixel+1;
                end if;    
            else
                en_out<='0';         
            end if; -- ending if(en_out1='1');
        end if;
    end if;
end process;


reg_cnt: 
process(clk,count_outpixel)
begin
    if(rising_edge(clk)) then
        if (rst='1' or count_outpixel = N2) then
             reg_counter <= 0;
        else
            if (reg_counter < P-1 and count_inpixel>=1) then
                 reg_counter <= reg_counter+1;
            else
                 reg_counter<=0;
            end if;
        end if;
    end if;
end process;

end Behavioral;
