----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/11/2020 02:52:11 PM
-- Design Name: 
-- Module Name: one_pixel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- -- Revision:
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

entity one_pixel_final is
         Port ( clk    : in STD_LOGIC;
                en_calc   : in STD_LOGIC;
                one_search: in search_window;
                en_out    : out std_logic;
                pixel_out : out STD_LOGIC_VECTOR(15 downto 0);
                h         : in STD_LOGIC_VECTOR(18 downto 0)
--                Z : out Std_logic_vector(20 downto 0);
--                vw: out Std_logic_vector(36 downto 0)
                
--                ssdd: out STD_LOGIC_VECTOR(35 downto 0);
--                ssdw : out STD_LOGIC_VECTOR(39 downto 0);
--                exp: out std_logic_vector(15 downto 0)
                );
                
end one_pixel_final;


architecture Behavioral of one_pixel_final is

component weight is
     Port ( clk,en:in std_logic;
            wind1,wind2: in weight_window;
            out_wt: out std_logic_vector(15 downto 0); --15downto0
            h: in std_logic_vector(18 downto 0)
--            ssdd: out STD_LOGIC_VECTOR(35 downto 0);
--            ssddh: out std_logic_vector(39 downto 0)
     );
end component weight;



signal central_window   : weight_window;                   -- For storing the Central Pixel Window 
signal each_weight      : weight_values;                   -- Weight Associated with each Pixel
signal mult_out         : multiply;                        -- Weight Multiplied with pixel values
signal sum_mult_out     : sum_multiply;                    -- To find sum of all PIXEL * WEIGHT products 
signal sum_weights      : sum_weight_val;                  -- To find the Total Sum of all Weights
signal normal_weight    : std_logic_vector(20 downto 0);  -- Normalisation Factor
signal vi_wi            : std_logic_vector(36 downto 0); -- FINAL Sum of PIXEL * WEIGHT excluding Z(i)
signal out_pixel        : STD_LOGIC_VECTOR(52 downto 0); -- vi_wi *1/(Z(i) Q23.30

--signal ssdh :STD_LOGIC_VECTOR(39 downto 0);
--signal ssd :STD_LOGIC_VECTOR(35 downto 0);

signal buf1,buf1_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf2,buf2_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf3,buf3_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf4,buf4_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf5,buf5_2 :  std_logic_vector(15 downto 0):= (others => '0');
 
signal buf6,buf6_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf7,buf7_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf8,buf8_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf9,buf9_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf10,buf10_2 :  std_logic_vector(15 downto 0):= (others => '0'); 

signal buf11,buf11_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf12,buf12_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf13,buf13_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf14,buf14_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf15,buf15_2 :  std_logic_vector(15 downto 0):= (others => '0'); 

signal buf16,buf16_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf17,buf17_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf18,buf18_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf19,buf19_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf20,buf20_2 :  std_logic_vector(15 downto 0):= (others => '0'); 

signal buf21,buf21_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf22,buf22_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf23,buf23_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf24,buf24_2 :  std_logic_vector(15 downto 0):= (others => '0'); 
signal buf25,buf25_2 :  std_logic_vector(15 downto 0):= (others => '0'); 




begin
--ssdw<=ssdh;
--ssdd<=ssd;
central_window <= one_search(13);
--exp<=each_weight(1);
-- one_search - Q16.0
-- each_weight - Q1.15
wt1: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(1),out_wt => each_weight(1), h=> h); --,ssdd => ssd,ssddh => ssdh
wt2: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(2),out_wt => each_weight(2), h=> h); --,ssdd => open,ssddh => open
wt3: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(3),out_wt => each_weight(3), h=> h);
wt4: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(4),out_wt => each_weight(4), h=> h);
wt5: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(5),out_wt => each_weight(5), h=> h);
wt6: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(6),out_wt => each_weight(6), h=> h);
wt7: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(7),out_wt => each_weight(7), h=> h);
wt8: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(8),out_wt => each_weight(8), h=> h);
wt9: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(9),out_wt => each_weight(9), h=> h);
wt10: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(10),out_wt => each_weight(10), h=> h);
wt11: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(11),out_wt => each_weight(11), h=> h);
wt12: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(12),out_wt => each_weight(12), h=> h);
wt13: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(13),out_wt => each_weight(13), h=> h);
wt14: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(14),out_wt => each_weight(14), h=> h);
wt15: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(15),out_wt => each_weight(15), h=> h);
wt16: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(16),out_wt => each_weight(16), h=> h);
wt17: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(17),out_wt => each_weight(17), h=> h);
wt18: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(18),out_wt => each_weight(18), h=> h);
wt19: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(19),out_wt => each_weight(19), h=> h);
wt20: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(20),out_wt => each_weight(20), h=> h);
wt21: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(21),out_wt => each_weight(21), h=> h);
wt22: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(22),out_wt => each_weight(22), h=> h);
wt23: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(23),out_wt => each_weight(23), h=> h);
wt24: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(24),out_wt => each_weight(24), h=> h);
wt25: weight port map(clk => clk, en => en_calc, wind1 => central_window, wind2 => one_search(25),out_wt => each_weight(25), h=> h);



Reg2:
	process(CLK)
    begin
    
    buf1_2  <= one_search(1)(5); 
    buf2_2  <= one_search(2)(5); 
    buf3_2  <= one_search(3)(5); 
    buf4_2  <= one_search(4)(5); 
    buf5_2  <= one_search(5)(5); 
    buf6_2  <= one_search(6)(5); 
    buf7_2  <= one_search(7)(5); 
    buf8_2  <= one_search(8)(5); 
    buf9_2  <= one_search(9)(5); 
    buf10_2  <= one_search(10)(5); 
    buf11_2  <= one_search(11)(5); 
    buf12_2  <= one_search(12)(5); 
    buf13_2  <= one_search(13)(5); 
    buf14_2  <= one_search(14)(5); 
    buf15_2  <= one_search(15)(5); 
    buf16_2  <= one_search(16)(5); 
    buf17_2  <= one_search(17)(5); 
    buf18_2  <= one_search(18)(5); 
    buf19_2  <= one_search(19)(5); 
    buf20_2  <= one_search(20)(5); 
    buf21_2  <= one_search(21)(5); 
    buf22_2  <= one_search(22)(5); 
    buf23_2  <= one_search(23)(5); 
    buf24_2  <= one_search(24)(5); 
    buf25_2  <= one_search(25)(5); 
        
   if rising_edge(CLK) then	
		buf1<= buf1_2; 
        buf2<= buf2_2; 
        buf3<= buf3_2; 
        buf4<= buf4_2; 
        buf5<= buf5_2; 
        buf6<= buf6_2; 
        buf7<= buf7_2; 
        buf8<= buf8_2; 
        buf9<= buf9_2; 
        buf10<= buf10_2; 
        buf11<= buf11_2; 
        buf12<= buf12_2; 
        buf13<= buf13_2; 
        buf14<= buf14_2; 
        buf15<= buf15_2; 
        buf16<= buf16_2; 
        buf17<= buf17_2; 
        buf18<= buf18_2; 
        buf19<= buf19_2; 
        buf20<= buf20_2; 
        buf21<= buf21_2; 
        buf22<= buf22_2; 
        buf23<= buf23_2; 
        buf24<= buf24_2; 
        buf25<= buf25_2;		
    end if;
    end process;

--  V(i) * W(i,j) excluding Z(i)  --

--mult_out(1) <= each_weight(1)*one_search(1)(5);
--mult_out(2) <= each_weight(2)*one_search(2)(5);
--mult_out(3) <= each_weight(3)*one_search(3)(5);
--mult_out(4) <= each_weight(4)*one_search(4)(5);
--mult_out(5) <= each_weight(5)*one_search(5)(5);
--mult_out(6) <= each_weight(6)*one_search(6)(5);
--mult_out(7) <= each_weight(7)*one_search(7)(5);
--mult_out(8) <= each_weight(8)*one_search(8)(5);
--mult_out(9) <= each_weight(9)*one_search(9)(5);
--mult_out(10) <= each_weight(10)*one_search(10)(5);
--mult_out(11) <= each_weight(11)*one_search(11)(5);
--mult_out(12) <= each_weight(12)*one_search(12)(5);
--mult_out(13) <= each_weight(13)*one_search(13)(5);
--mult_out(14) <= each_weight(14)*one_search(14)(5);
--mult_out(15) <= each_weight(15)*one_search(15)(5);
--mult_out(16) <= each_weight(16)*one_search(16)(5);
--mult_out(17) <= each_weight(17)*one_search(17)(5);
--mult_out(18) <= each_weight(18)*one_search(18)(5);
--mult_out(19) <= each_weight(19)*one_search(19)(5);
--mult_out(20) <= each_weight(20)*one_search(20)(5);
--mult_out(21) <= each_weight(21)*one_search(21)(5);
--mult_out(22) <= each_weight(22)*one_search(22)(5);
--mult_out(23) <= each_weight(23)*one_search(23)(5);
--mult_out(24) <= each_weight(24)*one_search(24)(5);
--mult_out(25) <= each_weight(25)*one_search(25)(5);
--mult_out - Q 17.15 = Q1.15*Q16.0 (32  bits)
 mult_out(1) <= each_weight(1)*buf1; 
 mult_out(2) <= each_weight(2)*buf2; 
 mult_out(3) <= each_weight(3)*buf3; 
 mult_out(4) <= each_weight(4)*buf4; 
 mult_out(5) <= each_weight(5)*buf5; 
 mult_out(6) <= each_weight(6)*buf6; 
 mult_out(7) <= each_weight(7)*buf7; 
 mult_out(8) <= each_weight(8)*buf8; 
 mult_out(9) <= each_weight(9)*buf9; 
 mult_out(10) <= each_weight(10)*buf10; 
 mult_out(11) <= each_weight(11)*buf11; 
 mult_out(12) <= each_weight(12)*buf12; 
 mult_out(13) <= each_weight(13)*buf13; 
 mult_out(14) <= each_weight(14)*buf14; 
 mult_out(15) <= each_weight(15)*buf15; 
 mult_out(16) <= each_weight(16)*buf16; 
 mult_out(17) <= each_weight(17)*buf17; 
 mult_out(18) <= each_weight(18)*buf18; 
 mult_out(19) <= each_weight(19)*buf19; 
 mult_out(20) <= each_weight(20)*buf20; 
 mult_out(21) <= each_weight(21)*buf21; 
 mult_out(22) <= each_weight(22)*buf22; 
 mult_out(23) <= each_weight(23)*buf23; 
 mult_out(24) <= each_weight(24)*buf24; 
 mult_out(25) <= each_weight(25)*buf25; 

-- SUM of ( V(i) * W(i,j) ) --
--sum_mult_out -Q22.15 - sum of all mult_outs (37 bits)
mult_out_sum:
sum_mult_out(1)(32 downto 0) <= ('0' & mult_out(1)) + ('0' & mult_out(2));
sum_mult_out(2)(32 downto 0) <= ('0' & mult_out(6)) + ('0' & mult_out(7));
sum_mult_out(3)(32 downto 0) <= ('0' & mult_out(11)) + ('0' & mult_out(12));
sum_mult_out(4)(32 downto 0) <= ('0' & mult_out(16)) + ('0' & mult_out(17));
sum_mult_out(5)(32 downto 0) <= ('0' & mult_out(21)) + ('0' & mult_out(22));
sum_mult_out(6)(32 downto 0) <= ('0' & mult_out(3)) + ('0' & mult_out(4));
sum_mult_out(7)(32 downto 0) <= ('0' & mult_out(8)) + ('0' & mult_out(9));
sum_mult_out(8)(32 downto 0) <= ('0' & mult_out(13)) + ('0' & mult_out(14));
sum_mult_out(9)(32 downto 0) <= ('0' & mult_out(18)) + ('0' & mult_out(19));
sum_mult_out(10)(32 downto 0) <= ('0' & mult_out(23)) + ('0' & mult_out(24));
sum_mult_out(11)(32 downto 0) <= ('0' & mult_out(5)) + ('0' & mult_out(10));
sum_mult_out(12)(32 downto 0) <= ('0' & mult_out(15)) + ('0' & mult_out(20));


sum_mult_out(13)(33 downto 0) <= ('0' & sum_mult_out(1)(32 downto 0)) + ('0' & sum_mult_out(2)(32 downto 0));
sum_mult_out(14)(33 downto 0) <= ('0' & sum_mult_out(3)(32 downto 0)) + ('0' & sum_mult_out(4)(32 downto 0));
sum_mult_out(15)(33 downto 0) <= ('0' & sum_mult_out(5)(32 downto 0)) + ('0' & sum_mult_out(6)(32 downto 0));
sum_mult_out(16)(33 downto 0) <= ('0' & sum_mult_out(7)(32 downto 0)) + ('0' & sum_mult_out(8)(32 downto 0));
sum_mult_out(17)(33 downto 0) <= ('0' & sum_mult_out(9)(32 downto 0)) + ('0' & sum_mult_out(10)(32 downto 0));
sum_mult_out(18)(33 downto 0) <= ('0' & sum_mult_out(11)(32 downto 0)) + ('0' & sum_mult_out(12)(32 downto 0));

sum_mult_out(19)(34 downto 0) <= ('0' & sum_mult_out(13)(33 downto 0)) + ('0' & sum_mult_out(14)(33 downto 0));
sum_mult_out(20)(34 downto 0) <= ('0' & sum_mult_out(15)(33 downto 0)) + ('0' & sum_mult_out(16)(33 downto 0));
sum_mult_out(21)(34 downto 0) <= ('0' & sum_mult_out(17)(33 downto 0)) + ('0' & sum_mult_out(18)(33 downto 0));
sum_mult_out(22)(32 downto 0) <= ('0' & mult_out(25));

sum_mult_out(23)(35 downto 0) <= ('0' & sum_mult_out(19)(34 downto 0)) + ('0' & sum_mult_out(20)(34 downto 0));
sum_mult_out(24)(35 downto 0) <= ('0' & sum_mult_out(21)(34 downto 0)) + ('0' & sum_mult_out(22)(32 downto 0));

sum_mult_out(25)(36 downto 0) <= ('0' & sum_mult_out(23)(35 downto 0)) + ('0' & sum_mult_out(24)(35 downto 0));

vi_wi <= sum_mult_out(25);
--vw<=vi_wi;
-- Z(i)  --
weight_sum:
sum_weights(1)(16 downto 0) <= ('0' & each_weight(1)) + ('0' & each_weight(2));
sum_weights(2)(16 downto 0) <= ('0' & each_weight(3)) + ('0' & each_weight(4));
sum_weights(3)(16 downto 0) <= ('0' & each_weight(6)) + ('0' & each_weight(7));
sum_weights(4)(16 downto 0) <= ('0' & each_weight(8)) + ('0' & each_weight(9));
sum_weights(5)(16 downto 0) <= ('0' & each_weight(11)) + ('0' & each_weight(12));
sum_weights(6)(16 downto 0) <= ('0' & each_weight(13)) + ('0' & each_weight(14));
sum_weights(7)(16 downto 0) <= ('0' & each_weight(16)) + ('0' & each_weight(17));
sum_weights(8)(16 downto 0) <= ('0' & each_weight(18)) + ('0' & each_weight(19));
sum_weights(9)(16 downto 0) <= ('0' & each_weight(21)) + ('0' & each_weight(22));
sum_weights(10)(16 downto 0) <= ('0' & each_weight(23)) + ('0' & each_weight(24));
sum_weights(11)(16 downto 0) <= ('0' & each_weight(5)) + ('0' & each_weight(10));
sum_weights(12)(16 downto 0) <= ('0' & each_weight(15)) + ('0' & each_weight(20));

sum_weights(13)(17 downto 0) <= ('0' & sum_weights(1)(16 downto 0)) + ('0' & sum_weights(2)(16 downto 0));
sum_weights(14)(17 downto 0) <= ('0' & sum_weights(3)(16 downto 0)) + ('0' & sum_weights(4)(16 downto 0));
sum_weights(15)(17 downto 0) <= ('0' & sum_weights(5)(16 downto 0)) + ('0' & sum_weights(6)(16 downto 0));
sum_weights(16)(17 downto 0) <= ('0' & sum_weights(7)(16 downto 0)) + ('0' & sum_weights(8)(16 downto 0));
sum_weights(17)(17 downto 0) <= ('0' & sum_weights(9)(16 downto 0)) + ('0' & sum_weights(10)(16 downto 0));
sum_weights(18)(17 downto 0) <= ('0' & sum_weights(11)(16 downto 0)) + ('0' & sum_weights(12)(16 downto 0));

sum_weights(19)(18 downto 0) <= ('0' & sum_weights(13)(17 downto 0)) + ('0' & sum_weights(14)(17 downto 0));
sum_weights(20)(18 downto 0) <= ('0' & sum_weights(15)(17 downto 0)) + ('0' & sum_weights(16)(17 downto 0));
sum_weights(21)(18 downto 0) <= ('0' & sum_weights(17)(17 downto 0)) + ('0' & sum_weights(18)(17 downto 0));
sum_weights(22)(16 downto 0) <= ('0' & each_weight(25));

sum_weights(23)(19 downto 0) <= ('0' & sum_weights(19)(18 downto 0)) + ('0' & sum_weights(20)(18 downto 0));
sum_weights(24)(19 downto 0) <= ('0' & sum_weights(21)(18 downto 0)) + ('0' & sum_weights(22)(16 downto 0));

sum_weights(25)(20 downto 0) <= ('0' & sum_weights(23)(19 downto 0)) + ('0' & sum_weights(24)(19 downto 0));

normal_weight <= sum_weights(25); -- Z(i) 
--Z<= normal_weight;

--pixel out - Q23.30 = Q22.15*Q1.15 (46  bits)
out_pixel <=
vi_wi * "0000010100011110" when normal_weight >= "11001000000000000000" else 
vi_wi * "0000010100100011" when normal_weight >= "11000111001100110011" else 
vi_wi * "0000010100101001" when normal_weight >= "11000110011001100110" else 
vi_wi * "0000010100101110" when normal_weight >= "11000101100110011001" else 
vi_wi * "0000010100110100" when normal_weight >= "11000100110011001100" else 
vi_wi * "0000010100111001" when normal_weight >= "11000100000000000000" else 
vi_wi * "0000010100111110" when normal_weight >= "11000011001100110011" else 
vi_wi * "0000010101000100" when normal_weight >= "11000010011001100110" else 
vi_wi * "0000010101001010" when normal_weight >= "11000001100110011001" else 
vi_wi * "0000010101001111" when normal_weight >= "11000000110011001100" else 
vi_wi * "0000010101010101" when normal_weight >= "11000000000000000000" else 
vi_wi * "0000010101011011" when normal_weight >= "10111111001100110011" else 
vi_wi * "0000010101100000" when normal_weight >= "10111110011001100110" else 
vi_wi * "0000010101100110" when normal_weight >= "10111101100110011001" else 
vi_wi * "0000010101101100" when normal_weight >= "10111100110011001100" else 
vi_wi * "0000010101110010" when normal_weight >= "10111100000000000000" else 
vi_wi * "0000010101111000" when normal_weight >= "10111011001100110011" else 
vi_wi * "0000010101111110" when normal_weight >= "10111010011001100110" else 
vi_wi * "0000010110000100" when normal_weight >= "10111001100110011001" else 
vi_wi * "0000010110001010" when normal_weight >= "10111000110011001100" else 
vi_wi * "0000010110010000" when normal_weight >= "10111000000000000000" else 
vi_wi * "0000010110010110" when normal_weight >= "10110111001100110011" else 
vi_wi * "0000010110011101" when normal_weight >= "10110110011001100110" else 
vi_wi * "0000010110100011" when normal_weight >= "10110101100110011001" else 
vi_wi * "0000010110101001" when normal_weight >= "10110100110011001100" else 
vi_wi * "0000010110110000" when normal_weight >= "10110100000000000000" else 
vi_wi * "0000010110110110" when normal_weight >= "10110011001100110011" else 
vi_wi * "0000010110111101" when normal_weight >= "10110010011001100110" else 
vi_wi * "0000010111000100" when normal_weight >= "10110001100110011001" else 
vi_wi * "0000010111001010" when normal_weight >= "10110000110011001100" else 
vi_wi * "0000010111010001" when normal_weight >= "10110000000000000000" else 
vi_wi * "0000010111011000" when normal_weight >= "10101111001100110011" else 
vi_wi * "0000010111011111" when normal_weight >= "10101110011001100110" else 
vi_wi * "0000010111100110" when normal_weight >= "10101101100110011001" else 
vi_wi * "0000010111101101" when normal_weight >= "10101100110011001100" else 
vi_wi * "0000010111110100" when normal_weight >= "10101100000000000000" else 
vi_wi * "0000010111111011" when normal_weight >= "10101011001100110011" else 
vi_wi * "0000011000000010" when normal_weight >= "10101010011001100110" else 
vi_wi * "0000011000001001" when normal_weight >= "10101001100110011001" else 
vi_wi * "0000011000010000" when normal_weight >= "10101000110011001100" else 
vi_wi * "0000011000011000" when normal_weight >= "10101000000000000000" else 
vi_wi * "0000011000011111" when normal_weight >= "10100111001100110011" else 
vi_wi * "0000011000100111" when normal_weight >= "10100110011001100110" else 
vi_wi * "0000011000101110" when normal_weight >= "10100101100110011001" else 
vi_wi * "0000011000110110" when normal_weight >= "10100100110011001100" else 
vi_wi * "0000011000111110" when normal_weight >= "10100100000000000000" else 
vi_wi * "0000011001000110" when normal_weight >= "10100011001100110011" else 
vi_wi * "0000011001001110" when normal_weight >= "10100010011001100110" else 
vi_wi * "0000011001010110" when normal_weight >= "10100001100110011001" else 
vi_wi * "0000011001011110" when normal_weight >= "10100000110011001100" else 
vi_wi * "0000011001100110" when normal_weight >= "10100000000000000000" else 
vi_wi * "0000011001101110" when normal_weight >= "10011111001100110011" else 
vi_wi * "0000011001110110" when normal_weight >= "10011110011001100110" else 
vi_wi * "0000011001111111" when normal_weight >= "10011101100110011001" else 
vi_wi * "0000011010000111" when normal_weight >= "10011100110011001100" else 
vi_wi * "0000011010010000" when normal_weight >= "10011100000000000000" else 
vi_wi * "0000011010011001" when normal_weight >= "10011011001100110011" else 
vi_wi * "0000011010100001" when normal_weight >= "10011010011001100110" else 
vi_wi * "0000011010101010" when normal_weight >= "10011001100110011001" else 
vi_wi * "0000011010110011" when normal_weight >= "10011000110011001100" else 
vi_wi * "0000011010111100" when normal_weight >= "10011000000000000000" else 
vi_wi * "0000011011000101" when normal_weight >= "10010111001100110011" else 
vi_wi * "0000011011001110" when normal_weight >= "10010110011001100110" else 
vi_wi * "0000011011011000" when normal_weight >= "10010101100110011001" else 
vi_wi * "0000011011100001" when normal_weight >= "10010100110011001100" else 
vi_wi * "0000011011101011" when normal_weight >= "10010100000000000000" else 
vi_wi * "0000011011110100" when normal_weight >= "10010011001100110011" else 
vi_wi * "0000011011111110" when normal_weight >= "10010010011001100110" else 
vi_wi * "0000011100001000" when normal_weight >= "10010001100110011001" else 
vi_wi * "0000011100010010" when normal_weight >= "10010000110011001100" else 
vi_wi * "0000011100011100" when normal_weight >= "10010000000000000000" else 
vi_wi * "0000011100100110" when normal_weight >= "10001111001100110011" else 
vi_wi * "0000011100110000" when normal_weight >= "10001110011001100110" else 
vi_wi * "0000011100111011" when normal_weight >= "10001101100110011001" else 
vi_wi * "0000011101000101" when normal_weight >= "10001100110011001100" else 
vi_wi * "0000011101010000" when normal_weight >= "10001100000000000000" else 
vi_wi * "0000011101011011" when normal_weight >= "10001011001100110011" else 
vi_wi * "0000011101100110" when normal_weight >= "10001010011001100110" else 
vi_wi * "0000011101110001" when normal_weight >= "10001001100110011001" else 
vi_wi * "0000011101111100" when normal_weight >= "10001000110011001100" else 
vi_wi * "0000011110000111" when normal_weight >= "10001000000000000000" else 
vi_wi * "0000011110010010" when normal_weight >= "10000111001100110011" else 
vi_wi * "0000011110011110" when normal_weight >= "10000110011001100110" else 
vi_wi * "0000011110101010" when normal_weight >= "10000101100110011001" else 
vi_wi * "0000011110110101" when normal_weight >= "10000100110011001100" else 
vi_wi * "0000011111000001" when normal_weight >= "10000100000000000000" else 
vi_wi * "0000011111001110" when normal_weight >= "10000011001100110011" else 
vi_wi * "0000011111011010" when normal_weight >= "10000010011001100110" else 
vi_wi * "0000011111100110" when normal_weight >= "10000001100110011001" else 
vi_wi * "0000011111110011" when normal_weight >= "10000000110011001100" else 
vi_wi * "0000100000000000" when normal_weight >= "10000000000000000000" else 
vi_wi * "0000100000001100" when normal_weight >= "01111111001100110011" else 
vi_wi * "0000100000011001" when normal_weight >= "01111110011001100110" else 
vi_wi * "0000100000100111" when normal_weight >= "01111101100110011001" else 
vi_wi * "0000100000110100" when normal_weight >= "01111100110011001100" else 
vi_wi * "0000100001000010" when normal_weight >= "01111100000000000000" else 
vi_wi * "0000100001001111" when normal_weight >= "01111011001100110011" else 
vi_wi * "0000100001011101" when normal_weight >= "01111010011001100110" else 
vi_wi * "0000100001101011" when normal_weight >= "01111001100110011001" else 
vi_wi * "0000100001111010" when normal_weight >= "01111000110011001100" else 
vi_wi * "0000100010001000" when normal_weight >= "01111000000000000000" else 
vi_wi * "0000100010010111" when normal_weight >= "01110111001100110011" else 
vi_wi * "0000100010100110" when normal_weight >= "01110110011001100110" else 
vi_wi * "0000100010110101" when normal_weight >= "01110101100110011001" else 
vi_wi * "0000100011000100" when normal_weight >= "01110100110011001100" else 
vi_wi * "0000100011010011" when normal_weight >= "01110100000000000000" else 
vi_wi * "0000100011100011" when normal_weight >= "01110011001100110011" else 
vi_wi * "0000100011110011" when normal_weight >= "01110010011001100110" else 
vi_wi * "0000100100000011" when normal_weight >= "01110001100110011001" else 
vi_wi * "0000100100010011" when normal_weight >= "01110000110011001100" else 
vi_wi * "0000100100100100" when normal_weight >= "01110000000000000000" else 
vi_wi * "0000100100110101" when normal_weight >= "01101111001100110011" else 
vi_wi * "0000100101000110" when normal_weight >= "01101110011001100110" else 
vi_wi * "0000100101010111" when normal_weight >= "01101101100110011001" else 
vi_wi * "0000100101101001" when normal_weight >= "01101100110011001100" else 
vi_wi * "0000100101111011" when normal_weight >= "01101100000000000000" else 
vi_wi * "0000100110001101" when normal_weight >= "01101011001100110011" else 
vi_wi * "0000100110011111" when normal_weight >= "01101010011001100110" else 
vi_wi * "0000100110110010" when normal_weight >= "01101001100110011001" else 
vi_wi * "0000100111000101" when normal_weight >= "01101000110011001100" else 
vi_wi * "0000100111011000" when normal_weight >= "01101000000000000000" else 
vi_wi * "0000100111101100" when normal_weight >= "01100111001100110011" else 
vi_wi * "0000101000000000" when normal_weight >= "01100110011001100110" else 
vi_wi * "0000101000010100" when normal_weight >= "01100101100110011001" else 
vi_wi * "0000101000101000" when normal_weight >= "01100100110011001100" else 
vi_wi * "0000101000111101" when normal_weight >= "01100100000000000000" else 
vi_wi * "0000101001010010" when normal_weight >= "01100011001100110011" else 
vi_wi * "0000101001101000" when normal_weight >= "01100010011001100110" else 
vi_wi * "0000101001111101" when normal_weight >= "01100001100110011001" else 
vi_wi * "0000101010010100" when normal_weight >= "01100000110011001100" else 
vi_wi * "0000101010101010" when normal_weight >= "01100000000000000000" else 
vi_wi * "0000101011000001" when normal_weight >= "01011111001100110011" else 
vi_wi * "0000101011011000" when normal_weight >= "01011110011001100110" else 
vi_wi * "0000101011110000" when normal_weight >= "01011101100110011001" else 
vi_wi * "0000101100001000" when normal_weight >= "01011100110011001100" else 
vi_wi * "0000101100100001" when normal_weight >= "01011100000000000000" else 
vi_wi * "0000101100111010" when normal_weight >= "01011011001100110011" else 
vi_wi * "0000101101010011" when normal_weight >= "01011010011001100110" else 
vi_wi * "0000101101101101" when normal_weight >= "01011001100110011001" else 
vi_wi * "0000101110001000" when normal_weight >= "01011000110011001100" else 
vi_wi * "0000101110100010" when normal_weight >= "01011000000000000000" else 
vi_wi * "0000101110111110" when normal_weight >= "01010111001100110011" else 
vi_wi * "0000101111011010" when normal_weight >= "01010110011001100110" else 
vi_wi * "0000101111110110" when normal_weight >= "01010101100110011001" else 
vi_wi * "0000110000010011" when normal_weight >= "01010100110011001100" else 
vi_wi * "0000110000110000" when normal_weight >= "01010100000000000000" else 
vi_wi * "0000110001001110" when normal_weight >= "01010011001100110011" else 
vi_wi * "0000110001101101" when normal_weight >= "01010010011001100110" else 
vi_wi * "0000110010001100" when normal_weight >= "01010001100110011001" else 
vi_wi * "0000110010101100" when normal_weight >= "01010000110011001100" else 
vi_wi * "0000110011001100" when normal_weight >= "01010000000000000000" else 
vi_wi * "0000110011101101" when normal_weight >= "01001111001100110011" else 
vi_wi * "0000110100001111" when normal_weight >= "01001110011001100110" else 
vi_wi * "0000110100110010" when normal_weight >= "01001101100110011001" else 
vi_wi * "0000110101010101" when normal_weight >= "01001100110011001100" else 
vi_wi * "0000110101111001" when normal_weight >= "01001100000000000000" else 
vi_wi * "0000110110011101" when normal_weight >= "01001011001100110011" else 
vi_wi * "0000110111000011" when normal_weight >= "01001010011001100110" else 
vi_wi * "0000110111101001" when normal_weight >= "01001001100110011001" else 
vi_wi * "0000111000010000" when normal_weight >= "01001000110011001100" else 
vi_wi * "0000111000111000" when normal_weight >= "01001000000000000000" else 
vi_wi * "0000111001100001" when normal_weight >= "01000111001100110011" else 
vi_wi * "0000111010001011" when normal_weight >= "01000110011001100110" else 
vi_wi * "0000111010110110" when normal_weight >= "01000101100110011001" else 
vi_wi * "0000111011100010" when normal_weight >= "01000100110011001100" else 
vi_wi * "0000111100001111" when normal_weight >= "01000100000000000000" else 
vi_wi * "0000111100111100" when normal_weight >= "01000011001100110011" else 
vi_wi * "0000111101101011" when normal_weight >= "01000010011001100110" else 
vi_wi * "0000111110011100" when normal_weight >= "01000001100110011001" else 
vi_wi * "0000111111001101" when normal_weight >= "01000000110011001100" else 
vi_wi * "0001000000000000" when normal_weight >= "01000000000000000000" else 
vi_wi * "0001000000110011" when normal_weight >= "00111111001100110011" else 
vi_wi * "0001000001101001" when normal_weight >= "00111110011001100110" else 
vi_wi * "0001000010011111" when normal_weight >= "00111101100110011001" else 
vi_wi * "0001000011010111" when normal_weight >= "00111100110011001100" else 
vi_wi * "0001000100010001" when normal_weight >= "00111100000000000000" else 
vi_wi * "0001000101001100" when normal_weight >= "00111011001100110011" else 
vi_wi * "0001000110001000" when normal_weight >= "00111010011001100110" else 
vi_wi * "0001000111000111" when normal_weight >= "00111001100110011001" else 
vi_wi * "0001001000000111" when normal_weight >= "00111000110011001100" else 
vi_wi * "0001001001001001" when normal_weight >= "00111000000000000000" else 
vi_wi * "0001001010001100" when normal_weight >= "00110111001100110011" else 
vi_wi * "0001001011010010" when normal_weight >= "00110110011001100110" else 
vi_wi * "0001001100011010" when normal_weight >= "00110101100110011001" else 
vi_wi * "0001001101100100" when normal_weight >= "00110100110011001100" else 
vi_wi * "0001001110110001" when normal_weight >= "00110100000000000000" else 
vi_wi * "0001010000000000" when normal_weight >= "00110011001100110011" else 
vi_wi * "0001010001010001" when normal_weight >= "00110010011001100110" else 
vi_wi * "0001010010100101" when normal_weight >= "00110001100110011001" else 
vi_wi * "0001010011111011" when normal_weight >= "00110000110011001100" else 
vi_wi * "0001010101010101" when normal_weight >= "00110000000000000000" else 
vi_wi * "0001010110110001" when normal_weight >= "00101111001100110011" else 
vi_wi * "0001011000010001" when normal_weight >= "00101110011001100110" else 
vi_wi * "0001011001110100" when normal_weight >= "00101101100110011001" else 
vi_wi * "0001011011011011" when normal_weight >= "00101100110011001100" else 
vi_wi * "0001011101000101" when normal_weight >= "00101100000000000000" else 
vi_wi * "0001011110110100" when normal_weight >= "00101011001100110011" else 
vi_wi * "0001100000100110" when normal_weight >= "00101010011001100110" else 
vi_wi * "0001100010011101" when normal_weight >= "00101001100110011001" else 
vi_wi * "0001100100011001" when normal_weight >= "00101000110011001100" else 
vi_wi * "0001100110011001" when normal_weight >= "00101000000000000000" else 
vi_wi * "0001101000011111" when normal_weight >= "00100111001100110011" else 
vi_wi * "0001101010101010" when normal_weight >= "00100110011001100110" else 
vi_wi * "0001101100111011" when normal_weight >= "00100101100110011001" else 
vi_wi * "0001101111010011" when normal_weight >= "00100100110011001100" else 
vi_wi * "0001110001110001" when normal_weight >= "00100100000000000000" else 
vi_wi * "0001110100010111" when normal_weight >= "00100011001100110011" else 
vi_wi * "0001110111000100" when normal_weight >= "00100010011001100110" else 
vi_wi * "0001111001111001" when normal_weight >= "00100001100110011001" else 
vi_wi * "0001111100111000" when normal_weight >= "00100000110011001100" else 
vi_wi * "0010000000000000" when normal_weight >= "00100000000000000000" else 
vi_wi * "0010000011010010" when normal_weight >= "00011111001100110011" else 
vi_wi * "0010000110101111" when normal_weight >= "00011110011001100110" else 
vi_wi * "0010001010011000" when normal_weight >= "00011101100110011001" else 
vi_wi * "0010001110001110" when normal_weight >= "00011100110011001100" else 
vi_wi * "0010010010010010" when normal_weight >= "00011100000000000000" else 
vi_wi * "0010010110100101" when normal_weight >= "00011011001100110011" else 
vi_wi * "0010011011001001" when normal_weight >= "00011010011001100110" else 
vi_wi * "0010100000000000" when normal_weight >= "00011001100110011001" else 
vi_wi * "0010100101001010" when normal_weight >= "00011000110011001100" else 
vi_wi * "0010101010101010" when normal_weight >= "00011000000000000000" else 
vi_wi * "0010110000100011" when normal_weight >= "00010111001100110011" else 
vi_wi * "0010110110110110" when normal_weight >= "00010110011001100110" else 
vi_wi * "0010111101101000" when normal_weight >= "00010101100110011001" else 
vi_wi * "0011000100111011" when normal_weight >= "00010100110011001100" else 
vi_wi * "0011001100110011" when normal_weight >= "00010100000000000000" else 
vi_wi * "0011010101010101" when normal_weight >= "00010011001100110011" else 
vi_wi * "0011011110100110" when normal_weight >= "00010010011001100110" else 
vi_wi * "0011101000101110" when normal_weight >= "00010001100110011001" else 
vi_wi * "0011110011110011" when normal_weight >= "00010000110011001100" else 
vi_wi * "0100000000000000" when normal_weight >= "00010000000000000000" else 
vi_wi * "0100001101011110" when normal_weight >= "00001111001100110011" else 
vi_wi * "0100011100011100" when normal_weight >= "00001110011001100110" else 
vi_wi * "0100101101001011" when normal_weight >= "00001101100110011001" else 
vi_wi * "0101000000000000" when normal_weight >= "00001100110011001100" else 
vi_wi * "0101010101010101" when normal_weight >= "00001100000000000000" else 
vi_wi * "0101101101101101" when normal_weight >= "00001011001100110011" else 
vi_wi * "0110001001110110" when normal_weight >= "00001010011001100110" else 
vi_wi * "0110101010101010" when normal_weight >= "00001001100110011001" else 
vi_wi * "0111010001011101" when normal_weight >= "00001000110011001100" else 
vi_wi * "1000000000000000" when normal_weight >= "00001000000000000000";


process(clk)
    begin
    if rising_edge(clk) then
        if (en_calc = '1') then
--            en_out <= '1';
            if (out_pixel(52 downto 46) >=1) then
                pixel_out<=(others=>'1');
            else
                pixel_out <= out_pixel(45 downto 30); -- Q23.23 precision is ignored and bits 16 bits are taken
            end if;
            if (out_pixel(45 downto 30)>=0) then
                en_out<='1';
            else
                en_out<='0';
            end if;
        else
            pixel_out<=(others=>'0');
            en_out <= '0';
        end if;
     end if;

end process;

end Behavioral;
