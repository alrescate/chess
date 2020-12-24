package JChess;
import java.util.HashMap;
import java.util.ArrayList;

// TWO IMPORTANT DIFFERENCES BETWEEN C++ CODE AND THIS
// THE ORDER OF THE PIECES IS, ASCENDING, P R N B Q K
// THE COLOR BIT IS LOW WHEN THE PIECE IS WHITE

public class ChessHelpers {
	
	// initialize tables to convert between various representations of information, like indices to square names (0 = a8, etc)
	static final String defaultFEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0";
	
    static HashMap<String, Integer> TwoCharToIndexTable;
    static final String[] IndexToTwoCharTable = { "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8", 
                                                  "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7", 
                                                  "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6", 
                                                  "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5", 
                                                  "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4", 
                                                  "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3", 
                                                  "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2", 
                                                  "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1" };
    static HashMap<String, Integer> StrToICode;
    static final String[] ICodeToStr = { "0",  "P",  "R",  "3",  "N",  "5",  "6",  "7", 
    	                                 "B",  "9",  "10", "11", "12", "13", "14", "15", 
    	                                 "Q",  "17", "18", "19", "20", "21", "22", "23", 
    	                                 "24", "25", "26", "27", "28", "29", "30", "31", 
    	                                 "K",  "33", "34", "35", "36", "37", "38", "39", 
    	                                 "40", "41", "42", "43", "44", "45", "46", "47", 
    	                                 "48", "49", "50", "51", "52", "53", "54", "55", 
    	                                 "56", "57", "58", "59", "60", "61", "62", "63", 
    	                                 "64", "p",  "r",  "67", "n",  "69", "70", "71", 
    	                                 "b",  "73", "74", "75", "76", "77", "78", "79", 
    	                                 "q",  "81", "82", "83", "84", "85", "86", "87", 
    	                                 "88", "89", "90", "91", "92", "93", "94", "95",
    	                                 "k" };
    
    // constants for piece values, used in scoring, and the sentinel "bad" for when values shouldn't be accessed
    static final int bad      = 9999;
    static final int wPawnV   = 100;
    static final int wRookV   = 500;
    static final int wKnightV = 350;
    static final int wBishopV = 350;
    static final int wQueenV  = 800;
    // no king!
    static final int bPawnV   = -100;
    static final int bRookV   = -500;
    static final int bKnightV = -350;
    static final int bBishopV = -350;
    static final int bQueenV  = -800;
    // no king!
    
    // table is spaced out so that piece codes can be used as indices, speeding things up
    static final int[] scoreTable = {      bad, wPawnV, wRookV, bad, wKnightV, bad, bad, bad,
    		                          wBishopV,    bad,    bad, bad,      bad, bad, bad, bad,
    		                           wQueenV,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad, bPawnV, bRookV, bad, bKnightV, bad, bad, bad,
    		                          bBishopV,    bad,    bad, bad,      bad, bad, bad, bad,
    		                           bQueenV,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad,    bad,    bad, bad,      bad, bad, bad, bad,
    		                               bad };
    
    
    static int[][][] pathTable; 
    static int[] flipTable;
    static int[][][] physTable;
    
    // constants for piece codes
    static final int empty   = 0x80;
    static final int wPawn   = 0x01;
    static final int wRook   = 0x02;
    static final int wKnight = 0x04;
    static final int wBishop = 0x08;
    static final int wQueen  = 0x10;
    static final int wKing   = 0x20;
    
    static final int blackMask = 0x40;
    static final int bPawn   = wPawn   | blackMask;
    static final int bRook   = wRook   | blackMask;
    static final int bKnight = wKnight | blackMask;
    static final int bBishop = wBishop | blackMask;
    static final int bQueen  = wQueen  | blackMask;
    static final int bKing   = wKing   | blackMask;
    
    // arrays defined so that they can be looped through in methods like ranomizeBoard and isBlackControlled
    static final int[] pieceArray = { wPawn, wRook, wKnight, wBishop, wQueen, wKing,
                                      bPawn, bRook, bKnight, bBishop, bQueen, bKing };
    static final int[] enPassantTargets = { 16, 17, 18, 19, 20, 21, 22, 23, 
    		                                40, 41, 42, 43, 44, 45, 46, 47 };
    static final int[] brArray = { wRook, wBishop };
    
    static final int allCastles  = 15;
    static final int noCastles   =  0;
    static final int noEnPassant = 0xff;
    
    static final int noTarget = 0xff;
    static ArrayList<Integer> noHighlights;
    
    // square index constants for testLegality
    static final int kingStart          = 60;
    static final int kingCastleThrough  = 61;
    static final int kingCastleEnd      = 62;
    static final int queenCastleThrough = 59;
    static final int queenCastleEnd     = 58;
	
	public static void setup() {
		// make char->ind table
		TwoCharToIndexTable = new HashMap<String, Integer>();
		StrToICode          = new HashMap<String, Integer>();
		TwoCharToIndexTable.put("a8", 0); TwoCharToIndexTable.put("a7", 8);  TwoCharToIndexTable.put("a6", 16); TwoCharToIndexTable.put("a5", 24); TwoCharToIndexTable.put("a4", 32); TwoCharToIndexTable.put("a3", 40); TwoCharToIndexTable.put("a2", 48); TwoCharToIndexTable.put("a1", 56);
		TwoCharToIndexTable.put("b8", 1); TwoCharToIndexTable.put("b7", 9);  TwoCharToIndexTable.put("b6", 17); TwoCharToIndexTable.put("b5", 25); TwoCharToIndexTable.put("b4", 33); TwoCharToIndexTable.put("b3", 41); TwoCharToIndexTable.put("b2", 49); TwoCharToIndexTable.put("b1", 57);
		TwoCharToIndexTable.put("c8", 2); TwoCharToIndexTable.put("c7", 10); TwoCharToIndexTable.put("c6", 18); TwoCharToIndexTable.put("c5", 26); TwoCharToIndexTable.put("c4", 34); TwoCharToIndexTable.put("c3", 42); TwoCharToIndexTable.put("c2", 50); TwoCharToIndexTable.put("c1", 58);
		TwoCharToIndexTable.put("d8", 3); TwoCharToIndexTable.put("d7", 11); TwoCharToIndexTable.put("d6", 19); TwoCharToIndexTable.put("d5", 27); TwoCharToIndexTable.put("d4", 35); TwoCharToIndexTable.put("d3", 43); TwoCharToIndexTable.put("d2", 51); TwoCharToIndexTable.put("d1", 59);
		TwoCharToIndexTable.put("e8", 4); TwoCharToIndexTable.put("e7", 12); TwoCharToIndexTable.put("e6", 20); TwoCharToIndexTable.put("e5", 28); TwoCharToIndexTable.put("e4", 36); TwoCharToIndexTable.put("e3", 44); TwoCharToIndexTable.put("e2", 52); TwoCharToIndexTable.put("e1", 60);
		TwoCharToIndexTable.put("f8", 5); TwoCharToIndexTable.put("f7", 13); TwoCharToIndexTable.put("f6", 21); TwoCharToIndexTable.put("f5", 29); TwoCharToIndexTable.put("f4", 37); TwoCharToIndexTable.put("f3", 45); TwoCharToIndexTable.put("f2", 53); TwoCharToIndexTable.put("f1", 61);
		TwoCharToIndexTable.put("g8", 6); TwoCharToIndexTable.put("g7", 14); TwoCharToIndexTable.put("g6", 22); TwoCharToIndexTable.put("g5", 30); TwoCharToIndexTable.put("g4", 38); TwoCharToIndexTable.put("g3", 46); TwoCharToIndexTable.put("g2", 54); TwoCharToIndexTable.put("g1", 62);
		TwoCharToIndexTable.put("h8", 7); TwoCharToIndexTable.put("h7", 15); TwoCharToIndexTable.put("h6", 23); TwoCharToIndexTable.put("h5", 31); TwoCharToIndexTable.put("h4", 39); TwoCharToIndexTable.put("h3", 47); TwoCharToIndexTable.put("h2", 55); TwoCharToIndexTable.put("h1", 63);
		TwoCharToIndexTable.put("-", noEnPassant);
				
		// make str->icode table
		StrToICode.put("P", wPawn);
		StrToICode.put("R", wRook);
		StrToICode.put("N", wKnight);
		StrToICode.put("B", wBishop);
		StrToICode.put("Q", wQueen);
		StrToICode.put("K", wKing);
		StrToICode.put("p", bPawn);
		StrToICode.put("r", bRook);
		StrToICode.put("n", bKnight);
		StrToICode.put("b", bBishop);
		StrToICode.put("q", bQueen);
		StrToICode.put("k", bKing);
		
		// make flip table
		int i = 0;
		flipTable = new int[32];
		for (int r = 0; r < 4; r++) { // it's only half length because it's being used to associate indices to flip with
			for (int c = 0; c < 8; c++) {
				flipTable[i++] = rctoi(7-r, c);
			}
		}
		
		// allocate some room in pathTable - NOTE: path table is for all the squares passed through between any given start and end
		pathTable = new int[64][64][8]; // these numbers come from 64*64 (froms * tos) and the longest length on the board, even though 6 is the actual path depth limit
		makePathTable();
				
		// phys table, arranged pieces->square[from]->squares[to]
		// highest key is 32 (pawns) so 33 size
		physTable = new int[33][64][32];
		makePhysTable();
		
		noHighlights = new ArrayList<Integer>();
	}
	
	public static boolean isValidPieceKey(int c) {
		// meant to exclude bad values from being put into arrays of piece keys, ie empty with color bit set
		return (c == wPawn || c == wRook || c == wKnight || c == wBishop || c == wQueen || c == wKing ||
				c == bPawn || c == bRook || c == bKnight || c == bBishop || c == bQueen || c == bKing || c == empty);
	}
	
	public static boolean isWhitePiece(int piece) {
		return ChessHelpers.isValidPieceKey(piece) && piece < ChessHelpers.blackMask;
	}
	
	public static boolean isBlackPiece(int piece) {
		return ChessHelpers.isValidPieceKey(piece) && piece > ChessHelpers.blackMask;
	}
	
	// flipping color bit
	public static int colorChange(int p) {
		p ^= blackMask;
		if (p == (empty | blackMask)) return empty; // don't allow colored empty squares, so that testing emptiness isn't a nightmare
		if (!isValidPieceKey(p))      return bad;   // if the result of the color flip isn't a piece key, the input wasn't either
		else                          return p;
	}
	
	public static int rctoi(int r, int c) {
		return (r*8+c); // 8 squares per row, plus the current column
	}
	
	public static void itorc(int i, int[] rc) {
		// fills into an array reference taken as a parameter so that arrays need not be returned
		rc[0] = i/8;
		rc[1] = i%8;
	}
	
	public static int itor(int i) {
		return i / 8;
	}
	
	public static int itoc(int i) {
		return i % 8;
	}
	
	public static int mirrorIndex(int i) {
		// does not use flipTable because flipTable only includes half of the board, with the presumption being that indices are being paired
		// with their counterparts in the other half. This can mirror any index.
		return rctoi(7-itor(i), itoc(i));
	}
	
	public static int rotateIndex(int i) {
		// mirroring is necessary for changing white into black, but rotation is necessary for looking at the board from the perspective of black
		return 63-i;
	}
	
	public static String movePairToTwoChar(int mS, int mE) {
		return IndexToTwoCharTable[mS] + IndexToTwoCharTable[mE];
	}
	
	public static void mirrorMovePair(int[] mp, int [] nmp) {
		nmp[0] = mirrorIndex(mp[0]);
		nmp[1] = mirrorIndex(mp[1]);
	}
	
	public static String indexToTwoChar(int i) {
		return IndexToTwoCharTable[i];
	}
	
	public static boolean rcOnBoard(int r, int c) {
		// checks that a hypothetical r/c pair is on an 8x8 board
		return (r < 8) && (c < 8) && (r >= 0) && (c >= 0);
	}
	
	private static void makePathTable() {
		// stuff to code for nulls
		for (int o = 0; o < 64; o++) {
			for (int i = 0; i < 64; i++) {
				for (int j = 0; j < 8; j++) {
					pathTable[o][i][j] = 0xff;
				}
			}
		}
		
		for (int fromI = 0; fromI < 64; fromI++) {
			for (int toI = 0; toI < 64; toI++) {
				// define utility terms
				int lowerI = (fromI > toI)?toI:fromI;
				int upperI = (fromI > toI)?fromI:toI;
				
				int lowerIR = itor(lowerI);
				int lowerIC = itoc(lowerI);
				int upperIR = itor(upperI);
				int upperIC = itoc(upperI);
				
				boolean foundPath = false;
				
				int start = 0, stop = 0, step = 0;
				
				if      (upperIR == lowerIR) { start = lowerI+1; stop = upperI; step = 1; foundPath = true; } // rankwise motion
				else if (upperIC == lowerIC) { start = lowerI+8; stop = upperI; step = 8; foundPath = true; } // columnwise motion
				else {
					// diagonals are fundamentally different from straight motions, so they are stylistically separated 
					if      ((upperIC < lowerIC) && ((upperI - lowerI) % 7) == 0) { start = lowerI+7; stop = upperI; step = 7; foundPath = true; }
					else if ((upperIC > lowerIC) && ((upperI - lowerI) % 9) == 0) { start = lowerI+9; stop = upperI; step = 9; foundPath = true; }
				}
				
				if (foundPath) {
					for (int dest = start, writePointer = 0; dest < stop; dest += step, writePointer++) {
						pathTable[fromI][toI][writePointer] = dest;
					}
				}
			}
		}
	}
	
	private static void listRookMoves(int fromI, int[] dest) {
		// because you can have no more than 14 possible rook moves (2*(8-1)) 
		// dest should only have 14 values. We will here use 32 as a standard.
		int fromIR = itor(fromI);
		int fromIC = itoc(fromI);
		for (int i = 0; i < 32; i++) {
			dest[i] = 0xff;
		}
		
		int writepointer = 0;
		for (int c = 0; c < 8; c++) { if (c != fromIC) dest[writepointer++] = rctoi(fromIR, c); } // row-constant destinations
		for (int r = 0; r < 8; r++) { if (r != fromIR) dest[writepointer++] = rctoi(r, fromIC); } // col-constant destinations		
	}
	
	private static void listBishopMoves(int fromI, int[] dest) {
		// because you can have no more than 14 possible rook moves (2*(8-1))
		// dest should only have 14 values. We will here use 32 as a standard.
		int fromIR = itor(fromI);
		int fromIC = itoc(fromI);
		for (int i = 0; i < 32; i++) {
			dest[i] = 0xff;
		}
		
		int writepointer = 0;
		for (int offset = 1; offset < 8; offset++) {
			// we'll need all of these to form the legs of the diagonals
			int rDec = fromIR - offset;
			int cDec = fromIC - offset;
			int rInc = fromIR + offset;
			int cInc = fromIC + offset;
			
			// check that the legs are on the board, then add their current values
			// in a spiral-out motion from the fromI
			if (rInc < 8) {
				if (cInc < 8) {
					// bottom-right arm of the spiral
					dest[writepointer++] = rctoi(rInc, cInc);
				}
				if (cDec >= 0) {
					// bottom-left arm of the spiral
					dest[writepointer++] = rctoi(rInc, cDec);
				}
			}
			if (rDec >= 0) {
				if (cInc < 8) {
					// upper-right arm of the spiral
					dest[writepointer++] = rctoi(rDec, cInc);
				}
				if (cDec >= 0) {
					// upper-left arm of the spiral
					dest[writepointer++] = rctoi(rDec, cDec);
				}
			}
		}
	}
	
	private static void generateKnightDestinations(int r, int c, int[][] dest) {
		// here dest is assumed to be [8][2]
		// on-board status is not checked because listKnightMoves does that
		// this was copied from C++, any errors also appear there
		dest[0][0] = r + 2;
		dest[0][1] = c + 1;

		dest[1][0] = r + 2;
		dest[1][1] = c - 1;

		dest[2][0] = r - 2;
		dest[2][1] = c + 1;

		dest[3][0] = r - 2;
		dest[3][1] = c - 1;

		dest[4][0] = r + 1;
		dest[4][1] = c + 2;

		dest[5][0] = r - 1;
		dest[5][1] = c + 2;

		dest[6][0] = r + 1;
		dest[6][1] = c - 2;

		dest[7][0] = r - 1;
		dest[7][1] = c - 2;

	}
	
	private static void listKnightMoves(int fromI, int[] dest) {
		// no more than 8 knight destinations are possible, but 32
		// is used as a standard
		int fromIR = itor(fromI);
		int fromIC = itoc(fromI);
		for (int i = 0; i < 32; i++) {
			dest[i] = 0xff;
		}
		
		int writepointer = 0;
		int[][] candidates = new int[8][2];
		generateKnightDestinations(fromIR, fromIC, candidates);
		
		for (int i = 0; i < 8; i++) {
			int candidateRow = candidates[i][0];
			int candidateColumn = candidates[i][1];
			if (rcOnBoard(candidateRow, candidateColumn)) { // prune rc pairs not on board
				dest[writepointer++] = rctoi(candidateRow, candidateColumn);
			}
		}
	}
	
	private static void listPawnMoves(int fromI, int[] dest) {
		// no more than 4 possibilities exist, but 32 is the standard
		int fromIR = itor(fromI);
		int fromIC = itoc(fromI);
		for (int i = 0; i < 32; i++) {
			dest[i] = 0xff;
		}
		
		if (fromIR != 0) {
			// no pawns will exist on rank 0, therefore it will not be written into
			int writepointer = 0;
			dest[writepointer++] = rctoi(fromIR-1, fromIC); // moving forward
			
			if (fromIR == 6) dest[writepointer++] = rctoi(fromIR-2, fromIC);   // moving two
			if (fromIC > 0)  dest[writepointer++] = rctoi(fromIR-1, fromIC-1); // capture left
			if (fromIC < 7)  dest[writepointer++] = rctoi(fromIR-1, fromIC+1); // capture right
		}
	}
	
	private static void generateKingDestinations(int r, int c, int[][] dest) {
		// dest assumed to be [8][2]
		dest[0][0] = r - 1;  dest[1][0] = r - 1;  dest[2][0] = r - 1;
		dest[0][1] = c - 1;  dest[1][1] = c;      dest[2][1] = c + 1;

		dest[3][0] = r;         /*yourself*/      dest[4][0] = r;
		dest[3][1] = c - 1;     /*  here  */      dest[4][1] = c + 1;

		dest[5][0] = r + 1;  dest[6][0] = r + 1;  dest[7][0] = r + 1;
		dest[5][1] = c - 1;  dest[6][1] = c;      dest[7][1] = c + 1;
	}
	
	private static void listKingMoves(int fromI, int[] dest) {
		// at most 8 are possible, but 32 is the standard
		int fromIR = itor(fromI);
		int fromIC = itoc(fromI);
		for (int i = 0; i < 32; i++) {
			dest[i] = 0xff;
		}
		
		int writepointer = 0;
		
		// extra-special castling conditions 
		if (fromI == 60) {
			dest[0] = 62;
			dest[1] = 58;
			writepointer = 2;
		}
		
		int[][] candidates = new int[8][2];
		generateKingDestinations(fromIR, fromIC, candidates);
		
		for (int i = 0; i < 8; i++) {
			int candidateRow = candidates[i][0];
			int candidateCol = candidates[i][1];
			if (rcOnBoard(candidateRow, candidateCol)) {
				dest[writepointer++] = rctoi(candidateRow, candidateCol);
			}
		}
	}
	
	/* 
	 * In keeping with the stylization of the C++, the physical moves table is laid out in 3 dimensions
	 * Dimension 1: the piece key, in it's byte representation form
	 * Dimension 2: the square of the board which it sits on, 0-63
	 * Dimension 3: the legal moves, which are the leaves of the tree
	 * */
	private static void makePhysTable() {
		for (int square = 0; square < 64; square++) {   listPawnMoves(square, physTable[wPawn]  [square]); }
		for (int square = 0; square < 64; square++) {   listRookMoves(square, physTable[wRook]  [square]); }
		for (int square = 0; square < 64; square++) { listKnightMoves(square, physTable[wKnight][square]); }
		for (int square = 0; square < 64; square++) { listBishopMoves(square, physTable[wBishop][square]); }
		for (int square = 0; square < 64; square++) {   listRookMoves(square, physTable[wQueen] [square]); } // rook used in queen position because queen is not actually unique, it's bishop | rook
		for (int square = 0; square < 64; square++) {   listKingMoves(square, physTable[wKing]  [square]); }
		
		// handle the specialness of the queen
		for (int square = 0; square < 64; square++) {
			// there's no need to fill the physTable before this step because
			// the above calls already stuffed 0xff into the inactive slots
			int qptr = 0; while (physTable[wQueen][square][qptr] != 0xff) qptr++;
			int bptr = 0;
			while (physTable[wBishop][square][bptr] != 0xff) {
				// copy from the start of the bishop table to the end of the queen table
				// for this square, making queen = rook + bishop
				physTable[wQueen][square][qptr++] = physTable[wBishop][square][bptr++];
			}
		}
	}
	
	public static int[] getMoveList(int piece, int square) {
		if (isValidPieceKey(piece)) {
			return physTable[piece][square];
		}
		else {
			// NOTE: a valueless array is returned so that we will definitely throw an exception
			// on any attempt to use the array, but will not have to declare this behavior since
			// it should literally never happen and would indicate the whole program having gone 
			// astray. 
			return new int[0];
		}
	}
	
	public static int[] getPassedThrough(int fromI, int toI) {
		return pathTable[fromI][toI];
	}
	
	public static void main(String[] args) {
		// testers, meant to allow formal verification against the python and C++ implementations
		ChessHelpers.setup();
		int[] rc = new int[2];
		ChessHelpers.itorc(54, rc);
		System.out.println(rc[0] + " " + rc[1] + " is the r/c of 54");
		ChessHelpers.itorc(13, rc);
		System.out.println(rc[0] + " " + rc[1] + " is the r/c of 13");
		ChessHelpers.itorc(63, rc);
		System.out.println(rc[0] + " " + rc[1] + " is the r/c of 63");
		ChessHelpers.itorc(0, rc);
		System.out.println(rc[0] + " " + rc[1] + " is the r/c of 0");
		System.out.println("--------------------");
		
		System.out.println(ChessHelpers.rctoi(1, 4) + " is the index of 1, 4");
		System.out.println(ChessHelpers.rctoi(3, 7) + " is the index of 3, 7");
		System.out.println(ChessHelpers.rctoi(7, 7) + " is the index of 7, 7");
		System.out.println(ChessHelpers.rctoi(0, 0) + " is the index of 0, 0");
		System.out.println("--------------------");
		
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wRook]   + " is the score of R");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wKnight] + " is the score of N");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wBishop] + " is the score of B");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wQueen]  + " is the score of Q");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wKing]   + " is the score of K");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.wPawn]   + " is the score of P");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bRook]   + " is the score of r");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bKnight] + " is the score of n");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bBishop] + " is the score of b");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bQueen]  + " is the score of q");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bKing]   + " is the score of k");
		System.out.println(ChessHelpers.scoreTable[ChessHelpers.bPawn]   + " is the score of p");
		System.out.println("--------------------");
		
		System.out.println(ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("R"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("N"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("B"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("Q"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("K"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("B"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("N"))] +
		                   ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("R"))] +
				           ChessHelpers.ICodeToStr[ChessHelpers.colorChange(ChessHelpers.StrToICode.get("P"))] +
				           " is the swap of RNBQKBNRP");
		System.out.println("--------------------");
		
		System.out.println("22 flips to " + ChessHelpers.flipTable[22]);
		System.out.println("13 flips to " + ChessHelpers.flipTable[13]);
		System.out.println("31 flips to " + ChessHelpers.flipTable[31]);
		System.out.println("0 flips to "  + ChessHelpers.flipTable [0]);
		System.out.println("--------------------");
		
		System.out.println(ChessHelpers.IndexToTwoCharTable[32] + " is the 2-char of 32");
		System.out.println(ChessHelpers.IndexToTwoCharTable[41] + " is the 2-char of 41");
		System.out.println(ChessHelpers.IndexToTwoCharTable[63] + " is the 2-char of 63");
		System.out.println(ChessHelpers.IndexToTwoCharTable [0] + " is the 2-char of 0" );
		System.out.println("--------------------");
		
		int[] passedThrough = new int[8];
		passedThrough = ChessHelpers.getPassedThrough(1, 19);
		for (int i : passedThrough) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println("is passed through between 1 and 19");
		
		passedThrough = ChessHelpers.getPassedThrough(5, 16);
		for (int i : passedThrough) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println("is passed through between 5 and 16");
		
		passedThrough = ChessHelpers.getPassedThrough(0, 63);
		for (int i : passedThrough) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println("is passed through between 0 and 63");
		
		passedThrough = ChessHelpers.getPassedThrough(63, 0);
		for (int i : passedThrough) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println("is passed through between 63 and 0");
		System.out.println("--------------------");
		
		int[] physicalMoves = new int[32];
		physicalMoves = ChessHelpers.getMoveList(wRook, 16);
		System.out.print("A rook   on 16 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wQueen, 63);
		System.out.print("A queen  on 63 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wKing, 60);
		System.out.print("A king   on 60 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wBishop, 33);
		System.out.print("A bishop on 33 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wKnight, 46);
		System.out.print("A knight on 46 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wPawn, 52);
		System.out.print("A pawn   on 52 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wPawn, 31);
		System.out.print("A pawn   on 31 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
		
		physicalMoves = ChessHelpers.getMoveList(wPawn, 8);
		System.out.print("A pawn   on  8 can go to ");
		for (int i : physicalMoves) {
			System.out.print(i + " ");
			if (i == 255) break;
		}
		System.out.println();
	}
}
