from chess_helpers import *
import random

class Board:
  def __init__(self, _Helpers, _Copy_board = None, _FEN_string = None): # add an engine later
    # call the board clearer
    self.Clear_board()
    # print "RAINING BUGS, INTRO,", _FEN_string
    # if _Copy_board is None:
      # print "RAINING BUGS, INTRO, _Copy_board is None"
    # else:
      # print "RAINING BUGS, INTRO,", _Copy_board

    # assign engine
    #self.Engine = _Engine
    
    # assign helpers
    self.Helpers = _Helpers
    # print "RAINING BUGS, INTRO, HELPERS ASSIGNED"
    
    # if we have an FEN string to boot from, use it
    if _FEN_string != None:
      self.Set_from_FEN(_FEN_string)
    # print "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    # if we are copy constructing from another board    
    if _Copy_board != None:
      self.Set_from_board(_Copy_board)
      
  def Set_from_board(self, _Copy_board):
    self.Squares = list(_Copy_board.Squares)
    self.Valid_castles = _Copy_board.Valid_castles
    self.En_passant_target = _Copy_board.En_passant_target
    self.Halfmove_clock = _Copy_board.Halfmove_clock
    self.Ply_count = _Copy_board.Ply_count
    self.Score = _Copy_board.Score
    self.Pedigree = list(_Copy_board.Pedigree)
    self.Flipped = _Copy_board.Flipped
    self.Hash = _Copy_board.Hash
  
  def Clear_board(self):
    
    # a board is an array of 64 squares, so the 64 empty spaces are create at the start
    self.Squares = [0] * 64 
    
    # the castling information will be set to all valid castles, or "KQkq"
    self.Valid_castles = 15
    
    # the target of an en passant capture will be set to "-" to indicate none
    self.En_passant_target = 100
    
    # the number of half-moves without pawn move or capture is 0
    self.Halfmove_clock = 0
    
    # the number of fullmoves is set to 0
    self.Ply_count = 0
    
    # the score is set to 0 since the board is equal
    self.Score = 0
    
    # the parent move is set to empty list
    self.Pedigree = []
    
    # we are not flipped
    self.Flipped = False
    
    # don't hash anything at this stage, just set it to none
    self.Hash = None
    
  def Set_from_FEN(self, _FEN_string):
    
    # call the board clearer, just in case we were called mid-game
    self.Clear_board()
    
    # an FEN string looks like "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 1 0"
    
    # seperate raw board structure from metadata by its spaces
    FEN_items = _FEN_string.split(" ")
    
    # seperate board items out by slashes
    FEN_ranks = FEN_items[0].split("/")
    
    # print FEN_ranks
    
    # keep track of what row we are in, starting at 0
    Current_square = 0
  
    # loop through the ranks, populating an internal board array
    for Rank in FEN_ranks:
      
      # go character by character in each rank
      for Char in Rank:
        
        # if the character is a number, it must be encoding blank spaces
        if Char in "12345678":
          
          # skip ahead by the amount of blank space, minus one because we have to increment again at the end
          Current_square += int(Char)
          
        # if the character is a valid letter, it must be encoding a piece
        elif Char in "rnbqkpRNBQKP":
          # print "We should have written a character to %d" % Current_square
          self.Squares[Current_square] = self.Helpers.Int_code_table[Char]
          Current_square+=1
          
        else:
          print "Error: unknown character"
          break
    
    # FEN_items[2], or the third FEN item, is the castling information
    FEN_valid_castles = FEN_items[2]
    
    # do we have less than 4 characters, and thus less than both castles for both players, in the FEN?
    if len(FEN_valid_castles) < 4:
      # we use xor to zero digits of the castle from the original 15, which is binary 1111
      if "K" not in FEN_valid_castles:
        self.Valid_castles ^= 8
      
      if "Q" not in FEN_valid_castles:
        self.Valid_castles ^= 4
        
      if "k" not in FEN_valid_castles:
        self.Valid_castles ^= 2
      
      if "q" not in FEN_valid_castles:
        self.Valid_castles ^= 1
        
    # encode what square can currently be the target of an en passant move
    self.En_passant_target = self.Helpers.Two_character_to_index_table[FEN_items[3]]

    # print self.Squares
    
    # encode the half-moves since pawn move or capture
    self.Halfmove_clock = int(FEN_items[4])
    
    # temporarily store the FEN indicated flag so that we can run other calculations with it
    FEN_color = (FEN_items[1] == "w")
    # print "RAINING BUGS, DRIZZLE 1,", FEN_color
    
    # assume we are not flipped
    self.Flipped = False
    
    # if it's black to move, plys are twice fullmoves plus one
    self.Ply_count = int(FEN_items[5]) * 2
    if not FEN_color:
      self.Ply_count += 1
    
    # no pedigree is guaranteed from FEN so it's left empty
    self.Pedigree = []
    
    # before flipping the board, hash the true representation of the board
    self.Hash = hash(tuple(self.Squares))
    
    # if we were told to play black, flip the board
    if not FEN_color:
      self.Flip_board(self)
      
    # work the score out from the board
    self.Score_board()
    # print "RAINING BUGS, DRIZZLE 1, SCORED BOARD %s" % self.Score
    
  # define a way to cast Boards to strings so that we can print them
  def __str__(self):
    
    # if self.Flipped:
      # Temp_board = Board(_Helpers = self.Helpers, _Copy_board = self)
      # self.Flip_board(Temp_board)
      
      # return str(Temp_board)
    
    # initialize a blank template to print later, newlines included (as 1 character, in fact, not 2)
    String_board = ("  a b c d e f g h  \n" +
                    "8                 8\n" +
                    "7                 7\n" +
                    "6                 6\n" +
                    "5                 5\n" +
                    "4                 4\n" +
                    "3                 3\n" +
                    "2                 2\n" +
                    "1                 1\n" +
                    "  a b c d e f g h  \n" )
                   
    Read_pointer = 0
    Write_pointer = 22
    
    for Read_pointer in xrange(64):
      # use integers, not the squares themselves, so that we can detect row breaks
      if self.Squares[Read_pointer] == 0:
        # if we had a blank space, use a dot (would be: String_board[Write_pointer] = ".")
        String_board = replace_char_into_string(String_board, Write_pointer, ".")
      else: 
        # use the character that was present (would be: String_board[Write_pointer] = self.Squares[Read_pointer])
        String_board = replace_char_into_string(String_board, Write_pointer, self.Helpers.Int_code_table[self.Squares[Read_pointer]])
      
      if (Read_pointer % 8) == 7:
        # skip through \n to next line
        Write_pointer += 6
      else:
        # skip over buffer space to next character
        Write_pointer += 2

    String_board += " White to move: %s \n Valid Castles: %s \n En passant target: %s \n Half-moves towards draw: %s \n Full moves: %s \n Plys so far: %s \n Score: %s \n Flipped: %s" % (not self.Flipped, 
                                                                                                                                                                                          self.Convert_castles(), 
                                                                                                                                                                                          self.Convert_en_passant(), 
                                                                                                                                                                                          self.Halfmove_clock, 
                                                                                                                                                                                          self.Ply_count // 2, 
                                                                                                                                                                                          self.Ply_count, 
                                                                                                                                                                                          self.Score,
                                                                                                                                                                                          self.Flipped)
    
    if self.Pedigree != []:
      String_board += "\n Pedigree: "
      for Move in self.Pedigree:
        String_board += " %s%s" % (self.Helpers.Two_character_naming_table[Move[0]], self.Helpers.Two_character_naming_table[Move[1]])
        
    String_board += "\n Hash: %d" % self.Hash
      
    return String_board
    
  def Convert_castles(self):
    Castles = ""
    if self.Valid_castles >> 3: # if the leading digit is set
      Castles += "K"
    else:
      Castles += "-"
    
    if self.Valid_castles & 4: # if the 4's place is set
      Castles += "Q"
    else:
      Castles += "-"
      
    if self.Valid_castles & 2: # if the 2's place is set
      Castles += "k"
    else:
      Castles += "-"
      
    if self.Valid_castles & 1: # if the 1's place is set
      Castles += "q"
    else:
      Castles += "-"
      
    return Castles
    
  def Convert_en_passant(self):
    # print self.En_passant_target
    return self.Helpers.Two_character_naming_table[self.En_passant_target] if self.En_passant_target != 100 else "-"
    
  def Board_to_FEN(self):
    
    position = 0
    Current_empty_squares = 0
    FEN_string = ""
    
    for Current_square in self.Squares:
      # work through the board data in order
      Current_item = self.Squares[position]
      if Current_item != 0:
        # if we are not on an empty space
        
        if Current_empty_squares != 0:
          # if there were empty spaces being counted and we've just encountered a piece, add in the empty spaces
          FEN_string += str(Current_empty_squares)
          # then clear the counter
          Current_empty_squares = 0
        
        # since there is a piece, just add it to the string
        FEN_string += self.Helpers.Int_code_table[Current_item]
        
      else:
        # if we are on an empty, add into the empty space tracker
        Current_empty_squares += 1
        
      if (position % 8) == 7:
        # if we are on the end of the line, add in a slash and any tracked empties we may have
        if Current_empty_squares != 0:
          FEN_string += str(Current_empty_squares)
          Current_empty_squares = 0
          
        FEN_string += "/"
        
      position+=1
      
    FEN_castles = "" 
    if self.Valid_castles == 0:
      FEN_castles = "-"
    else:
      FEN_castles = self.Convert_castles().replace("-", "")
        
    Side_to_move = "b" if self.Flipped else "w"
        
    FEN_string += " %s %s %s %d %d" % ( Side_to_move, 
                                        FEN_castles, 
                                        self.Convert_en_passant(), 
                                        self.Halfmove_clock, 
                                        self.Ply_count // 2)
      
    return FEN_string
    
  def Randomize_board(self):
    # clear the board so that no old data is present when we randomize
    self.Clear_board()
    # decide which squares I want to put pieces on, using a list comprehension, which means that Python will build the list for me
    # and all I have to do is set the parameters. K is irrelevent, I just want a random number of random numbers. Specifically, anywhere between 0 and 32 random numbers in the range 0-63.
    Target_squares = [random.randint(0, 63) for k in xrange(random.randint(0, 32))]
    
    for Square in Target_squares:
      # use the random targets to fill in valid pieces from a list
      self.Squares[Square] = random.randint(1, 12)
    
    # fill in a random valid castle from this list
    self.Valid_castles = random.randint(0, 15)
    
    # fill in a random en passant target from this list of possible targets
    self.En_passant_target = random.choice(range(16, 24) + range(40, 48) + [100])
                                            
    # fill in a random integer for plys since pawn move / capture
    self.Halfmove_clock = random.randint(0, 49)
    
    # fill in a random integer for full moves since game start
    self.Ply_count = random.randint(self.Halfmove_clock, 150)
    
    # score ourselves after this
    self.Score_board()
    
    # assume no parent
    self.Pedigree = []
    
    # we are not flipped
    self.Flipped = False
    
    # hash ourselves
    self.Hash_board()
    
  def Set_square(self, Piece, Square = None, Row = None, Column = None):
    if Square != None:
      self.Squares[Square] = Piece
    elif (Row != None) and (Column != None):
      self.Squares[Rowcolumn_to_index(Row, Column)] = Piece
    else:
      print "Invoked without valid square"
      
    self.Hash_board()
      
  def Get_square(self, Square = None, Row = None, Column = None):
    if Square != None:
      return self.Squares[Square]
    elif (Row != None) and (Column != None):
      return self.Squares[Rowcolumn_to_index(Row, Column)]
    else:
      return None
      
  def Set_castles(self, Replacement):
    self.Valid_castles = Replacement
    
  def __eq__(self, Other_board):
    # NOTE: we don't have to check score because score is a derivative of Squares. If Squares is the same then score will be the same
    return ((self.Squares == Other_board.Squares)                     and 
            (self.Valid_castles == Other_board.Valid_castles)         and 
            (self.En_passant_target == Other_board.En_passant_target) and 
            (self.Flipped == Other_board.Flipped)                     and 
            (self.Halfmove_clock == Other_board.Halfmove_clock)       and 
            (self.Ply_count == Other_board.Ply_count)                 and
            (self.Pedigree == Other_board.Pedigree))
            
  def Is_empty(self, Square):
    return (self.Squares[Square] == 0)
    
  def Is_white(self, Square):
    return (self.Squares[Square] < 7)
    
  def Is_white_piece(self, Piece):
    return (Piece < 7)
    
  def Is_black(self, Square):
    return (self.Squares[Square] > 6)
  
  def Is_black_piece(self, Piece):
    return (Piece > 6)
    
  def Is_clear_path(self, From_index, To_index):
    Clear_path = True
    
    Pass_through = self.Helpers.Path_table[From_index * 64 + To_index]
    # print "RAINING BUGS, AFTERMATH", From_index, To_index, Pass_through
    
    for Square_Index in Pass_through:
      if self.Squares[Square_Index] != 0:
        Clear_path = False
        break
    
    return Clear_path
    
  # function is not validated
  def Is_check(self):
    for Square in xrange(64):
      if self.Squares[Square] == 6: # code for white king
        # print "Found white king on square %d, dispatching to ask about black pieces" % Square
        return self.Is_black_controlled(Square)
    
  # rewrite to take a flip-into board  
  def Flip_board(self, Target_board):
      
    # reverse the flipped flag
    Target_board.Flipped = not self.Flipped
    # WARNING: UNTIL THIS POINT IT IS NOT SAFE TO PRINT THE BOARDS
    # PRINTING WILL CALL THE TRUE BOARD STRING OPERATOR
    # WHICH WILL CAUSE AN INFINITE RECURSION
    
    # print Target_board
    
    # flip and copy the board
    for Item_1_index in xrange(32):
      # the source index is where we expect to read out of - we have to flip this and the 
      # item in the flipped index, which is done through an intermediary step
      # because we flip two squares at a time, we don't itterate through every square, but
      # rather only the the first 32
      Item_2_index = self.Helpers.Flip_table[Item_1_index]
      
      Item_1 = self.Squares[Item_1_index]
      Item_2 = self.Squares[Item_2_index]
      
      Target_board.Squares[Item_2_index] = self.Helpers.Color_change[Item_1]
      Target_board.Squares[Item_1_index] = self.Helpers.Color_change[Item_2]
      
    
    # flip and copy the castles
    New_valid_castles = self.Valid_castles
    
    Black_castles = New_valid_castles & 3
    New_valid_castles >>= 2
    New_valid_castles += (Black_castles << 2)
    Target_board.Set_castles(New_valid_castles)
    
    # handle the changes of en passant positions
    Target_board.En_passant_target = self.En_passant_target
    
    if self.En_passant_target != 100:
      if self.En_passant_target < 40:
        Target_board.En_passant_target += 24 # skip from row 6 to row 3
      else:
        Target_board.En_passant_target -= 24 # skip from row 3 to row 6
    
    # Halfmove_clock and Ply_count will be handled by Make_move function
    
    # Score changes sign 
    Target_board.Score = self.Score * -1
    
    # Pedigree is unchanged by flipping the board
    Target_board.Pedigree = self.Pedigree[:]
    
    # Hash is unchanged by flipping the board because the hash is always the hash of the pure board state
    Target_board.Hash = self.Hash
    
    # print Target_board.Flipped
    
  def Test_legality(self, From_index, To_index):
    # assumes move is in physical move table
    Moving_piece = self.Squares[From_index]
    Destination = self.Squares[To_index]
    
    # print "RAINING BUGS, FLOOD,\n", self
    
    # name the critical values for castling so that it's easier to tell what they are
    King_starting_position = 60
    Kingside_castle_ending = 62
    Kingside_castle_through = 61
    Queenside_castle_ending = 58
    Queenside_castle_through = 59
    
    # for convenience, name the numeric literal of the pieces
    Pawn   = 1
    Rook   = 2
    Knight = 3
    Bishop = 4
    Queen  = 5
    King   = 6
    
    # int keys will have the following characters
    Standard_legal = 1
    Illegal = 0
    Capture_en_passant = 2
    Pawn_moved_two = 3
    Castle_kingside = 4
    Castle_queenside = 5
    Promotion = 6
    
    # preset illegal, for the future
    Move_type = Illegal
    
    # check if the path is clear, since this will be needed several times
    Clear_path = self.Is_clear_path(From_index, To_index)
    
    # print self.Is_clear_path(52, 36)
    
    if Moving_piece == Knight:
      # a knight's path is always clear
      Clear_path = True
      
    # first, assume that the move is one of the standard types
    # meaning a move onto empty, capture, promotion, castle, pawn moving two, or capture en passant
    if Clear_path:
      # if self.Is_empty(To_index):
      # print "RAINING BUGS, HARD RAIN,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
      if self.Squares[To_index] == 0:
        # print "Thought square %s was 0" % self.Helpers.Two_character_naming_table[To_index]
        # print "self.Squares[To_index] = %d" % self.Squares[To_index]
        if Moving_piece != Pawn:
          # if we are moving onto an empty square and we are not moving a pawn (since that is more complicated)
          Move_type = Standard_legal
          # print "RAINING BUGS, VERSE,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
          # print "RAINING BUGS, VERSE,", Moving_piece, Clear_path
        elif From_index - To_index == 16:
          # if we are moving a pawn onto empty and moving two, mark that
          Move_type = Pawn_moved_two
        elif (self.En_passant_target != 100) and (To_index == self.En_passant_target):
          # these above statements cannot be made seperate because satisfying one and not the other will falsely drop us out of the elif chain.
          Move_type = Capture_en_passant
        elif To_index != From_index - 8:
          # pawn moves diagonally, but is moving onto empty
          Move_type = Illegal
        elif To_index < 8:
          # pawn moves onto back rank
          Move_type = Promotion
        else:
          # pawn moves legally forward
          Move_type = Standard_legal
          # print "RAINING BUGS, DRIZZLE 2,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
          # print "RAINING BUGS, DRIZZLE 2,", Moving_piece, Clear_path
        
      elif Destination > 6:
        # if the destination was black, this is a normal capture
        if Moving_piece != Pawn:
          Move_type = Standard_legal
          # print "RAINING BUGS, BRIDGE,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
          # print "RAINING BUGS, BRIDGE,", Moving_piece, Clear_path
          # print "RAINING BUGS, BRIDGE,", self.Squares[Destination]
        elif (To_index == From_index - 9) or (To_index == From_index - 7):
          Move_type = Standard_legal
          # print "RAINING BUGS, CHORUS,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
          # print "RAINING BUGS, CHORUS,", Moving_piece, Clear_path
        else:
          Move_type = Illegal
        
      elif Destination < 7:
        # if the destination was white, this is an illegal capture
        Move_type = Illegal
        
    else:
      # if the path was not clear, this is an illegal path
      Move_type = Illegal
      
    # handle the tests of castling, first by making sure we were trying to castle
    if (Moving_piece == King) and (From_index == King_starting_position) and ((To_index == Kingside_castle_ending) or (To_index == Queenside_castle_ending)):
      # since we know we're trying to castle, we can now assume an illegal castle until proven otherwise
      Move_type = Illegal
      if Clear_path and (self.Squares[To_index] == 0) and not self.Is_black_controlled(King_starting_position):
        # if we are trying to castle and the path is clear and the king is not in check, figure out which castle
        if To_index == Kingside_castle_ending:
          # if kingside castling, test through squares and that the castle is not invalidated
          if (self.Valid_castles >> 3) and not (self.Is_black_controlled(Kingside_castle_ending) or self.Is_black_controlled(Kingside_castle_through)):
            # if Kingside is valid and the king doesn't go through or into check, mark it
            Move_type = Castle_kingside
        else:
          # we already know we tried a castle, so if it wasn't kingside it must be queenside
          if (self.Valid_castles & 4) and not (self.Is_black_controlled(Queenside_castle_ending) or self.Is_black_controlled(Queenside_castle_through) or (self.Squares[57] != 0)):
            # if Queenside is valid and the king doesn't go through or into check, mark it
            Move_type = Castle_queenside
        
    # print "RAINING BUGS, MOSH 1,", self.Helpers.Two_character_naming_table[From_index], self.Helpers.Two_character_naming_table[To_index]
    # print "RAINING BUGS, MOSH 1,", Move_type
    return Move_type
    
  def Is_black_controlled(self, Target):
    # if a knight were on the square, where could it jump to? This also says what squares can knights be on so that they could get here.
    Direct_jump_indicies = self.Helpers.Physical_moves[3][Target]
    Black_knight = 9
    Black_pawn = 7
    Black_queen = 11
    Black_king = 12
    
    # print "Targeting square %d" % Target
    
    Pieces_on_knight_squares = [self.Squares[k] for k in Direct_jump_indicies]
    if Black_knight in Pieces_on_knight_squares:
      # if a knight can jump here, just break out by returning true
      # print "Found a knight that could capture"
      return True
      
    # print "Did not find a knight that could capture"
    
    # though this would have simply been -7 or -9, that can wrap the edges and cause problems
    # instead we actually check the row/column of the two squares
    Target_rc = Index_to_rowcolumn(Target)
    if Black_pawn in ([self.Squares[Rowcolumn_to_index(k[0], k[1])] for k in 
                      [(Target_rc[0] - 1, Target_rc[1] + 1), (Target_rc[0] - 1, Target_rc[1] - 1)] 
                      if self.Helpers.Check_rowcolumn_on_board(k[0], k[1])]):
      # print "Found a pawn that could capture"
      return True
      
    if Black_king in [self.Squares[k] for k in self.Helpers.Physical_moves[6][Target]]:
      # if a king is found in the 8 squares which surround the target
      return True
    
    else:
      # print "Did not find a pawn that could capture"
      for Piece in (2, 4):
        # print "Testing both rooks and bishops"
        # print "Trying to key self.Helpers.Physical_moves with %d, %d" % (Piece, Target)
        # find both rooks and bishops and return if either passes the test
        Potential_attackers = self.Helpers.Physical_moves[Piece][Target]
        # print Potential_attackers
        for Attacker in Potential_attackers:
          # if there is a clear path between the attacker and the target
          if self.Is_clear_path(Attacker, Target):
            # print "Found a suitable piece, checking if it is the right color"
            # print "Square is %d" % Attacker
            # if the attacker is either a black version of the piece we're evaluating or a black queen
            Attacking_piece = self.Squares[Attacker]
            if ((Attacking_piece == (Piece + 6)) or (Attacking_piece == Black_queen)):
              # print "found an attacking piece, returned that the Target is black controlled"
              return True
        
        # if any([k for k in self.Helpers.Physical_moves[Piece][Target] if (self.Is_clear_path(k, Target) and ((self.Squares[k] == Piece.lower()) or (self.Squares[k] == "q")))]):
        #   return True
          
    return False
          
  def Make_move(self, From_index, To_index, Promote_to = 5):
    # performs a move and updates metadata
    Piece = self.Squares[From_index]
    # print "Attempting to check legality of %d, %d" % (From_index, To_index)
    Move_type = self.Test_legality(From_index, To_index)
    # print Move_type
    if not Move_type:
      return 2
    else:
      # we are guaranteed by now that the move can be made - now we have to update the metadata & board state
      # we will always move the piece to the To_index, no matter what kind of move it is, and zero where it came from
      
      captured = self.Squares[To_index] == 0
      
      self.Squares[To_index] = Piece
      self.Squares[From_index] = 0
      
      # * type has no special actions, so we ignore it.
        
      # metadata update - unless you moved a pawn 2, there should no longer be an en passant target
      self.En_passant_target = 100
        
      # for convenience, name the same literals from Test_legality
      Standard_legal = 1
      Illegal = 0
      Capture_en_passant = 2
      Pawn_moved_two = 3
      Castle_kingside = 4
      Castle_queenside = 5
      Promotion = 6
      
      White_rook = 2
      White_king = 6
      White_queen = 5
      
      if Move_type == Pawn_moved_two:
        # Move_type being $ indicates that a pawn is moving two, which says that the en passant target must be updated
        # write the square 8 after To_index as the en passant target
        self.En_passant_target = To_index + 8
        
      # NOTE ABOUT CASTLING
      #   The 1-ply legality check will only catch castling into check, but cannot evaluate caslting out of or through check.
      #   In order to catch these things, we actually have to test them here. Into check is actually relatively simple, so we also work it out here.
      #   This is done through combining all lists of controlled squares and asking if the king's current, pass-through, or destination are in any of those.
        
      elif Move_type == Castle_kingside:
        # Move_type being K indicates kingside castling
        # associated rook (which logically can't have moved) must be moved to correct square
        self.Squares[63] = 0
        self.Squares[61] = White_rook
        
        # metadata updates - clear both castles due to the fact that the king has moved
        self.Valid_castles &= 3
        
      elif Move_type == Castle_queenside:
        # Move_type being Q indicates queenside castling
        # associated rook (which logically can't have moved) must be moved to correct square
        self.Squares[56] = 0
        self.Squares[59] = White_rook
        
        # metadata updates - clear both castles due to the fact that the king has moved
        self.Valid_castles &= 3
        
      elif Move_type == Capture_en_passant:
        # Move_type being & indicates that a piece was captured en passant, meaning that we cannot treat it like a normal capture
        #   if we got this, then we know that the en passant target must have been the To_index
        #   thus we can clear the en passant target up at the top and it won't effect us here
        # zero the piece 8 squares after, or one row beneath
        self.Squares[To_index + 8] = 0
        
      elif Move_type == Promotion:
        # Move_type being @ indicates that a promotion -- which is treated as always to a queen -- occured
        self.Squares[To_index] = Promote_to
        
      # clean up so that rook and king moves are caught to update castling flags
      if Piece == White_king:
        # create two dashes and then add black's castles onto them - clears whites castles efficiently
        self.Valid_castles &= 3
        
      elif (Piece == White_rook):
        if From_index == 63:
          # if the king's rook moves, clear the king castle
          self.Valid_castles &= 7
        
        elif From_index == 56:
          # if the queen's rook moves, clear the queen castle
          self.Valid_castles &= 11
          
      self.Ply_count += 1
        
      if self.Flipped:
        self.Pedigree.append((self.Helpers.Mirror_position(From_index), self.Helpers.Mirror_position(To_index))) 
      else:
        self.Pedigree.append((From_index, To_index))
        
      # update hash so that we don't have to rehash when simply trying to fetch it
      self.Hash_board()
      
      self.Score_board()
        
      # return True if the halfmove clock should be wiped, return false if it should be incremented
      # NOTE: whatever functions call Make_move need to be aware of the fact that it both has behavior
      #       that changes the board and returns data about externally necessary metadata updates
      if (captured) or (Piece == 1):
        return 1
      else:
        return 0
        
  def Get_score(self):
    self.Score_board()
    return self.Score
      
  def Score_board(self):
    Temporary_flipped_board = Board(_Helpers = self.Helpers, _Copy_board = self)
    self.Flip_board(Temporary_flipped_board)
    self.Score = (Score_white_pieces(self) - Score_white_pieces(Temporary_flipped_board))
    
  def Get_pedigree(self):
    return self.Pedigree
    
  def Hash_board(self):
    if self.Flipped:
      Temp_board = Board(_Helpers = self.Helpers, _Copy_board = self)
      self.Flip_board(Temp_board)
      self.Hash = hash(tuple(Temp_board.Squares))
    
    else:
      self.Hash = hash(tuple(self.Squares))
    
  def Enumerate_moves(self):
    
    Move_list = []
    
    for Square in xrange(64):
      Piece = self.Squares[Square]
      if Piece != 0:
        if self.Is_white_piece(Piece):
          Candidate_moves = self.Helpers.Physical_moves[Piece][Square]
          # print "Candidate moves:", Candidate_moves
          for Move in Candidate_moves:
            # each move will be appended as a tuple to the list
            if self.Test_legality(Square, Move):
              Move_list.append((Square, Move))
    # return the list of tuples, otherwise known as "moves"
    return Move_list
    
if __name__ == "__main__":
  Test_board = Board(_Helpers = Chess_helpers(), _FEN_string = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0")
  # print Test_board
  # print Test_board.Enumerate_moves()
  # print Test_board.Score
  
  
    