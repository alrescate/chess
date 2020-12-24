package JChess;
import JChess.Board;
import java.util.ArrayList;
public class BoardTester {
    public static void testFEN() {
    	Board tba = new Board();
    	Board tbb = new Board();
    	for (int i = 0; i < 10000; i++) {
    		tba.randomizeBoard();
    		String FENa = tba.boardToFEN();
    		tbb.setFromFEN(FENa);
    		if (!tba.equals(tbb)) {
    			System.out.println("Failed!");
    			System.out.println(tba);
    			System.out.println(tbb);
    			System.out.println(FENa);
    		}
    	}
    }
    
    public static void testIndexAndTwoChar() {
    	for (int i = 0; i < 64; i++) {
    		if (ChessHelpers.TwoCharToIndexTable.get(ChessHelpers.IndexToTwoCharTable[i]) != i) {
    			System.out.println("Failed to map " + i + " correctly.");
    		}
    	}
    }
    
    public static void testPhysTable() {
    	for (int p = 0; p < 6; p++) {
    	    for (int i = 0; i < 64; i++) {
    		    Board tb = new Board();
    		    int[] validMoves = ChessHelpers.getMoveList(ChessHelpers.pieceArray[p], i);
    		    for (int to: validMoves) {
    		    	if (to != 0xff) tb.setFlagSquare(to);
    		    	else break;
    		    }
    		    tb.setSquare(ChessHelpers.pieceArray[p], i);
    		    System.out.println(tb);
    	    }
        }
    }
    
    public static void testClearPath() {
    	Board tb = new Board();
    	tb.randomizeBoard();
    	for (int i = 0; i < 64; i++) {
    		for (int p = 0; p < 6; p++) {
    			int[] physicalDestinations = ChessHelpers.getMoveList(ChessHelpers.pieceArray[p], i);
    			Board display = new Board(tb);
    			for (int dest: physicalDestinations) {
    				if (dest != 0xff) {
    				    if (tb.isClearPath(i, dest) && tb.isEmpty(dest) && tb.isEmpty(i)) {
    					    display.setFlagSquare(dest);
    				    }
    				}
    				else break;
    			}
    			
    			display.setSquare(ChessHelpers.pieceArray[p], i);
    			System.out.println(tb);
    			System.out.println(display);
    		}
    	}
    }
    
    public static void testFlip() {
    	Board tb = new Board();
    	for (int i = 0; i < 10; i++) {
    		tb.randomizeBoard();
    		System.out.println(tb);
    		tb.flipBoard(tb);
    		System.out.println("Flipped is:\n" + tb);
    		System.out.println("\n-----------------------------\n-----------------------------\n-----------------------------");
    	}
    }
    
    public static void testMakeMove(String FENtest, boolean stop) {
    	Board tb = new Board(FENtest);
    	for (int i = 0; i < 64; i++) {
    		int piece = tb.getSquare(i);
    		if (piece != ChessHelpers.empty) {
    			if (ChessHelpers.isWhitePiece(piece)) {
    				int[] candidates = ChessHelpers.getMoveList(piece, i);
    				
    				ArrayList<ArrayList<Integer>> enumMoves = new ArrayList<ArrayList<Integer>>();
    				// tb.enumerateMoves(i, enumMoves);
    				for (int j = 0; j < enumMoves.size(); j++) {
    					System.out.print(ChessHelpers.IndexToTwoCharTable[enumMoves.get(j).get(0)] + ChessHelpers.IndexToTwoCharTable[enumMoves.get(j).get(1)] + " ");
    				}
    				System.out.println();
    				
    				for (int move: candidates) {
    					if (move != 0xff) {
    						Board mod = new Board(tb);
    						boolean r = mod.makeMove(i, move, ChessHelpers.wQueen);
    						if (r) {
    							Board modf = new Board();
    							mod.flipBoard(modf);
    						    System.out.println(ChessHelpers.IndexToTwoCharTable[i] + " " + ChessHelpers.IndexToTwoCharTable[move]);
	    					    System.out.println(tb);
    						    System.out.println(mod);
    						    System.out.println("MODF: \n" + modf);
    						    System.out.println(ChessHelpers.IndexToTwoCharTable[mod.getPedigree().get(0).get(0)] + " " + 
    					                       	   ChessHelpers.IndexToTwoCharTable[mod.getPedigree().get(0).get(1)]);
    						    System.out.println("White in check?: " +  mod.isCheck());
    						    System.out.println("Black in check?: " + modf.isCheck());
    						    System.out.println("\n-----------------------------\n-----------------------------\n-----------------------------");
    						}
    				    }
    					else break;
    				}
    			}
    		}
    	}
    	
    	if (!stop) {
    		System.out.println("Flip!");
    		tb.flipBoard(tb);
    		tb.setFlipped(false);
    		testMakeMove(tb.boardToFEN(), true);
    	}
    }
    
    public static void testScore(String FEN) {
    	Board tb = new Board(FEN);
    	System.out.println(tb);
    }
    
    public static void testCheck(String FEN) {
    	Board tb = new Board(FEN);
    	System.out.println(tb);
    	System.out.println(tb.isCheck());
    }
    
    public static void main(String[] args) {
    	System.out.println("Nothing should appear after this.");               testFEN();             System.out.println();
    	System.out.println("Nothing should appear after this.");               testIndexAndTwoChar(); System.out.println();
    	System.out.println("Each board should make sense.");                   testPhysTable();       System.out.println();
    	System.out.println("Each board should make sense, and be identical."); testClearPath();       System.out.println();
    	System.out.println("Each pair should be reversed.");                   testFlip();            System.out.println();
    	
    	System.out.println("All the moves you see here should be legal."); testMakeMove("8/8/8/8/8/8/Pk5P/R3K2R w KQkq - 0 0", false); System.out.println();
    	System.out.println("The scores should be accurate.");              testScore("3k3r/1b1pb3/4q1p1/1p6/6np/5N2/2Q2PPP/R1R3K1 w - - 0 0");  System.out.println();
    	System.out.println("The state of check should be accurate.");      testCheck("7k/R7/1R6/8/8/8/8/K7 w - - 0 0");                         System.out.println();
    }
}
