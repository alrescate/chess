library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library soc_system;
use soc_system.chess_rtl_pkg.all;

entity black_ctrl is
port (
clk : in std_logic;
board : in boardRecord;
blackControlled : out std_logic_vector(63 downto 0)
);
end entity;

architecture rtl of black_ctrl is
signal isBlackControlled : std_logic_vector(63 downto 0);
begin

isBlackControlled(0) <= ((board.squares(17).black AND board.squares(17).knight) OR (board.squares(10).black AND board.squares(10).knight)) OR
('0') OR
(testAdj(board.bKingPos, 0)) OR
(board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(1).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(1).empty AND board.squares(2).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(8).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(8).empty AND board.squares(16).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(9).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(9).empty AND board.squares(18).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen));

isBlackControlled(1) <= ((board.squares(18).black AND board.squares(18).knight) OR (board.squares(16).black AND board.squares(16).knight) OR (board.squares(11).black AND board.squares(11).knight)) OR
('0') OR
(testAdj(board.bKingPos, 1)) OR
(board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
(board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(2).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(2).empty AND board.squares(3).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(9).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(9).empty AND board.squares(17).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
(board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen)) OR
((board.squares(10).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(10).empty AND board.squares(19).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty) AND board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen));

isBlackControlled(2) <= ((board.squares(19).black AND board.squares(19).knight) OR (board.squares(17).black AND board.squares(17).knight) OR (board.squares(12).black AND board.squares(12).knight) OR (board.squares(8).black AND board.squares(8).knight)) OR
('0') OR
(testAdj(board.bKingPos, 2)) OR
((board.squares(1).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
(board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
(board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(3).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(3).empty AND board.squares(4).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(10).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(10).empty AND board.squares(18).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
(board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(11).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(9).empty) AND board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen)) OR
((board.squares(11).empty AND board.squares(20).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(11).empty AND board.squares(20).empty AND board.squares(29).empty) AND board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(11).empty AND board.squares(20).empty AND board.squares(29).empty AND board.squares(38).empty) AND board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen));

isBlackControlled(3) <= ((board.squares(20).black AND board.squares(20).knight) OR (board.squares(18).black AND board.squares(18).knight) OR (board.squares(13).black AND board.squares(13).knight) OR (board.squares(9).black AND board.squares(9).knight)) OR
('0') OR
(testAdj(board.bKingPos, 3)) OR
((board.squares(1).empty AND board.squares(2).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(2).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
(board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
(board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(4).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(4).empty AND board.squares(5).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(11).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(11).empty AND board.squares(19).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
(board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(12).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(10).empty) AND board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(12).empty AND board.squares(21).empty) AND board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(10).empty AND board.squares(17).empty) AND board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
((board.squares(12).empty AND board.squares(21).empty AND board.squares(30).empty) AND board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen));

isBlackControlled(4) <= ((board.squares(21).black AND board.squares(21).knight) OR (board.squares(19).black AND board.squares(19).knight) OR (board.squares(14).black AND board.squares(14).knight) OR (board.squares(10).black AND board.squares(10).knight)) OR
('0') OR
(testAdj(board.bKingPos, 4)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(2).empty AND board.squares(3).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(3).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
(board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
(board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(5).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(5).empty AND board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(12).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(12).empty AND board.squares(20).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
(board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(13).empty) AND board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(11).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(13).empty AND board.squares(22).empty) AND board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
((board.squares(11).empty AND board.squares(18).empty) AND board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(11).empty AND board.squares(18).empty AND board.squares(25).empty) AND board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen));

isBlackControlled(5) <= ((board.squares(22).black AND board.squares(22).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(15).black AND board.squares(15).knight) OR (board.squares(11).black AND board.squares(11).knight)) OR
('0') OR
(testAdj(board.bKingPos, 5)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(3).empty AND board.squares(4).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(4).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
(board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
(board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(6).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(13).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(13).empty AND board.squares(21).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
(board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(14).empty) AND board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen)) OR
((board.squares(12).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(12).empty AND board.squares(19).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(12).empty AND board.squares(19).empty AND board.squares(26).empty) AND board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(12).empty AND board.squares(19).empty AND board.squares(26).empty AND board.squares(33).empty) AND board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen));

isBlackControlled(6) <= ((board.squares(23).black AND board.squares(23).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(12).black AND board.squares(12).knight)) OR
('0') OR
(testAdj(board.bKingPos, 6)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(4).empty AND board.squares(5).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(5).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
(board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
(board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(14).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(14).empty AND board.squares(22).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen)) OR
(board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(13).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(13).empty AND board.squares(20).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty) AND board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen));

isBlackControlled(7) <= ((board.squares(22).black AND board.squares(22).knight) OR (board.squares(13).black AND board.squares(13).knight)) OR
('0') OR
(testAdj(board.bKingPos, 7)) OR
((board.squares(1).empty AND board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(2).empty AND board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(3).empty AND board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(4).empty AND board.squares(5).empty AND board.squares(6).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(5).empty AND board.squares(6).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(6).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
(board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
(board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
((board.squares(15).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(15).empty AND board.squares(23).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(14).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(14).empty AND board.squares(21).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen));

isBlackControlled(8) <= ((board.squares(25).black AND board.squares(25).knight) OR (board.squares(18).black AND board.squares(18).knight) OR (board.squares(2).black AND board.squares(2).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(0, 1)).black AND board.squares(rctoi(0, 1)).pawn)))) OR
(testAdj(board.bKingPos, 8)) OR
(board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(9).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(9).empty AND board.squares(10).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
(board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(16).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(16).empty AND board.squares(24).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
(board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen)) OR
((board.squares(17).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(17).empty AND board.squares(26).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty) AND board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen));

isBlackControlled(9) <= ((board.squares(26).black AND board.squares(26).knight) OR (board.squares(24).black AND board.squares(24).knight) OR (board.squares(19).black AND board.squares(19).knight) OR (board.squares(3).black AND board.squares(3).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 0)).black AND board.squares(rctoi(0, 0)).pawn)) OR ('1' AND (board.squares(rctoi(0, 2)).black AND board.squares(rctoi(0, 2)).pawn)))) OR
(testAdj(board.bKingPos, 9)) OR
(board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
(board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(10).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(10).empty AND board.squares(11).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
(board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(17).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(17).empty AND board.squares(25).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
(board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen)) OR
(board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen)) OR
(board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen)) OR
((board.squares(18).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(18).empty AND board.squares(27).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen));

isBlackControlled(10) <= ((board.squares(27).black AND board.squares(27).knight) OR (board.squares(25).black AND board.squares(25).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(4).black AND board.squares(4).knight) OR (board.squares(16).black AND board.squares(16).knight) OR (board.squares(0).black AND board.squares(0).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 1)).black AND board.squares(rctoi(0, 1)).pawn)) OR ('1' AND (board.squares(rctoi(0, 3)).black AND board.squares(rctoi(0, 3)).pawn)))) OR
(testAdj(board.bKingPos, 10)) OR
((board.squares(9).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
(board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
(board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(11).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(11).empty AND board.squares(12).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
(board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(18).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(18).empty AND board.squares(26).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
(board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
(board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
(board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen)) OR
((board.squares(19).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(17).empty) AND board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
((board.squares(19).empty AND board.squares(28).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty) AND board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen));

isBlackControlled(11) <= ((board.squares(28).black AND board.squares(28).knight) OR (board.squares(26).black AND board.squares(26).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(5).black AND board.squares(5).knight) OR (board.squares(17).black AND board.squares(17).knight) OR (board.squares(1).black AND board.squares(1).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 2)).black AND board.squares(rctoi(0, 2)).pawn)) OR ('1' AND (board.squares(rctoi(0, 4)).black AND board.squares(rctoi(0, 4)).pawn)))) OR
(testAdj(board.bKingPos, 11)) OR
((board.squares(9).empty AND board.squares(10).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(10).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
(board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
(board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(12).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(12).empty AND board.squares(13).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
(board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(19).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(19).empty AND board.squares(27).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
(board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
(board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
(board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen)) OR
((board.squares(20).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(18).empty) AND board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(20).empty AND board.squares(29).empty) AND board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(18).empty AND board.squares(25).empty) AND board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
((board.squares(20).empty AND board.squares(29).empty AND board.squares(38).empty) AND board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen));

isBlackControlled(12) <= ((board.squares(29).black AND board.squares(29).knight) OR (board.squares(27).black AND board.squares(27).knight) OR (board.squares(22).black AND board.squares(22).knight) OR (board.squares(6).black AND board.squares(6).knight) OR (board.squares(18).black AND board.squares(18).knight) OR (board.squares(2).black AND board.squares(2).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 3)).black AND board.squares(rctoi(0, 3)).pawn)) OR ('1' AND (board.squares(rctoi(0, 5)).black AND board.squares(rctoi(0, 5)).pawn)))) OR
(testAdj(board.bKingPos, 12)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(10).empty AND board.squares(11).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(11).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
(board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
(board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(13).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(13).empty AND board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
(board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(20).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(20).empty AND board.squares(28).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
(board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
(board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen)) OR
(board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
((board.squares(21).empty) AND board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(19).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(21).empty AND board.squares(30).empty) AND board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
((board.squares(19).empty AND board.squares(26).empty) AND board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(19).empty AND board.squares(26).empty AND board.squares(33).empty) AND board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen));

isBlackControlled(13) <= ((board.squares(30).black AND board.squares(30).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(23).black AND board.squares(23).knight) OR (board.squares(7).black AND board.squares(7).knight) OR (board.squares(19).black AND board.squares(19).knight) OR (board.squares(3).black AND board.squares(3).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 4)).black AND board.squares(rctoi(0, 4)).pawn)) OR ('1' AND (board.squares(rctoi(0, 6)).black AND board.squares(rctoi(0, 6)).pawn)))) OR
(testAdj(board.bKingPos, 13)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(11).empty AND board.squares(12).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(12).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
(board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
(board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(14).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
(board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(21).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(21).empty AND board.squares(29).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
(board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
(board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen)) OR
(board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
((board.squares(22).empty) AND board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
((board.squares(20).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(20).empty AND board.squares(27).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty) AND board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen));

isBlackControlled(14) <= ((board.squares(31).black AND board.squares(31).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(4).black AND board.squares(4).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 5)).black AND board.squares(rctoi(0, 5)).pawn)) OR ('1' AND (board.squares(rctoi(0, 7)).black AND board.squares(rctoi(0, 7)).pawn)))) OR
(testAdj(board.bKingPos, 14)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(12).empty AND board.squares(13).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(13).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
(board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
(board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
(board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(22).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(22).empty AND board.squares(30).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen)) OR
(board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
(board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen)) OR
(board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen)) OR
((board.squares(21).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(21).empty AND board.squares(28).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen));

isBlackControlled(15) <= ((board.squares(30).black AND board.squares(30).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(5).black AND board.squares(5).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(0, 6)).black AND board.squares(rctoi(0, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 15)) OR
((board.squares(9).empty AND board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(10).empty AND board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(11).empty AND board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(12).empty AND board.squares(13).empty AND board.squares(14).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(13).empty AND board.squares(14).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(14).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
(board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
(board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(23).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(23).empty AND board.squares(31).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
(board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen)) OR
((board.squares(22).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(22).empty AND board.squares(29).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty) AND board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen));

isBlackControlled(16) <= ((board.squares(33).black AND board.squares(33).knight) OR (board.squares(1).black AND board.squares(1).knight) OR (board.squares(26).black AND board.squares(26).knight) OR (board.squares(10).black AND board.squares(10).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(1, 1)).black AND board.squares(rctoi(1, 1)).pawn)))) OR
(testAdj(board.bKingPos, 16)) OR
(board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(17).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(17).empty AND board.squares(18).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(8).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
(board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
(board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(24).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(24).empty AND board.squares(32).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
(board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(25).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(9).empty) AND board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen)) OR
((board.squares(25).empty AND board.squares(34).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(25).empty AND board.squares(34).empty AND board.squares(43).empty) AND board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(25).empty AND board.squares(34).empty AND board.squares(43).empty AND board.squares(52).empty) AND board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen));

isBlackControlled(17) <= ((board.squares(34).black AND board.squares(34).knight) OR (board.squares(32).black AND board.squares(32).knight) OR (board.squares(2).black AND board.squares(2).knight) OR (board.squares(0).black AND board.squares(0).knight) OR (board.squares(27).black AND board.squares(27).knight) OR (board.squares(11).black AND board.squares(11).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 0)).black AND board.squares(rctoi(1, 0)).pawn)) OR ('1' AND (board.squares(rctoi(1, 2)).black AND board.squares(rctoi(1, 2)).pawn)))) OR
(testAdj(board.bKingPos, 17)) OR
(board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
(board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(18).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(18).empty AND board.squares(19).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(9).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
(board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
(board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(25).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(25).empty AND board.squares(33).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
(board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
(board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
(board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen)) OR
((board.squares(26).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(10).empty) AND board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
((board.squares(26).empty AND board.squares(35).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty) AND board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen));

isBlackControlled(18) <= ((board.squares(35).black AND board.squares(35).knight) OR (board.squares(33).black AND board.squares(33).knight) OR (board.squares(3).black AND board.squares(3).knight) OR (board.squares(1).black AND board.squares(1).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(12).black AND board.squares(12).knight) OR (board.squares(24).black AND board.squares(24).knight) OR (board.squares(8).black AND board.squares(8).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 1)).black AND board.squares(rctoi(1, 1)).pawn)) OR ('1' AND (board.squares(rctoi(1, 3)).black AND board.squares(rctoi(1, 3)).pawn)))) OR
(testAdj(board.bKingPos, 18)) OR
((board.squares(17).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
(board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
(board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(19).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(19).empty AND board.squares(20).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(10).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
(board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
(board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(26).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(26).empty AND board.squares(34).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
(board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
(board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
(board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(27).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(25).empty) AND board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
((board.squares(11).empty) AND board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
((board.squares(9).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen)) OR
((board.squares(27).empty AND board.squares(36).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen));

isBlackControlled(19) <= ((board.squares(36).black AND board.squares(36).knight) OR (board.squares(34).black AND board.squares(34).knight) OR (board.squares(4).black AND board.squares(4).knight) OR (board.squares(2).black AND board.squares(2).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(13).black AND board.squares(13).knight) OR (board.squares(25).black AND board.squares(25).knight) OR (board.squares(9).black AND board.squares(9).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 2)).black AND board.squares(rctoi(1, 2)).pawn)) OR ('1' AND (board.squares(rctoi(1, 4)).black AND board.squares(rctoi(1, 4)).pawn)))) OR
(testAdj(board.bKingPos, 19)) OR
((board.squares(17).empty AND board.squares(18).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(18).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
(board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
(board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(20).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(20).empty AND board.squares(21).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(11).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
(board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
(board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(27).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(27).empty AND board.squares(35).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
(board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
(board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
(board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(28).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(26).empty) AND board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(12).empty) AND board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen)) OR
((board.squares(10).empty) AND board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen)) OR
((board.squares(28).empty AND board.squares(37).empty) AND board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(26).empty AND board.squares(33).empty) AND board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen)) OR
((board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen));

isBlackControlled(20) <= ((board.squares(37).black AND board.squares(37).knight) OR (board.squares(35).black AND board.squares(35).knight) OR (board.squares(5).black AND board.squares(5).knight) OR (board.squares(3).black AND board.squares(3).knight) OR (board.squares(30).black AND board.squares(30).knight) OR (board.squares(14).black AND board.squares(14).knight) OR (board.squares(26).black AND board.squares(26).knight) OR (board.squares(10).black AND board.squares(10).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 3)).black AND board.squares(rctoi(1, 3)).pawn)) OR ('1' AND (board.squares(rctoi(1, 5)).black AND board.squares(rctoi(1, 5)).pawn)))) OR
(testAdj(board.bKingPos, 20)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(18).empty AND board.squares(19).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(19).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
(board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
(board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(21).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(21).empty AND board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(12).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
(board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
(board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(28).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(28).empty AND board.squares(36).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
(board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
(board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
(board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(29).empty) AND board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(27).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(13).empty) AND board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen)) OR
((board.squares(11).empty) AND board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen)) OR
((board.squares(29).empty AND board.squares(38).empty) AND board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen)) OR
((board.squares(27).empty AND board.squares(34).empty) AND board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen));

isBlackControlled(21) <= ((board.squares(38).black AND board.squares(38).knight) OR (board.squares(36).black AND board.squares(36).knight) OR (board.squares(6).black AND board.squares(6).knight) OR (board.squares(4).black AND board.squares(4).knight) OR (board.squares(31).black AND board.squares(31).knight) OR (board.squares(15).black AND board.squares(15).knight) OR (board.squares(27).black AND board.squares(27).knight) OR (board.squares(11).black AND board.squares(11).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 4)).black AND board.squares(rctoi(1, 4)).pawn)) OR ('1' AND (board.squares(rctoi(1, 6)).black AND board.squares(rctoi(1, 6)).pawn)))) OR
(testAdj(board.bKingPos, 21)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(19).empty AND board.squares(20).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(20).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
(board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
(board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(22).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(13).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
(board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
(board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(29).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(29).empty AND board.squares(37).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
(board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
(board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
(board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(30).empty) AND board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
((board.squares(28).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(14).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen)) OR
((board.squares(12).empty) AND board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
((board.squares(28).empty AND board.squares(35).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen));

isBlackControlled(22) <= ((board.squares(39).black AND board.squares(39).knight) OR (board.squares(37).black AND board.squares(37).knight) OR (board.squares(7).black AND board.squares(7).knight) OR (board.squares(5).black AND board.squares(5).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(12).black AND board.squares(12).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 5)).black AND board.squares(rctoi(1, 5)).pawn)) OR ('1' AND (board.squares(rctoi(1, 7)).black AND board.squares(rctoi(1, 7)).pawn)))) OR
(testAdj(board.bKingPos, 22)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(20).empty AND board.squares(21).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(21).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
(board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
(board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(14).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
(board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
(board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(30).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(30).empty AND board.squares(38).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
(board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
(board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen)) OR
(board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(29).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(13).empty) AND board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
((board.squares(29).empty AND board.squares(36).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty) AND board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen));

isBlackControlled(23) <= ((board.squares(38).black AND board.squares(38).knight) OR (board.squares(6).black AND board.squares(6).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(13).black AND board.squares(13).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(1, 6)).black AND board.squares(rctoi(1, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 23)) OR
((board.squares(17).empty AND board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(18).empty AND board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(19).empty AND board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(20).empty AND board.squares(21).empty AND board.squares(22).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(21).empty AND board.squares(22).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(22).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
(board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(15).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
(board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(31).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(31).empty AND board.squares(39).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
(board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(30).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(14).empty) AND board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen)) OR
((board.squares(30).empty AND board.squares(37).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(30).empty AND board.squares(37).empty AND board.squares(44).empty) AND board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(30).empty AND board.squares(37).empty AND board.squares(44).empty AND board.squares(51).empty) AND board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen));

isBlackControlled(24) <= ((board.squares(41).black AND board.squares(41).knight) OR (board.squares(9).black AND board.squares(9).knight) OR (board.squares(34).black AND board.squares(34).knight) OR (board.squares(18).black AND board.squares(18).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(2, 1)).black AND board.squares(rctoi(2, 1)).pawn)))) OR
(testAdj(board.bKingPos, 24)) OR
(board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(25).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(25).empty AND board.squares(26).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(8).empty AND board.squares(16).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(16).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
(board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
(board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(32).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(32).empty AND board.squares(40).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
(board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(33).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(17).empty) AND board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(33).empty AND board.squares(42).empty) AND board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(10).empty AND board.squares(17).empty) AND board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
((board.squares(33).empty AND board.squares(42).empty AND board.squares(51).empty) AND board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen));

isBlackControlled(25) <= ((board.squares(42).black AND board.squares(42).knight) OR (board.squares(40).black AND board.squares(40).knight) OR (board.squares(10).black AND board.squares(10).knight) OR (board.squares(8).black AND board.squares(8).knight) OR (board.squares(35).black AND board.squares(35).knight) OR (board.squares(19).black AND board.squares(19).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 0)).black AND board.squares(rctoi(2, 0)).pawn)) OR ('1' AND (board.squares(rctoi(2, 2)).black AND board.squares(rctoi(2, 2)).pawn)))) OR
(testAdj(board.bKingPos, 25)) OR
(board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
(board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(26).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(26).empty AND board.squares(27).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(9).empty AND board.squares(17).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(17).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
(board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
(board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(33).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(33).empty AND board.squares(41).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
(board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
(board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
(board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen)) OR
((board.squares(34).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(18).empty) AND board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(34).empty AND board.squares(43).empty) AND board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(11).empty AND board.squares(18).empty) AND board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
((board.squares(34).empty AND board.squares(43).empty AND board.squares(52).empty) AND board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen));

isBlackControlled(26) <= ((board.squares(43).black AND board.squares(43).knight) OR (board.squares(41).black AND board.squares(41).knight) OR (board.squares(11).black AND board.squares(11).knight) OR (board.squares(9).black AND board.squares(9).knight) OR (board.squares(36).black AND board.squares(36).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(32).black AND board.squares(32).knight) OR (board.squares(16).black AND board.squares(16).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 1)).black AND board.squares(rctoi(2, 1)).pawn)) OR ('1' AND (board.squares(rctoi(2, 3)).black AND board.squares(rctoi(2, 3)).pawn)))) OR
(testAdj(board.bKingPos, 26)) OR
((board.squares(25).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
(board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
(board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(27).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(27).empty AND board.squares(28).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(10).empty AND board.squares(18).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(18).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
(board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
(board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(34).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(34).empty AND board.squares(42).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
(board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
(board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
(board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(35).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(33).empty) AND board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen)) OR
((board.squares(19).empty) AND board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(17).empty) AND board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen)) OR
((board.squares(35).empty AND board.squares(44).empty) AND board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(12).empty AND board.squares(19).empty) AND board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen)) OR
((board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen));

isBlackControlled(27) <= ((board.squares(44).black AND board.squares(44).knight) OR (board.squares(42).black AND board.squares(42).knight) OR (board.squares(12).black AND board.squares(12).knight) OR (board.squares(10).black AND board.squares(10).knight) OR (board.squares(37).black AND board.squares(37).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(33).black AND board.squares(33).knight) OR (board.squares(17).black AND board.squares(17).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 2)).black AND board.squares(rctoi(2, 2)).pawn)) OR ('1' AND (board.squares(rctoi(2, 4)).black AND board.squares(rctoi(2, 4)).pawn)))) OR
(testAdj(board.bKingPos, 27)) OR
((board.squares(25).empty AND board.squares(26).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(26).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
(board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
(board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(28).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(28).empty AND board.squares(29).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(11).empty AND board.squares(19).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(19).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
(board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
(board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(35).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(35).empty AND board.squares(43).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
(board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
(board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
(board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(36).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(34).empty) AND board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(20).empty) AND board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(18).empty) AND board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(36).empty AND board.squares(45).empty) AND board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(34).empty AND board.squares(41).empty) AND board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen)) OR
((board.squares(13).empty AND board.squares(20).empty) AND board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen)) OR
((board.squares(9).empty AND board.squares(18).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen)) OR
((board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen));

isBlackControlled(28) <= ((board.squares(45).black AND board.squares(45).knight) OR (board.squares(43).black AND board.squares(43).knight) OR (board.squares(13).black AND board.squares(13).knight) OR (board.squares(11).black AND board.squares(11).knight) OR (board.squares(38).black AND board.squares(38).knight) OR (board.squares(22).black AND board.squares(22).knight) OR (board.squares(34).black AND board.squares(34).knight) OR (board.squares(18).black AND board.squares(18).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 3)).black AND board.squares(rctoi(2, 3)).pawn)) OR ('1' AND (board.squares(rctoi(2, 5)).black AND board.squares(rctoi(2, 5)).pawn)))) OR
(testAdj(board.bKingPos, 28)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(26).empty AND board.squares(27).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(27).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
(board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
(board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(29).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(29).empty AND board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(12).empty AND board.squares(20).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(20).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
(board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
(board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(36).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(36).empty AND board.squares(44).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
(board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
(board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
(board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(37).empty) AND board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(35).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(21).empty) AND board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(19).empty) AND board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(37).empty AND board.squares(46).empty) AND board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen)) OR
((board.squares(35).empty AND board.squares(42).empty) AND board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(14).empty AND board.squares(21).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen)) OR
((board.squares(10).empty AND board.squares(19).empty) AND board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen)) OR
((board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen));

isBlackControlled(29) <= ((board.squares(46).black AND board.squares(46).knight) OR (board.squares(44).black AND board.squares(44).knight) OR (board.squares(14).black AND board.squares(14).knight) OR (board.squares(12).black AND board.squares(12).knight) OR (board.squares(39).black AND board.squares(39).knight) OR (board.squares(23).black AND board.squares(23).knight) OR (board.squares(35).black AND board.squares(35).knight) OR (board.squares(19).black AND board.squares(19).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 4)).black AND board.squares(rctoi(2, 4)).pawn)) OR ('1' AND (board.squares(rctoi(2, 6)).black AND board.squares(rctoi(2, 6)).pawn)))) OR
(testAdj(board.bKingPos, 29)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(27).empty AND board.squares(28).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(28).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
(board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
(board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(30).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(13).empty AND board.squares(21).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(21).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
(board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
(board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(37).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(37).empty AND board.squares(45).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
(board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
(board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
(board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(38).empty) AND board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen)) OR
((board.squares(36).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(22).empty) AND board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen)) OR
((board.squares(20).empty) AND board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(36).empty AND board.squares(43).empty) AND board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(11).empty AND board.squares(20).empty) AND board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen)) OR
((board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen));

isBlackControlled(30) <= ((board.squares(47).black AND board.squares(47).knight) OR (board.squares(45).black AND board.squares(45).knight) OR (board.squares(15).black AND board.squares(15).knight) OR (board.squares(13).black AND board.squares(13).knight) OR (board.squares(36).black AND board.squares(36).knight) OR (board.squares(20).black AND board.squares(20).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 5)).black AND board.squares(rctoi(2, 5)).pawn)) OR ('1' AND (board.squares(rctoi(2, 7)).black AND board.squares(rctoi(2, 7)).pawn)))) OR
(testAdj(board.bKingPos, 30)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(28).empty AND board.squares(29).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(29).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
(board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
(board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(14).empty AND board.squares(22).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(22).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
(board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
(board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(38).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(38).empty AND board.squares(46).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
(board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
(board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen)) OR
(board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(37).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(21).empty) AND board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(37).empty AND board.squares(44).empty) AND board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(12).empty AND board.squares(21).empty) AND board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen)) OR
((board.squares(37).empty AND board.squares(44).empty AND board.squares(51).empty) AND board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen));

isBlackControlled(31) <= ((board.squares(46).black AND board.squares(46).knight) OR (board.squares(14).black AND board.squares(14).knight) OR (board.squares(37).black AND board.squares(37).knight) OR (board.squares(21).black AND board.squares(21).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(2, 6)).black AND board.squares(rctoi(2, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 31)) OR
((board.squares(25).empty AND board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(26).empty AND board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(27).empty AND board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(28).empty AND board.squares(29).empty AND board.squares(30).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(29).empty AND board.squares(30).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(30).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
(board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(15).empty AND board.squares(23).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
((board.squares(23).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
(board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
(board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(39).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(39).empty AND board.squares(47).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
(board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(38).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(22).empty) AND board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(38).empty AND board.squares(45).empty) AND board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(13).empty AND board.squares(22).empty) AND board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen)) OR
((board.squares(38).empty AND board.squares(45).empty AND board.squares(52).empty) AND board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen));

isBlackControlled(32) <= ((board.squares(49).black AND board.squares(49).knight) OR (board.squares(17).black AND board.squares(17).knight) OR (board.squares(42).black AND board.squares(42).knight) OR (board.squares(26).black AND board.squares(26).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(3, 1)).black AND board.squares(rctoi(3, 1)).pawn)))) OR
(testAdj(board.bKingPos, 32)) OR
(board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(33).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(33).empty AND board.squares(34).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(16).empty AND board.squares(24).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(24).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
(board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
(board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(40).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(40).empty AND board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
(board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(41).empty) AND board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(25).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(41).empty AND board.squares(50).empty) AND board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
((board.squares(18).empty AND board.squares(25).empty) AND board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(11).empty AND board.squares(18).empty AND board.squares(25).empty) AND board.squares(4).black AND (board.squares(4).bishop OR board.squares(4).queen));

isBlackControlled(33) <= ((board.squares(50).black AND board.squares(50).knight) OR (board.squares(48).black AND board.squares(48).knight) OR (board.squares(18).black AND board.squares(18).knight) OR (board.squares(16).black AND board.squares(16).knight) OR (board.squares(43).black AND board.squares(43).knight) OR (board.squares(27).black AND board.squares(27).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 0)).black AND board.squares(rctoi(3, 0)).pawn)) OR ('1' AND (board.squares(rctoi(3, 2)).black AND board.squares(rctoi(3, 2)).pawn)))) OR
(testAdj(board.bKingPos, 33)) OR
(board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
(board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(34).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(34).empty AND board.squares(35).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(17).empty AND board.squares(25).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(25).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
(board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
(board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(41).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(41).empty AND board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
(board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen)) OR
(board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
(board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
((board.squares(42).empty) AND board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(26).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(42).empty AND board.squares(51).empty) AND board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
((board.squares(19).empty AND board.squares(26).empty) AND board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(12).empty AND board.squares(19).empty AND board.squares(26).empty) AND board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen));

isBlackControlled(34) <= ((board.squares(51).black AND board.squares(51).knight) OR (board.squares(49).black AND board.squares(49).knight) OR (board.squares(19).black AND board.squares(19).knight) OR (board.squares(17).black AND board.squares(17).knight) OR (board.squares(44).black AND board.squares(44).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(40).black AND board.squares(40).knight) OR (board.squares(24).black AND board.squares(24).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 1)).black AND board.squares(rctoi(3, 1)).pawn)) OR ('1' AND (board.squares(rctoi(3, 3)).black AND board.squares(rctoi(3, 3)).pawn)))) OR
(testAdj(board.bKingPos, 34)) OR
((board.squares(33).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
(board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
(board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(35).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(35).empty AND board.squares(36).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(18).empty AND board.squares(26).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(26).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
(board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
(board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(42).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(42).empty AND board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
(board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
(board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
(board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(43).empty) AND board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(41).empty) AND board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen)) OR
((board.squares(27).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(25).empty) AND board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen)) OR
((board.squares(43).empty AND board.squares(52).empty) AND board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen)) OR
((board.squares(20).empty AND board.squares(27).empty) AND board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty) AND board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen));

isBlackControlled(35) <= ((board.squares(52).black AND board.squares(52).knight) OR (board.squares(50).black AND board.squares(50).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(18).black AND board.squares(18).knight) OR (board.squares(45).black AND board.squares(45).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(41).black AND board.squares(41).knight) OR (board.squares(25).black AND board.squares(25).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 2)).black AND board.squares(rctoi(3, 2)).pawn)) OR ('1' AND (board.squares(rctoi(3, 4)).black AND board.squares(rctoi(3, 4)).pawn)))) OR
(testAdj(board.bKingPos, 35)) OR
((board.squares(33).empty AND board.squares(34).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(34).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
(board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
(board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(36).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(36).empty AND board.squares(37).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(19).empty AND board.squares(27).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(27).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
(board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
(board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(43).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(43).empty AND board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
(board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
(board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
(board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(44).empty) AND board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(42).empty) AND board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(28).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(26).empty) AND board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(44).empty AND board.squares(53).empty) AND board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen)) OR
((board.squares(42).empty AND board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen)) OR
((board.squares(21).empty AND board.squares(28).empty) AND board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(17).empty AND board.squares(26).empty) AND board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen));

isBlackControlled(36) <= ((board.squares(53).black AND board.squares(53).knight) OR (board.squares(51).black AND board.squares(51).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(19).black AND board.squares(19).knight) OR (board.squares(46).black AND board.squares(46).knight) OR (board.squares(30).black AND board.squares(30).knight) OR (board.squares(42).black AND board.squares(42).knight) OR (board.squares(26).black AND board.squares(26).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 3)).black AND board.squares(rctoi(3, 3)).pawn)) OR ('1' AND (board.squares(rctoi(3, 5)).black AND board.squares(rctoi(3, 5)).pawn)))) OR
(testAdj(board.bKingPos, 36)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(34).empty AND board.squares(35).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(35).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
(board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
(board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(37).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(37).empty AND board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(20).empty AND board.squares(28).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(28).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
(board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
(board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(44).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(44).empty AND board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
(board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
(board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
(board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(45).empty) AND board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(43).empty) AND board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(29).empty) AND board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(27).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(45).empty AND board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen)) OR
((board.squares(43).empty AND board.squares(50).empty) AND board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen)) OR
((board.squares(22).empty AND board.squares(29).empty) AND board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen)) OR
((board.squares(18).empty AND board.squares(27).empty) AND board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen));

isBlackControlled(37) <= ((board.squares(54).black AND board.squares(54).knight) OR (board.squares(52).black AND board.squares(52).knight) OR (board.squares(22).black AND board.squares(22).knight) OR (board.squares(20).black AND board.squares(20).knight) OR (board.squares(47).black AND board.squares(47).knight) OR (board.squares(31).black AND board.squares(31).knight) OR (board.squares(43).black AND board.squares(43).knight) OR (board.squares(27).black AND board.squares(27).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 4)).black AND board.squares(rctoi(3, 4)).pawn)) OR ('1' AND (board.squares(rctoi(3, 6)).black AND board.squares(rctoi(3, 6)).pawn)))) OR
(testAdj(board.bKingPos, 37)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(35).empty AND board.squares(36).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(36).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
(board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
(board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(38).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(21).empty AND board.squares(29).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(29).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
(board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
(board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(45).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(45).empty AND board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
(board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
(board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
(board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(46).empty) AND board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen)) OR
((board.squares(44).empty) AND board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(30).empty) AND board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen)) OR
((board.squares(28).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(44).empty AND board.squares(51).empty) AND board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen)) OR
((board.squares(19).empty AND board.squares(28).empty) AND board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty) AND board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen));

isBlackControlled(38) <= ((board.squares(55).black AND board.squares(55).knight) OR (board.squares(53).black AND board.squares(53).knight) OR (board.squares(23).black AND board.squares(23).knight) OR (board.squares(21).black AND board.squares(21).knight) OR (board.squares(44).black AND board.squares(44).knight) OR (board.squares(28).black AND board.squares(28).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 5)).black AND board.squares(rctoi(3, 5)).pawn)) OR ('1' AND (board.squares(rctoi(3, 7)).black AND board.squares(rctoi(3, 7)).pawn)))) OR
(testAdj(board.bKingPos, 38)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(36).empty AND board.squares(37).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(37).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
(board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
(board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(22).empty AND board.squares(30).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(30).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
(board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
(board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(46).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(46).empty AND board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen)) OR
(board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
(board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
(board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(45).empty) AND board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(29).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(45).empty AND board.squares(52).empty) AND board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
((board.squares(20).empty AND board.squares(29).empty) AND board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(11).empty AND board.squares(20).empty AND board.squares(29).empty) AND board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen));

isBlackControlled(39) <= ((board.squares(54).black AND board.squares(54).knight) OR (board.squares(22).black AND board.squares(22).knight) OR (board.squares(45).black AND board.squares(45).knight) OR (board.squares(29).black AND board.squares(29).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(3, 6)).black AND board.squares(rctoi(3, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 39)) OR
((board.squares(33).empty AND board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(34).empty AND board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(35).empty AND board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(36).empty AND board.squares(37).empty AND board.squares(38).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(37).empty AND board.squares(38).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(38).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
(board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
((board.squares(23).empty AND board.squares(31).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
((board.squares(31).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
(board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
(board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(47).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(47).empty AND board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
(board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(46).empty) AND board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(30).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(46).empty AND board.squares(53).empty) AND board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
((board.squares(21).empty AND board.squares(30).empty) AND board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(12).empty AND board.squares(21).empty AND board.squares(30).empty) AND board.squares(3).black AND (board.squares(3).bishop OR board.squares(3).queen));

isBlackControlled(40) <= ((board.squares(57).black AND board.squares(57).knight) OR (board.squares(25).black AND board.squares(25).knight) OR (board.squares(50).black AND board.squares(50).knight) OR (board.squares(34).black AND board.squares(34).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(4, 1)).black AND board.squares(rctoi(4, 1)).pawn)))) OR
(testAdj(board.bKingPos, 40)) OR
(board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(41).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(41).empty AND board.squares(42).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(24).empty AND board.squares(32).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(32).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
(board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
(board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(48).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
(board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(49).empty) AND board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen)) OR
((board.squares(33).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(26).empty AND board.squares(33).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(19).empty AND board.squares(26).empty AND board.squares(33).empty) AND board.squares(12).black AND (board.squares(12).bishop OR board.squares(12).queen)) OR
((board.squares(12).empty AND board.squares(19).empty AND board.squares(26).empty AND board.squares(33).empty) AND board.squares(5).black AND (board.squares(5).bishop OR board.squares(5).queen));

isBlackControlled(41) <= ((board.squares(58).black AND board.squares(58).knight) OR (board.squares(56).black AND board.squares(56).knight) OR (board.squares(26).black AND board.squares(26).knight) OR (board.squares(24).black AND board.squares(24).knight) OR (board.squares(51).black AND board.squares(51).knight) OR (board.squares(35).black AND board.squares(35).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 0)).black AND board.squares(rctoi(4, 0)).pawn)) OR ('1' AND (board.squares(rctoi(4, 2)).black AND board.squares(rctoi(4, 2)).pawn)))) OR
(testAdj(board.bKingPos, 41)) OR
(board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
(board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(42).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(42).empty AND board.squares(43).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(25).empty AND board.squares(33).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(33).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
(board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
(board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(49).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
(board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen)) OR
(board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
(board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
((board.squares(50).empty) AND board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
((board.squares(34).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(27).empty AND board.squares(34).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty) AND board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty) AND board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen));

isBlackControlled(42) <= ((board.squares(59).black AND board.squares(59).knight) OR (board.squares(57).black AND board.squares(57).knight) OR (board.squares(27).black AND board.squares(27).knight) OR (board.squares(25).black AND board.squares(25).knight) OR (board.squares(52).black AND board.squares(52).knight) OR (board.squares(36).black AND board.squares(36).knight) OR (board.squares(48).black AND board.squares(48).knight) OR (board.squares(32).black AND board.squares(32).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 1)).black AND board.squares(rctoi(4, 1)).pawn)) OR ('1' AND (board.squares(rctoi(4, 3)).black AND board.squares(rctoi(4, 3)).pawn)))) OR
(testAdj(board.bKingPos, 42)) OR
((board.squares(41).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
(board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
(board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(43).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(43).empty AND board.squares(44).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(26).empty AND board.squares(34).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(34).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
(board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
(board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(50).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
(board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
(board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
(board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(51).empty) AND board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
((board.squares(49).empty) AND board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen)) OR
((board.squares(35).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(33).empty) AND board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
((board.squares(28).empty AND board.squares(35).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty) AND board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen));

isBlackControlled(43) <= ((board.squares(60).black AND board.squares(60).knight) OR (board.squares(58).black AND board.squares(58).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(26).black AND board.squares(26).knight) OR (board.squares(53).black AND board.squares(53).knight) OR (board.squares(37).black AND board.squares(37).knight) OR (board.squares(49).black AND board.squares(49).knight) OR (board.squares(33).black AND board.squares(33).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 2)).black AND board.squares(rctoi(4, 2)).pawn)) OR ('1' AND (board.squares(rctoi(4, 4)).black AND board.squares(rctoi(4, 4)).pawn)))) OR
(testAdj(board.bKingPos, 43)) OR
((board.squares(41).empty AND board.squares(42).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(42).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
(board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
(board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(44).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(44).empty AND board.squares(45).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(27).empty AND board.squares(35).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(35).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
(board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
(board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(51).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
(board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
(board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
(board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(52).empty) AND board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen)) OR
((board.squares(50).empty) AND board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen)) OR
((board.squares(36).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(34).empty) AND board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(29).empty AND board.squares(36).empty) AND board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(25).empty AND board.squares(34).empty) AND board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty) AND board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen));

isBlackControlled(44) <= ((board.squares(61).black AND board.squares(61).knight) OR (board.squares(59).black AND board.squares(59).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(27).black AND board.squares(27).knight) OR (board.squares(54).black AND board.squares(54).knight) OR (board.squares(38).black AND board.squares(38).knight) OR (board.squares(50).black AND board.squares(50).knight) OR (board.squares(34).black AND board.squares(34).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 3)).black AND board.squares(rctoi(4, 3)).pawn)) OR ('1' AND (board.squares(rctoi(4, 5)).black AND board.squares(rctoi(4, 5)).pawn)))) OR
(testAdj(board.bKingPos, 44)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(42).empty AND board.squares(43).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(43).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
(board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
(board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
((board.squares(45).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(45).empty AND board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(28).empty AND board.squares(36).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(36).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
(board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
(board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(52).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
(board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
(board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
(board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(53).empty) AND board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen)) OR
((board.squares(51).empty) AND board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen)) OR
((board.squares(37).empty) AND board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(35).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(30).empty AND board.squares(37).empty) AND board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen)) OR
((board.squares(26).empty AND board.squares(35).empty) AND board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty) AND board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen));

isBlackControlled(45) <= ((board.squares(62).black AND board.squares(62).knight) OR (board.squares(60).black AND board.squares(60).knight) OR (board.squares(30).black AND board.squares(30).knight) OR (board.squares(28).black AND board.squares(28).knight) OR (board.squares(55).black AND board.squares(55).knight) OR (board.squares(39).black AND board.squares(39).knight) OR (board.squares(51).black AND board.squares(51).knight) OR (board.squares(35).black AND board.squares(35).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 4)).black AND board.squares(rctoi(4, 4)).pawn)) OR ('1' AND (board.squares(rctoi(4, 6)).black AND board.squares(rctoi(4, 6)).pawn)))) OR
(testAdj(board.bKingPos, 45)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(43).empty AND board.squares(44).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(44).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
(board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
(board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(46).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(29).empty AND board.squares(37).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(37).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
(board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
(board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(53).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
(board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
(board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
(board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(54).empty) AND board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen)) OR
((board.squares(52).empty) AND board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
((board.squares(38).empty) AND board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
((board.squares(36).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(27).empty AND board.squares(36).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty) AND board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen));

isBlackControlled(46) <= ((board.squares(63).black AND board.squares(63).knight) OR (board.squares(61).black AND board.squares(61).knight) OR (board.squares(31).black AND board.squares(31).knight) OR (board.squares(29).black AND board.squares(29).knight) OR (board.squares(52).black AND board.squares(52).knight) OR (board.squares(36).black AND board.squares(36).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 5)).black AND board.squares(rctoi(4, 5)).pawn)) OR ('1' AND (board.squares(rctoi(4, 7)).black AND board.squares(rctoi(4, 7)).pawn)))) OR
(testAdj(board.bKingPos, 46)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(44).empty AND board.squares(45).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(45).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
(board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
(board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(30).empty AND board.squares(38).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(38).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
(board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
(board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(54).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen)) OR
(board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
(board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
(board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(53).empty) AND board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
((board.squares(37).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(28).empty AND board.squares(37).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty) AND board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty) AND board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen));

isBlackControlled(47) <= ((board.squares(62).black AND board.squares(62).knight) OR (board.squares(30).black AND board.squares(30).knight) OR (board.squares(53).black AND board.squares(53).knight) OR (board.squares(37).black AND board.squares(37).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(4, 6)).black AND board.squares(rctoi(4, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 47)) OR
((board.squares(41).empty AND board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
((board.squares(42).empty AND board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
((board.squares(43).empty AND board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
((board.squares(44).empty AND board.squares(45).empty AND board.squares(46).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
((board.squares(45).empty AND board.squares(46).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
((board.squares(46).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
(board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
((board.squares(31).empty AND board.squares(39).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(39).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
(board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
(board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(55).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
(board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(54).empty) AND board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen)) OR
((board.squares(38).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(29).empty AND board.squares(38).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(20).empty AND board.squares(29).empty AND board.squares(38).empty) AND board.squares(11).black AND (board.squares(11).bishop OR board.squares(11).queen)) OR
((board.squares(11).empty AND board.squares(20).empty AND board.squares(29).empty AND board.squares(38).empty) AND board.squares(2).black AND (board.squares(2).bishop OR board.squares(2).queen));

isBlackControlled(48) <= ((board.squares(33).black AND board.squares(33).knight) OR (board.squares(58).black AND board.squares(58).knight) OR (board.squares(42).black AND board.squares(42).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(5, 1)).black AND board.squares(rctoi(5, 1)).pawn)))) OR
(testAdj(board.bKingPos, 48)) OR
(board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(49).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(49).empty AND board.squares(50).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(32).empty AND board.squares(40).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(40).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
(board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
(board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen)) OR
(board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(41).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(34).empty AND board.squares(41).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(20).black AND (board.squares(20).bishop OR board.squares(20).queen)) OR
((board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(13).black AND (board.squares(13).bishop OR board.squares(13).queen)) OR
((board.squares(13).empty AND board.squares(20).empty AND board.squares(27).empty AND board.squares(34).empty AND board.squares(41).empty) AND board.squares(6).black AND (board.squares(6).bishop OR board.squares(6).queen));

isBlackControlled(49) <= ((board.squares(34).black AND board.squares(34).knight) OR (board.squares(32).black AND board.squares(32).knight) OR (board.squares(59).black AND board.squares(59).knight) OR (board.squares(43).black AND board.squares(43).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 0)).black AND board.squares(rctoi(5, 0)).pawn)) OR ('1' AND (board.squares(rctoi(5, 2)).black AND board.squares(rctoi(5, 2)).pawn)))) OR
(testAdj(board.bKingPos, 49)) OR
(board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
(board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(50).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(50).empty AND board.squares(51).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(33).empty AND board.squares(41).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(41).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
(board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
(board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen)) OR
(board.squares(56).black AND (board.squares(56).bishop OR board.squares(56).queen)) OR
(board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
(board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen)) OR
((board.squares(42).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(35).empty AND board.squares(42).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen));

isBlackControlled(50) <= ((board.squares(35).black AND board.squares(35).knight) OR (board.squares(33).black AND board.squares(33).knight) OR (board.squares(60).black AND board.squares(60).knight) OR (board.squares(44).black AND board.squares(44).knight) OR (board.squares(56).black AND board.squares(56).knight) OR (board.squares(40).black AND board.squares(40).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 1)).black AND board.squares(rctoi(5, 1)).pawn)) OR ('1' AND (board.squares(rctoi(5, 3)).black AND board.squares(rctoi(5, 3)).pawn)))) OR
(testAdj(board.bKingPos, 50)) OR
((board.squares(49).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
(board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
(board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(51).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(51).empty AND board.squares(52).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(34).empty AND board.squares(42).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(42).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
(board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
(board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
(board.squares(57).black AND (board.squares(57).bishop OR board.squares(57).queen)) OR
(board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
(board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(43).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(41).empty) AND board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
((board.squares(36).empty AND board.squares(43).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty) AND board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty) AND board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen));

isBlackControlled(51) <= ((board.squares(36).black AND board.squares(36).knight) OR (board.squares(34).black AND board.squares(34).knight) OR (board.squares(61).black AND board.squares(61).knight) OR (board.squares(45).black AND board.squares(45).knight) OR (board.squares(57).black AND board.squares(57).knight) OR (board.squares(41).black AND board.squares(41).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 2)).black AND board.squares(rctoi(5, 2)).pawn)) OR ('1' AND (board.squares(rctoi(5, 4)).black AND board.squares(rctoi(5, 4)).pawn)))) OR
(testAdj(board.bKingPos, 51)) OR
((board.squares(49).empty AND board.squares(50).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(50).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
(board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
(board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(52).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(52).empty AND board.squares(53).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(35).empty AND board.squares(43).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(43).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
(board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
(board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
(board.squares(58).black AND (board.squares(58).bishop OR board.squares(58).queen)) OR
(board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
(board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(44).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(42).empty) AND board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(37).empty AND board.squares(44).empty) AND board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(33).empty AND board.squares(42).empty) AND board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen)) OR
((board.squares(30).empty AND board.squares(37).empty AND board.squares(44).empty) AND board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen));

isBlackControlled(52) <= ((board.squares(37).black AND board.squares(37).knight) OR (board.squares(35).black AND board.squares(35).knight) OR (board.squares(62).black AND board.squares(62).knight) OR (board.squares(46).black AND board.squares(46).knight) OR (board.squares(58).black AND board.squares(58).knight) OR (board.squares(42).black AND board.squares(42).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 3)).black AND board.squares(rctoi(5, 3)).pawn)) OR ('1' AND (board.squares(rctoi(5, 5)).black AND board.squares(rctoi(5, 5)).pawn)))) OR
(testAdj(board.bKingPos, 52)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(50).empty AND board.squares(51).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(51).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
(board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
(board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
((board.squares(53).empty) AND board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(53).empty AND board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(36).empty AND board.squares(44).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(44).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
(board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
(board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen)) OR
(board.squares(59).black AND (board.squares(59).bishop OR board.squares(59).queen)) OR
(board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
(board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(45).empty) AND board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(43).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(38).empty AND board.squares(45).empty) AND board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen)) OR
((board.squares(34).empty AND board.squares(43).empty) AND board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(25).empty AND board.squares(34).empty AND board.squares(43).empty) AND board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen));

isBlackControlled(53) <= ((board.squares(38).black AND board.squares(38).knight) OR (board.squares(36).black AND board.squares(36).knight) OR (board.squares(63).black AND board.squares(63).knight) OR (board.squares(47).black AND board.squares(47).knight) OR (board.squares(59).black AND board.squares(59).knight) OR (board.squares(43).black AND board.squares(43).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 4)).black AND board.squares(rctoi(5, 4)).pawn)) OR ('1' AND (board.squares(rctoi(5, 6)).black AND board.squares(rctoi(5, 6)).pawn)))) OR
(testAdj(board.bKingPos, 53)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(51).empty AND board.squares(52).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(52).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
(board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
(board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(54).empty) AND board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(37).empty AND board.squares(45).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(45).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
(board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
(board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen)) OR
(board.squares(60).black AND (board.squares(60).bishop OR board.squares(60).queen)) OR
(board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
(board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(46).empty) AND board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
((board.squares(44).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(35).empty AND board.squares(44).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty) AND board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty) AND board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen));

isBlackControlled(54) <= ((board.squares(39).black AND board.squares(39).knight) OR (board.squares(37).black AND board.squares(37).knight) OR (board.squares(60).black AND board.squares(60).knight) OR (board.squares(44).black AND board.squares(44).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 5)).black AND board.squares(rctoi(5, 5)).pawn)) OR ('1' AND (board.squares(rctoi(5, 7)).black AND board.squares(rctoi(5, 7)).pawn)))) OR
(testAdj(board.bKingPos, 54)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(52).empty AND board.squares(53).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(53).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
(board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
(board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(38).empty AND board.squares(46).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(46).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
(board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
(board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
(board.squares(63).black AND (board.squares(63).bishop OR board.squares(63).queen)) OR
(board.squares(61).black AND (board.squares(61).bishop OR board.squares(61).queen)) OR
(board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen)) OR
(board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(45).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(36).empty AND board.squares(45).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen));

isBlackControlled(55) <= ((board.squares(38).black AND board.squares(38).knight) OR (board.squares(61).black AND board.squares(61).knight) OR (board.squares(45).black AND board.squares(45).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(5, 6)).black AND board.squares(rctoi(5, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 55)) OR
((board.squares(49).empty AND board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
((board.squares(50).empty AND board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
((board.squares(51).empty AND board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
((board.squares(52).empty AND board.squares(53).empty AND board.squares(54).empty) AND board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
((board.squares(53).empty AND board.squares(54).empty) AND board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
((board.squares(54).empty) AND board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
(board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
((board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(39).empty AND board.squares(47).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(47).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
(board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
(board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
(board.squares(62).black AND (board.squares(62).bishop OR board.squares(62).queen)) OR
(board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(46).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(37).empty AND board.squares(46).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(19).black AND (board.squares(19).bishop OR board.squares(19).queen)) OR
((board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(10).black AND (board.squares(10).bishop OR board.squares(10).queen)) OR
((board.squares(10).empty AND board.squares(19).empty AND board.squares(28).empty AND board.squares(37).empty AND board.squares(46).empty) AND board.squares(1).black AND (board.squares(1).bishop OR board.squares(1).queen));

isBlackControlled(56) <= ((board.squares(41).black AND board.squares(41).knight) OR (board.squares(50).black AND board.squares(50).knight)) OR
('1' AND ((('0')) OR ('1' AND (board.squares(rctoi(6, 1)).black AND board.squares(rctoi(6, 1)).pawn)))) OR
(testAdj(board.bKingPos, 56)) OR
(board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
((board.squares(57).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
((board.squares(57).empty AND board.squares(58).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(8).empty AND board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(0).black AND (board.squares(0).rook OR board.squares(0).queen)) OR
((board.squares(16).empty AND board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(8).black AND (board.squares(8).rook OR board.squares(8).queen)) OR
((board.squares(24).empty AND board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(16).black AND (board.squares(16).rook OR board.squares(16).queen)) OR
((board.squares(32).empty AND board.squares(40).empty AND board.squares(48).empty) AND board.squares(24).black AND (board.squares(24).rook OR board.squares(24).queen)) OR
((board.squares(40).empty AND board.squares(48).empty) AND board.squares(32).black AND (board.squares(32).rook OR board.squares(32).queen)) OR
((board.squares(48).empty) AND board.squares(40).black AND (board.squares(40).rook OR board.squares(40).queen)) OR
(board.squares(48).black AND (board.squares(48).rook OR board.squares(48).queen)) OR
(board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(49).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(42).empty AND board.squares(49).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(28).black AND (board.squares(28).bishop OR board.squares(28).queen)) OR
((board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(21).black AND (board.squares(21).bishop OR board.squares(21).queen)) OR
((board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(14).black AND (board.squares(14).bishop OR board.squares(14).queen)) OR
((board.squares(14).empty AND board.squares(21).empty AND board.squares(28).empty AND board.squares(35).empty AND board.squares(42).empty AND board.squares(49).empty) AND board.squares(7).black AND (board.squares(7).bishop OR board.squares(7).queen));

isBlackControlled(57) <= ((board.squares(42).black AND board.squares(42).knight) OR (board.squares(40).black AND board.squares(40).knight) OR (board.squares(51).black AND board.squares(51).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 0)).black AND board.squares(rctoi(6, 0)).pawn)) OR ('1' AND (board.squares(rctoi(6, 2)).black AND board.squares(rctoi(6, 2)).pawn)))) OR
(testAdj(board.bKingPos, 57)) OR
(board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
((board.squares(58).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
((board.squares(58).empty AND board.squares(59).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(9).empty AND board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(1).black AND (board.squares(1).rook OR board.squares(1).queen)) OR
((board.squares(17).empty AND board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(9).black AND (board.squares(9).rook OR board.squares(9).queen)) OR
((board.squares(25).empty AND board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(17).black AND (board.squares(17).rook OR board.squares(17).queen)) OR
((board.squares(33).empty AND board.squares(41).empty AND board.squares(49).empty) AND board.squares(25).black AND (board.squares(25).rook OR board.squares(25).queen)) OR
((board.squares(41).empty AND board.squares(49).empty) AND board.squares(33).black AND (board.squares(33).rook OR board.squares(33).queen)) OR
((board.squares(49).empty) AND board.squares(41).black AND (board.squares(41).rook OR board.squares(41).queen)) OR
(board.squares(49).black AND (board.squares(49).rook OR board.squares(49).queen)) OR
(board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
(board.squares(48).black AND (board.squares(48).bishop OR board.squares(48).queen)) OR
((board.squares(50).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(43).empty AND board.squares(50).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(29).black AND (board.squares(29).bishop OR board.squares(29).queen)) OR
((board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(22).black AND (board.squares(22).bishop OR board.squares(22).queen)) OR
((board.squares(22).empty AND board.squares(29).empty AND board.squares(36).empty AND board.squares(43).empty AND board.squares(50).empty) AND board.squares(15).black AND (board.squares(15).bishop OR board.squares(15).queen));

isBlackControlled(58) <= ((board.squares(43).black AND board.squares(43).knight) OR (board.squares(41).black AND board.squares(41).knight) OR (board.squares(52).black AND board.squares(52).knight) OR (board.squares(48).black AND board.squares(48).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 1)).black AND board.squares(rctoi(6, 1)).pawn)) OR ('1' AND (board.squares(rctoi(6, 3)).black AND board.squares(rctoi(6, 3)).pawn)))) OR
(testAdj(board.bKingPos, 58)) OR
((board.squares(57).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
(board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
((board.squares(59).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
((board.squares(59).empty AND board.squares(60).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
((board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(10).empty AND board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(2).black AND (board.squares(2).rook OR board.squares(2).queen)) OR
((board.squares(18).empty AND board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(10).black AND (board.squares(10).rook OR board.squares(10).queen)) OR
((board.squares(26).empty AND board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(18).black AND (board.squares(18).rook OR board.squares(18).queen)) OR
((board.squares(34).empty AND board.squares(42).empty AND board.squares(50).empty) AND board.squares(26).black AND (board.squares(26).rook OR board.squares(26).queen)) OR
((board.squares(42).empty AND board.squares(50).empty) AND board.squares(34).black AND (board.squares(34).rook OR board.squares(34).queen)) OR
((board.squares(50).empty) AND board.squares(42).black AND (board.squares(42).rook OR board.squares(42).queen)) OR
(board.squares(50).black AND (board.squares(50).rook OR board.squares(50).queen)) OR
(board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
(board.squares(49).black AND (board.squares(49).bishop OR board.squares(49).queen)) OR
((board.squares(51).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(49).empty) AND board.squares(40).black AND (board.squares(40).bishop OR board.squares(40).queen)) OR
((board.squares(44).empty AND board.squares(51).empty) AND board.squares(37).black AND (board.squares(37).bishop OR board.squares(37).queen)) OR
((board.squares(37).empty AND board.squares(44).empty AND board.squares(51).empty) AND board.squares(30).black AND (board.squares(30).bishop OR board.squares(30).queen)) OR
((board.squares(30).empty AND board.squares(37).empty AND board.squares(44).empty AND board.squares(51).empty) AND board.squares(23).black AND (board.squares(23).bishop OR board.squares(23).queen));

isBlackControlled(59) <= ((board.squares(44).black AND board.squares(44).knight) OR (board.squares(42).black AND board.squares(42).knight) OR (board.squares(53).black AND board.squares(53).knight) OR (board.squares(49).black AND board.squares(49).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 2)).black AND board.squares(rctoi(6, 2)).pawn)) OR ('1' AND (board.squares(rctoi(6, 4)).black AND board.squares(rctoi(6, 4)).pawn)))) OR
(testAdj(board.bKingPos, 59)) OR
((board.squares(57).empty AND board.squares(58).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
((board.squares(58).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
(board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
((board.squares(60).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
((board.squares(60).empty AND board.squares(61).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(11).empty AND board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(3).black AND (board.squares(3).rook OR board.squares(3).queen)) OR
((board.squares(19).empty AND board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(11).black AND (board.squares(11).rook OR board.squares(11).queen)) OR
((board.squares(27).empty AND board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(19).black AND (board.squares(19).rook OR board.squares(19).queen)) OR
((board.squares(35).empty AND board.squares(43).empty AND board.squares(51).empty) AND board.squares(27).black AND (board.squares(27).rook OR board.squares(27).queen)) OR
((board.squares(43).empty AND board.squares(51).empty) AND board.squares(35).black AND (board.squares(35).rook OR board.squares(35).queen)) OR
((board.squares(51).empty) AND board.squares(43).black AND (board.squares(43).rook OR board.squares(43).queen)) OR
(board.squares(51).black AND (board.squares(51).rook OR board.squares(51).queen)) OR
(board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
(board.squares(50).black AND (board.squares(50).bishop OR board.squares(50).queen)) OR
((board.squares(52).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(50).empty) AND board.squares(41).black AND (board.squares(41).bishop OR board.squares(41).queen)) OR
((board.squares(45).empty AND board.squares(52).empty) AND board.squares(38).black AND (board.squares(38).bishop OR board.squares(38).queen)) OR
((board.squares(41).empty AND board.squares(50).empty) AND board.squares(32).black AND (board.squares(32).bishop OR board.squares(32).queen)) OR
((board.squares(38).empty AND board.squares(45).empty AND board.squares(52).empty) AND board.squares(31).black AND (board.squares(31).bishop OR board.squares(31).queen));

isBlackControlled(60) <= ((board.squares(45).black AND board.squares(45).knight) OR (board.squares(43).black AND board.squares(43).knight) OR (board.squares(54).black AND board.squares(54).knight) OR (board.squares(50).black AND board.squares(50).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 3)).black AND board.squares(rctoi(6, 3)).pawn)) OR ('1' AND (board.squares(rctoi(6, 5)).black AND board.squares(rctoi(6, 5)).pawn)))) OR
(testAdj(board.bKingPos, 60)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
((board.squares(58).empty AND board.squares(59).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
((board.squares(59).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
(board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
((board.squares(61).empty) AND board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(61).empty AND board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(12).empty AND board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(4).black AND (board.squares(4).rook OR board.squares(4).queen)) OR
((board.squares(20).empty AND board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(12).black AND (board.squares(12).rook OR board.squares(12).queen)) OR
((board.squares(28).empty AND board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(20).black AND (board.squares(20).rook OR board.squares(20).queen)) OR
((board.squares(36).empty AND board.squares(44).empty AND board.squares(52).empty) AND board.squares(28).black AND (board.squares(28).rook OR board.squares(28).queen)) OR
((board.squares(44).empty AND board.squares(52).empty) AND board.squares(36).black AND (board.squares(36).rook OR board.squares(36).queen)) OR
((board.squares(52).empty) AND board.squares(44).black AND (board.squares(44).rook OR board.squares(44).queen)) OR
(board.squares(52).black AND (board.squares(52).rook OR board.squares(52).queen)) OR
(board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
(board.squares(51).black AND (board.squares(51).bishop OR board.squares(51).queen)) OR
((board.squares(53).empty) AND board.squares(46).black AND (board.squares(46).bishop OR board.squares(46).queen)) OR
((board.squares(51).empty) AND board.squares(42).black AND (board.squares(42).bishop OR board.squares(42).queen)) OR
((board.squares(46).empty AND board.squares(53).empty) AND board.squares(39).black AND (board.squares(39).bishop OR board.squares(39).queen)) OR
((board.squares(42).empty AND board.squares(51).empty) AND board.squares(33).black AND (board.squares(33).bishop OR board.squares(33).queen)) OR
((board.squares(33).empty AND board.squares(42).empty AND board.squares(51).empty) AND board.squares(24).black AND (board.squares(24).bishop OR board.squares(24).queen));

isBlackControlled(61) <= ((board.squares(46).black AND board.squares(46).knight) OR (board.squares(44).black AND board.squares(44).knight) OR (board.squares(55).black AND board.squares(55).knight) OR (board.squares(51).black AND board.squares(51).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 4)).black AND board.squares(rctoi(6, 4)).pawn)) OR ('1' AND (board.squares(rctoi(6, 6)).black AND board.squares(rctoi(6, 6)).pawn)))) OR
(testAdj(board.bKingPos, 61)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
((board.squares(59).empty AND board.squares(60).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
((board.squares(60).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
(board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(62).empty) AND board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(13).empty AND board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(5).black AND (board.squares(5).rook OR board.squares(5).queen)) OR
((board.squares(21).empty AND board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(13).black AND (board.squares(13).rook OR board.squares(13).queen)) OR
((board.squares(29).empty AND board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(21).black AND (board.squares(21).rook OR board.squares(21).queen)) OR
((board.squares(37).empty AND board.squares(45).empty AND board.squares(53).empty) AND board.squares(29).black AND (board.squares(29).rook OR board.squares(29).queen)) OR
((board.squares(45).empty AND board.squares(53).empty) AND board.squares(37).black AND (board.squares(37).rook OR board.squares(37).queen)) OR
((board.squares(53).empty) AND board.squares(45).black AND (board.squares(45).rook OR board.squares(45).queen)) OR
(board.squares(53).black AND (board.squares(53).rook OR board.squares(53).queen)) OR
(board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
(board.squares(52).black AND (board.squares(52).bishop OR board.squares(52).queen)) OR
((board.squares(54).empty) AND board.squares(47).black AND (board.squares(47).bishop OR board.squares(47).queen)) OR
((board.squares(52).empty) AND board.squares(43).black AND (board.squares(43).bishop OR board.squares(43).queen)) OR
((board.squares(43).empty AND board.squares(52).empty) AND board.squares(34).black AND (board.squares(34).bishop OR board.squares(34).queen)) OR
((board.squares(34).empty AND board.squares(43).empty AND board.squares(52).empty) AND board.squares(25).black AND (board.squares(25).bishop OR board.squares(25).queen)) OR
((board.squares(25).empty AND board.squares(34).empty AND board.squares(43).empty AND board.squares(52).empty) AND board.squares(16).black AND (board.squares(16).bishop OR board.squares(16).queen));

isBlackControlled(62) <= ((board.squares(47).black AND board.squares(47).knight) OR (board.squares(45).black AND board.squares(45).knight) OR (board.squares(52).black AND board.squares(52).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 5)).black AND board.squares(rctoi(6, 5)).pawn)) OR ('1' AND (board.squares(rctoi(6, 7)).black AND board.squares(rctoi(6, 7)).pawn)))) OR
(testAdj(board.bKingPos, 62)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
((board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
((board.squares(60).empty AND board.squares(61).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
((board.squares(61).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
(board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(63).black AND (board.squares(63).rook OR board.squares(63).queen)) OR
((board.squares(14).empty AND board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(6).black AND (board.squares(6).rook OR board.squares(6).queen)) OR
((board.squares(22).empty AND board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(14).black AND (board.squares(14).rook OR board.squares(14).queen)) OR
((board.squares(30).empty AND board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(22).black AND (board.squares(22).rook OR board.squares(22).queen)) OR
((board.squares(38).empty AND board.squares(46).empty AND board.squares(54).empty) AND board.squares(30).black AND (board.squares(30).rook OR board.squares(30).queen)) OR
((board.squares(46).empty AND board.squares(54).empty) AND board.squares(38).black AND (board.squares(38).rook OR board.squares(38).queen)) OR
((board.squares(54).empty) AND board.squares(46).black AND (board.squares(46).rook OR board.squares(46).queen)) OR
(board.squares(54).black AND (board.squares(54).rook OR board.squares(54).queen)) OR
(board.squares(55).black AND (board.squares(55).bishop OR board.squares(55).queen)) OR
(board.squares(53).black AND (board.squares(53).bishop OR board.squares(53).queen)) OR
((board.squares(53).empty) AND board.squares(44).black AND (board.squares(44).bishop OR board.squares(44).queen)) OR
((board.squares(44).empty AND board.squares(53).empty) AND board.squares(35).black AND (board.squares(35).bishop OR board.squares(35).queen)) OR
((board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(26).black AND (board.squares(26).bishop OR board.squares(26).queen)) OR
((board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(17).black AND (board.squares(17).bishop OR board.squares(17).queen)) OR
((board.squares(17).empty AND board.squares(26).empty AND board.squares(35).empty AND board.squares(44).empty AND board.squares(53).empty) AND board.squares(8).black AND (board.squares(8).bishop OR board.squares(8).queen));

isBlackControlled(63) <= ((board.squares(46).black AND board.squares(46).knight) OR (board.squares(53).black AND board.squares(53).knight)) OR
('1' AND (('1' AND (board.squares(rctoi(6, 6)).black AND board.squares(rctoi(6, 6)).pawn)) OR ('0'))) OR
(testAdj(board.bKingPos, 63)) OR
((board.squares(57).empty AND board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(56).black AND (board.squares(56).rook OR board.squares(56).queen)) OR
((board.squares(58).empty AND board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(57).black AND (board.squares(57).rook OR board.squares(57).queen)) OR
((board.squares(59).empty AND board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(58).black AND (board.squares(58).rook OR board.squares(58).queen)) OR
((board.squares(60).empty AND board.squares(61).empty AND board.squares(62).empty) AND board.squares(59).black AND (board.squares(59).rook OR board.squares(59).queen)) OR
((board.squares(61).empty AND board.squares(62).empty) AND board.squares(60).black AND (board.squares(60).rook OR board.squares(60).queen)) OR
((board.squares(62).empty) AND board.squares(61).black AND (board.squares(61).rook OR board.squares(61).queen)) OR
(board.squares(62).black AND (board.squares(62).rook OR board.squares(62).queen)) OR
((board.squares(15).empty AND board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(7).black AND (board.squares(7).rook OR board.squares(7).queen)) OR
((board.squares(23).empty AND board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(15).black AND (board.squares(15).rook OR board.squares(15).queen)) OR
((board.squares(31).empty AND board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(23).black AND (board.squares(23).rook OR board.squares(23).queen)) OR
((board.squares(39).empty AND board.squares(47).empty AND board.squares(55).empty) AND board.squares(31).black AND (board.squares(31).rook OR board.squares(31).queen)) OR
((board.squares(47).empty AND board.squares(55).empty) AND board.squares(39).black AND (board.squares(39).rook OR board.squares(39).queen)) OR
((board.squares(55).empty) AND board.squares(47).black AND (board.squares(47).rook OR board.squares(47).queen)) OR
(board.squares(55).black AND (board.squares(55).rook OR board.squares(55).queen)) OR
(board.squares(54).black AND (board.squares(54).bishop OR board.squares(54).queen)) OR
((board.squares(54).empty) AND board.squares(45).black AND (board.squares(45).bishop OR board.squares(45).queen)) OR
((board.squares(45).empty AND board.squares(54).empty) AND board.squares(36).black AND (board.squares(36).bishop OR board.squares(36).queen)) OR
((board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(27).black AND (board.squares(27).bishop OR board.squares(27).queen)) OR
((board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(18).black AND (board.squares(18).bishop OR board.squares(18).queen)) OR
((board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(9).black AND (board.squares(9).bishop OR board.squares(9).queen)) OR
((board.squares(9).empty AND board.squares(18).empty AND board.squares(27).empty AND board.squares(36).empty AND board.squares(45).empty AND board.squares(54).empty) AND board.squares(0).black AND (board.squares(0).bishop OR board.squares(0).queen));

blackControlled <= isBlackControlled when rising_edge(clk);
end architecture;

