from Storkfresh import *
from chess_helpers import *

class UCI_interface:
  
  def __init__(self):
    self.Log=open('./uci.tmp',mode='a',buffering=0)
    self.Log.write("==========================================\n")
    
    # make a table of functions so that the code is nice and short when we do the listening loop
    self.Command_table = { "uci"        : self.Answer_UCI,
                           "isready"    : self.Answer_Is_ready,
                           "go"         : self.Go,
                           "quit"       : self.Quit_loop,
                           "position"   : self.Initialize_new_engine }
                           
    self.Engine = None
    
    self.Verbose = False
    
    # random.seed(1938436)
    
    self.Helpers = Chess_helpers()
    
  def Set_verbose(self, Value):
    self.Verbose = Value
                           
  def Answer_UCI(self, Items):
    return ["id name Storkfresh 1.0", "id author Henry", "uciok"] # definately original
    
  def Answer_Is_ready(self, Items):
    return ["readyok"]
    
  def Initialize_new_engine(self, Items):
    # set self.Engine to be a new engine with a board built from Items
    self.Engine = Engine(_Helpers = self.Helpers, _Position_call = Items, _Verbose = self.Verbose, _Log = self.Log)
    
    if self.Verbose:
      self.Log.write("Engine now thinks the board is \n%s\n" % str(self.Engine.Board))
      self.Engine.Log.write("If you're seeing this, the engine got a reference to the UCI log\n")
      self.Log.write("Engine believes Verbose is %s\n" % self.Engine.Verbose)
    
  def Go(self, Items):
    # when the engine tells us to think, Negamax and then return that move
    # self.Log.write(str(self.Board) + "\n")
    if self.Verbose:
      self.Log.write("Inside go, trying to treat %d as the depth limit from the Engine\n" % self.Engine.Depth_limit)
    
    Depth = self.Engine.Depth_limit
    if len(Items) > 1:
      if Items[1] == "depth":
        Depth = int(Items[2])
        if self.Verbose:
          self.Log.write("Trying to treat %d as the depth" % Depth)
          
    self.Engine.Set_depth_limit(4) # should be Depth
        
    Best_value, Best_chain  = self.Engine.Negamax()
    
    if self.Verbose:
      self.Log.write("Negamax returned, yielding best value %d and best move chain %s\n" % (Best_value, Best_chain))
    
    # reformat information
    Index_chain = list(reversed(Best_chain))
    Best_move = Index_chain[0]
    
    if self.Verbose:
      self.Log.write("Made forward chain %s and isolated best move of that %s\n" % (Index_chain, Best_move))
    
    Start_position = 1
    if self.Engine.Board.Flipped:
      Start_position = 0
    
    for i in xrange(Start_position, len(Index_chain), 2):
      From, To = Index_chain[i]
      Index_chain[i] = [self.Helpers.Mirror_position(From), self.Helpers.Mirror_position(To)]
      
    Chain_names = [self.Helpers.Two_character_naming_table[k[0]] + self.Helpers.Two_character_naming_table[k[1]] for k in Index_chain]
    
    if self.Verbose:
      self.Log.write("Found chain of best names %s\n" % Chain_names)
    
    # report the results
    Best_chain_single_string = ""
    for Move in Chain_names:
      Best_chain_single_string += Move
      Best_chain_single_string += " "
      
    # if the board was flipped invert the score
    Best_value = max(-9999, min(Best_value, 9999))
    if self.Engine.Board.Flipped:
      Best_value *= -1
    
    if self.Verbose:
      self.Log.write("Created best moves string %s and found best value to be reported as %d" % (Best_chain_single_string, Best_value))
      
    return ["info depth %d score cp %d pv %s" % (self.Engine.Depth_limit, Best_value, Best_chain_single_string), "bestmove %s" % Chain_names[0]]
    
  def Quit_loop(self, Items):
    return "Quit"
    
  def Play_in_GUI(self):
    Quit=False
    while not Quit:
      # fetching loop
        Received=raw_input()
        self.Log.write("%s\n" % Received)
        Items=Received.split()
        if len(Items):
          # if we didn't get sent nothing
          Response = None
          try:
            if self.Verbose:
              self.Log.write("Dispatching to %s and giving it %s\n" % (Items[0], Items))
            Response = self.Command_table[Items[0]](Items)
          except:
            pass
            
          if Response is not None:
            if Response == "Quit":
              # if we were told to quit, do so
              Quit = True
              
            else:
              # otherwise, just tell the GUI what we sent back
              for Item in Response:
                self.Log.write("sent %s\n" % Item)
                print Item
        
if __name__ == "__main__":
  Debug = False
  if Debug:
    UCI = UCI_interface()
    UCI.Set_verbose(True)
    UCI.Initialize_new_engine("position startpos".split())
    # UCI.Log.write("Engine thinks the states are %s\n" % UCI.Engine.State_history)
    # UCI.Log.write("Engine now has the board %s\n" % str(UCI.Engine.Board))
    UCI.Engine.Set_depth_limit(4)
    print UCI.Engine.Negamax()
    
    # for i in xrange(100):
      # print UCI.Random_decision()
  
  else:
    UCI = UCI_interface()
    UCI.Play_in_GUI()
