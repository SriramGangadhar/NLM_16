----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2020 02:51:20 PM
-- Design Name: 
-- Module Name: tb_base - Behavioral
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
use STD.textio.all;

library UNISIM;
use UNISIM.VComponents.all;
use work.nlmspackage.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_base is
--  Port ( );
end tb_base;

architecture Behavioral of tb_base is
component base is 
   
    Port ( clk        : in Std_logic;
        en_in      : in std_logic;
        rst        : in std_logic;
        img_input  : in std_logic_vector(15 downto 0);
        img_output : out std_logic_vector(15 downto 0);
        en_out     : out std_logic
--        count_pixel_in : out STD_LOGIC_VECTOR(16 downto 0);
--                 count_pixel_out: out STD_LOGIC_VECTOR(16 downto 0);
--                 h          : out std_logic_vector(18 downto 0):=(others => '0');
--                 den_img    : out image_size_out := (others=>"0000000000000000");
 
----                rc :out std_logic_vector (6 downto 0);
----                cc :out std_logic_vector (6 downto 0);
--                test: out std_logic_vector(15 downto 0);
--        valid  : out std_logic
        );
 end component;
 

signal valid: std_logic;
signal clk ,en_out:std_logic;
signal en_in: std_logic :='1';
signal rst : std_logic  :='0';
signal img_input,img_output,test: std_logic_vector(15 downto 0) := (others =>'0');
signal den_img: image_size_out := (others=>"0000000000000000");
signal count_pixel_in,count_pixel_out:std_logic_vector(16 downto 0) := (others =>'0');
signal h : std_logic_vector(18 downto 0) :=(others => '0');
--signal difference: std_logic_vector(15 downto 0);
constant CLK_Perd   : time := 13.33 ns; 


--signal validmed5: std_logic;
--signal median5 :  signed (16 downto 0);
--signal window: search_window;
--signal  Z : Std_logic_vector(20 downto 0);
--	constant InitDly    : time := 100 ns;
--	constant Setup      : time := 0.1 * CLK_Perd;
--	constant Hold       : time := 0.1 * CLK_Perd;
--	constant Width_In	: integer := 16;



begin

uut:
	 base 
		port map (CLK => CLK, en_in => en_in ,rst => rst ,img_input => img_input,img_output => img_output,en_out => en_out); --,count_pixel_in=>count_pixel_in,count_pixel_out =>count_pixel_out, h=>h, den_img=>den_img,test=>test,valid => valid);--,rc=>rc,cc=>cc,test=>test );--h => h, valid => valid);
			
Clock:
    process
    begin
        CLK <= '1';
        wait for CLK_Perd/2;
        CLK <= '0';
        wait for CLK_Perd/2;
    end process;
	
	
reponse:
    process(clk)
    
     file  File1  : text open write_mode is "C:\Users\Sriram G\Desktop\MATLAB\VHDL Test\output_img.txt";--Output file--"C:\Users\DSPLAB\Desktop\Rithwik\Image_files\output_newLena.txt";     
     variable TestDat1   : integer;
     variable TesLin1   : line;
       begin
       if(rising_edge(clk)) then
               if(en_out = '1') then
              TestDat1    := to_integer(unsigned(img_output));
               write(TesLin1,integer'image(TestDat1), right, 16);--disp_file, right, 24);
               writeline(File1,TesLin1);
               end if;
       end if;
        
    end process;
    
     --Stimulus process
   Stimulus:
       process
           file Infile1          : text is in  "C:\Users\Sriram G\Desktop\MATLAB\VHDL Test\noisypad.txt";--"C:\Users\DSPLAB\Desktop\Rithwik\Image_files\SAR_first_blk_70x70.txt";--Input file--
           variable Inline1      : line;
           variable Val1         : integer;    
       begin 
           --wait for InitDly;
--           wait until rising_edge(clk);
           --wait for CLK_Perd - Setup; 
        
           -- Reading data        
           for i in 1 to P loop--64 loop
               readline(Infile1, Inline1);
               for j in 1 to P loop--64 loop
                   read(Inline1, Val1);
                   img_input <= std_logic_vector(to_unsigned(Val1, 16));--std_logic_vector(to_unsigned(Val1, 8));
                   en_in <= '1';
                   rst <= '0';
                   wait for CLK_Perd;
               end loop;
           end loop;
           en_in <= '0';
           end process; 
    
    






end Behavioral;
