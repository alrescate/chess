from chess_helpers import *
from Board import *
import sys

class Engine:
  
  # set up the insides of the class
  def __init__(self, _Helpers, _Board = None, _Position_call = None, _Log = None, _Verbose = False, _Depth_limit = 6):
    self.Helpers = _Helpers
    
    if _Board is not None:
      self.Board = Board(_Helpers = self.Helpers, _Copy_board = _Board)
    else:
      self.Board = Board(_Helpers = self.Helpers, _FEN_string = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0")
    
    self.Depth_limit = _Depth_limit
    self.Stack = [Board(_Helpers = self.Helpers) for k in xrange(self.Depth_limit + 4)]
    self.State_history = {}
    self.Stack[0] = self.Board
    # print self.Stack
    self.Verbose = _Verbose
    self.Node_count = 0

    if _Log is not None:
      self.Log = _Log
    else:
      self.Log = None
    
    if _Position_call is not None:
      self.Update_position(_Position_call) # NOTE: _Position_call must be split before giving it to the Engine
    
  def Update_position(self, Items):
    # re-define the board position from scratch each time
    if Items[1] == "startpos":
      self.Board.Set_from_FEN("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0")
      # self.Log.write(str(self.Board) + "\n")
      
      Promotion_to = 5 # set this to White Queen, it may never be changed so we want to make sure it's the default
      
      # convert to move tuples
      Moves_to_play = Items[3:]
      # prune just in case there were promotions
      for Move in Moves_to_play:
        if len(Move) == 5: # promotion occurs
          Promotion_to = Move[4]
      Moves_to_play = [Move[:4] for Move in Moves_to_play]
      Moves_to_play = [(self.Helpers.Two_character_to_index_table[Move[:2]], self.Helpers.Two_character_to_index_table[Move[2:]]) for Move in Moves_to_play]
      
      Start_position = 1
      if self.Board.Flipped:
        Start_position = 0
        
      for Move in xrange(Start_position, len(Moves_to_play), 2):
        Moves_to_play[Move] = self.Helpers.Mirror_move_tuple(Moves_to_play[Move])
      
      for Move in Moves_to_play:
        # self.Log.write("ID: " + str(id(self.Board)) + "\n")
        self.Board.Make_move(Move[0], Move[1], Promotion_to)
        self.Update_states()
        
        # self.Log.write(str(self.Board) + "\n")
        
        self.Board.Flip_board(Target_board = self.Board)
        
        # self.Log.write("ID: " + str(id(self.Board)) + "\n")
        # self.Log.write("Board (inside the loop):\n" + str(self.Board) + "\n")
      
      # self.Log.write("ID: " + str(id(self.Board)) + "\n")
      # self.Log.write("Board (outside the loop):\n" + str(self.Board) + "\n")
      # self.Log.write(self.Board.Board_to_FEN() + "\n")
      

    
  # set the board later
  def Set_board(self, New_board):
    self.Board = New_board
    self.Stack[0] = self.Board
    
  # make board from FEN
  def Set_from_FEN(self, FEN):
    self.Board = Board(_Helpers = self.Helpers, _FEN_string = FEN)
    self.Stack[0] = self.Board
    
  def Set_depth_limit(self, New_depth):
    self.Depth_limit = New_depth
    
  def Update_states(self):
    # called after playing a move to update the state history
    New_squares_hash = self.Board.Hash
    if self.Verbose:
      self.Log.write("Retrieved hash %d from self.Board, which has FEN string %s\n" %  (New_squares_hash, self.Board.Board_to_FEN()))
    if New_squares_hash in self.State_history.keys():
      # this state is a repeat
      if self.Verbose:
        self.Log.write("Found that hash as a key, when searching keys %s\n" % self.State_history.keys())
      
      if self.Verbose:
        self.Log.write("Attempting to write self.State_history[New_squares_hash], which is currently value %d\n" % self.State_history[New_squares_hash])
        
      self.State_history[New_squares_hash] += 1
      
      if self.Verbose:
        self.Log.write("Incremented self.State_history[New_squares_hash] to the value %d\n" % self.State_history[New_squares_hash])
    else:
      # this state is new
      if self.Verbose:
        self.Log.write("Did not find that hash as a key, when searching keys %s\n" % self.State_history.keys())
      self.State_history[New_squares_hash] = 1
  # with consideration for the stack, is this state a repeat    
  def Check_repetition_draw(self, _Board, _Offset):
    # We have the guarantee that these board were already hashed correctly by their Make_move function
    Stack_hashes = [Board.Hash for Board in self.Stack[1:_Offset]] # ignore the current state of the board, which sits on top of the stack
    if self.Verbose:
      self.Log.write("Found the following hashes above ourselves %s\n" % Stack_hashes)
    Current_squares_hash = _Board.Hash # we also already know our own hash, and don't have to recalculate it
    if self.Verbose:
      self.Log.write("We found a hash of ourselves to be %d\n" % Current_squares_hash)
    
    # count the repetitions in the stack
    # NOTE: you are at least the first repetition of yourself
    Repetitions = 1
    for Hash in Stack_hashes:
      if Hash == Current_squares_hash:
        Repetitions += 1
        
    # count the repetitions in the history
    Historical_repetitions = self.State_history.get(Current_squares_hash, None)
    if self.Verbose:
      self.Log.write("Historical_repetitions told me that I had..." + str(Historical_repetitions) + "\n")
      self.Log.write("I found %d repetitions above me in the stack\n" % Repetitions)
    if Historical_repetitions is not None:
      Repetitions += Historical_repetitions
    else:
      if self.Verbose:
        self.Log.write("We failed to access the State_history successfuly using this key %d\n" % Current_squares_hash)
        self.Log.write(str(self.State_history))
      else:
        pass
      
    if Repetitions == 3:
      # it can't have exceeded three because we test this before recurring to a child, so this must be the first time we could have drawn
      if self.Verbose:
        self.Log.write("Returning True, the position would be a draw\n")
      return True
    else:
      # if we didn't find three, return false
      if self.Verbose:
        self.Log.write("Returning False, the position would not be a draw\n")
        self.Log.write("%d repetitions found not equal to 3\n" % Repetitions)
      return False
    
  # find the best child of a Board looking self.Depth_limit ahead
  def Negamax(self, Alpha = None, Beta = None, Stack_offset = 0):
  
    if self.Verbose:
      self.Log.write("We called into Negamax within the Engine\n")
  
    if Alpha is None:
      Alpha = self.Helpers.Neg_infinity
      
    if Beta is None:
      Beta = self.Helpers.Pos_infinity
  
    # handle being a leaf
    if self.Verbose:
      self.Log.write("-------------------\n\n-------------------\n\n-------------------\n")
      self.Log.write("Stack offset: %d\n" % Stack_offset)
      self.Log.write("Depth: %d Alpha: %d Beta: %d\n" % (Stack_offset, Alpha, Beta))
      self.Log.write("Parent board is:\n" + str(self.Stack[Stack_offset]) + "\n")
    
    if Stack_offset == self.Depth_limit:
      # return Score, Best_below
      # NOTE: the child is created and put in place before the reccuring call, so the child will already be here
      if self.Verbose:
          self.Log.write("Returning here, as a leaf\n")
      return self.Stack[Stack_offset].Score, []
    # handle recurring down the tree
    
    _Board = self.Stack[Stack_offset]
    
    # if we didn't break from leaf status...
    # get the future states as moves, formatted (From_index, To_index)
    Child_moves = _Board.Enumerate_moves()
    if self.Verbose:
      if _Board.Flipped:
        self.Log.write("Child moves: " + str([self.Helpers.Two_character_of_move_tuple(self.Helpers.Mirror_move_tuple(Move)) for Move in Child_moves]) + "\n")
      else:
        self.Log.write("Child moves: " + str([self.Helpers.Two_character_of_move_tuple(Move) for Move in Child_moves]) + "\n")
    
    Playable_children = False
    
    # NOTE: Pruned nodes are not guaranteed to have found their worst result.
    #       They prune themselves as soon as they find that they cannot do better
    #       than the bottom line. Thus they must NEVER be allowed to replace the best
    #       value at their parent level, because they can be worse
    Pruned = False
    
    # set the best to a sentinel, -999999
    Best_value = -999999
    # set that we have not found our optimal path, nor know the path to the best leaf down below us
    Our_best_choice = []
    Best_moves_below = []
    
    In_check = _Board.Is_check()
    
    if self.Verbose:
      self.Log.write("in check? " + str(In_check) + "\n")
    
    for Move in Child_moves:
      if self.Verbose:
        self.Log.write("We are inside the loop\n")
      if self.Verbose:
        self.Log.write("Testing move %d %d\n" % Move)
      # copy the current level of board into the position beneath it
      # get reference to level beneath ourself
      # play the move on the level below
      
      Child_board = self.Stack[Stack_offset + 1]
      if self.Verbose:
        self.Log.write("Fetched stack position %d\n" % (Stack_offset + 1))
      Child_board.Set_from_board(_Board)
      if self.Verbose:
        self.Log.write("Set child board equal to parent, now is: \n" + str(Child_board) + "\n")
      Result = Child_board.Make_move(Move[0], Move[1])
      if self.Verbose:
        self.Log.write("Got result: %d\n" % Result)
        self.Log.write("Trying move: %d %d\n" % Move)
      
      if self.Verbose:
        self.Log.write("Child board was: \n" + str(Child_board) + "\n")

      # assess if the child is legal - NOTE: only the black king can have been captured by this point.
      # if the White-ish king was captured, then a Board above us captured the "black" king and we can't
      # have gotten here
      Candidate_move_check = Child_board.Is_check()
      if self.Verbose:
        self.Log.write("Was this child in check? %s\n" % Candidate_move_check)
      
      if not Candidate_move_check:
        # this asks if the white-type king is in check
        Playable_children = True
        if self.Verbose:
          self.Log.write("Evaluating node\n")
        # only if we haven't broken by now from a checkmate condition  
        if Result == 1:
          Child_board.Halfmove_clock = 0
        elif Result == 0:
          Child_board.Halfmove_clock += 1
          
        Value = -999999
          
        if Child_board.Halfmove_clock == 50:
          Value = -1 # a 50 move stale-game draw
          Best_child_move_list = []
          
        elif self.Check_repetition_draw(Child_board, Stack_offset + 1):
          Value = -1 # use the check function to ask about 3-fold draws
          Best_child_move_list = []
        
        else:
          # if we got here the move must have been played, thus a bool was returned
          # only these boards are evaluable, so the rest of the code goes in here
          # flip the child after playing a move
          # NOTE: Child_board cannot be used here because it will reasign rather than edit in the stack
          Child_board.Flip_board(Child_board)
          if self.Verbose:
            self.Log.write("Child is:\n" + str(self.Stack[Stack_offset + 1]) + "\n")
          
          # get the value and inherited path to the best leaf from our new child by recursive callable
          # NOTE: Negamax flips and inverts Alpha and Beta because we are flipping the board, which means
          #       that actually on the next pass down we're doing the opposite of what we did here (either minimizing or maximizing, depending on what we flipped to)
          #       the issue is that in order to keep the code short, we have to invert the numbers so that we always use max(), 
          #       but get alternating results
          Value, Best_child_move_list = self.Negamax(-Beta, -Alpha, Stack_offset + 1)
          if self.Verbose:
            self.Log.write("----------------------------------------\n")
          self.Node_count += 1
          if self.Verbose:
            self.Log.write("Value: %d Moves with best path from child: %s\n" % (Value, Best_child_move_list))
          Value *= -1
          
        # if this node is a new best node, change the best values
        if Value > Best_value:
          if self.Verbose:
            self.Log.write("New best value: %d\n" % Value)
            self.Log.write("New best choice: %d %d\n" % Move)
            self.Log.write("New best child moves: %s\n" % Best_child_move_list)
          Best_value = Value
          Our_best_choice = Move
          Best_moves_below = Best_child_move_list
          # self.Log.write(str(Child_board))
          
        else:
          if self.Verbose:
            self.Log.write("Concluded value %d was less than already known best value %d\n" % (Value, Best_value))
          else:
            pass
        # update Alpha
        Alpha = max(Alpha, Value)
        # if we now have Alpha >= Beta, the node must be worse than our guaranteed bottom line, so stop evaluating
        if Alpha >= Beta:
          if self.Verbose:
            self.Log.write("Alpha %d was greater than or equal to Beta %d\n" % (Alpha, Beta))
            Parent_move = _Board.Pedigree[-1]
            self.Log.write("Pruned child inheriting from %s\n" % (self.Helpers.Index_to_two_character(Parent_move[0]) + self.Helpers.Index_to_two_character(Parent_move[1])))
          Pruned = True
          break
      
      
    if not Playable_children: # if we had no playable children...
      if In_check: # were we in check?
        if self.Verbose:
          self.Log.write("Returning here, with checkmate\n")
        return (-99999) + Stack_offset, [] # if yes, checkmate
        # NOTE: in order to promote short checkmates, Depth is subtracted so the value is slightly greater when your are not as deep in the tree
      else:
        if self.Verbose:
          self.Log.write("Returning here, with stalemate\n")
        return -1, [] # if no, stalemate
    elif Pruned:
      return self.Helpers.Pos_infinity, []
    else:
      # return the best value you had so that the call above you can use it as Value, and the move chain to the best child 
      # so that it can become Best_child_move_list in the call above. Should this be the top node, this will return the best
      # value at that depth and the move sequence that makes it best.
      Best_moves_below.append(Our_best_choice)
      if self.Verbose:
        self.Log.write("Returning here, with a new best move\n")
      return Best_value, Best_moves_below
    
if __name__ == "__main__":
  C = Chess_helpers()
  E = Engine(_Helpers = C, _Depth_limit = 4)
  
  Test_board = Board(_Helpers = E.Helpers, _FEN_string = "r3b1Q1/pp2k1p1/5p1p/b5q1/2B5/8/PP4PP/3R1R1K w - - 0 0")
  
  # Test_board.Flip_board(Test_board)
  
  E.Set_board(Test_board)
  # print E.Board
  # define some helpful ways to move back and forth between testing and playing in a GUI
  # E.Update_position("position startpos moves d2d4 d7d5 e2e4 d5e4 f1c4 d8d6 c4b5 c7c6 b5f1 e7e5 d4e5 d6e5 c2c3 c8e6 d1d4 e5d4 c3d4 f8b4 c1d2 a7a5 a2a4 b8d7 f1e2 e6b3 d2b4 a5b4 b1d2 b3c2 g1h3 e8e7 a1c1 c2d3 h3g5 a8a4 d2e4 d3e4 g5e4 g8f6 e4f6 d7f6 e2d3 a4a2 c1b1 h8d8 e1d2 d8d4 d2e3 d4d5 f2f3 a2a8 d3c4 d5a5 h2h4 a8d8 c4b3 f6d5 b3d5 a5d5 b1a1 e7f6 h4h5 d8e8 e3f2 d5d2 f2g3 e8e2 g3f4 e2g2 a1a8".split())
  # print E.Board
  
  Result = E.Negamax(Alpha = -10000, Beta = 10000, Stack_offset = 0)
  # print E.Board
  
  # for a in E.Stack:
    # print a
  
  # print Result
  
  print Result[0]
  Index_chain = list(reversed(Result[1]))
  print E.Node_count
  for i in xrange(1, len(Index_chain), 2):
    From, To = Index_chain[i]
    Index_chain[i] = [E.Helpers.Mirror_position(From), E.Helpers.Mirror_position(To)]
  
  print [E.Helpers.Two_character_naming_table[k[0]] + E.Helpers.Two_character_naming_table[k[1]] for k in Index_chain]
  
