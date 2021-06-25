----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2020 01:43:17 PM
-- Design Name: 
-- Module Name: weight - Behavioral
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
use work.nlmspackage.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weight is
 Port ( clk,en:in std_logic;
        wind1,wind2: in weight_window;
        out_wt: out std_logic_vector(15 downto 0); --15downto0
        h: in std_logic_vector(18 downto 0)
--        ssdd: out std_logic_vector(35 downto 0); 
--        ssddh: out std_logic_vector(39 downto 0)
      );
end weight;


architecture Behavioral of weight is

signal swind1,swind2: weight_window;
signal sub_window: weight_window:= (others=>(others=>'0'));
signal subsq_res: subsq_window:= (others=>(others=>'0'));
signal sum_res: sum_window:= (others=>(others=>'0')); -- final sum_res, sum_res(9) = ssd
signal ssd: std_logic_vector(35 downto 0); --Q36.0
signal exp: std_logic_vector(15 downto 0); --Q1.15

signal en_exp : STD_LOGIC;
--signal flag: STD_LOGIC;

signal ssddbyh2 : STD_LOGIC_VECTOR(55 downto 0); --Q36.20

component exp_map
          Port (clk :in std_logic;
                inp_wt:in std_logic_vector(39 downto 0);
                out_wt:out std_logic_vector(15 downto 0);
                en_exp:out std_logic );
end component;

begin

-- calculating the difference between the two windows--

gen1: for i in 1 to L generate
gen2: for j in 1 to L generate       
      subsq_res((i-1)*L+j) <= (wind1((i-1)*L+j) - wind2((i-1)*L+j))*(wind1((i-1)*L+j) - wind2((i-1)*L+j)) when wind1((i-1)*L+j)>wind2((i-1)*L+j) else
                            (wind2((i-1)*L+j)-wind1((i-1)*L+j))*(wind2((i-1)*L+j)-wind1((i-1)*L+j));         
end generate;
end generate;

sum_res(1)(32 downto 0) <= ('0' & subsq_res(1))+('0' & subsq_res(2));
sum_res(2)(32 downto 0) <= ('0' & subsq_res(3))+('0' & subsq_res(4));
sum_res(3)(32 downto 0) <= ('0' & subsq_res(5))+('0' & subsq_res(6));
sum_res(4)(32 downto 0) <= ('0' & subsq_res(7))+('0' & subsq_res(8));
sum_res(5)(32 downto 0) <= ('0' & subsq_res(9));
sum_res(6)(33 downto 0) <= ('0' & sum_res(1)(32 downto 0))+('0' & sum_res(2)(32 downto 0));
sum_res(7)(33 downto 0) <= ('0' & sum_res(3)(32 downto 0))+('0' & sum_res(4)(32 downto 0));
sum_res(8)(34 downto 0) <= ('0' & sum_res(6)(33 downto 0))+('0' & sum_res(7)(33 downto 0));
sum_res(9)(35 downto 0) <= ('0' & sum_res(8)(34 downto 0))+('0' & sum_res(5)(32 downto 0));
--ssdd<=sum_res(9);
ssd <= sum_res(9);

--Q36.0*Q0.20 = Q36.20
ssddbyh2 <= 
ssd * "00000101001110010111" when h <= "000000000000000111" else 
ssd * "00000010000111011001" when h <= "000000000000001011" else 
ssd * "00000001001000110100" when h <= "000000000000001111" else 
ssd * "00000000101101011000" when h <= "000000000000010011" else 
ssd * "00000000011110111110" when h <= "000000000000010111" else 
ssd * "00000000010110011110" when h <= "000000000000011011" else 
ssd * "00000000010001000011" when h <= "000000000000011111" else 
ssd * "00000000001101010111" when h <= "000000000000100011" else 
ssd * "00000000001010110001" when h <= "000000000000100111" else 
ssd * "00000000001000110111" when h <= "000000000000101011" else 
ssd * "00000000000111011010" when h <= "000000000000101111" else 
ssd * "00000000000110010011" when h <= "000000000000110011" else 
ssd * "00000000000101011010" when h <= "000000000000110111" else 
ssd * "00000000000100101101" when h <= "000000000000111011" else 
ssd * "00000000000100001000" when h <= "000000000000111111" else 
ssd * "00000000000011101001" when h <= "000000000001000011" else 
ssd * "00000000000011010000" when h <= "000000000001000111" else 
ssd * "00000000000010111010" when h <= "000000000001001011" else 
ssd * "00000000000010101000" when h <= "000000000001001111" else 
ssd * "00000000000010011000" when h <= "000000000001010011" else 
ssd * "00000000000010001010" when h <= "000000000001010111" else 
ssd * "00000000000001111110" when h <= "000000000001011011" else 
ssd * "00000000000001110100" when h <= "000000000001011111" else 
ssd * "00000000000001101010" when h <= "000000000001100011" else 
ssd * "00000000000001100010" when h <= "000000000001100111" else 
ssd * "00000000000001011011" when h <= "000000000001101011" else 
ssd * "00000000000001010101" when h <= "000000000001101111" else 
ssd * "00000000000001001111" when h <= "000000000001110011" else 
ssd * "00000000000001001010" when h <= "000000000001110111" else 
ssd * "00000000000001000101" when h <= "000000000001111011" else 
ssd * "00000000000001000001" when h <= "000000000001111111" else 
ssd * "00000000000000111101" when h <= "000000000010000011" else 
ssd * "00000000000000111001" when h <= "000000000010000111" else 
ssd * "00000000000000110110" when h <= "000000000010001011" else 
ssd * "00000000000000110011" when h <= "000000000010001111" else 
ssd * "00000000000000110000" when h <= "000000000010010011" else 
ssd * "00000000000000101101" when h <= "000000000010010111" else 
ssd * "00000000000000101011" when h <= "000000000010011011" else 
ssd * "00000000000000101001" when h <= "000000000010011111" else 
ssd * "00000000000000100111" when h <= "000000000010100011" else 
ssd * "00000000000000100101" when h <= "000000000010100111" else 
ssd * "00000000000000100011" when h <= "000000000010101011" else 
ssd * "00000000000000100010" when h <= "000000000010101111" else 
ssd * "00000000000000100000" when h <= "000000000010110011" else 
ssd * "00000000000000011111" when h <= "000000000010110111" else 
ssd * "00000000000000011101" when h <= "000000000010111011" else 
ssd * "00000000000000011100" when h <= "000000000010111111" else 
ssd * "00000000000000011011" when h <= "000000000011000011" else 
ssd * "00000000000000011010" when h <= "000000000011000111" else 
ssd * "00000000000000011001" when h <= "000000000011001011" else 
ssd * "00000000000000011000" when h <= "000000000011001111" else 
ssd * "00000000000000010111" when h <= "000000000011010011" else 
ssd * "00000000000000010110" when h <= "000000000011010111" else 
ssd * "00000000000000010101" when h <= "000000000011011011" else 
ssd * "00000000000000010101" when h <= "000000000011011111" else 
ssd * "00000000000000010100" when h <= "000000000011100011" else 
ssd * "00000000000000010011" when h <= "000000000011100111" else 
ssd * "00000000000000010010" when h <= "000000000011101011" else 
ssd * "00000000000000010010" when h <= "000000000011101111" else 
ssd * "00000000000000010001" when h <= "000000000011110011" else 
ssd * "00000000000000010001" when h <= "000000000011110111" else 
ssd * "00000000000000010000" when h <= "000000000011111011" else 
ssd * "00000000000000010000" when h <= "000000000011111111" else 
ssd * "00000000000000001111" when h <= "000000000100000011" else 
ssd * "00000000000000001111" when h <= "000000000100000111" else 
ssd * "00000000000000001110" when h <= "000000000100001011" else 
ssd * "00000000000000001110" when h <= "000000000100001111" else 
ssd * "00000000000000001101" when h <= "000000000100010011" else 
ssd * "00000000000000001101" when h <= "000000000100010111" else 
ssd * "00000000000000001101" when h <= "000000000100011011" else 
ssd * "00000000000000001100" when h <= "000000000100011111" else 
ssd * "00000000000000001100" when h <= "000000000100100011" else 
ssd * "00000000000000001100" when h <= "000000000100100111" else 
ssd * "00000000000000001011" when h <= "000000000100101011" else 
ssd * "00000000000000001011" when h <= "000000000100101111" else 
ssd * "00000000000000001011" when h <= "000000000100110011" else 
ssd * "00000000000000001010" when h <= "000000000100110111" else 
ssd * "00000000000000001010" when h <= "000000000100111011" else 
ssd * "00000000000000001010" when h <= "000000000100111111" else 
ssd * "00000000000000001010" when h <= "000000000101000011" else 
ssd * "00000000000000001001" when h <= "000000000101000111" else 
ssd * "00000000000000001001" when h <= "000000000101001011" else 
ssd * "00000000000000001001" when h <= "000000000101001111" else 
ssd * "00000000000000001001" when h <= "000000000101010011" else 
ssd * "00000000000000001000" when h <= "000000000101010111" else 
ssd * "00000000000000001000" when h <= "000000000101011011" else 
ssd * "00000000000000001000" when h <= "000000000101011111" else 
ssd * "00000000000000001000" when h <= "000000000101100011" else 
ssd * "00000000000000001000" when h <= "000000000101100111" else 
ssd * "00000000000000000111" when h <= "000000000101101011" else 
ssd * "00000000000000000111" when h <= "000000000101101111" else 
ssd * "00000000000000000111" when h <= "000000000101110011" else 
ssd * "00000000000000000111" when h <= "000000000101110111" else 
ssd * "00000000000000000111" when h <= "000000000101111011" else 
ssd * "00000000000000000111" when h <= "000000000101111111" else 
ssd * "00000000000000000111" when h <= "000000000110000011" else 
ssd * "00000000000000000110" when h <= "000000000110000111" else 
ssd * "00000000000000000110" when h <= "000000000110001011" else 
ssd * "00000000000000000110" when h <= "000000000110001111" else 
ssd * "00000000000000000110" when h <= "000000000110010011" else 
ssd * "00000000000000000110" when h <= "000000000110010111" else 
ssd * "00000000000000000110" when h <= "000000000110011011" else 
ssd * "00000000000000000110" when h <= "000000000110011111" else 
ssd * "00000000000000000101" when h <= "000000000110100011" else 
ssd * "00000000000000000101" when h <= "000000000110100111" else 
ssd * "00000000000000000101" when h <= "000000000110101011" else 
ssd * "00000000000000000101" when h <= "000000000110101111" else 
ssd * "00000000000000000101" when h <= "000000000110110011" else 
ssd * "00000000000000000101" when h <= "000000000110110111" else 
ssd * "00000000000000000101" when h <= "000000000110111011" else 
ssd * "00000000000000000101" when h <= "000000000110111111" else 
ssd * "00000000000000000101" when h <= "000000000111000011" else 
ssd * "00000000000000000101" when h <= "000000000111000111" else 
ssd * "00000000000000000100" when h <= "000000000111001011" else 
ssd * "00000000000000000100" when h <= "000000000111001111" else 
ssd * "00000000000000000100" when h <= "000000000111010011" else 
ssd * "00000000000000000100" when h <= "000000000111010111" else 
ssd * "00000000000000000100" when h <= "000000000111011011" else 
ssd * "00000000000000000100" when h <= "000000000111011111" else 
ssd * "00000000000000000100" when h <= "000000000111100011" else 
ssd * "00000000000000000100" when h <= "000000000111100111" else 
ssd * "00000000000000000100" when h <= "000000000111101011" else 
ssd * "00000000000000000100" when h <= "000000000111101111" else 
ssd * "00000000000000000100" when h <= "000000000111110011" else 
ssd * "00000000000000000100" when h <= "000000000111110111" else 
ssd * "00000000000000000100" when h <= "000000000111111011" else 
ssd * "00000000000000000100" when h <= "000000000111111111" else 
ssd * "00000000000000000011" when h <= "000000001000000011" else 
ssd * "00000000000000000011" when h <= "000000001000000111" else 
ssd * "00000000000000000011" when h <= "000000001000001011" else 
ssd * "00000000000000000011" when h <= "000000001000001111" else 
ssd * "00000000000000000011" when h <= "000000001000010011" else 
ssd * "00000000000000000011" when h <= "000000001000010111" else 
ssd * "00000000000000000011" when h <= "000000001000011011" else 
ssd * "00000000000000000011" when h <= "000000001000011111" else 
ssd * "00000000000000000011" when h <= "000000001000100011" else 
ssd * "00000000000000000011" when h <= "000000001000100111" else 
ssd * "00000000000000000011" when h <= "000000001000101011" else 
ssd * "00000000000000000011" when h <= "000000001000101111" else 
ssd * "00000000000000000011" when h <= "000000001000110011" else 
ssd * "00000000000000000011" when h <= "000000001000110111" else 
ssd * "00000000000000000011" when h <= "000000001000111011" else 
ssd * "00000000000000000011" when h <= "000000001000111111" else 
ssd * "00000000000000000011" when h <= "000000001001000011" else 
ssd * "00000000000000000011" when h <= "000000001001000111" else 
ssd * "00000000000000000011" when h <= "000000001001001011" else 
ssd * "00000000000000000011" when h <= "000000001001001111" else 
ssd * "00000000000000000010" when h <= "000000001001010011" else 
ssd * "00000000000000000010" when h <= "000000001001010111" else 
ssd * "00000000000000000010" when h <= "000000001001011011" else 
ssd * "00000000000000000010" when h <= "000000001001011111" else 
ssd * "00000000000000000010" when h <= "000000001001100011" else 
ssd * "00000000000000000010" when h <= "000000001001100111" else 
ssd * "00000000000000000010" when h <= "000000001001101011" else 
ssd * "00000000000000000010" when h <= "000000001001101111" else 
ssd * "00000000000000000010" when h <= "000000001001110011" else 
ssd * "00000000000000000010" when h <= "000000001001110111" else 
ssd * "00000000000000000010" when h <= "000000001001111011" else 
ssd * "00000000000000000010" when h <= "000000001001111111" else 
ssd * "00000000000000000010" when h <= "000000001010000011" else 
ssd * "00000000000000000010" when h <= "000000001010000111" else 
ssd * "00000000000000000010" when h <= "000000001010001011" else 
ssd * "00000000000000000010" when h <= "000000001010001111" else 
ssd * "00000000000000000010" when h <= "000000001010010011" else 
ssd * "00000000000000000010" when h <= "000000001010010111" else 
ssd * "00000000000000000010" when h <= "000000001010011011" else 
ssd * "00000000000000000010" when h <= "000000001010011111" else 
ssd * "00000000000000000010" when h <= "000000001010100011" else 
ssd * "00000000000000000010" when h <= "000000001010100111" else 
ssd * "00000000000000000010" when h <= "000000001010101011" else 
ssd * "00000000000000000010" when h <= "000000001010101111" else 
ssd * "00000000000000000010" when h <= "000000001010110011" else 
ssd * "00000000000000000010" when h <= "000000001010110111" else 
ssd * "00000000000000000010" when h <= "000000001010111011" else 
ssd * "00000000000000000010" when h <= "000000001010111111" else 
ssd * "00000000000000000010" when h <= "000000001011000011" else 
ssd * "00000000000000000010" when h <= "000000001011000111" else 
ssd * "00000000000000000010" when h <= "000000001011001011" else 
ssd * "00000000000000000010" when h <= "000000001011001111" else 
ssd * "00000000000000000010" when h <= "000000001011010011" else 
ssd * "00000000000000000001" when h <= "000000001011010111" else 
ssd * "00000000000000000001" when h <= "000000001011011011" else 
ssd * "00000000000000000001" when h <= "000000001011011111" else 
ssd * "00000000000000000001" when h <= "000000001011100011" else 
ssd * "00000000000000000001" when h <= "000000001011100111" else 
ssd * "00000000000000000001" when h <= "000000001011101011" else 
ssd * "00000000000000000001" when h <= "000000001011101111" else 
ssd * "00000000000000000001" when h <= "000000001011110011" else 
ssd * "00000000000000000001" when h <= "000000001011110111" else 
ssd * "00000000000000000001" when h <= "000000001011111011" else 
ssd * "00000000000000000001" when h <= "000000001011111111" else 
ssd * "00000000000000000001" when h <= "000000001100000011" else 
ssd * "00000000000000000001" when h <= "000000001100000111" else 
ssd * "00000000000000000001" when h <= "000000001100001011" else 
ssd * "00000000000000000001" when h <= "000000001100001111" else 
ssd * "00000000000000000001" when h <= "000000001100010011" else 
ssd * "00000000000000000001" when h <= "000000001100010111" else 
ssd * "00000000000000000001" when h <= "000000001100011011" else 
ssd * "00000000000000000001" when h <= "000000001100011111" else 
ssd * "00000000000000000001" when h <= "000000001100100011" else 
ssd * "00000000000000000001" when h <= "000000001100100111" else 
ssd * "00000000000000000001" when h <= "000000001100101011" else 
ssd * "00000000000000000001" when h <= "000000001100101111" else 
ssd * "00000000000000000001" when h <= "000000001100110011" else 
ssd * "00000000000000000001" when h <= "000000001100110111" else 
ssd * "00000000000000000001" when h <= "000000001100111011" else 
ssd * "00000000000000000001" when h <= "000000001100111111" else 
ssd * "00000000000000000001" when h <= "000000001101000011" else 
ssd * "00000000000000000001" when h <= "000000001101000111" else 
ssd * "00000000000000000001" when h <= "000000001101001011" else 
ssd * "00000000000000000001" when h <= "000000001101001111" else 
ssd * "00000000000000000001" when h <= "000000001101010011" else 
ssd * "00000000000000000001" when h <= "000000001101010111" else 
ssd * "00000000000000000001" when h <= "000000001101011011" else 
ssd * "00000000000000000001" when h <= "000000001101011111" else 
ssd * "00000000000000000001" when h <= "000000001101100011" else 
ssd * "00000000000000000001" when h <= "000000001101100111" else 
ssd * "00000000000000000001" when h <= "000000001101101011" else 
ssd * "00000000000000000001" when h <= "000000001101101111" else 
ssd * "00000000000000000001" when h <= "000000001101110011" else 
ssd * "00000000000000000001" when h <= "000000001101110111" else 
ssd * "00000000000000000001" when h <= "000000001101111011" else 
ssd * "00000000000000000001" when h <= "000000001101111111" else 
ssd * "00000000000000000001" when h <= "000000001110000011" else 
ssd * "00000000000000000001" when h <= "000000001110000111" else 
ssd * "00000000000000000001" when h <= "000000001110001011" else 
ssd * "00000000000000000001" when h <= "000000001110001111" else 
ssd * "00000000000000000001" when h <= "000000001110010011" else 
ssd * "00000000000000000001" when h <= "000000001110010111" else 
ssd * "00000000000000000001" when h <= "000000001110011011" else 
ssd * "00000000000000000001" when h <= "000000001110011111" else 
ssd * "00000000000000000001" when h <= "000000001110100011" else 
ssd * "00000000000000000001" when h <= "000000001110100111" else 
ssd * "00000000000000000001" when h <= "000000001110101011" else 
ssd * "00000000000000000001" when h <= "000000001110101111" else 
ssd * "00000000000000000001" when h <= "000000001110110011" else 
ssd * "00000000000000000001" when h <= "000000001110110111" else 
ssd * "00000000000000000001" when h <= "000000001110111011" else 
ssd * "00000000000000000001" when h <= "000000001110111111" else 
ssd * "00000000000000000001" when h <= "000000001111000011" else 
ssd * "00000000000000000001" when h <= "000000001111000111" else 
ssd * "00000000000000000001";

            

--ssddh<=ssddbyh2;
exponentLUT: 
            exp_map 
                    port map(clk => clk, inp_wt => ssddbyh2(55 downto 16) , out_wt => exp, en_exp => en_exp );


Output  : process(clk)
            begin
                if(en_exp = '1') then
                    out_wt <= exp;
                end if;
            end process;

end Behavioral;
-----------------------------
------------------------
---------------------------
--------------------------
-------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use work.nlmspackage.all;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity weight is
-- Port ( clk,en:in std_logic;
--        wind1,wind2: in weight_window;
--        out_wt: out std_logic_vector(15 downto 0); --15downto0
--        h: in std_logic_vector(18 downto 0)
----        ssdd: out std_logic_vector(35 downto 0); 
----        ssddh: out std_logic_vector(39 downto 0)
--      );
--end weight;


--architecture Behavioral of weight is

--signal swind1,swind2: weight_window;
--signal sub_window: weight_window:= (others=>(others=>'0'));
--signal subsq_res: subsq_window:= (others=>(others=>'0'));
--signal sum_res: sum_window:= (others=>(others=>'0')); -- final sum_res, sum_res(9) = ssd
--signal ssd: std_logic_vector(39 downto 0); --Q36.4
--signal exp: std_logic_vector(15 downto 0); --Q1.15

--signal en_exp : STD_LOGIC;
----signal flag: STD_LOGIC;

--signal ssddbyh2 : STD_LOGIC_VECTOR(39 downto 0);

--component exp_map
--          Port (clk :in std_logic;
--                inp_wt:in std_logic_vector(39 downto 0);
--                out_wt:out std_logic_vector(15 downto 0);
--                en_exp:out std_logic );
--end component;

--begin

---- calculating the difference between the two windows--

--gen1: for i in 1 to L generate
--gen2: for j in 1 to L generate       
--      subsq_res((i-1)*L+j) <= (wind1((i-1)*L+j) - wind2((i-1)*L+j))*(wind1((i-1)*L+j) - wind2((i-1)*L+j)) when wind1((i-1)*L+j)>wind2((i-1)*L+j) else
--                            (wind2((i-1)*L+j)-wind1((i-1)*L+j))*(wind2((i-1)*L+j)-wind1((i-1)*L+j));         
--end generate;
--end generate;

--sum_res(1)(32 downto 0) <= ('0' & subsq_res(1))+('0' & subsq_res(2));
--sum_res(2)(32 downto 0) <= ('0' & subsq_res(3))+('0' & subsq_res(4));
--sum_res(3)(32 downto 0) <= ('0' & subsq_res(5))+('0' & subsq_res(6));
--sum_res(4)(32 downto 0) <= ('0' & subsq_res(7))+('0' & subsq_res(8));
--sum_res(5)(32 downto 0) <= ('0' & subsq_res(9));
--sum_res(6)(33 downto 0) <= ('0' & sum_res(1)(32 downto 0))+('0' & sum_res(2)(32 downto 0));
--sum_res(7)(33 downto 0) <= ('0' & sum_res(3)(32 downto 0))+('0' & sum_res(4)(32 downto 0));
--sum_res(8)(34 downto 0) <= ('0' & sum_res(6)(33 downto 0))+('0' & sum_res(7)(33 downto 0));
--sum_res(9)(35 downto 0) <= ('0' & sum_res(8)(34 downto 0))+('0' & sum_res(5)(32 downto 0));
----ssdd<=sum_res(9);
--ssd <= sum_res(9) & "0000";


--RightShift:
--            process(ssd,h)
--            begin
           
--            if(h>"10000000000000000") then -- 2^16
--                    if("100000000000000000"-h>h-"10000000000000000") then --2^17-h>h-2^16
--                        ssddbyh2 <= "00000000000000000000000000000000" & ssd(39 downto 32); --32 0s
--                    else
--                        ssddbyh2 <= "0000000000000000000000000000000000"  & ssd(39 downto 34);
--                    end if;
                    
--            elsif (h>"1000000000000000") then 
--                    if("10000000000000000"-h>h-"1000000000000000") then 
--                         ssddbyh2 <= "000000000000000000000000000000" & ssd(39 downto 30); 
--                    else
--                         ssddbyh2 <= "00000000000000000000000000000000"  & ssd(39 downto 32);
--                   end if;
                   
--            elsif (h>"100000000000000") then 
--                     if("1000000000000000"-h>h-"100000000000000") then 
--                          ssddbyh2 <= "0000000000000000000000000000" & ssd(39 downto 28); 
--                     else
--                          ssddbyh2 <= "000000000000000000000000000000"  & ssd(39 downto 30);
--                     end if; 
                     
--            elsif (h>"10000000000000") then 
--                      if("100000000000000"-h>h-"10000000000000") then 
--                            ssddbyh2 <= "00000000000000000000000000" & ssd(39 downto 26); 
--                      else
--                            ssddbyh2 <= "0000000000000000000000000000"  & ssd(39 downto 28);
--                      end if;   
                      
--            elsif (h>"1000000000000") then 
--                       if("10000000000000"-h>h-"1000000000000") then 
--                             ssddbyh2 <= "000000000000000000000000" & ssd(39 downto 24); 
--                       else
--                             ssddbyh2 <= "00000000000000000000000000"  & ssd(39 downto 26);
--                       end if;     

--            elsif (h>"100000000000") then 
--                       if("1000000000000"-h>h-"100000000000") then 
--                             ssddbyh2 <= "0000000000000000000000" & ssd(39 downto 22); 
--                       else
--                             ssddbyh2 <= "000000000000000000000000"  & ssd(39 downto 24);
--                       end if; 
                       
--            elsif (h>"10000000000") then 
--                       if("100000000000"-h>h-"10000000000") then 
--                              ssddbyh2 <= "00000000000000000000" & ssd(39 downto 20); 
--                       else
--                              ssddbyh2 <= "0000000000000000000000"  & ssd(39 downto 22);
--                       end if; 
                       
--            elsif (h>"1000000000") then 
--                       if("10000000000"-h>h-"1000000000") then 
--                               ssddbyh2 <= "000000000000000000" & ssd(39 downto 18); 
--                       else
--                               ssddbyh2 <= "00000000000000000000"  & ssd(39 downto 20);
--                       end if; 

--            elsif (h>"100000000") then 
--                       if("1000000000"-h>h-"100000000") then 
--                               ssddbyh2 <= "0000000000000000" & ssd(39 downto 16); 
--                       else
--                               ssddbyh2 <= "000000000000000000"  & ssd(39 downto 18);
--                       end if;

--            elsif (h>"10000000") then 
--                       if("100000000"-h>h-"10000000") then 
--                               ssddbyh2 <= "00000000000000" & ssd(39 downto 14); 
--                       else
--                               ssddbyh2 <= "0000000000000000"  & ssd(39 downto 16);
--                       end if;

--            elsif (h>"1000000") then 
--                       if("10000000"-h>h-"1000000") then 
--                               ssddbyh2 <= "000000000000" & ssd(39 downto 12); 
--                       else
--                               ssddbyh2 <= "00000000000000"  & ssd(39 downto 14);
--                       end if;

--            elsif (h>"100000") then 
--                       if("1000000"-h>h-"100000") then 
--                               ssddbyh2 <= "0000000000" & ssd(39 downto 10); 
--                       else
--                               ssddbyh2 <= "000000000000"  & ssd(39 downto 12);
--                       end if;

--            elsif (h>"10000") then 
--                       if("100000"-h>h-"10000") then 
--                               ssddbyh2 <= "00000000" & ssd(39 downto 8); 
--                       else
--                               ssddbyh2 <= "0000000000"  & ssd(39 downto 10);
--                       end if;

--            elsif (h>"1000") then 
--                       if("10000"-h>h-"1000") then 
--                               ssddbyh2 <= "000000" & ssd(39 downto 6); 
--                       else
--                               ssddbyh2 <= "00000000"  & ssd(39 downto 8);
--                       end if;

--            elsif (h>"100") then 
--                       if("1000"-h>h-"100") then 
--                               ssddbyh2 <= "0000" & ssd(39 downto 4); 
--                       else
--                               ssddbyh2 <= "000000"  & ssd(39 downto 6);
--                       end if;

--            elsif (h>"10") then 
--                       if("100"-h>h-"10") then 
--                               ssddbyh2 <= "00" & ssd(39 downto 2); 
--                       else
--                               ssddbyh2 <= "0000"  & ssd(39 downto 4);
--                       end if;

--            else 
--                       if("10"-h>h-"1") then 
--                               ssddbyh2 <=  ssd(39 downto 0); 
--                       else
--                               ssddbyh2 <= "00"  & ssd(39 downto 2);
--                       end if;
--            end if;
            
--            end process;
            

----ssddh<=ssddbyh2;
--exponentLUT: 
--            exp_map 
--                    port map(clk => clk, inp_wt => ssddbyh2 , out_wt => exp, en_exp => en_exp );


--Output  : process(clk)
--            begin
--                if(en_exp = '1') then
--                    out_wt <= exp;
--                end if;
--            end process;

--end Behavioral;
