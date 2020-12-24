import random

def replace_char_into_string(string, index, character):
    # cut up to, but excluding, the index
    # add the character where the index was
    # add in everything from the index forward
    return string[:index]+character+string[(index+1):]
    
def Order_integers(a, b):
  # reorder two integers based on size
  return (a,b) if a<b else (b,a)
    
def Index_to_rowcolumn(Index):
  return (Index // 8, Index % 8)
    
def Rowcolumn_to_index(Row, Column):
  # row:0 column: 0 is square 0
  return (Row * 8) + Column
  
def Score_white_pieces(Board):
  White_score = 0
  Current_index = 0
  
  Control_total = 0
  
  for Square in Board.Squares:
    if (Square < 6) and (Square):
      White_score += Board.Helpers.Scoring_table[Square]
      
      Control = [k for k in Board.Helpers.Physical_moves[Square][Current_index] if Board.Test_legality(Current_index, k)]
      
      Control_total += len(Control)
      
    Current_index += 1
    
  White_score += int(Control_total * random.gauss(4, 0.05))
    
  return White_score

class Chess_helpers:

  def __init__(self):
    # create the 2char-index reference table
    self.Two_character_to_index_table = { "a8" : 0,  "b8" :  1, "c8" : 2,  "d8" : 3,  "e8" : 4,  "f8" : 5,  "g8" : 6,  "h8" : 7,
                                          "a7" : 8,  "b7" :  9, "c7" : 10, "d7" : 11, "e7" : 12, "f7" : 13, "g7" : 14, "h7" : 15,
                                          "a6" : 16, "b6" : 17, "c6" : 18, "d6" : 19, "e6" : 20, "f6" : 21, "g6" : 22, "h6" : 23,
                                          "a5" : 24, "b5" : 25, "c5" : 26, "d5" : 27, "e5" : 28, "f5" : 29, "g5" : 30, "h5" : 31,
                                          "a4" : 32, "b4" : 33, "c4" : 34, "d4" : 35, "e4" : 36, "f4" : 37, "g4" : 38, "h4" : 39,
                                          "a3" : 40, "b3" : 41, "c3" : 42, "d3" : 43, "e3" : 44, "f3" : 45, "g3" : 46, "h3" : 47,
                                          "a2" : 48, "b2" : 49, "c2" : 50, "d2" : 51, "e2" : 52, "f2" : 53, "g2" : 54, "h2" : 55,
                                          "a1" : 56, "b1" : 57, "c1" : 58, "d1" : 59, "e1" : 60, "f1" : 61, "g1" : 62, "h1" : 63, "-" : 100 }
                                          
    # create the 2char naming array 
    self.Two_character_naming_table = ["a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8",
                                       "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
                                       "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
                                       "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
                                       "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
                                       "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
                                       "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
                                       "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"]

    # create scoring table
    self.Scoring_table = { 2  :    500,  # R
                           3  :    300,  # B
                           4  :    300,  # N
                           5  :    800,  # Q
                           # king omitted
                           1  :    100 } # P
                           
    # create color change table
    self.Color_change = { 1  : 7,
                          2  : 8,
                          3  : 9,
                          4  : 10,
                          5  : 11,
                          6  : 12,
                          7  : 1,
                          8  : 2,
                          9  : 3,
                          10 : 4,
                          11 : 5,
                          12 : 6,
                          "-" : "-", 
                          0 : 0 }
                          
    # create int code table
    self.Int_code_table = { "P" :   1,
                            "R" :   2,
                            "N" :   3,
                            "B" :   4,
                            "Q" :   5,
                            "K" :   6,
                            "p" :   7,
                            "r" :   8,
                            "n" :   9,
                            "b" :  10,
                            "q" :  11,
                            "k" :  12, 
                             1  : "P",
                             2  : "R",
                             3  : "N",
                             4  : "B",
                             5  : "Q",
                             6  : "K",
                             7  : "p",
                             8  : "r",
                             9  : "n",
                            10  : "b",
                            11  : "q",
                            12  : "k" }
                            
    self.Pos_infinity =  1000000
    self.Neg_infinity = -1000000
    
    self.Path_table = [[]] * 4096
    self.Make_path_table()
                     
    # create a flipping table for physical positions
    self.Flip_table = []
    for Row in xrange(4):
      for Col in xrange(8):
        self.Flip_table.append(Rowcolumn_to_index(7-Row, Col)) # 7-Row is used to flip row
        
    # print self.Flip_table
                                       
    self.Generate_physical_move_table()
      
  def Mirror_position(self, Index):
    r,c = Index_to_rowcolumn(Index)
    return Rowcolumn_to_index(7-r, c)
      
  def Two_character_of_move_tuple(self, Move):
    return self.Two_character_naming_table[Move[0]] + self.Two_character_naming_table[Move[1]]
    
  def Mirror_move_tuple(self, Move):
    return (self.Mirror_position(Move[0]), self.Mirror_position(Move[1]))
      
  def Two_character_to_index(self, Two_character):
    return Two_character_to_index_table[Two_character]
    
  def Index_to_two_character(self, index):
    return self.Two_character_naming_table[index]
    
  def Make_path_table(self):
    for From_index in xrange(64):
      for To_index in xrange(64):
        if From_index<To_index:
          Lower_index = From_index
          Upper_index = To_index
        else:
          Upper_index = From_index
          Lower_index = To_index
    
        Upper_index_row = Upper_index >> 3
        Upper_index_column = Upper_index & 7
        Lower_index_row = Lower_index >> 3
        Lower_index_column = Lower_index & 7
        
        Pass_through = []
        
        # rankwise motion
        if Upper_index_row == Lower_index_row:
          Pass_through = xrange(Lower_index+1, Upper_index) 
        # columnwise motion
        elif Upper_index_column == Lower_index_column:
          Pass_through = xrange(Lower_index+8, Upper_index, 8)
        # diagonal motion
        else:
          if (Upper_index_column < Lower_index_column) and (((Upper_index - Lower_index) % 7) == 0):
            Pass_through = xrange(Lower_index+7, Upper_index, 7)
          elif (Upper_index_column > Lower_index_column) and (((Upper_index - Lower_index) % 9) == 0):
            Pass_through = xrange(Lower_index+9, Upper_index, 9)
            
        self.Path_table[From_index * 64 + To_index] = Pass_through
    
  def List_rook_moves(self, From_index):
    From_row, From_column = Index_to_rowcolumn(From_index)
    
    # move along the row and then down the column
    Row_constant_moves = [Rowcolumn_to_index(From_row, k) for k in range(8) if (k != From_column)]
    Column_constant_moves = [Rowcolumn_to_index(k, From_column) for k in range(8) if (k != From_row)]
    
    return Row_constant_moves + Column_constant_moves
    
  def List_bishop_moves(self, From_index):
    From_row, From_column = Index_to_rowcolumn(From_index)
    
    Valid_destinations = []
    
    for Offset in xrange(1, 8):
      
      # save operations in the future by defining terms here
      Row_decremented = From_row - Offset
      Column_decremented = From_column - Offset
      Row_incremented = From_row + Offset
      Column_incremented = From_column + Offset
      
      # work outwards along the four "legs" of bishop motion
      if Row_incremented < 8:
        # if the row can be increased, check valid column changes - we may find none
        if Column_incremented < 8:
          Valid_destinations.append(Rowcolumn_to_index(Row_incremented, Column_incremented))
        if Column_decremented >= 0:
          Valid_destinations.append(Rowcolumn_to_index(Row_incremented, Column_decremented))
      
      if Row_decremented >= 0:
        # if the row can be decreased, check valid column changes - we may find none, and we may not have gotten here
        if Column_incremented < 8:
          Valid_destinations.append(Rowcolumn_to_index(Row_decremented, Column_incremented))
        if Column_decremented >= 0:
          Valid_destinations.append(Rowcolumn_to_index(Row_decremented, Column_decremented))
          
    return Valid_destinations
    
  def Generate_knight_destinations(self, Row, Column):
    # calculate all possible destinations for knight, even if they're off the board
    return ((Row + 2, Column + 1), (Row + 2, Column - 1),
            (Row - 2, Column + 1), (Row - 2, Column - 1),
            (Row + 1, Column + 2), (Row - 1, Column + 2),
            (Row + 1, Column - 2), (Row - 1, Column - 2))
            
  def Check_rowcolumn_on_board(self, Row, Column):
    # check validity of r/c pair, used for pruning knight and king possibilities
    return (((Row < 8) and (Row >= 0)) and 
         ((Column < 8) and (Column >= 0)))
    
  def List_knight_moves(self, From_index):
    From_row, From_column = Index_to_rowcolumn(From_index)
    
    # generate possible knight moves
    Candidate_destinations = self.Generate_knight_destinations(From_row, From_column)
    Valid_destinations = []
    
    # prune away illegal moves
    for Destination in Candidate_destinations:
      if self.Check_rowcolumn_on_board(Destination[0], Destination[1]):
        Valid_destinations.append(Destination)
        
    # convert r/c to index through list comprehension before returning
    return [Rowcolumn_to_index(Valid_destinations[k][0], Valid_destinations[k][1]) for k in xrange(len(Valid_destinations))]
    
  def List_pawn_moves(self, From_index):
    From_row, From_column = Index_to_rowcolumn(From_index)
    
    Valid_destinations = []
    
    # moves of one
    Valid_destinations.append(Rowcolumn_to_index(From_row-1, From_column))
      
    # moves of two
    if From_row == 6:
      Valid_destinations.append(Rowcolumn_to_index(From_row-2, From_column))
      
    # captures
    if From_column > 0: Valid_destinations.append(Rowcolumn_to_index(From_row-1, From_column-1))
    if From_column < 7: Valid_destinations.append(Rowcolumn_to_index(From_row-1, From_column+1))
    
    return Valid_destinations
    
  def Generate_king_destinations(self, Row, Column):
    return ((Row-1, Column-1), (Row-1, Column), (Row-1, Column+1),
            (Row,   Column-1),                  (Row,   Column+1),
            (Row+1, Column-1), (Row+1, Column), (Row+1, Column+1))
    
  def List_king_moves(self, From_index):
    From_row, From_column = Index_to_rowcolumn(From_index)
    
    Valid_destinations = []
    Candidate_destinations = self.Generate_king_destinations(From_row, From_column)
    
    for Destination in Candidate_destinations:
      if self.Check_rowcolumn_on_board(Destination[0], Destination[1]):
        Valid_destinations.append(Destination)
        
    # king moves exclude castling due to the fact that it is conditionally possible, NOT a standard move for the piece
    return [Rowcolumn_to_index(Valid_destinations[k][0], Valid_destinations[k][1]) for k in xrange(len(Valid_destinations))]
    
  def Generate_physical_move_table(self):
    self.Physical_moves = {}
    
    # NOTE: Dictionary is first keyed with piece key, always white, to indicate which piece will move
    #       Then the array is indexed with the square index we are checking to return an array of legal move from the square
    #       So for example, self.Physical_moves[2][14] will return the list of legal rook destinations from the 14th square
    
    # fill in rook moves
    self.Physical_moves[2] = [self.List_rook_moves(Square) for Square in xrange(64)]
    # print self.Physical_moves[2][60]
    
    # fill in bishop moves
    self.Physical_moves[4] = [self.List_bishop_moves(Square) for Square in xrange(64)]
    
    # fill in queen moves - since queen is a combination of rook and bishop, no new function is used
    self.Physical_moves[5] = [(self.Physical_moves[2][Square] + self.Physical_moves[4][Square]) for Square in xrange(64)]
    
    # fill in knight moves
    self.Physical_moves[3] = [self.List_knight_moves(Square) for Square in xrange(64)]
    
    # fill in pawn moves -- NOTE: Pawn moves in squares 0-7 are illegal moves because no pawn can be on the back rank and still be a pawn
    self.Physical_moves[1] = [self.List_pawn_moves(Square) for Square in xrange(64)]
    # print "Hello from the helpers:", self.Physical_moves[1]
    
    # fill in king moves
    self.Physical_moves[6] = [self.List_king_moves(Square) for Square in xrange(64)]
    self.Physical_moves[6][60] += [62, 58] # add in the castling moves, which need to be here
    
if __name__ == "__main__":
  C = Chess_helpers()
  print "%d %d is r/c of 54" % Index_to_rowcolumn(54)
  print "%d %d is r/c of 13" % Index_to_rowcolumn(13)
  print "%d %d is r/c of 63" % Index_to_rowcolumn(63)
  print "%d %d is r/c of 0"  % Index_to_rowcolumn(0)
  print "------------------"
  
  print "%d is index of 1, 4" % Rowcolumn_to_index(1, 4)
  print "%d is index of 3, 7" % Rowcolumn_to_index(3, 7)
  print "%d is index of 7, 7" % Rowcolumn_to_index(7, 7)
  print "%d is index of 0, 0" % Rowcolumn_to_index(0, 0)
  print "------------------"
  
  print "%d is the score of R" % C.Scoring_table[2]
  print "%d is the score of N" % C.Scoring_table[3]
  print "%d is the score of B" % C.Scoring_table[4]
  print "%d is the score of Q" % C.Scoring_table[5]
  print "0  is the score of K"
  print "%d is the score of P" % C.Scoring_table[1]
  print "------------------"
  
  print "%s%s%s%s%s%s%s%s is the swap of RNBQKBNR" % (C.Int_code_table[C.Color_change[2]], C.Int_code_table[C.Color_change[3]], C.Int_code_table[C.Color_change[4]], C.Int_code_table[C.Color_change[5]], C.Int_code_table[C.Color_change[6]], C.Int_code_table[C.Color_change[4]], C.Int_code_table[C.Color_change[3]], C.Int_code_table[C.Color_change[2]])
  print "------------------"
  
  print "22 flips to %d" % C.Flip_table[22]
  print "13 flips to %d" % C.Flip_table[13]
  print "31 flips to %d" % C.Flip_table[31]
  print "0 flips to %d"  % C.Flip_table[0]
  print "------------------"
  
  print "%s is the 2-char of 32" % C.Two_character_naming_table[32]
  print "%s is the 2-char of 41" % C.Two_character_naming_table[41]
  print "%s is the 2-char of 63" % C.Two_character_naming_table[63]
  print "%s is the 2-char of 0" %  C.Two_character_naming_table[0]
  print "------------------"
  
  print "%s is passed through between  1 and 19" % list(C.Path_table[1 * 64 + 19])
  print "%s is passed through between  5 and 16" % C.Path_table[5 * 64 + 16]
  print "%s is passed through between  0 and 63" % list(C.Path_table[0 * 64 + 63])
  print "%s is passed through between 63 and  0" % list(C.Path_table[63 * 64 + 0])
  print "%s is passed through between 50 and 23" % list(C.Path_table[50 * 64 + 23])
  print "------------------"
  
  print "A rook   on 16 can go to %s" % C.Physical_moves[2][16]
  print "A queen  on 63 can go to %s" % C.Physical_moves[5][63]
  print "A king   on 60 can go to %s" % C.Physical_moves[6][60]
  print "A bishop on 33 can go to %s" % C.Physical_moves[4][33]
  print "A knight on 46 can go to %s" % C.Physical_moves[3][46]
  print "A pawn   on 52 can go to %s" % C.Physical_moves[1][52]
  print "A pawn   on 31 can go to %s" % C.Physical_moves[1][31]
  print "A pawn   on  8 can go to %s" % C.Physical_moves[1][8]
  