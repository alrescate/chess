-- chess_top.vhd
-- 11 64 bit registers for going from dram writes to an internal board

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library soc_system;
use soc_system.chess_rtl_pkg.all;

entity chess_top is
  port (
    csi_clk : in std_logic;
    rsi_reset_n : in std_logic;
    
    avs_address : in std_logic_vector(6 downto 0);
    avs_write : in std_logic;
    avs_writedata : in std_logic_vector(63 downto 0);
    
    avs_read : in std_logic;
    avs_readdata : out std_logic_vector(63 downto 0)
    -- avs_readdatavalid : out std_logic
  );
end entity;

architecture rtl of chess_top is 
  signal regs : reg_array;
  -- signal avs_read_z : std_logic;
  signal addr_int : integer range 0 to 127;
  signal top_board : boardRecord;
  signal blk : std_logic_vector(63 downto 0);
  signal counter : unsigned(15 downto 0);
begin
  -- avs_readdatavalid <= avs_read_z;
  -- avs_read_z <= avs_read and rsi_reset_n when rising_edge(csi_clk);
  addr_int <= to_integer(unsigned(avs_address));
  
p_wrdecode : process(csi_clk)
begin
  if rising_edge(csi_clk) then
    if (rsi_reset_n = '0') then
      regs <= (others => (others => '0'));
      counter <= to_unsigned(0, 16);
    else
      if avs_write = '1' then
        for k in 0 to regs'length-1 loop
          if k = addr_int then
            regs(k) <= avs_writedata;
            if k < 8 then
                counter <= counter + 1;
            end if;
          end if;
        end loop;
      end if;
    end if;
  end if;
end process;

p_regs_to_board : process(regs)
begin
  for rank in 0 to 7 loop
    for col in 0 to 7 loop
      top_board.squares(rank*8 + col).empty  <= regs(rank)(col*8+7);
      top_board.squares(rank*8 + col).black  <= regs(rank)(col*8+6);
      top_board.squares(rank*8 + col).king   <= regs(rank)(col*8+5);
      top_board.squares(rank*8 + col).queen  <= regs(rank)(col*8+4);
      top_board.squares(rank*8 + col).bishop <= regs(rank)(col*8+3);
      top_board.squares(rank*8 + col).knight <= regs(rank)(col*8+2);
      top_board.squares(rank*8 + col).rook   <= regs(rank)(col*8+1);
      top_board.squares(rank*8 + col).pawn   <= regs(rank)(col*8+0);
    end loop;
  end loop;
  
  top_board.score <= signed(regs(9)(31 downto 0));
  top_board.plyCount <= unsigned(regs(9)(47 downto 32));
  top_board.validCastles <= unsigned(regs(9)(51 downto 48));
  top_board.enPassantTarget <= unsigned(regs(9)(61 downto 56));

  top_board.halfmoveClock <= unsigned(regs(10)(5 downto 0));
  top_board.flipped <= regs(10)(8);
  top_board.wKingPos <= unsigned(regs(10)(21 downto 16));
  top_board.bKingPos <= unsigned(regs(10)(29 downto 24));
end process;

u_black_ctrl : entity work.black_ctrl
  port map (
    clk => csi_clk,
    board => top_board,
    blackControlled => blk
  );

p_out : process(csi_clk)
begin
  if rising_edge(csi_clk) then
    if avs_read = '1' then
      if addr_int = 11 then
        avs_readdata <= regs(11) xor x"123456789abcdef0";
      elsif addr_int = 12 then
        avs_readdata <= blk; 
      elsif addr_int = 13 then
        avs_readdata <= std_logic_vector(resize(top_board.bKingPos, 64));
      elsif addr_int = 14 then
        avs_readdata <= x"456723891290abdf";
      elsif addr_int = 15 then
        avs_readdata <= std_logic_vector(resize(counter, 64));
      else
        avs_readdata <= (others => '0');
      end if;
    end if;
  end if;
end process;

-- u_engine : (  bd => top_board --- top_board<=f_regs_to_board(regs) )
end architecture;