----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/07/2020 11:51:30 AM
-- Design Name: 
-- Module Name: AXI_wrap - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AXI_wrap is
  Port ( axi_clk: in std_logic;
       axi_rst_n: in std_logic;
       
       --Slave
       s_axi_valid : in std_logic;
       s_axi_data  : in std_logic_vector(15 downto 0);
       s_axi_ready : out std_logic;
       
       --master
       m_axi_valid : out std_logic;
       m_axi_data  : out std_logic_vector(15 downto 0);
       m_axi_ready : in std_logic;
       m_axi_tlast : out std_logic
       
       --leds

      );
end AXI_wrap;

architecture Behavioral of AXI_wrap is
component base is
  Port ( clk        : in Std_logic:= '0';
         en_in      : in std_logic:= '0';
         rst        : in std_logic:= '0';
         img_input  : in std_logic_vector(15 downto 0):=(others => '0');
         img_output : out std_logic_vector(15 downto 0):=(others => '0');
          en_out     : out std_logic:= '0';
          tlast      : out std_logic:= '0');
end component;

component skidbuffer is
    generic ( OPT_LOWPOWER:integer:=1;
              OPT_OUTREG  :integer:=0;
              OPT_PASSTHROUGH: integer:=0;
              DW : integer:=8);
    port (i_clk : in std_logic;
          i_reset : in std_logic;
          i_valid: in std_logic;
          o_ready: out std_logic;
          i_data : in std_logic_vector(DW-1 downto 0);
          o_valid: out std_logic;
          i_ready: in std_logic;
          o_data: out std_logic_vector(DW-1 downto 0)
         );
              
end component;


signal axi_rst: std_logic;
signal img_data:std_logic_vector(15 downto 0);
signal done: std_logic;


begin
axi_rst <= not(axi_rst_n);


nlm:
base port map 
        ( clk        =>axi_clk,
         en_in       =>s_axi_valid,
         rst         =>axi_rst,
         img_input   =>s_axi_data,
         img_output  =>img_data,
         en_out      =>done,
         tlast       =>m_axi_tlast);

skid_buffer:
skidbuffer generic map (OPT_LOWPOWER=>1,OPT_OUTREG=>0,OPT_PASSTHROUGH=>0, DW=>16 )
           port map 
         (i_clk => axi_clk,
          i_reset  => axi_rst,
          i_valid => done,
          o_ready => s_axi_ready ,
          i_data  =>img_data ,
          o_valid => m_axi_valid,
          i_ready =>m_axi_ready ,
          o_data => m_axi_data
         );


end Behavioral;
