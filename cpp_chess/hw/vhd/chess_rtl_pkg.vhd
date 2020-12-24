library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library chess_rtl;

package chess_rtl_pkg is

function adjrc(m : unsigned(2 downto 0);
               n : unsigned(2 downto 0)) return std_logic;

function eightway(row1    : unsigned(2 downto 0);
                  column1 : unsigned(2 downto 0);
                  row2    : unsigned(2 downto 0);
                  column2 : unsigned(2 downto 0)) return std_logic;   
                  
function testAdj(index1 : unsigned(5 downto 0);
                 index2 : integer) return std_logic;
                 
function rctoi(r : integer; 
               c : integer) return integer;
                 
type boardSquare is record
  empty   : std_logic;
  black   : std_logic;
  king    : std_logic;
  queen   : std_logic;
  bishop  : std_logic;
  knight  : std_logic;
  rook    : std_logic;
  pawn    : std_logic;
end record;

subtype reg is std_logic_vector(63 downto 0);
type reg_array is array(0 to 11) of reg;
            
type boardSquareArray is array(0 to 63) of boardSquare;

type boardRecord is record 
  squares : boardSquareArray;
  score : signed(31 downto 0);
  plyCount : unsigned(15 downto 0);
  validCastles : unsigned(3 downto 0);
  enPassantTarget : unsigned(5 downto 0);
  halfmoveClock : unsigned(5 downto 0);
  flipped : std_logic;
  wKingPos : unsigned(5 downto 0);
  bKingPos : unsigned(5 downto 0);
end record;
                 
-- function memToBoard(mem : std_logic_vector(703 downto 0)) return boardRecord;

end package;

package body chess_rtl_pkg is

function adjrc(m : unsigned(2 DOWNTO 0); 
               n : unsigned(2 DOWNTO 0)) return std_logic is
  variable ret : std_logic;
begin
  ret := '0';

  case m is
    when "000"  => 
    if n = "001" then
      ret := '1';
    end if;
    
    when "001"  => 
    if (n = "000") or (n = "010") then
      ret := '1';
    end if;
    
    when "010"  => 
    if (n = "001") or (n = "011") then
      ret := '1';
    end if;
    
    when "011"  => 
    if (n = "010") or (n = "100") then
      ret := '1';
    end if;
    
    when "100"  => 
    if (n = "011") or (n = "101") then
      ret := '1';
    end if;
    
    when "101"  =>
    if (n = "100") or (n = "110") then
      ret := '1';
    end if;
    
    when "110"  =>
    if (n = "101") or (n = "111") then
      ret := '1';
    end if;
    
    when others =>
    if (n = "110") then
      ret := '1';
    end if;
    
  end case;

  return ret;
end;

function eightway(row1    : unsigned(2 DOWNTO 0); 
                  column1 : unsigned(2 DOWNTO 0); 
			      row2    : unsigned(2 DOWNTO 0); 
				  column2 : unsigned(2 DOWNTO 0)) return std_logic is
  variable eqcol : std_logic;
  variable eqrow : std_logic;
  variable ajcol : std_logic;
  variable ajrow : std_logic;
  variable ret   : std_logic;
begin

  ret := '0';
  eqcol := '0';
  eqrow := '0';
  ajcol := '0';
  ajrow := '0';

  if row1 = row2 then
    eqrow := '1';
  end if;
  
  if column1 = column2 then
    eqcol := '1';
  end if;
  
  if adjrc(row1, row2) = '1' then
    ajrow := '1';
  end if;
  
  if adjrc(column1, column2) = '1' then
    ajcol := '1';
  end if;
  
  if (eqrow = '1') and (ajcol = '1') then
    ret := '1';
  elsif (eqcol = '1') and (ajrow = '1') then
    ret := '1';
  elsif (ajrow = '1') and (ajcol = '1') then
    ret := '1';
  end if;
  
  return ret;
end;

function testAdj(index1 : unsigned(5 downto 0);
                 index2 : integer range 0 to 63) return std_logic is -- index2 is an integer because of the generated code in black_ctrl (integer literals)
variable ret : std_logic;
variable temp : unsigned(5 downto 0);
begin
  temp := to_unsigned(index2, 6);
  ret := eightway(row1    => index1(5 downto 3), 
                  column1 => index1(2 downto 0), 
			 	  row2    => temp(5 downto 3), 
			 	  column2 => temp(2 downto 0));
  return ret;
end;

-- function memToBoard(mem : std_logic_vector(703 downto 0)) return boardRecord is
-- variable ret : boardRecord;
-- begin
  -- ret.squares := 
-- end;

function rctoi(r : integer;
               c : integer) return integer is
variable temp : integer range 0 to 63;
begin
  temp := r;
  temp := temp * 8;
  temp := temp + c;
  return temp;
end;

end package body chess_rtl_pkg;

