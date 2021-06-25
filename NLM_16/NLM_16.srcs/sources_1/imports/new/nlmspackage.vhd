----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2020 01:56:48 PM
-- Design Name: 
-- Module Name: nlmspackage - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



package nlmspackage is

       constant w:integer :=16;
       constant r: integer := 15;
    
       constant N : integer := 1024;--512;--256;--74;
       constant M : integer := 5;--Search window
       constant L : integer := 3;--Similarity window or neighbourhood
       --constant h_val :std_logic_vector(7 downto 0):= "00000100";  -- h_val = 4;
       constant L2 : integer := L*L;
       constant M2 : integer := M*M;
       constant N2 : integer := N*N;
       constant reg_size : integer := M + L - 1; --7
       constant P : integer := N + M + L-2; --262
       constant P2 : integer := P*P;--Padded matrix size
       constant R2 : integer := reg_size*P;--N

    
        -- Weight Base  TYPES --
        type weight_window is array( 1 to L2) of std_logic_vector(15 downto 0); 
        type subsq_window is array( 1 to L2) of std_logic_vector(31 downto 0); 
        type sum_window is array( 1 to L2) of std_logic_vector(35 downto 0);
        
        
        -- One Pixel Types --
        type search_window is array(1 to M2) of weight_window; 
        type weight_values is array(1 to M2) of std_logic_vector(15 downto 0);-- e^-ssd/h2
        type sum_weight_val is array(1 to M2 ) of std_logic_vector(20 downto 0);--For Z(i);
        type multiply is array(1 to M2) of std_logic_vector(31 downto 0);-- weight value * pixel value(search window)
        type sum_multiply is array(1 to M2) of std_logic_vector(36 downto 0);-- summation of type multiply(25 additions)
        
 
       
        -- Image Type --
        type image_size is array(1 to P2) of std_logic_vector(15 downto 0);--( 7 downto 0 );
        type image_size_out is array(1 to N2) of std_logic_vector(15 downto 0);--( 7 downto 0 );
        type register_array is array( 1 to R2) of std_logic_vector(15 downto 0);--( 7 downto 0);
        
        type rarr is array (1 to N2) of  std_logic_vector(15 downto 0);
        type median_array is array( 1 to 420) of std_logic_vector(15 downto 0);
        
--        type fp_var is array(0 to 48) of std_logic_vector( 14 downto 0 );
    

end package nlmspackage;