package JChess;
import java.util.Random;
import java.util.ArrayList;
import java.util.Arrays;
import JChess.ChessHelpers;
import JChess.moveType;

public class Board {
    int[] squares;       // array of square codes, format ECKQBNRP
    int validCastles;    // 4-bit codes KQkq
    int enPassantTarget; // square index for active ep target
    int halfmoveClock;   // plies since pawn push or capture - for draws
    int plyCount;        // plies since start of game - for convenience of display
    int score;           // piece values with simple control weighting
    ArrayList<ArrayList<Integer>> pedigree;    // growing list of all to/from moves from the perspective of the player being white (every other is flipped) played in the game
    ArrayList<Integer>            hashHistory; // history of past hashes - for repetition draw checks
    boolean flipped;     // whether or not the colors are currently reversed from the true state 
    int hash;            // hash of the board - for repetition draw checks
    
    public Board() {  // implicitly verified by other tests
    	initialize();
    	clearBoard();
    }
    
    // copy constructor
    public Board(Board copy) { // implicitly verified by other tests 
    	initialize();
    	setFromBoard(copy);
    }
    
    // FEN construction
    public Board(String FEN) { // explicitly verified by testFEN
    	initialize();
    	setFromFEN(FEN);
    }
    
    private void setFromBoard(Board copy) { // implicitly verified by functionality of larger unit (copy constructor)
    	for (int i = 0; i < 64; i++) {
    		squares[i] = copy.getSquare(i);
    	}
    	validCastles = copy.getCastles();
    	enPassantTarget = copy.getEnPassant();
    	halfmoveClock = copy.getHalfmoves();
    	plyCount = copy.getPlyCount();
    	score = copy.getScore();
    	pedigree = new ArrayList<ArrayList<Integer>>(copy.getPedigree());
    	flipped = copy.getFlipped();
    	hash = copy.getHash();
    	hashHistory = copy.getHashHistory();
    } 
    
    private void initialize() { // implicitly verified by other tests
    	squares = new int[64];
    	pedigree = new ArrayList<ArrayList<Integer>>();
    	hashHistory = new ArrayList<Integer>();
    	ChessHelpers.setup(); // IMPORTANT - look here first for unexplained null pointers!
    }
    
    public void clearBoard() { // explicitly verified by board printing / examining in single step
    	for (int i = 0; i < 64; i++) {
    		squares[i] = ChessHelpers.empty;
    	}
    	validCastles = ChessHelpers.allCastles; // 0b1111, all flags high
    	enPassantTarget = ChessHelpers.noEnPassant;
    	halfmoveClock = 0;
    	plyCount = 0;
    	score = 0;
    	flipped = false;
    	hash = 0;
    }
    
    // accessors, mutators - implicitly verified by other tests
    public int[] getSquares() {
    	return squares;
    }
    public int getCastles() {
    	return validCastles;
    }
    public int getEnPassant() {
    	return enPassantTarget;
    }
    public int getHalfmoves() {
    	return halfmoveClock;
    }
    public int getPlyCount() {
    	return plyCount;
    }
    public int getScore() {
    	return score;
    }
    public ArrayList<ArrayList<Integer>> getPedigree() {
    	return pedigree;
    }
    public ArrayList<Integer> getHashHistory() {
    	return hashHistory;
    }
    public boolean getFlipped() {
    	return flipped;
    }
    public int getHash() {
    	return hash;
    }
    
    public void setSquares(int[] newSquares) {
    	squares = newSquares;
    }
    public void setCastles(int v) {
    	validCastles = v;
    }
    public void setEnPassant(int v) {
    	enPassantTarget = v;
    }
    public void setHalfmoves(int v) {
    	halfmoveClock = v;
    }
    public void incHalfmoves() {
    	halfmoveClock++;
    }
    public void setPlyCount(int v) {
    	plyCount = v;
    }
    public void incPlyCount() {
    	plyCount++;
    }
    public void setScore(int v) {
    	score = v;
    }
    public void setPedigree(ArrayList<ArrayList<Integer>> newPedigree) {
    	pedigree = newPedigree;
    }
    public void addToPedigree(int from, int to) {
    	ArrayList<Integer> t = new ArrayList<Integer>();
    	t.add(from); t.add(to);
    	pedigree.add(t);
    }
    public void setHashHistory(ArrayList<Integer> newHashHistory) {
    	hashHistory = newHashHistory;
    }
    public void setFlipped(boolean v) {
    	flipped = v;
    }
    public void setHash(int v) {
    	hash = v;
    }
    public void rehash() { // no flaws known, not verified
    	hash = Arrays.hashCode(squares)                     ^ 
    		   Integer.toString(validCastles).hashCode()    ^
    		   Integer.toString(enPassantTarget).hashCode() ^
    		   Boolean.toString(flipped).hashCode(); // flipped is hashed in so that palindromic boards - 
    	                                             // boards which appear the same when either white or black is to move - 
    	                                             // don't appear identical. Normally impetus would be factored into the hash
    	                                             // by hashing the active state, but palindromes would trick the hash.
    }
    
    public void setFromFEN(String FEN) { // explicitly verified by testFEN
    	// an FEN string looks like "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 1 0"
    	clearBoard();
    	String[] FENitems = FEN.split(" ");
    	String[] FENranks = FENitems[0].split("/");
    	int curSquare = 0;
    	
    	for (String rank: FENranks) {
    		for (char c : rank.toCharArray()) {
    			String s = new String(""+c);
    			if ("123456789".contains(s)) {
    				curSquare += Character.getNumericValue(c); // c used because of reliability
    			}
    			else if ("rnbqkpRNBQKP".contains(s)) {
    				squares[curSquare++] = ChessHelpers.StrToICode.get(s);
    			}
    			else {
    				System.out.println("Error: unknown character " + c); // no pipe to UCI interface, so System.out is safe to dump errors in
    				break;
    			}
    		}
    	}
    	
    	// color flag ignored for a moment because it has special handling
    	
    	String FENvalidCastles = FENitems[2];
    	if (FENvalidCastles.length() < 4) {
    		// validCastles guaranteed to start 0b1111 - clearBoard at top
    		if (!FENvalidCastles.contains("K")) {
    			validCastles ^= 8; // 8 because 0b1000 lines up with White Kingside flag
    		}
    		if (!FENvalidCastles.contains("Q")) {
    			validCastles ^= 4; // 4 because 0b0100 lines up with White Queenside flag
    		}
    		if (!FENvalidCastles.contains("k")) {
    			validCastles ^= 2; // 2 because 0b0010 lines up with Black Kingside flag
    		}
    		if (!FENvalidCastles.contains("q")) {
    			validCastles ^= 1; // 1 because 0b0001 lines up with Black Queenside flag
    		}
    	}
    	
    	enPassantTarget = ChessHelpers.TwoCharToIndexTable.get(FENitems[3]); // this is okay because there's a specific entry mapping "-" to noEnPassant
    	
    	halfmoveClock = Integer.parseInt(FENitems[4]);
    	
    	boolean FENcolor = FENitems[1].equals("w");
    	flipped = false;
    	
    	plyCount = Integer.parseInt(FENitems[5]) * 2;
    	if (!FENcolor) plyCount++;
    	
    	pedigree = new ArrayList<ArrayList<Integer>>(); // no pedigree is guaranteed to empty it out
    	
    	hashHistory = new ArrayList<Integer>();
    	
    	if (!FENcolor) flipBoard(this);
    	
    	scoreBoard();
    	rehash(); // always hash the boards in the active state, where the apparent white player is to play
    	          // this avoids falsely representing boards with a different active player as the same
    }
    
    private String replc(char c, int i, String s) { // implicitly verified by every time a board is printed vs single-step examination
    	char[] cr = s.toCharArray();
    	cr[i] = c;
    	return String.valueOf(cr);
    }
    
    public String toString() { // implicitly verified by every time a board is printed
    	String stringBoard = "  a b c d e f g h  \n" +
                             "8                 8\n" +
                             "7                 7\n" +
                             "6                 6\n" +
                             "5                 5\n" +
                             "4                 4\n" +
                             "3                 3\n" +
                             "2                 2\n" +
                             "1                 1\n" +
                             "  a b c d e f g h  \n";
    	
    	int rp = 0;
    	int wp = 22;
    	
    	for (; rp < 64; rp++) {
    		if (squares[rp] == ChessHelpers.empty) {
    			stringBoard = replc('.', wp, stringBoard);
    		}
    		else if (squares[rp] == 0xfeab ) {
    			stringBoard = replc('x', wp, stringBoard);
    		}
    		else {
    			stringBoard = replc(ChessHelpers.ICodeToStr[squares[rp]].toCharArray()[0], wp, stringBoard);
    		}
    		
    		if (rp % 8 == 7) wp += 6;
    		else             wp += 2;
    	}
    	
    	stringBoard += " White to move: "           + !flipped             + "\n" +
    			       " Valid Castles: "           + convertCastles()     + "\n" +
    			       " En Passant Target: "       + convertEnPassant()   + "\n" +
    			       " Half-moves towards draw: " + halfmoveClock        + "\n" +
    			       " Full moves: "              + plyCount/2           + "\n" +
    			       " Plys so far: "             + plyCount             + "\n" +
    			       " Score: "                   + score                + "\n" +
    			       " Flipped: "                 + flipped;
    	
    	if (pedigree.size() != 0) {
    		stringBoard += "\n Pedigree: ";
    		for (ArrayList<Integer> move: pedigree) {
    			stringBoard += ChessHelpers.IndexToTwoCharTable[move.get(0)] + ChessHelpers.IndexToTwoCharTable[move.get(1)];
    		}
    	}
    	
    	stringBoard += "\n Hash: " + hash;
    	return stringBoard;
    }
    
    private String convertCastles() { // implicitly verified by function of larger block toString
    	String castles = "";
    	if ((validCastles >> 3) != 0) castles += 'K';
    	else                          castles += '-';
    	
    	if ((validCastles & 4) != 0)  castles += 'Q';
    	else                          castles += '-';
    	
    	if ((validCastles & 2) != 0)  castles += 'k';
    	else                          castles += '-';
    	
    	if ((validCastles & 1) != 0)  castles += 'q';
    	else                          castles += '-';
    	
    	return castles;
    }
    
    private String convertEnPassant() { // implicitly verified by function of larger block toString
    	if (enPassantTarget != ChessHelpers.noEnPassant) return ChessHelpers.IndexToTwoCharTable[enPassantTarget];
    	else                                             return "-";
    }
    
    public String boardToFEN() { // explicitly verified by testFEN
    	int curEmpty = 0;
    	String FEN = "";
    	
    	for (int position = 0; position < 64; position++) {
    		int curItem = squares[position];
    		if (curItem != ChessHelpers.empty) {
    			if (curEmpty != 0) {
    				// if our current square is not empty but we had previously been accumulating empties,
    				// put the count into the string (see FEN standards)
    				FEN += Integer.toString(curEmpty);
    				curEmpty = 0;
    			}
    			FEN += ChessHelpers.ICodeToStr[curItem];
    		}
    		else {
    			// increment empty space tracker
    			curEmpty++;
    		}
    		if ((position % 8) == 7) {
    			// at eol, handle edge cases & add '/'
    			if (curEmpty != 0) {
    				FEN += Integer.toString(curEmpty);
    				curEmpty = 0;
    			}
    			if (position != 63) FEN += "/";
    		}
    	}
    	
    	String FENcastles = "";
    	if (validCastles == ChessHelpers.noCastles) {
    		FENcastles = "-";
    	}
    	else {
    		FENcastles = convertCastles().replaceAll("-", "");
    	}
    	
    	String sideToMove = (flipped)?"b":"w";
    	FEN += " " + sideToMove + " " + FENcastles + " " + convertEnPassant() + " " + halfmoveClock + " " + plyCount/2;
    	
    	return FEN;
    }
    
    public void randomizeBoard() { // implicitly verified by testFEN, others
    	clearBoard();
    	Random r = new Random();
    	for (int i = 0; i < 64; i++) {
            if ((int)(10*r.nextDouble()) > 6) {
            	// if we randomly chose to target this square (~40% chance)
            	squares[i] = ChessHelpers.pieceArray[(int)(r.nextDouble()*12)];
            }
    	}
    	
    	validCastles = (int)(r.nextDouble()*15);
    	enPassantTarget = ChessHelpers.enPassantTargets[(int)(r.nextDouble()*16)];
    	halfmoveClock = (int)(r.nextDouble()*49);
    	plyCount = ((int)(r.nextDouble()*(150-halfmoveClock)+halfmoveClock))&0xfffe;
    	scoreBoard();
    	pedigree = new ArrayList<ArrayList<Integer>>();
    	flipped = false;
    	rehash();
    }
    
    // checks done here to avoid harming internal representation - internal will always be valid,
    // though external accesses may be wrong. - implicitly verified by other tests
    public void setSquare(int piece, int i) {
    	if (ChessHelpers.isValidPieceKey(piece)) squares[i] = piece;
    }
    
    public void setSquare(int piece, int r, int c) {
    	if (ChessHelpers.isValidPieceKey(piece) && ChessHelpers.rcOnBoard(r, c)) squares[ChessHelpers.rctoi(r, c)] = piece;
    }
    
    public void setFlagSquare(int i) {
    	squares[i] = 0xfeab;
    } 
    
    public int getSquare(int i) {
    	return squares[i];
    }
    
    public int getSquare(int r, int c) {
    	return squares[ChessHelpers.rctoi(r, c)];
    }
    
    public boolean equals(Board other) { // unverified, some criteria may be invalid - is pedigree needed or damaging? Ply count?
    	return Arrays.equals(squares, other.getSquares()) &&
    		   validCastles == other.getCastles()         &&
    		   enPassantTarget == other.getEnPassant()    &&
    		   flipped == other.getFlipped()              &&
    		   halfmoveClock == other.getHalfmoves();
    }
    
    // implicitly verified by other tests 
    public boolean isEmpty(int i) {
    	return squares[i] == ChessHelpers.empty;
    }
    
    // implicitly verified by other tests
    public boolean isWhite(int i) {
    	return squares[i] < ChessHelpers.blackMask;
    }
    
    // implicitly verified by other tests
    public boolean isBlack(int i) {
    	return (!isEmpty(i)) && (squares[i] > ChessHelpers.blackMask);
    }
    
    // explicitly verified by testClearPath, testMakeMove
    public boolean isClearPath(int from, int to) {
    	boolean clear = true;
    	int[] passThrough = ChessHelpers.getPassedThrough(from, to);
    	for (int i: passThrough) {
    		if (i != 0xff) {
    		    if (!isEmpty(i)) {
    		    	clear = false;
    		    }
    		}
    		else break;
    	}
    	
    	return clear;
    }
    
    // incompletely explicitly verified by larger block isCheck, and by origin in python/C++ 
    public boolean isBlackControlled(int i) {
    	// check for knights
    	int[] directKJumps = ChessHelpers.getMoveList(ChessHelpers.wKnight, i);
    	for (int s: directKJumps) { // if a black knight can get to the square, black controls it.
    		if (s != 0xff) {
    		    if (squares[s] == ChessHelpers.bKnight) return true;
    		}
    		else break;
    	}
    	
    	// check for pawns
    	int targetR = ChessHelpers.itor(i) - 1; // because we don't use the row we're on, always the row above us
    	int targetC = ChessHelpers.itoc(i);
    	if (targetR >= 0) {
    		if (targetC-1 >= 0 && squares[ChessHelpers.rctoi(targetR, targetC-1)] == ChessHelpers.bPawn) return true;
    		if (targetC+1 < 8  && squares[ChessHelpers.rctoi(targetR, targetC+1)] == ChessHelpers.bPawn) return true;
    	}
    	
    	// direct king control of target
    	int[] directKControl = ChessHelpers.getMoveList(ChessHelpers.wKing, i);
    	for (int s: directKControl) {
    		if (s != 0xff) {
    		    if (squares[s] == ChessHelpers.bKing) return true;
    		}
    		else break;
    	}
    	
    	// (rook | bishop) | queen checks
    	for (int p: ChessHelpers.brArray) {
    		int[] potentialAttackers = ChessHelpers.getMoveList(p, i);
    		for (int attacker: potentialAttackers) {
    			if (attacker != 0xff) {
    			    if (isClearPath(attacker, i)) {
    			    	int attackingPiece = squares[attacker];
    			    	if (attackingPiece == (p | ChessHelpers.blackMask) || 
    			    	    attackingPiece == ChessHelpers.bQueen) return true;
    			    }
    			}
    			else break;
    		}
    	}
    	
    	// fall-through means no attackers to i
    	return false;
    	
    }
    
    public boolean isCheck() { // explicitly verified by larger block makeMove
    	for (int i = 0; i < 64; i++) {
    		if (squares[i] == ChessHelpers.wKing) {
    			return isBlackControlled(i);
    		}
    	}
    	
    	return false;
    }
    
    public void flipBoard(Board target) { // explicitly verified by testFlip
    	// each attribute is inverted across to the target from ourselves
    	// this is so that boards can flip into others (which is important
    	// for a stack-based engine if one is to be made as an extension).
    	
    	// BIG, IMPORTANT NOTE: THIS SETS THE FLIPPED FLAG
    	// IF YOU TRY TO FLIP A BOARD AND THEN USE THE FLIPPED FEN YOU WILL FAIL
    	// BECAUSE SETFROMFEN WILL UNFLIP IT FOR YOU. FORCE THIS FLAG LOW
    	// IF YOUR INTENTION IS TO CONVERT TO FEN AND THEN SET ANOTHER BOARD FROM THAT FEN
    	
    	target.setFlipped(!flipped);
    	for (int item1I = 0; item1I < 32; item1I++) {
    		// flip half of the board by swapping with the other half
    		int item2I = ChessHelpers.flipTable[item1I];
    		
    		int item1 = squares[item1I];
    		int item2 = squares[item2I];
    		
    		target.setSquare(ChessHelpers.colorChange(item1), item2I);
    		target.setSquare(ChessHelpers.colorChange(item2), item1I);
    	}
    	
    	int newValidCastles = validCastles;
    	int blackCastles = newValidCastles & 3; // low bits are black, only get those
    	newValidCastles >>= 2;                  // shift away black castles
    	newValidCastles |= (blackCastles << 2); // add in preserved castles
    	target.setCastles(newValidCastles);
    	
    	if (enPassantTarget != ChessHelpers.noEnPassant) {
    		if (enPassantTarget < 40) { // if we're on row 6, skip three rows down to 3
    			target.setEnPassant(enPassantTarget+24);
    		}
    		else {                      // if we're on row 3, skip three rows up to 6
    			target.setEnPassant(enPassantTarget-24);
    		}
    	}
    	else {
    		target.setEnPassant(ChessHelpers.noEnPassant);
    	}
    	
    	// this is a departure from the python - look here for bugs!
    	target.setHalfmoves(halfmoveClock);
    	target.setPlyCount(plyCount);
    	// end departure
    	target.setScore(score*-1);
    	target.setPedigree(pedigree);
    	target.rehash(); // this is also different - policy here is to hash active representations, not true states
    }
    
    public moveType testLegality(int from, int to) { // implicitly verified by larger block makeMove
    	// preconditioned by moves being in physical move table
    	// method does not check if the piece is allowed to move from where it is to "to"
    	int movingPiece = squares[from];
    	int destination = squares[to];
    	
    	moveType result = moveType.ILLEGAL;
    	
    	boolean clearPath = isClearPath(from, to);
    	
    	if (movingPiece == ChessHelpers.wKnight) clearPath = true;
    	if (clearPath) {
    		if (isEmpty(to)) {
    			if (movingPiece != ChessHelpers.wPawn) {
    				// moving a non-pawn through a clear path 
    				result = moveType.STANDARD_LEGAL;
    			}
    			else if (from-to == 16) {
    				// it is a pawn, did two ranks get traversed?
    				result = moveType.PAWN_MOVED_TWO;
    			}
    			else if ((enPassantTarget != ChessHelpers.noEnPassant) && (to == enPassantTarget)) {
    				// moving onto the target
    				result = moveType.CAPTURE_EN_PASSANT;
    			}
    			else if (to != from-8) {
    				// a pawn moves diagonally, but the square is empty
    				result = moveType.ILLEGAL;
    			}
    			else if (to < 8) {
    				// pawn moves onto the back rank
    				result = moveType.PROMOTION;
    			}
    			else {
    				// pawn moves legally forward
    				result = moveType.STANDARD_LEGAL;
    			}
    		}
    		else if (ChessHelpers.isBlackPiece(destination)) {
    			// if black and not a pawn, normal capture
    			if (movingPiece != ChessHelpers.wPawn) {
    				result = moveType.STANDARD_LEGAL;
    			}
    			else if (to == from-9 || to == from-7) {
    				// diagonal motion
    				result = moveType.STANDARD_LEGAL;
    			}
    			else {
    				result = moveType.ILLEGAL;
    			}
    		}
    		else if (ChessHelpers.isWhitePiece(destination)) {
    			// no capturing white piece
    			result = moveType.ILLEGAL;
    		}
    	}
    	else {
    		// not-clear paths
    		result = moveType.ILLEGAL;
    	}
    	
    	// castling is a bit different. First, deduce if this is a castling move
    	if (movingPiece == ChessHelpers.wKing && from == ChessHelpers.kingStart && 
    	   (to == ChessHelpers.kingCastleEnd  ||   to == ChessHelpers.queenCastleEnd)) {
    		result = moveType.ILLEGAL; // since it's now a castle, assume illegal again even if we met other conditions above
    		if (clearPath && isEmpty(to) && !isBlackControlled(ChessHelpers.kingStart)) {
    			// above determined if we castled out of check, now determine if we're castling in
    			if (to == ChessHelpers.kingCastleEnd) {
    				if ((validCastles >> 3) != 0 && !(isBlackControlled(ChessHelpers.kingCastleEnd) || isBlackControlled(ChessHelpers.kingCastleThrough))) {
    					// kingside castling is still available and we didn't go through check, therefore it's legal
    					result = moveType.CASTLE_KINGSIDE;
    				}
    			}
    			else {
    				// we don't need to check if queenside because we already know a castle was attempted
    				if ((validCastles & 4) != 0 && !(isBlackControlled(ChessHelpers.queenCastleEnd) || isBlackControlled(ChessHelpers.queenCastleThrough))) {
    					result = moveType.CASTLE_QUEENSIDE;
    				}
    			}
    		}
    	}
    	
    	// Contextual illegality: does this move put white in check? If so it is illegal.
    	// no metadata updates are made in this cheap version of the makeMove method because they don't matter;
    	// either black controls the square with the king on it or black doesn't, and the flags
    	// can't effect that. Rooks aren't moved because it isn't necessary in castling situations
    	
    	/* In depth: why aren't the rooks moved for castling situations?
    	 * There are two potential reasons why this handling of the lookahead can be wrong: false negatives and false positives.
    	 * False negative case: this function says that check does not occur, but in reality it does.
    	 *    - This is not a concern because the rook starts in the corner. There is nowhere for the rook to reveal by moving,
    	 *      and thus there cannot be any threat of check from any other part of the board because there is no more board in that direction.
    	 * False positive case: this function says that check does occur, but in reality it does not.
    	 *    - This is not a concern because the rook only shields the squares a1-f1 when sitting on f1. Pieces not on those squares won't
    	 *      have their ability to give check effected by the rook. Because that's purely a horizontal, there are only two pieces which could
    	 *      sit on it to give check: queens and rooks. However, in order to give check, they would need to have a clear path to g1, the king's
    	 *      location after it's been moved by this function. That requires them to either be:
    	 *        - on h1, which is impossible because the rook is there
    	 *        - on f1, which is impossible because then the king's path wouldn't be clear
    	 *        - on e1, which is impossible because the king had to start there
    	 *        - on a1-d1, which is impossible because then they would have a clear path through e1, putting the king in check (which he cannot castle out of).
    	 *        
    	 * In conclusion, this situation cannot arise.
    	 * */
    	Board lookahead = new Board(this);
    	lookahead.setSquare(movingPiece, to);
    	lookahead.setSquare(ChessHelpers.empty, from);
    	if (result == moveType.CAPTURE_EN_PASSANT) { // if we already determined this move was an attempt at a capture en passant, update the appropriate square
    		lookahead.setSquare(ChessHelpers.empty, to+8);
    	}
    	if (lookahead.isCheck()) {
    		result = moveType.ILLEGAL;
    	}
    	
    	return result;
    }
    
    public boolean makeMove(int from, int to, int promotion) { // explicitly verified by testMakeMove
    	int piece = squares[from];
    	moveType move = testLegality(from, to);
    	if (move == moveType.ILLEGAL) {
    		return false;
    	}
    	
    	boolean captured = !isEmpty(to);
    	
    	// it is now guaranteed that the move can be made
    	squares[to] = piece;
    	squares[from] = ChessHelpers.empty;
    	
    	// update metadata
    	enPassantTarget = ChessHelpers.noEnPassant; // wipe ep for now
    	switch (move) {
    	    case PAWN_MOVED_TWO:
    	        enPassantTarget = to + 8; // one rank below current position is the space moved over
    	        break;
    	    case CASTLE_KINGSIDE:
    	    	// manual updates at known positions must be made in case of castling
        		squares[63] = ChessHelpers.empty;
        		squares[61] = ChessHelpers.wRook;
        		break;
    	    case CASTLE_QUEENSIDE:
    	    	// manual updates at known positions must be made in case of castling
    	    	squares[56] = ChessHelpers.empty;
    	    	squares[59] = ChessHelpers.wRook;
    	    	break;
    	    case CAPTURE_EN_PASSANT:
    	    	// clear out the en passant captured square
    	    	squares[to+8] = ChessHelpers.empty;
    	    	break;
    	    case PROMOTION:
    	    	// upgrade the piece
    	    	squares[to] = promotion;
    	    	break;
		    default:
			    break;
    	}
    	
    	if (piece == ChessHelpers.wKing) {
    		validCastles &= 3; // wipe white's castles
    	}
    	else if (piece == ChessHelpers.wRook) {
    		if (from == 63) {
    			validCastles &= 7;
    		}
    		else if (from == 56) {
    			validCastles &= 11;
    		}
    	}
    	plyCount++;
    	ArrayList<Integer> moveMade = new ArrayList<Integer>();
    	if (flipped) {
    		moveMade.add(ChessHelpers.mirrorIndex(from));
    		moveMade.add(ChessHelpers.mirrorIndex(to));
    	}
    	else {
    		moveMade.add(from);
    		moveMade.add(to);
    	}
    	pedigree.add(moveMade);
    	
    	rehash();
    	hashHistory.add(hash);
    	scoreBoard();
    	
    	if (captured || piece == ChessHelpers.wPawn) halfmoveClock = 0;
    	else                                         halfmoveClock++;
    	return true;
    }
    
    private static int scoreWhitePieces(Board b) { // implicitly verified by function of larger block scoreBoard
    	// simple scoring - no positional analysis given here
    	int score = 0;
    	
    	for (int i: b.getSquares()) {
    		if (ChessHelpers.isWhitePiece(i)) {
    			score += ChessHelpers.scoreTable[i];
    		}
    	}
    	return score;
    }
    
    public void scoreBoard() { // explicitly tested by testScore
    	Board temp = new Board(this);
    	flipBoard(temp);
    	score = scoreWhitePieces(this)-scoreWhitePieces(temp);
    }
    
    public void enumerateMoves(ArrayList<ArrayList<Integer>> dest) { // unverified, but also probably unused (engine expansion only)
    	// precondition: dest is empty
    	int piece = 0;
    	for (int i = 0; i < 64; i++) {
    		piece = squares[i];
    		if (ChessHelpers.isWhitePiece(piece)) {
    			int[] candidates = ChessHelpers.getMoveList(piece, i);
    			for (int to: candidates) {
    				if (to != 0xff) {
    				    if (testLegality(i, to) != moveType.ILLEGAL) {
    				    	ArrayList<Integer> move = new ArrayList<Integer>();
    				    	move.add(i); move.add(to);
    				    	dest.add(move);
    				    }
    				}
    				else break;
    			}
    		}
    	}
    }
    
    public void enumerateMoves(int from, ArrayList<Integer> dest) { // NO LONGER VERIFIED!
    	// precondition: dest is empty
    	int piece = squares[from];
    	int[] candidates = ChessHelpers.getMoveList(piece, from);
    	for (int to: candidates) {
    		if (to != 0xff) {
    		    if (testLegality(from, to) != moveType.ILLEGAL) {
    		    	dest.add(to);
    		    }
    		}
    		else break;
    	}
    }
    
    private boolean containsPawns() {
    	for (int p: squares) {
    		if (p == ChessHelpers.wPawn || p == ChessHelpers.bPawn) return true;
    	}
    	return false;
    }
    
    private boolean containsRooks() {
    	for (int p: squares) {
    		if (p == ChessHelpers.wRook || p == ChessHelpers.bRook) return true;
    	}
    	
    	return false;
    }
    
    private boolean containsQueens() {
    	for (int p: squares) {
    		if (p == ChessHelpers.wQueen || p == ChessHelpers.bQueen) return true;
    	}
    	
    	return false;
    }
    
    private boolean containsTwoSameSideBishops() {
    	int wbc = 0;
    	int bbc = 0;
    	for (int p: squares) {
    		if      (p == ChessHelpers.wBishop)      wbc++;
    		else if (p == ChessHelpers.bBishop) bbc++;
    	}
    	if (wbc > 1 || bbc > 1) return true;
    	else                    return false;
    }
    
    private boolean containsSameSideBishopAndKnight() {
    	boolean wb = false, wn = false, bb = false, bn = false;
    	for (int p: squares) {
    		if      (p == ChessHelpers.wBishop) wb = true;
    		else if (p == ChessHelpers.wKnight) wn = true;
    		else if (p == ChessHelpers.bBishop) bb = true;
    		else if (p == ChessHelpers.bKnight) bn = true;
    	}
    	
    	if (wb && wn) return true;
    	if (bb && bn) return true;
    	
    	return false;
    }
    
    public resolution getGameResolution() { // unverified, but closely related to verified functions in C++
    	ArrayList<ArrayList<Integer>> moves = new ArrayList<ArrayList<Integer>>();
    	enumerateMoves(moves);
    	if (moves.size() == 0) {
            if (isCheck())
    		    // no legal moves found and in check, therefore this is checkmate on white
    		    return resolution.CHECKMATE;
    	    else 
        		// no moves but not in check, stalemate
        		return resolution.STALEMATE; 
    	}
    	if (halfmoveClock >= 50) {
    		return resolution.DRAWBY50;
    	}
    	int reps = 0;
    	for (int thishash: hashHistory) {
    		for (int j = 0; j < hashHistory.size(); j++) {
    			if (thishash == hashHistory.get(j)) reps++; // we do not exclude counting ourselves because the same board has to appear 3 times
    			                                            // and the instance we are on still counts in that.
    		}
    		if (reps >= 3) { // we should never exceed three but just in case something happens this is safer
    			return resolution.DRAWBYREPEAT;
    		}
    		else {
    			reps = 0;
    		}
    	}
    	
    	// check the various ways in which material can be insufficient, if all of them are lacking then the position is either:
    	//   - an inevitable draw by some other means in the future, or
    	//   - not a draw
    	if (!containsPawns() && !containsQueens() && !containsRooks() && !containsTwoSameSideBishops() && !containsSameSideBishopAndKnight()) {
    		return resolution.DRAWINSUFFICIENT;
    	}
    	
    	return resolution.NOEND;
    }
    
	public static void main(String[] args) {
        
	}

}
