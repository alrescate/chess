#include <stdint.h>
#include <string>
#include <iostream>
#include <stdlib.h>
#include <HRand.h>
#include <Board.h>

Board Board::scratch;
HRand Board::r;

void testFEN() {
    Board tba, tbb;
    for (int i = 0; i < 10000; i++) {
        tba.randomizeBoard();
        std::string FENa = tba.boardToFEN();
        tbb.setFromFEN(FENa);
        if (!tba.equals(tbb)) {
        	std::cout << "Failed!"      << std::endl;
        	std::cout << tba.toString() << std::endl;
        	std::cout << tbb.toString() << std::endl;
        	std::cout << FENa           << std::endl;
        }
    }
}

void testIndexAndTwoChar() {
    for (int i = 0; i < 64; i++) {
        if (twoCharToIndex(twoCharNamingTable[i]) != i) {
        	std::cout << "Failed to map " << i << " correctly" << std::endl;
        }
    }
}

void testPhysTable() {
    for (int p = 0; p < 6; p++) {
        for (int i = 0; i < 64; i++) {
            Board tb;
            uint8_t* validMoves = getMoveList(pieceArray[p], i); 
            for (int i = 0; i < 32; i++) 
            	if (validMoves[i] != 0xff) 
            	    std::cout << (uint16_t)validMoves[i] << " "; 
                else break;
            std::cout << std::endl;
            for (int to = 0; to < 32; to++) {
                if (validMoves[to] != 0xff) tb.setFlag(validMoves[to]);
                else break;
            }
            tb.setSquare(pieceArray[p], i);
            std::cout << tb.toString() << std::endl;
        }
    }
}

void testClearPath() {
    Board tb;
    tb.randomizeBoard();
    for (int i = 0; i < 64; i++) {
    	if (tb.isEmpty(i)){
            for (int p = 0; p < 6; p++) {
                uint8_t* physicalDestinations = getMoveList(pieceArray[p], i);
                for (int j = 0; j < 32; j++) {
                    if (physicalDestinations[j] != 0xff) {
                	    std::cout << (uint16_t)physicalDestinations[j] << " ";
                    }
                    else break;
                }
                std::cout << std::endl;
                Board display(tb);
                for (int dest = 0; dest < 32; dest++) {
                    if (physicalDestinations[dest] != 0xff) {
                        if (tb.isClearPath(i, physicalDestinations[dest]) && tb.isEmpty(physicalDestinations[dest])) {
                            display.setFlag(physicalDestinations[dest]);
                        }
                    }
                    else break;
                }
                
                display.setSquare(pieceArray[p], i);
                std::cout << tb.toString() << std::endl;
                std::cout << display.toString() << std::endl;
                std::cout << "-----------------------\n""-----------------------\n""-----------------------" << std::endl;
            }
        }
    }
}

void testFlip() {
    Board tb;
    for (int i = 0; i < 10; i++) {
        tb.randomizeBoard();
        std::cout << tb.toString() << std::endl;
        tb.flipBoard();
        std::cout << "Flipped is:\n" << tb.toString() << std::endl;
        std::cout << "-----------------------\n""-----------------------\n""-----------------------" << std::endl;
    }
}

void testMakeMove(std::string FENtest, bool stop) {
    Board tb(FENtest);
    for (int i = 0; i < 64; i++) {
        uint8_t piece = tb.getSquare(i);
        if (piece != empty) {
            if (isWhitePiece(piece)) {
                uint8_t* candidates = getMoveList(piece, i);
                uint8_t enumMoves[128];
                
                tb.enumerateMoves(i, enumMoves);
                
                for (uint8_t move = 0; move < 32; move++) {
                    if (candidates[move] != 0xff) {
                        Board mod(tb);
                        bool r = mod.makeMove(i, candidates[move], wQueen);
                        if (r) {
                            Board modf;
                            mod.flipBoard(modf);
                            std::cout << twoCharNamingTable[i] << " " << twoCharNamingTable[candidates[move]] << std::endl;
                            std::cout << tb.toString() << std::endl;
                            std::cout << mod.toString() << std::endl;
                            std::cout << "MODF: \n" << modf.toString() << std::endl;
                            std::cout << "White in check?: " << mod.isCheck() << std::endl;
                            std::cout << "Black in check?: " << modf.isCheck() << std::endl;
                            std::cout << "-----------------------\n""-----------------------\n""-----------------------" << std::endl;
                        }
                    }
                    else break;
                }
            }
        }
    }
    
    if (!stop) {
    	std::cout << "FLIP!" << std::endl;
    	tb.flipBoard();
    	tb.setFlipped(false);
    	testMakeMove(tb.boardToFEN(), true);
    }
}

void testScore(std::string FEN) {
    Board tb(FEN);
    std::cout << tb.toString() << std::endl;
}

void testCheck(std::string FEN) {
    Board tb(FEN);
    std::cout << tb.toString() << std::endl;
    std::cout << tb.isCheck() << std::endl;
}

void testResolution(std::string FEN) {
    Board tb(FEN);
    std::cout << tb.toString() << std::endl;
    resolution r = tb.getGameResolution();
    
    if      (r == CHECKMATE)        std::cout << "CHECKMATE"        << std::endl;
    else if (r == STALEMATE)        std::cout << "STALEMATE"        << std::endl;
    else if (r == DRAWBY50)         std::cout << "DRAWBY50"         << std::endl;
    else if (r == DRAWINSUFFICIENT) std::cout << "DRAWINSUFFICIENT" << std::endl;
    else if (r == NOEND)            std::cout << "NOEND"            << std::endl;
}

int main(int argc, char** argv) {
	setup();
	std::cout << "Nothing should appear after this."               << std::endl; testFEN();             std::cout << std::endl;
	std::cout << "Nothing should appear after this."               << std::endl; testIndexAndTwoChar(); std::cout << std::endl;
	std::cout << "Each board should make sense"                    << std::endl; testPhysTable();       std::cout << std::endl;
	std::cout << "Each board should make sense, and be identical." << std::endl; testClearPath();       std::cout << std::endl;
	std::cout << "Each pair should be reversed."                   << std::endl; testFlip();            std::cout << std::endl;
	
	std::cout << "All the moves you see here should be legal"      << std::endl; testMakeMove("8/8/8/8/8/8/Pk5P/R3K2R w KQkq - 0 0", false);         std::cout << std::endl;
	std::cout << "The scores should be accurate."                  << std::endl; testScore("3k3r/1b1pb3/4q1p1/1p6/6np/5N2/2Q2PPP/R1R3K1 w - - 0 0"); std::cout << std::endl;
	std::cout << "The state of check should be accurate."          << std::endl; testCheck("7k/R7/1R6/8/8/8/8/K7 w - - 0 0");                        std::cout << std::endl;
	
	std::cout << "The resolutions should be accurate"              << std::endl; testResolution("7k/R7/1R6/8/8/8/8/K7 w - - 0 0");                             std::cout << std::endl;
	                                                                             testResolution("7k/R7/1R6/8/8/8/8/K7 w - - 50 50");                           std::cout << std::endl;
	                                                                             testResolution("7k/8/8/8/8/8/8/K7 w - - 0 0");                                std::cout << std::endl;
	                                                                             testResolution("r6K/r7/8/8/8/8/8/k7 w - - 0 0");                              std::cout << std::endl;
	                                                                             testResolution("7K/8/6q1/8/8/8/8/k7 w - - 0 0");                              std::cout << std::endl;
	                                                                             testResolution("R5RK/PP1B1P1q/1QN1PpP1/5Npp/5p2/1pp5/2b5/r1b1k2r w - - 0 0"); std::cout << std::endl;
	
	return EXIT_SUCCESS;
}
