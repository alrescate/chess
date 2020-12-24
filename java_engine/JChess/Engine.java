package JChess;

import java.io.*;
import java.util.ArrayList;
public class Engine {
    private final int depthLimit = 6;  // the maximum depth to think to
    private final int verbose;         // whether we're writing out verbose messages
    private final int hashDepth = 400; // the depth of the hash stack, presumed to be the maximum number of plies in a game
    private final int defaultPromotion = ChessHelpers.wQueen;
    
    private int[][][] bestMoves;       // see lengthy explanation below
    // private int[] bestChoice;          // a pair of indices indicating the best move (to be sent to a GUI)
    private Board[] boardStack;        // the thinking region of boards, which negamax descends into
    private Integer[] hashHistory;     // the hashes of all past states in order, excluding the stack
    
    private Board cBoard;              // the board on which evaluations are made (copied into top of boardStack) and history is checked
    private int hashIndex;             // the current stack access for the hash history stack
    private int nodeCount;             // count of the number of nodes evaluated
    private PrintWriter log;           // log file written to if verbose is used 
    
    public Engine(PrintWriter l, int v, String initial) {
    	/*
    	 * How does bestMoves work?
    	 * It is the pair of move indices which indicate the best move sequence to reach the chosen leaf node from any given depth
    	 * down to the leaf. This is maintained so that the lower stack depths can communicate their ideal move sequences back up
    	 * the stack without any new return information or other inconvenient tricks. The use of the array is triangular, following
    	 * the rule that you only begin writing from the stackOffset (aka depth) down. Thus...
    	 *     0 1 2 3 
    	 *   0 K . . .
    	 *   1 L L . . 
    	 *   2 N N N .
    	 *   3 M M M M
    	 * is built in reverse order (3 down to 0) for a depthLimit of 4. 
    	 * */
    	bestMoves = new int[depthLimit][depthLimit][2];
    	// bestChoice = new int[2];
    	boardStack = new Board[depthLimit + 4];
    	hashHistory = new Integer[hashDepth];
    	
    	for (int i = 0; i < depthLimit + 4; i++)
    		boardStack[i] = new Board();
    	log = l;
    	verbose = v;
    	cBoard = new Board(initial);
    	hashIndex = cBoard.getHashHistory().size();
    	
    	boardStack[0] = cBoard;
    	cBoard.getHashHistory().toArray(hashHistory);
    }
    
    public int[][][] getBestMoves() {
    	return bestMoves;
    }
    
    public Board getCBoard() {
    	return cBoard;
    }
    
    public int getNodeCount() {
    	return nodeCount;
    }
    
    // split omitted because it is already provided
    // setStackTop & setHistory omitted because they are extraneous with boards packed into a class
    // updatePosition TEMPORARILY omitted because it is a GUI interfacing function
    // startup omitted because the constructor already serves its purpose
    // candidates & runRankTest omitted because they no longer serve a purpose
    
    private boolean checkRepetitionDraw(int stackAccess) {
      // stackAccess points to the newest board in the boardStack (furthest down, since we are inside negamax) 
    	// stackAccess also serves as the number of hashes added to the end of hashHistory
    	// hashIndex is moved from its position on the end of the historical hashes for this method and this method ONLY
    	boolean ret = false;
    	for (int i = stackAccess; i > 0; i--) {
    		// hashIndex is post-incremented, so we can fill in the temp values
    		// from the boardStack this way to fill up the stack
    		hashHistory[hashIndex++] = boardStack[i].getHash();
    	}
    	
    	for (int i = 0; i < stackAccess; i++) {
    		// i is purely a counter, with hashIndex-- doing the work here
    		int reps = 0;
    		for (int j = hashIndex - 2; j > 0; j--) 
    			if (hashHistory[hashIndex - 1] == hashHistory[j])
    				reps++;
    		if (reps >= 3)
    			ret = true;
    		
    		hashIndex--;
    	}
    	
    	return ret;
    }
    
    // copyDown omitted because it is provided by board.setFromBoard(otherBoard)
    
    private void clrMovesBelow(int stackOffset) {
    	// wipe the moves in bestMoves at the indicated stackOffset
    	// used in cases where no move chain is valid (like checkmate, stalemate, pruning, etc)
    	// NOTE: clears straight down below stackOffset, does not clear further depths
    	for (int tempIndex = stackOffset; tempIndex != depthLimit; tempIndex++) {
    		bestMoves[stackOffset][tempIndex][0] = 0xff;
    		bestMoves[stackOffset][tempIndex][1] = 0xff;
    	}
    }
    
    private int negamax(int alpha, int beta, int stackAccess) {
    	if (verbose >= 20) 
    		log.printf("Called into negamax with alpha = %d, beta = %d, and depth %d%n", alpha, beta, stackAccess);
    	// KEY POINT: stackOffset and the depth are the same thing, but the name stackOffset is used
    	//            because it's more frequently used as a displacement into boardStack
    	
    	// first, leafs
    	if (stackAccess == depthLimit) {
    		if (verbose >= 20) 
    			log.printf("Returning from leaf clause with value %d%n", boardStack[stackAccess].getScore());
    		return boardStack[stackAccess].getScore();
    	}
    	
    	if (verbose >= 30) 
    		log.printf("Parent board of nodes is: %n%s%n", boardStack[stackAccess].toString());
    	
    	ArrayList<ArrayList<Integer>> childMoves = new ArrayList<ArrayList<Integer>>();
    	Board parent = boardStack[stackAccess];
    	parent.enumerateMoves(childMoves);
    	if (verbose >= 40)
    		log.printf("Enumerated moves as childMoves successfully%n");
    	
    	boolean playableChildren =            false;
    	boolean pruned           =            false;
    	int bestValue            =         -9999999; // sentinel
    	boolean parentInCheck    = parent.isCheck();
    	if (verbose >= 30)
    		log.printf("Determined parent board check status as %s. Parent board is: %n%s%n", parentInCheck, boardStack[stackAccess].toString());
    	
    	// begin child-handling loop
    	for (int childIndex = 0; childIndex < 128; childIndex++) {
    		if (childIndex < childMoves.size() && childMoves.get(childIndex).get(0) != 0xff) {
    			Board child = boardStack[stackAccess + 1];
    			child.setFromBoard(parent);
    			child.makeMove(childMoves.get(childIndex).get(0), childMoves.get(childIndex).get(1), defaultPromotion);
    			// setHistory omitted because the checkRepititionDraw method does this work itself
    			
    			boolean childInCheck = child.isCheck();
    			if (verbose >= 20)
    				log.printf("Made child with move %d %d%n", childMoves.get(childIndex).get(0), childMoves.get(childIndex).get(1));
    			if (verbose >= 30)
    				log.printf("Determined child board check status to be %s, child board is: %n%s%n", childInCheck, child.toString());
    			
    			if (!childInCheck) {
    				// we haven't flipped yet, so the white-ish king from the parent is being evaluated for check.
    				// this makes sense, because it means that childInCheck is an indication of whether the move
    				// we just made put ourselves in check
    				
    				playableChildren = true;
    				int cValue = -9999999; // sentinel
    				
    				// we need to run pre-recursion checks, because this child may not be a playable position
    				if (child.getHalfmoves() == 50) {
    					cValue = -1; // draw reluctance
    					clrMovesBelow(stackAccess + 1);
    					if (verbose >= 20)
    						log.printf("No recursion due to 50 move draw rule%n");
    				}
    				else if (checkRepetitionDraw(stackAccess + 1)) {
    					cValue = -1;
    					clrMovesBelow(stackAccess + 1);
    					if (verbose >= 20)
    						log.printf("Did not recur due to 3x repetition rule%n");
    				}
    				else {
    					// now that the pre-recursion checks have passed, we can safely flip and recur.
    					if (verbose >= 40)
    						log.printf("beta = %d, alpha = %d%n", beta, alpha);
    					
    					child.flipBoard(child);
    					
    					if (verbose >= 40)
    						log.printf("beta = %d, alpha = %d%n", beta, alpha);
    					cValue = -1 * negamax(-beta, -alpha, stackAccess + 1); // recursive call. See Wikipedia or other resources for why alpha/beta flip and invert
    					if (verbose >= 40)
    						log.printf("Completed recursion to depth %d and returned to depth %d%n", stackAccess + 1, stackAccess);
    					nodeCount++;
    					// DO NOT KEEP THIS IN FOREVER
    					if (nodeCount % 10000 == 0)
    					    System.out.println("Approximate nodes so far: " + nodeCount);
    				}
    				
    				// bestMoves must have something in stackAccess + 1, even if it's empty sentinels.
    				// if we have a new best move, it must be copied up.
    				if (cValue > bestValue) {
    					if (verbose >= 50)
    						log.printf("Determined cValue %d was greater than bestValue %d%n", cValue, bestValue);
    					
    					bestValue = cValue;
    					
    					// put new best move on top, copy in best moves below
    					if (verbose >= 50)
    						log.printf("New values %d %d placed into bestMoves%n", childMoves.get(childIndex).get(0), childMoves.get(childIndex).get(1));
    					bestMoves[stackAccess][stackAccess][0] = childMoves.get(childIndex).get(0);
    					bestMoves[stackAccess][stackAccess][1] = childMoves.get(childIndex).get(1);
    					
    					for (int tempIndex = stackAccess + 1; tempIndex < depthLimit; tempIndex++) {
    						bestMoves[stackAccess][tempIndex][0] = bestMoves[stackAccess + 1][tempIndex][0];
    						bestMoves[stackAccess][tempIndex][1] = bestMoves[stackAccess + 1][tempIndex][1];
    					}
    					
    					if (verbose >= 50)
    						log.printf("Completed copy of bestMoves without infinite looping%n");
                        // update alpha
    			        if (verbose >= 60) 
    			        	log.printf("Updating alpha to " + bestValue + "%n");
    			        alpha = bestValue;
    			        
    			        // check bottom line - if this child is a new worst, the opponent will pick something
    			        // AT LEAST this bad, which means that we should break.
    			        if (alpha >= beta) {
    			        	pruned = true; // AT LEAST this bad - we might not have found the worst, so we need to avoid letting this node tie
    			        	if (verbose >= 20)
    			        		log.printf("Determined alpha %d was >= beta %d and pruned the node%n", alpha, beta);
    			        	break;
    			        }
    				}
    			}
    		}
    		// this line is associated with the same scope as 117, within the child checking loop.
    		// we will not get here from a pruning break. We are only here to break if there are no more children.
    		else 
    			break;
    	}
    	
    	// outside the child checking loop
        if (!playableChildren) {
        	// with no playable children, a checkmate/stalemate resolution has to be made
        	if (parentInCheck) {
        		// unresolved check from parent = checkmate
        		clrMovesBelow(stackAccess);
        		if (verbose >= 20)
        			log.printf("Determined checkmate at depth %d and returned depth-sensitive sentinel", stackAccess);
        		return -9999999 + stackAccess; // more distant checkmates are less bad than less distant ones
        	}
        	else {
        		// stalemate
        		clrMovesBelow(stackAccess);
        		if (verbose >= 20) 
        			log.printf("Determined stalemate at depth %d and returned -1", stackAccess);
        		return -1; // contempt of draw
        	}
        }
        
        else if (pruned) {
        	// a pruned node found ONE child that was worse than the bottom line, but might have had
        	// even worse children which were never scored. Thus, a pruned node is potentially
        	// infinitely bad
        	clrMovesBelow(stackAccess);
        	if (verbose >= 30) 
        		log.printf("Determined pruned exit from depth %d and returned sentinel", stackAccess);
        	return 100000000; // most aggressive possible negative sentinel - MAX because this node must look bad to the node
        	                          // ABOVE us so that they don't pick it, since that's who determined if we pruned it to begin with.
        }
        
        else {
        	// return the best value with bestMoves in place
        	if (verbose >= 40)
        		log.printf("Made normal exit from depth %d returning value %d", stackAccess, bestValue);
        	return bestValue;
        }
    }
    
    public static void main(String[] args) throws IOException {
    	ChessHelpers.setup();
    	final int dAlpha = -100000000;
    	final int dBeta  = 100000000;
    	PrintWriter err = new PrintWriter(new FileWriter("./negamax.err"));
    	Engine e = new Engine(err, 0, args[0]);
    	System.out.println(e.getCBoard());
    	System.out.println("Ending score (extremely large values are checkmates): " + e.negamax(dAlpha, dBeta, 0));
    	System.out.println("Final node count: " + e.getNodeCount());
    	System.out.println("Final moves sequence: ");
    	for (int m = 0; m < e.getBestMoves()[0].length; m++)
    		if (e.getBestMoves()[0][m][0] == 0xff)
    			break;
    		else
    			if (m % 2 == 1)
    				System.out.println(ChessHelpers.indexToTwoChar(ChessHelpers.mirrorIndex(e.getBestMoves()[0][m][0])) + ChessHelpers.indexToTwoChar(ChessHelpers.mirrorIndex(e.getBestMoves()[0][m][1])));
    			else
    				System.out.println(ChessHelpers.indexToTwoChar(e.getBestMoves()[0][m][0]) + ChessHelpers.indexToTwoChar(e.getBestMoves()[0][m][1]));;
        err.close();
    }
}
