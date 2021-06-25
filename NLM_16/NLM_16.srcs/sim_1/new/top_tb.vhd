----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/31/2020 10:50:57 AM
-- Design Name: 
-- Module Name: final_tb - Behavioral
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
use STD.textio.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
use work.nlmspackage.all;

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is
component AXI_wrap is
  Port ( axi_clk: in std_logic;
         axi_rst_n: in std_logic;
         
         --Slave
         s_axi_valid : in std_logic;
         s_axi_data  : in std_logic_vector(15 downto 0);
         s_axi_ready : out std_logic;
         
         --master
         m_axi_valid : out std_logic;
         m_axi_data  : out std_logic_vector(15 downto 0);
         m_axi_ready : in std_logic
         );
end component;

signal axi_clk: std_logic :='0';
signal axi_rst_n: std_logic :='0';
signal s_axi_valid: std_logic :='0';
signal m_axi_valid: std_logic;
signal s_axi_ready: std_logic;
signal m_axi_ready: std_logic :='1';
signal s_axi_data: std_logic_vector(15 downto 0):="0000000000000000";
signal m_axi_data: std_logic_vector(15 downto 0);
constant CLK_Perd   : time := 10 ns; 
signal count_input_pixel: std_logic_vector(18 downto 0):="0000000000000000000";


begin

--axi_rst_n<= '0','1' after 10ns;
axi_rst_n<='1';
s_axi_valid<='1' when count_input_pixel>=1 and count_input_pixel<=P2 else '0';
--m_axi_ready<='1','0' after 8000ns,'1' after 18020ns;
uut: AXI_wrap port map ( axi_clk=> axi_clk,
                                 axi_rst_n=>axi_rst_n ,       
                                --Slave
                                 s_axi_valid=> s_axi_valid,
                                 s_axi_data=>s_axi_data ,
                                 s_axi_ready=>s_axi_ready ,         
                                --master
                                 m_axi_valid=>m_axi_valid ,
                                 m_axi_data=>m_axi_data ,
                                 m_axi_ready=> m_axi_ready );
        
 --when count_input_pixel>=1 and count_input_pixel<=P2 else '0';
Clock:
    process
    begin
        axi_clk<= not axi_clk;
        
        wait for CLK_Perd/2;
    end process;
 
 cnt_inpix:
    process(axi_clk)
    begin 
        if (axi_rst_n='0') then
            count_input_pixel<="0000000000000000001";
        else
            if (rising_edge(axi_clk)) then
                if (count_input_pixel<=P2) then
                    count_input_pixel<=count_input_pixel+1;
                end if; 
            end if;
        end if;
    end process;
    

    
stimulus:
     process
               file Infile1          : text is in  "C:\Users\Sriram G\Desktop\MATLAB\VHDL Test\noisypad.txt";--"C:\Users\DSPLAB\Desktop\Rithwik\Image_files\SAR_first_blk_70x70.txt";--Input file--
               variable Inline1      : line;
               variable Val1         : integer;    
           begin
               for i in 1 to P loop--64 loop
                   readline(Infile1, Inline1);
                   for j in 1 to P loop--64 loop
                       read(Inline1, Val1);
                       s_axi_data <= std_logic_vector(to_unsigned(Val1, 16));--std_logic_vector(to_unsigned(Val1, 8));

                       wait for CLK_Perd;
                   end loop;
                  
               end loop;
 
               end process; 
    
    reponse:
        process(axi_clk)
        
         file  File1  : text open write_mode is "C:\Users\Sriram G\Desktop\MATLAB\VHDL Test\output_img.txt";--Output file--"C:\Users\DSPLAB\Desktop\Rithwik\Image_files\output_newLena.txt";     
         variable TestDat1   : integer;
         variable TesLin1   : line;
           begin
           if(rising_edge(axi_clk)) then
                   if(m_axi_valid = '1') then
                  TestDat1    := to_integer(unsigned(m_axi_data));
                   write(TesLin1,integer'image(TestDat1), right, 16);--disp_file, right, 24);
                   writeline(File1,TesLin1);
                   end if;
           end if;
            
        end process;
end Behavioral;
