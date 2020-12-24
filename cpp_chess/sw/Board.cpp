/*
 * Board.cpp
 *
 *  Created on: May 29, 2019
 *      Author: henry
 */

/*
*/

#include <Board.h>
#include <sstream>
#include <algorithm>

using namespace chessHelpers;

chessBoard::Board chessBoard::scratch1;
chessBoard::Board chessBoard::scratch2;
HRand             chessBoard::r;
volatile void*    chessBoard::mem_map = NULL;
const uint32_t    chessBoard::phase2mc = 250000;
const uint8_t     chessBoard::phase2pc = 15;

uint64_t chessBoard::knightCounter = 0;
uint64_t chessBoard::pawnCounter = 0;
uint64_t chessBoard::kingCounter = 0;
uint64_t chessBoard::bishopCounter = 0;
uint64_t chessBoard::rookCounter = 0;

uint64_t chessBoard::controlQueries = 0;
uint64_t chessBoard::checkQueries = 0;
uint8_t  chessBoard::legalBuffer[256][2];

// if looking for OP_WRITE, it's in the header so that it can propagate up to the main

// #define SLOW_KING
// #define BC_DEBUG
// #define NO_READ
// #define EXP_CP

uint64_t chessBoard::next(const uint64_t u) {
  uint64_t v = u * 3935559000370003845 + 2691343689449507681;

  v ^= v >> 21;
  v ^= v << 37;
  v ^= v >>  4;

  v *= 4768777513237032717;

  v ^= v << 20;
  v ^= v >> 41;
  v ^= v <<  5;

  return v;
}

void chessBoard::setFromBoard(chessBoard::Board& b, const chessBoard::Board& other, const uint8_t move_memos) {
	b.ranks[0] = other.ranks[0]; // unrolled loop because we don't want to have a loop variable
	b.ranks[1] = other.ranks[1];
	b.ranks[2] = other.ranks[2];
	b.ranks[3] = other.ranks[3];
	b.ranks[4] = other.ranks[4];
	b.ranks[5] = other.ranks[5];
	b.ranks[6] = other.ranks[6];
	b.ranks[7] = other.ranks[7];
	
	if (move_memos) { // don't even check if we can copy if we don't want to
	    if (other.legalValid) {
	        for (uint8_t i = 0; i < 32; i++) // copy the legal moves IF they're valid, otherwise ignore them
	            reinterpret_cast<uint64_t*>(b.legalMoves)[i] = reinterpret_cast<const uint64_t*>(other.legalMoves)[i];
	        b.legalValid = 1;
	    }
	    else
	        b.legalValid = 0;
	}
	else
	    b.legalValid = 0;
	
	
	b.validCastles = other.validCastles;
	b.enPassantTarget = other.enPassantTarget;
	b.halfmoveClock = other.halfmoveClock;
	b.plyCount = other.plyCount;
	b.score = other.score;
	b.flipped = other.flipped;
	b.hash = other.hash;
	b.wKingPos = other.wKingPos;
	b.bKingPos = other.bKingPos;
	b.gamePhase = other.gamePhase;
	b.restrictLegalities = other.restrictLegalities;
	b.inCheck = other.inCheck;
	b.checkValid = other.checkValid;
	b.pliesUntilLeafProduction = other.pliesUntilLeafProduction;
}

void chessBoard::clearBoard(chessBoard::Board& b) {
	b.ranks[0] = emptyRank;
	b.ranks[1] = emptyRank;
	b.ranks[2] = emptyRank;
	b.ranks[3] = emptyRank;
	b.ranks[4] = emptyRank;
	b.ranks[5] = emptyRank;
	b.ranks[6] = emptyRank;
	b.ranks[7] = emptyRank;
	
	b.validCastles = noCastles;
	b.enPassantTarget = noEnPassant;
	b.halfmoveClock = 0;
	b.plyCount = 0;
	b.score = 0;
	b.flipped = 0;
	b.hash = 0;
	b.wKingPos = 255;
	b.bKingPos = 255;
	b.legalValid = 0; // a totally empty board can't have legal moves enumerated
	b.gamePhase = 0;
	b.restrictLegalities = 0;
	b.inCheck = 0;
	b.checkValid = 0;
	b.pliesUntilLeafProduction = 255;
}

void chessBoard::rehash(chessBoard::Board& b) {
	b.hash = chessBoard::next(b.ranks[0]) ^
		     chessBoard::next(b.ranks[1]) ^
		     chessBoard::next(b.ranks[2]) ^
		     chessBoard::next(b.ranks[3]) ^
		     chessBoard::next(b.ranks[4]) ^
		     chessBoard::next(b.ranks[5]) ^
		     chessBoard::next(b.ranks[6]) ^
		     chessBoard::next(b.ranks[7]) ^
		     chessBoard::next(b.validCastles) ^
		     chessBoard::next(b.enPassantTarget) ^
		                     (b.flipped?0xfeeabb7374564756ULL:
		                                0xbbcdaa6378348367ULL); // since flipped boards are not identical, 
		                                                        // they are distinguished by a brute application
		                                                        // of a salt
}

uint8_t chessBoard::calcPhase(chessBoard::Board& b, const uint8_t pc) {
    // this will calculate what phase of the game the current board is in, where
    // 0 = the first phase of the game, defined by the first 20 plies
    // 1 = the middle phase of the game, where the total number of pieces on the board
    //     is greater than 10 and the total value of the pieces is greater than 25
    // 2 = the last phase of the game, when one of the two conditions for the middle
    //     phase is no longer true
    // note that the game phase doesn't change during tree evaluation in negamax
    if (b.plyCount < 20)
        return 0;
    else if ((pc > chessBoard::phase2pc) && (chessBoard::scoreMaterial(b) > chessBoard::phase2mc))
        return 1;
    else
        return 2;
}

void chessBoard::setFromFEN(chessBoard::Board& b, const char* const FEN) {
	// an FEN string looks like "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq c6 1 0"
	// FEN.push_back(' '); // this aids in detecting the end of the string -- not needed with c-style string rules
	// WARNING: if given a bad pointer, this function will produce total garbage and make evaluation totally impossible!
	chessBoard::clearBoard(b);

	uint8_t* byteBase = reinterpret_cast<uint8_t*>(b.ranks); // to access the individual board spaces
	uint8_t curIndex = 0;
	uint8_t flipAfter = 0;
    uint8_t pieceCount = 0;

	char curChar = FEN[curIndex];

	while (curChar != ' ') { // the board contents segment has no spaces
        switch(curChar) {
        case 'p': case 'r': case 'n': case 'b': case 'q':
        case 'P': case 'R': case 'N': case 'B': case 'Q':
        	(*byteBase++) = charToCode(curChar);
        	pieceCount++;
            break;
            
        case 'K':
            (*byteBase++) = charToCode(curChar);
            b.wKingPos = (uint8_t)(reinterpret_cast<uint64_t>(byteBase) - reinterpret_cast<uint64_t>((b.ranks))) - 1;
            pieceCount++;
            break;
            
        case 'k':
            (*byteBase++) = charToCode(curChar);
            b.bKingPos = (uint8_t)(reinterpret_cast<uint64_t>(byteBase) - reinterpret_cast<uint64_t>((b.ranks))) - 1;
            pieceCount++;
            break;
            
        case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
        	byteBase += (uint8_t)(curChar) - (uint8_t)('0');
        	break;

        default: break;
        }

        curIndex++;
        curChar = FEN[curIndex];
	}

	// at this point, curIndex is on a space and, including that one, 5 spaces remain
	uint8_t ended = 0;

	// side to play
	flipAfter = (FEN[++curIndex] == 'b');
	curIndex += 2; // 2 because we pre-incremented to sit on w/b, and now we skip over the space to the next value

    // castling flags
	// this loop runs at least TWICE, post increment means that we don't see a space until we've moved off it.
	do {
		char castle = FEN[curIndex++];
		switch (castle) {
		    case 'K': b.validCastles |= 8; break;
		    case 'Q': b.validCastles |= 4; break;
		    case 'k': b.validCastles |= 2; break;
		    case 'q': b.validCastles |= 1; break;
		    case '-':                      break;
		    case ' ': ended = 1;           break;
		}
	} while (!ended);
	ended = 0;

	// en passant
	// this is done in two steps because it has to be taken all at once - either both characters, or the one.
	char firstChar = FEN[curIndex];
	if (firstChar != '-') {
		b.enPassantTarget = twoCharToIndex(FEN + curIndex);
		curIndex += 3; // 3 because we skip over the second character (ie 3 in a3) and the following space
	}
	else {
		b.enPassantTarget = noEnPassant;
		curIndex += 2; // 2 because we skip over the - and the following space
	}

	// halfmove clock
	// b.halfmoveClock = atoi(FEN.substr(curIndex).c_str());
	b.halfmoveClock = atoi(FEN + curIndex);

	// there are an unknown number of digits in this number, so just go until we hit a space.
	// must run at least TWICE
	do {
		if (FEN[curIndex++] == ' ') {
			ended = 1;
		}
	} while (!ended);
	ended = 0;

	// ply count
	b.plyCount = atoi(FEN + curIndex) * 2;
	if (flipAfter) b.plyCount++; // if black to move, the plyCount is odd

	// again, an unknown number of digits
	// must run at least TWICE
	/* we don't need to process this number because it is the fullmove count,
	   a metric which we completely ignore.
	do {
		if (FEN[curIndex++] == ' ') {
			ended = 1;
		}
	} while (!ended);
	ended = 0;
    */
    
	// the string is processed, but now we have to do flipAfter
	if (flipAfter) {
		chessBoard::flipBoard(b);
	}

	chessBoard::updatePosDepFlags(b); // this will form legalMoves and set them valid
	                                  // so we don't have to set legalValid here
	                                  // it does the same for check
	chessBoard::rehash(b);
	
	b.gamePhase = chessBoard::calcPhase(b, pieceCount);
}

// replc omitted because it's already a function of strings in c++

void chessBoard::toString(const chessBoard::Board& b, std::string& target) {
	target = "  a b c d e f g h  \n"
	         "8                 8\n"
	         "7                 7\n"
	         "6                 6\n"
	         "5                 5\n"
	         "4                 4\n"
	         "3                 3\n"
	         "2                 2\n"
	         "1                 1\n"
	         "  a b c d e f g h  \n";

	uint8_t rp = 0;
	uint8_t wp = 22;

	for (; rp < 64; rp++) {
	    if (chessBoard::getSquare(b, rp) == empty) {
			target[wp] = '.';
		}
		else if (chessBoard::getSquare(b, rp) == flag) {
			target[wp] = 'x';
		}
		else {
			target[wp] = codeToChar(chessBoard::getSquare(b, rp));
		}

		if (rp % 8 == 7) wp += 6;
		else             wp += 2;
	}
    std::stringstream fields;
    std::string ctl(""); chessBoard::convertCastles(b, ctl);
    std::string enp(""); chessBoard::convertEnPassant(b, enp);
	fields << " White to move: "           << ((!b.flipped)?"1":"0")               << "\n" <<
			  " Valid Castles: "           << ctl                                  << "\n" <<
			  " En Passant Target: "       << enp                                  << "\n" <<
			  " Half-moves towards draw: " << (uint16_t)b.halfmoveClock            << "\n" <<
			  " Full moves: "              << (uint16_t)b.plyCount/2               << "\n" <<
			  " Plys so far: "             << (uint16_t)b.plyCount                 << "\n" <<
			  " Score: "                   << b.score                              << "\n" <<
			  " Flipped: "                 << (b.flipped?"1":"0")                  << "\n" << 
			  " Hash: "                    << (uint64_t)b.hash                     << "\n" <<
			  " White King Pos: "          << (uint16_t)b.wKingPos                 << "\n" <<
			  " Black King Pos: "          << (uint16_t)b.bKingPos                 << "\n" <<
			  " Memory Map: "              << (uint64_t)chessBoard::mem_map        << "\n" <<
			  " Legal Valid: "             << (uint16_t)b.legalValid               << "\n" <<
			  " Game Phase: "              << (uint16_t)b.gamePhase                << "\n" <<
			  " Restricted: "              << (uint16_t)b.restrictLegalities       << "\n" <<
			  " Plies until leafs: "       << (uint16_t)b.pliesUntilLeafProduction;
			  
	target += fields.str();
}

void chessBoard::convertCastles(const chessBoard::Board& b, std::string& target) { // implicitly verified by function of larger block toString
    target = "";
    if ((b.validCastles & 8) != 0) target += 'K';
    else                           target += '-';

    if ((b.validCastles & 4) != 0) target += 'Q';
   	else                           target += '-';

    if ((b.validCastles & 2) != 0) target += 'k';
    else                           target += '-';

    if ((b.validCastles & 1) != 0) target += 'q';
    else                           target += '-';
}

void chessBoard::convertEnPassant(const chessBoard::Board& b, std::string& target) {
    if (b.enPassantTarget != noEnPassant) target = twoCharNamingTable[b.enPassantTarget];
    else                                  target = '-';
}

void chessBoard::boardToFEN(const chessBoard::Board& b, std::string& target) {
    uint8_t curEmpty = 0;
    std::stringstream FEN;

    for (uint8_t position = 0; position < 64; position++) {
    	uint8_t curItem = chessBoard::getSquare(b, position);
    	if (curItem != empty) {
    		if (curEmpty != 0) {
    			// if our current square is not empty but we had previously been accumulating empties,
    			// put the count into the string (see FEN standards)
    			FEN << (uint16_t)curEmpty;
    			curEmpty = 0;
    		}
    		FEN << codeToChar(curItem);
    	}
    	else {
    		// increment empty space tracker
    		curEmpty++;
    	}
    	if ((position % 8) == 7) {
    		// at eol, handle edge cases & add '/'
    		if (curEmpty != 0) {
    			FEN << (uint16_t)curEmpty;
    			curEmpty = 0;
    		}
    		if (position != 63) FEN << "/";
    	}
    }

    std::string FENcastles(""); 
    chessBoard::convertCastles(b, FENcastles);
    if (b.validCastles == noCastles) {
    	FENcastles = '-';
    }
    else {
    	FENcastles.erase(std::remove(FENcastles.begin(), FENcastles.end(), '-'), FENcastles.end());
    }

    std::string  sideToMove = (b.flipped)?"b":"w";
    std::string  enp("");
    chessBoard::convertEnPassant(b, enp);
    FEN << " " << sideToMove << " " << FENcastles << " " << enp << " " << (uint16_t)b.halfmoveClock << " " << b.plyCount/2;

    target = FEN.str();
}

void chessBoard::randomizeBoard(chessBoard::Board& b) {
   	chessBoard::clearBoard(b);
   	for (uint8_t i = 0; i < 64; i++) {
        if ((r.next(10)) > 6) {
       	    // if we randomly chose to target this square (~40% chance)
       	    chessBoard::setSquare(b, pieceArray[r.next(12)], i);
        }
   	}

   	b.validCastles = r.next(16);
   	b.enPassantTarget = enPassantTargets[(r.next(17))];
   	b.halfmoveClock = r.next(50);
   	b.plyCount = ((uint16_t)((r.next(100)/100.0)*(150-b.halfmoveClock)+b.halfmoveClock))&0xfffe;
   	chessBoard::updatePosDepFlags(b); // remember, this will validate the legal moves
   	b.flipped = 0;
   	chessBoard::rehash(b);
   	for (uint8_t i = 0; i < 64; i++) {
   	    // search for the kings
   	    uint8_t p = chessBoard::getSquare(b, i);
   	    if (p == chessHelpers::wKing) {
   	        b.wKingPos = i;
   	    }
   	    else if (p == chessHelpers::bKing) {
   	        b.bKingPos = i;
   	    }
   	}
}

void chessBoard::setSquare(chessBoard::Board& b, const uint8_t piece, const uint8_t i) {
	*(reinterpret_cast<uint8_t*>(b.ranks) + i) = piece;
	if      (piece == chessHelpers::wKing) b.wKingPos = i;
	else if (piece == chessHelpers::bKing) b.bKingPos = i;
	
	b.legalValid = 0; // this changes the board so we have to scrap the moves
	b.checkValid = 0; // and the check flag
}

void chessBoard::setSquare(chessBoard::Board& b, const uint8_t piece, const uint8_t r, const uint8_t c) {
	*(reinterpret_cast<uint8_t*>(b.ranks[r])+c) = piece;
	uint8_t i = chessHelpers::rctoi(r, c);
	if      (piece == chessHelpers::wKing) b.wKingPos = i;
	else if (piece == chessHelpers::bKing) b.bKingPos = i;
	
	b.legalValid = 0; // this changes the board so we have to scrap the moves
	b.checkValid = 0; // and the check flag
}

void chessBoard::setFlag(chessBoard::Board& b, const uint8_t i) {
	*(reinterpret_cast<uint8_t*>(b.ranks) + i) = flag; // user is free to hurt themselves with this one - won't check for disturbing the king positions
	                                                   // this will also not influence the enumerate moves
}

uint8_t chessBoard::equals(const chessBoard::Board& b, const chessBoard::Board& other) {
	const uint64_t* otherRanks = other.ranks;
   	return b.validCastles == other.validCastles       &&
    	   b.enPassantTarget == other.enPassantTarget &&
    	   b.halfmoveClock == other.halfmoveClock     &&
   		   b.flipped ==  other.flipped                &&
   		   b.ranks[0] == otherRanks[0]                &&
   		   b.ranks[1] == otherRanks[1]                &&
		   b.ranks[2] == otherRanks[2]                &&
		   b.ranks[3] == otherRanks[3]                &&
		   b.ranks[4] == otherRanks[4]                &&
		   b.ranks[5] == otherRanks[5]                &&
		   b.ranks[6] == otherRanks[6]                &&
		   b.ranks[7] == otherRanks[7];
}

uint8_t chessBoard::isWhite(const chessBoard::Board& b, const uint8_t i) {
  	return chessBoard::getSquare(b, i) < blackMask;
}

uint8_t chessBoard::isBlack(const chessBoard::Board& b, const uint8_t i) {
  	return (!chessBoard::isEmpty(b, i)) && (chessBoard::getSquare(b, i) > blackMask);
}

uint8_t chessBoard::isClearPath(const chessBoard::Board& b, const uint8_t from, const uint8_t to) {
   	/*
    uint8_t clear = 1;
   	uint8_t* passThrough = chessHelpers::getPassedThrough(from, to);
   	while (*passThrough != 0xff) {
   		if (!chessBoard::isEmpty(b, *passThrough)) {
   		    clear = 0;
   		    break;
   		}
   		passThrough++;
   	}
   	return clear;
   	*/
   	
   	uint8_t* passThrough = chessHelpers::getPassedThrough(from, to);
   	while (true) {
   	    uint8_t i = *passThrough++; // this might be one instruction as opposed to two like above?
   	    if (i == 0xff) // I don't know if it's possible to convince it to register i
   	        break;
   	    else if (!chessBoard::isEmpty(b, i)) // this is safe because the above if cuts us off
   	        return 0; // the square is in the path and not empty, so the path is not clear
   	}
   	return 1; // falling through means we hit the end without finding an occupied square
}

/*
uint8_t chessBoard::isBlackControlled(const chessBoard::Board& b, const uint8_t i) {
#ifdef BC_DEBUG
    uint8_t hw_solution = 255;
    uint8_t sw_solution = 255;
    if (chessBoard::mem_map)
        hw_solution = chessBoard::isBlackControlled_hw(b, i);
    
    sw_solution = chessBoard::isBlackControlled_sw(b, i);
#ifndef NO_READ
    if (sw_solution != hw_solution) {
        std::string temp("");
        chessBoard::toString(b, temp);
        std::cout << "Failed divergence testing on following board:\n" << temp << "\nFEN string was ";
        chessBoard::boardToFEN(b, temp);
        std::cout << temp << std::endl << "Hardware solution for black control of i (" << (uint16_t)i << ") was: " << (uint16_t)hw_solution << " and software was: " << (uint16_t)sw_solution << std::endl;;
        std::cout << "Full masks: " << std::endl;
        *(chessBoard::Board*)chessBoard::mem_map = b;
        uint64_t black_controlled = *((uint64_t*)chessBoard::mem_map + 12);
	    printf( "%llu\n", black_controlled);
	    uint64_t black_king = *((uint64_t*)chessBoard::mem_map + 13);
	    printf( "%llu\n", black_king);
	    printf("Hardware:\n");
	    printf("  0   1   2   3   4   5   6   7   8   9  10"
	           "  11  12  13  14  15  16  17  18  19  20"
	           "  21  22  23  24  25  26  27  28  29  30"
	           "  31  32  33  34  35  36  37  38  39  40"
	           "  41  42  43  44  45  46  47  48  49  50"
	           "  51  52  53  54  55  56  57  58  59  60"
	           "  61  62  63\n");
	    for (uint8_t s = 0; s < 64; s++) {
	        printf( "  %u ", (uint8_t)(black_controlled&1));
	        black_controlled >>= 1;
	    }
	    printf("\n");
	    printf("Software:\n");
	    printf("  0   1   2   3   4   5   6   7   8   9  10"
	           "  11  12  13  14  15  16  17  18  19  20"
	           "  21  22  23  24  25  26  27  28  29  30"
	           "  31  32  33  34  35  36  37  38  39  40"
	           "  41  42  43  44  45  46  47  48  49  50"
	           "  51  52  53  54  55  56  57  58  59  60"
	           "  61  62  63\n");
	    uint64_t cbc = 0x0ULL;
	    for (uint8_t s = 0; s < 64; s++) {
	        printf( "  %u ", chessBoard::isBlackControlled_sw(b, s));
	        cbc |= ((uint64_t)chessBoard::isBlackControlled_sw(b, s) << (uint8_t)(s));
	    }
	    std::cout << std::endl;
    }
#endif
    return sw_solution; // idea here is that a bad hardware solution shouldn't be allowed to cause subsequent problems, so just return the software answer
#else
    if (chessBoard::mem_map)
        return chessBoard::isBlackControlled_hw(b, i);
    else
        return chessBoard::isBlackControlled_sw(b, i);
#endif
}
*/

// isBlackControlled is THE DEVIL for speed. Something about this function is making it
// responsible for 87.9% of all running time in this program, so even the slightest of optimizations
// will have a huge time impact
uint8_t chessBoard::isBlackControlled(const chessBoard::Board& b, const uint8_t i) {
   	// nothing here can be accelerated by memos because clear path checks are still faster than querying
   	// the legal moves of a target that gets found in reverse
   	// NOTE that that means that this function does not rely on valid memos to function correctly
   	
   	chessBoard::controlQueries++;
   	
   	// FUNCITON CALLS:
   	//  getMoveList is inlined and is probably optimal
   	//  getSquare is inlined and is probably optimal
   	//  itor is inlined and theoretically optimal
   	//  itoc is inlined and theoretically optimal
   	//  rctoi is inlined and might have an optimization (instead of add column, OR it)
   	//  isClearPath cannot be inlined and calls two other functions...
   	//    getPassedThrough is inlined and is probably optimal
   	//    isEmpty is inlined and is probably optimal
   	//    and the function itself it improved, but might still have optimizations possible
   	
   	// THIS FUNCTION:
   	//  it may still be possible to optimize pawns with a table (probably should do this)
   	//  it may still be possible to optimize rook/bishop/queen by splitting the search
   	//  into four different paths and having the option to break from each when an obstructing
   	//  piece is found (though this would be a very involved thing to implement)
   	
   	// IN DEPTH: why are the least common use cases first?
   	//    Even though kings and pawns control less board capital than rooks and bishops,
   	//    they are significantly less expensive in the negative case. Detecting that 
   	//    the king does not control a square is a lot less expensive than detecting
   	//    that a bishop does not, so the time trade-off ultimately prefers putting the
   	//    least expensive operations up front so that the heavy operations (rook/bishop/queen)
   	//    don't always run. The cutoff is worth more than the extraneous computations.
   	
    // check for knights - might be able to optimize this like with isClearPath above
    // so that it doesn't try to dereference this pointer twice
   	
   	// direct king control of target - this is theoretically optimized thanks to a pre-computed table
   	if ((chessHelpers::adjTable[b.bKingPos] >> i) & 1) {
   	    // chessBoard::kingCounter++;
   	    return 1;
   	}
    
   	// check for pawns - this version is fast, but a table is probably better (1 memory access, 2-4 compares, one shift versus lots of arithmetic)
   	if (itor(i) > 1) { // pawns can't sit on rank 0, so we can't be threatened by them on rank 1
   	    const uint8_t targetC = itoc(i);
   		// if ((targetC > 0) && chessBoard::getSquare(b, rctoi(targetR, targetC-1)) == bPawn) return 1;
   		// if ((targetC < 7)  && chessBoard::getSquare(b, rctoi(targetR, targetC+1)) == bPawn) return 1;
   		if ((targetC > 0) && chessBoard::getSquare(b, i-9) == bPawn) {
   		    // chessBoard::pawnCounter++;
   		    return 1;
   		}
   		if ((targetC < 7)  && chessBoard::getSquare(b, i-7) == bPawn) { 
   		    // chessBoard::pawnCounter++;
   		    return 1;
   		}
   	}
   	
   	uint8_t* directNJumps = getMoveList(wKnight, i);
   	while(true) { // if a black knight can get to the square, black controls it.
   	    const uint8_t from = *directNJumps++;
   	    if (from == 0xff)
   	        break;
   	    else if (chessBoard::getSquare(b, from) == bKnight) {
   	        // chessBoard::knightCounter++;
   	        return 1;
   	    }
   	}
   	
   	// rook | queen checks
   	uint8_t* potentialAttackers = getMoveList(wRook, i);
   	while (true) {
   		uint8_t from = *potentialAttackers++; // last use is post-incremented (I don't know what this means but I'm terrified to delete it)
   		if (from == 0xff)
   		    break;
   		else {
   		    const uint8_t attackingPiece = chessBoard::getSquare(b, from);
   		    if (((attackingPiece == bRook) || (attackingPiece == bQueen)) && (chessBoard::isClearPath(b, from, i))) {
   		        // chessBoard::rookCounter++;
   			    return 1;
   			}
   		}
   	}
   	
   	// bishop | queen checks
   	potentialAttackers = getMoveList(wBishop, i);
   	while (true) {
   		uint8_t from = *potentialAttackers++; // last use is post-incremented (I don't know what this means but I'm terrified to delete it)
   		if (from == 0xff)
   		    break;
   		else {
   		    const uint8_t attackingPiece = chessBoard::getSquare(b, from);
   		    if (((attackingPiece == bBishop) || (attackingPiece == bQueen)) && (chessBoard::isClearPath(b, from, i))) {
   		        // chessBoard::bishopCounter++;
   			    return 1;
   			}
   		}
   	}

   	// fall-through means no attackers to i
   	return 0;
}

/*
uint8_t chessBoard::isBlackControlled_hw(const chessBoard::Board& b, const uint8_t i) {
    volatile uint64_t counter1 = *((volatile uint64_t*)chessBoard::mem_map + 15);
#ifdef EXP_CP
    volatile uint64_t* d = (volatile uint64_t*)chessBoard::mem_map;
    uint64_t* z = (uint64_t*)(&b);
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
    *d++ = *z++;
#else
    *(chessBoard::Board*)chessBoard::mem_map = b;
#endif
#ifndef NO_READ
    // uint64_t val = (*((uint64_t*)chessBoard::mem_map+12));
    // std::cout << "Read the bit from the hardware as: " << (uint16_t)(((*((uint64_t*)chessBoard::mem_map+12)) >> i) & 1) << std::endl;
    volatile uint64_t counter2 = *((volatile uint64_t*)chessBoard::mem_map + 15) & 0xffff;
    // std::cout << "Header check" << std::endl;
    while (counter2 != ((counter1 + 8) & 0xffff)) {
        std::cout << "Read before write hazard present! counter1 = " << counter1 << " and counter2 = " << counter2 << " with (counter1 + 8) & 0xffff = " << ((counter1 + 8) & 0xffff) << std::endl;
        counter2 = *((uint64_t*)chessBoard::mem_map + 15) & 0xffff;
    }
    return ((*((uint64_t*)chessBoard::mem_map+12)) >> i) & 1;
#else
    return 254;
#endif
}
*/

uint8_t chessBoard::updateCheck(chessBoard::Board& b) {
    chessBoard::checkQueries++;
    if (b.checkValid)
        return b.inCheck;
    else {
        b.inCheck = chessBoard::isBlackControlled(b, b.wKingPos);
        b.checkValid = 1;
        return b.inCheck;
    }
}

void chessBoard::flipBoard(const chessBoard::Board& b,  chessBoard::Board& target) {
	// this function is ISOLATED - the from and to boards must be different
	// loop is unrolled for SLGIHT increase in efficiency

	// each attribute is inverted across to the target from ourselves
	// this is so that boards can flip into others (which is important
	// for a stack-based engine if one is to be made as an extension).

	// BIG, IMPORTANT NOTE: THIS SETS THE FLIPPED FLAG
	// IF YOU TRY TO FLIP A BOARD AND THEN USE THE FLIPPED FEN YOU WILL FAIL
	// BECAUSE SETFROMFEN WILL UNFLIP IT FOR YOU. FORCE THIS FLAG LOW
	// IF YOUR INTENTION IS TO CONVERT TO FEN AND THEN SET ANOTHER BOARD FROM THAT FEN

	target.ranks[0] = swapRankColor(b.ranks[7]);
	target.ranks[1] = swapRankColor(b.ranks[6]);
	target.ranks[2] = swapRankColor(b.ranks[5]);
	target.ranks[3] = swapRankColor(b.ranks[4]);
	target.ranks[4] = swapRankColor(b.ranks[3]);
	target.ranks[5] = swapRankColor(b.ranks[2]);
	target.ranks[6] = swapRankColor(b.ranks[1]);
	target.ranks[7] = swapRankColor(b.ranks[0]);
	uint8_t newValidCastles = b.validCastles;
	uint8_t blackCastles = newValidCastles & 3; // low bits are black, only get those
	newValidCastles >>= 2;                  // shift away black castles
	newValidCastles |= (blackCastles << 2); // add in preserved castles
	target.validCastles = newValidCastles;

	if (b.enPassantTarget != noEnPassant) {
		if (b.enPassantTarget < 40) { // if we're on row 6, skip three rows down to 3
		    target.enPassantTarget = b.enPassantTarget+24;
		}
		else {                      // if we're on row 3, skip three rows up to 6
			target.enPassantTarget = b.enPassantTarget-24;
		}
	}
	else {
		target.enPassantTarget = noEnPassant;
	}
	
	// this is a departure from the python - look here for bugs!
	target.halfmoveClock = b.halfmoveClock;
	target.plyCount = b.plyCount;
	// end departure
	target.score = b.score*-1; // if you think this breaks negamax please draw yourself a picture of how negamax trees work - spoiler: this doesn't break negamax
	                           // also, we don't rescore the board here since it's cheaper to regenerate the legal moves than it is to do that AND rescore the board
	chessBoard::rehash(target); // this is also different - policy here is to hash active representations, not 1 states
	target.wKingPos = chessHelpers::flipTable[b.bKingPos];
	target.bKingPos = chessHelpers::flipTable[b.wKingPos];
	
	target.flipped = 1 ^ b.flipped;
	target.legalValid = 0; // remember this! The legal moves are not valid anymore!
	target.checkValid = 0; // you cannot know anything about check status on the flip of the board
	target.gamePhase = b.gamePhase; // flipping doesn't change the game phase
	target.restrictLegalities = b.restrictLegalities; // flipping doesn't change legality restrictions
	target.pliesUntilLeafProduction = b.pliesUntilLeafProduction;
}

void chessBoard::flipBoard(chessBoard::Board& b) {
    // this function is REFLEXIVE - the target board and target meta are flipped in place
    // loop is unrolled for SLIGHT increase in efficiency

    // flip ranks 0 and 7
    uint64_t rankFlipTemp = swapRankColor(b.ranks[7]);
    b.ranks[7] = swapRankColor(b.ranks[0]);
    b.ranks[0] = rankFlipTemp;

    // flip ranks 1 and 6
    rankFlipTemp = swapRankColor(b.ranks[6]);
    b.ranks[6] = swapRankColor(b.ranks[1]);
    b.ranks[1] = rankFlipTemp;

    // flip ranks 2 and 5
    rankFlipTemp = swapRankColor(b.ranks[5]);
    b.ranks[5] = swapRankColor(b.ranks[2]);
    b.ranks[2] = rankFlipTemp;

    // flip ranks 3 and 4
    rankFlipTemp = swapRankColor(b.ranks[4]);
    b.ranks[4] = swapRankColor(b.ranks[3]);
    b.ranks[3] = rankFlipTemp;

    uint8_t newValidCastles = b.validCastles;
	uint8_t blackCastles = newValidCastles & 3; // low bits are black, only get those
	newValidCastles >>= 2;                  // shift away black castles
	newValidCastles |= (blackCastles << 2); // add in preserved castles
	b.validCastles = newValidCastles;

	if (b.enPassantTarget != noEnPassant) {
		if (b.enPassantTarget < 40) { // if we're on row 6, skip three rows down to 3
			b.enPassantTarget += 24;
		}
		else {                      // if we're on row 3, skip three rows up to 6
			b.enPassantTarget -= 24;
		}
	}
	else {
		b.enPassantTarget = noEnPassant;
	}

	b.score *= -1; // we don't rescore because, again, it's still faster to regenerate the legal moves than to do that with the overhead of updatePosDepFlags
	chessBoard::rehash(b); // this is also different - policy here is to hash active representations, not 1 states
	
	uint8_t posTemp = chessHelpers::flipTable[b.bKingPos]; // hold on to the correct flipped wKingPos while we do the other change   
	b.bKingPos = chessHelpers::flipTable[b.wKingPos];
	b.wKingPos = posTemp;
	
	b.flipped ^= 1;
	b.legalValid = 0; // remember that this is invalid! 
	b.checkValid = 0;
	
	// game phase, plies until leaf production, and restrictLegalities don't change
}

uint8_t examineCheck(const chessBoard::Board& b, const uint8_t from, const uint8_t to) {
    // can the check status have changed?
    
    if (b.inCheck == 0) { // a non-king piece leaving a square cannot resolve check, so if we're already in check, we don't have to do this
        if ((chessHelpers::adjTable[b.wKingPos] & (1ULL << from)) || ((*getPassedThrough(b.wKingPos, from) != 0xff) && chessBoard::isClearPath(b, b.wKingPos, from))) {
            return 1; 
        }
    }
    else {
        // a non-king piece entering a square cannot cause check, so we only need to do this we're already in check
        if (chessHelpers::adjTable[b.wKingPos] & (1ULL << to))
            return 1;
        if ((*getPassedThrough(b.wKingPos, to) != 0xff) && chessBoard::isClearPath(b, b.wKingPos, to))
            return 1; // there is a path from the king to the to square and it's clear and we're in check, 
                      // we could have blocked or captured a threat
        if (chessBoard::getSquare(b, to) == bKnight) {
            // if we captured a knight, check to see if it was in the vicinity of 
            // the king. Otherwise we know that we aren't influencing knight captures
            uint8_t* nInterests = getMoveList(wKnight, b.wKingPos);
            
            while (true) {
                const uint8_t i = *nInterests++;
                if (i == 0xff)
                    break;
                if (to == i)
                    return 1; // we have captured a knight, return that we might have a change
            }
        }
    }
    
    return 0; // if we didn't reveal or enter into any square of interest, we know that the check status can't have changed
}

moveType chessBoard::testLegality(const chessBoard::Board& b, const uint8_t from, const uint8_t to) {
	// preconditioned by moves being in physical move table
	// note that almost every ILLEGAL result is "return ILLEGAL" because we don't overwrite
	// illegality, nor do we differentiate among types of it
	// std::cout << "while calculating under testLegality, checkValid was " << (uint16_t)b.checkValid << std::endl;
	
	if (b.legalValid) // if the legalities are valid then just return what we already calculated
	    return b.legalities[from][to];
	
	// if we got down here we must not have a valid state for the legalities
	uint8_t movingPiece = chessBoard::getSquare(b, from);
	uint8_t destination = chessBoard::getSquare(b, to);

	moveType result = ILLEGAL;
    
	uint8_t clearPath = 0;
	
	if (movingPiece == wKnight) clearPath = 1; 
	else                        clearPath = chessBoard::isClearPath(b, from, to);

	if (clearPath) {
		if (chessBoard::isEmpty(b, to)) { // these are non-captures
			if (movingPiece != wPawn) {
				// moving a non-pawn through a clear path
				result = STANDARD_LEGAL;
			}
			else if (from-to == 16) {
				// it is a pawn, did two ranks get traversed?
				// this only needs to happen so that we can set the en passant flags
				result = PAWN_MOVED_TWO;
			}
			else if (to == b.enPassantTarget) {
				// moving onto the target
				// note that we don't ask "is there an en passant target" because
				// the inactive state of the target is 0xff, which definitely won't
				// trigger this statement because pieces can't try to move to square 255
				result = CAPTURE_EN_PASSANT;
			}
			else if (to != from-8) {
				// a pawn moves diagonally, but the square is empty
				// you don't have to wait for any other information in this case
				// because you already know you're making an illegal move
				return ILLEGAL;
			}
			else if (to < 8) {
				// pawn moves onto the back rank
				result = PROMOTION;
			}
			else {
				// pawn moves legally forward
				result = STANDARD_LEGAL;
			}
		}
		else if (isBlackPiece(destination)) { // these are types of captures
		    const moveType capType = ((b.restrictLegalities == 0) && (b.pliesUntilLeafProduction > 0))?STANDARD_LEGAL:((chessBoard::isBlackControlled(b, to))?PROTECTED_CAPTURE:UNPROTECTED_CAPTURE);
			// if black and not a pawn, normal capture
			if (movingPiece != wPawn) {
				result = capType;
			}
			else if (to == from-9 || to == from-7) {
				// diagonal motion
				// this is necessary because pawns can move, but not capture, forwards
				result = capType;
			}
			else {
			    // pawn is trying to capture forward
			    // again, we know that this move is illegal, so we don't have to worry
				return ILLEGAL;
			}
		}
		else if (isWhitePiece(destination)) {
			// no capturing white piece
			return ILLEGAL;
		}
	}
	else {
		// not-clear paths
		return ILLEGAL;
	}

	// note that the above conditions for returning illegal don't exclude this code
	// castling is a bit different. First, deduce if this is a castling move
	if (movingPiece == wKing && from == kingStart &&
	   (to == kingCastleEnd  ||   to == queenCastleEnd)) {
		result = ILLEGAL; // since it's now a castle, assume illegal again even if we met other conditions above
		if (clearPath && chessBoard::isEmpty(b, to) && !chessBoard::isBlackControlled(b, kingStart)) {
			// above determined if we castled out of check, now determine if we're castling in
			if (to == kingCastleEnd) {
				if ((b.validCastles >> 3) != 0 && !(chessBoard::isBlackControlled(b, kingCastleEnd) || chessBoard::isBlackControlled(b, kingCastleThrough))) {
					// kingside castling is still available and we didn't go through check, therefore it's legal
					result = CASTLE_KINGSIDE;
				}
			}
			else {
				// we don't need to check if queenside because we already know a castle was attempted
				if ((b.validCastles & 4) != 0 && !(chessBoard::isBlackControlled(b, queenCastleEnd) || chessBoard::isBlackControlled(b, queenCastleThrough))) {
					result = CASTLE_QUEENSIDE;
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
	 * false negative case: this function says that check does not occur, but in reality it does.
	 *    - This is not a concern because the rook starts in the corner. There is nowhere for the rook to reveal by moving,
	 *      and thus there cannot be any threat of check from any other part of the board because there is no more board in that direction.
	 * false positive case: this function says that check does occur, but in reality it does not.
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
	

	// now, that's all fine and good, but if we're in the restricted legalities state,
	// only capture moves can be permissible. This is so that "deep search" evaluations
	// in the negamax algorithm don't branch as aggresively as "quick search" evaluations
	
	if (b.restrictLegalities && (!(result == PROTECTED_CAPTURE) && !(result = UNPROTECTED_CAPTURE))) {
	    return ILLEGAL; // all moves which aren't captures are illegal under restricted legality, and we don't need to ask any more questions
	}
	else if (result != ILLEGAL) { // now we need to ask if the move we just played put ourself in check
	    // moveType newResult = result;
	    /*
	    if (chessBoard::updateCheck(chessBoard::scratch1)) {
	        result = ILLEGAL;
	    }
	    */
	    if (movingPiece == wKing) {
	        chessBoard::setFromBoard(chessBoard::scratch1, b);
	        chessBoard::setSquare(chessBoard::scratch1, movingPiece, to); // setSquare actually protects against moving the king without
	                                                                      // updating the appropriate flags
	        chessBoard::setSquare(chessBoard::scratch1, empty, from);
	        if (result == CAPTURE_EN_PASSANT) { // if we already determined this move was an attempt at a capture en passant, update the appropriate square
	        	chessBoard::setSquare(chessBoard::scratch1, empty, to+8);
	        }
	        
	        // note that we don't promote the pawn even if it moves onto the edge of the board
	        // because the identity of the promotion is not part of determining the legality of the promotion
	        
	        // if the king moved, do the whole evaluation completely
	        if (chessBoard::isBlackControlled(chessBoard::scratch1, chessBoard::scratch1.wKingPos)) {
	            return ILLEGAL;
	        }
	    }
	    else {
	        // if the king didn't move, can the piece that did move have changed our check status?
	        if (examineCheck(b, from, to)) {
	        	// so the check status might have changed
	        	
	        	chessBoard::setFromBoard(chessBoard::scratch1, b);
	            chessBoard::setSquare(chessBoard::scratch1, movingPiece, to); // setSquare actually protects against moving the king without
	                                                                          // updating the appropriate flags
	            chessBoard::setSquare(chessBoard::scratch1, empty, from);
	            if (result == CAPTURE_EN_PASSANT) { // if we already determined this move was an attempt at a capture en passant, update the appropriate square
	            	chessBoard::setSquare(chessBoard::scratch1, empty, to+8);
	            }
	        	
	        	if (chessBoard::isBlackControlled(chessBoard::scratch1, scratch1.wKingPos))
	        	    return ILLEGAL;
	        }
	        else {
	            if (b.checkValid) {
	                if (b.inCheck) {
	                    return ILLEGAL; // if the check status can't have changed, and we were in check, this is illegal
	                }
	            }
	            else {
	                // I'm pretty sure we should never get here, but just in case, reevaluate check on the board
	                chessBoard::setFromBoard(chessBoard::scratch1, b);
	                chessBoard::setSquare(chessBoard::scratch1, movingPiece, to); // setSquare actually protects against moving the king without
	                                                                              // updating the appropriate flags
	                chessBoard::setSquare(chessBoard::scratch1, empty, from);
	                if (result == CAPTURE_EN_PASSANT) { // if we already determined this move was an attempt at a capture en passant, update the appropriate square
	                	chessBoard::setSquare(chessBoard::scratch1, empty, to+8);
	                }
	                if (chessBoard::isBlackControlled(chessBoard::scratch1, scratch1.wKingPos)) {
	                    // std::cout << "We are, in fact, recalculating due to lack of validity" << std::endl;
	                    return ILLEGAL;
	                }
	            }
	        }
	    }
	}
	
	return result;
}

uint8_t chessBoard::playMove(chessBoard::Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval, const moveType move) {
    uint8_t piece = chessBoard::getSquare(b, from);
    uint8_t captured = !chessBoard::isEmpty(b, to);

	// we know the move is playable because we wouldn't be called if it weren't
	chessBoard::setSquare(b, piece, to);
	chessBoard::setSquare(b, empty, from);

	// update metadata
	b.enPassantTarget = noEnPassant; // wipe ep for now
	switch (move) {
		case PAWN_MOVED_TWO:
			b.enPassantTarget = to + 8; // one rank below current position is the space moved over
			break;
		case CASTLE_KINGSIDE:
			// manual updates at known positions must be made in case of castling
			chessBoard::setSquare(b, empty, 63);
			chessBoard::setSquare(b, wRook, 61);
			break;
		case CASTLE_QUEENSIDE:
			// manual updates at known positions must be made in case of castling
			chessBoard::setSquare(b, empty, 56);
			chessBoard::setSquare(b, wRook, 59);
			break;
		case CAPTURE_EN_PASSANT:
			// clear out the en passant captured square
			chessBoard::setSquare(b, empty, to+8);
			break;
		case PROMOTION:
			// upgrade the piece
			chessBoard::setSquare(b, promotion, to);
			break;
		default: // STANDARD_LEGAL and the captures fall through to here, because there is no need to change flags
			break;
	}

	if (piece == wKing) {
		b.validCastles &= 3; // wipe white's castles - note that we always do this because the king moving will always 
		                     // nullify the castles and it will always be faster to do this write than to check if we've already done it
	}
	else if (piece == wRook) { // these operations are a little more specific than above, but apply the same principle
		if (from == 63) {
			b.validCastles &= 7;
		}
		else if (from == 56) {
			b.validCastles &= 11;
		}
	}
	b.plyCount++;
	chessBoard::rehash(b);
	if (eval) // only rebuild memos if eval is on - this mostly saves time while configuring children
	    chessBoard::updatePosDepFlags(b);

	if (captured || piece == wPawn) b.halfmoveClock = 0;
	else                            b.halfmoveClock++;
	
	b.pliesUntilLeafProduction--;
	
	return 1;
}

uint8_t chessBoard::makeMove(chessBoard::Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval, const moveType inheritedMemo) {
	if (inheritedMemo != ILLEGAL)
        return chessBoard::playMove(b, from, to, promotion, eval, inheritedMemo);
    else
        return 0;
}

uint8_t chessBoard::makeMove(chessBoard::Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval) {
	moveType move = chessBoard::testLegality(b, from, to); // this will use memos if they are valid
	if (move == ILLEGAL)
	    return 0;
	else
	    return chessBoard::playMove(b, from, to, promotion, eval, move);
}

int32_t chessBoard::pdfWhite(chessBoard::Board& b) {
	// position dependent flags for white - score and memos, including the legal moves
	// this function has the power to update the memoization
	// so we first invalidate the current state (this is probably already done, but just to be sure)
	// same with check, just to be sure
	b.legalValid = 0; 
	b.checkValid = 0;
	
	// now, nuke the legalities and the legal moves
	for (uint8_t o = 0; o < 64; o++) {
	    for (uint8_t i = 0; i < 64; i++) {
	        b.legalities[o][i] = ILLEGAL;
	    }
	}
	// we have to do this because we are going to fill in only SOME of the moves from an ordering
	for (uint8_t i = 0; i < 64; i++) {
	    reinterpret_cast<uint64_t*>(b.legalMoves)[i] = 0xffffffffffffffffULL;
	    reinterpret_cast<uint64_t*>(chessBoard::legalBuffer)[i] = 0xffffffffffffffffULL;
	}
	// create the ordering so that the memoization will be useful in negamax
	uint8_t indices[64];
	chessBoard::orderPieces(b, indices);
	
	chessBoard::updateCheck(b); // set this up here so that testLegality can be optimized
	                            // note that this will validate the check flag
	                            
    if (b.inCheck) {
        b.restrictLegalities = 0; // we cannot be in restricted legality mode while in check
    }
	
	// now we can do the score evaluation and legal move memoization
	int32_t score = 0;
	int32_t pScore = 0;
	uint8_t lwp = 0;
	uint8_t bwp = 0;
	const uint8_t* bSquares = reinterpret_cast<const uint8_t*>(b.ranks);	
	for (uint8_t i = 0; i < 64; i++) {
	    uint8_t from = indices[i]; // pay attention here - this creates order because this is a memoizing function
	    if (from != 0xff) {
	        uint8_t s = bSquares[from];
		    score += scoreTable[s];
		    uint8_t* candidates = getMoveList(s, from);
		    uint8_t to = *candidates;
		    uint8_t j = 0;
		    while (to != 0xff) {
		        moveType legality = chessBoard::testLegality(b, from, to);
		        b.legalities[from][to] = legality; // memoize this step - IMPORTANT for deep search step
		        if (legality != ILLEGAL) {
		            // memoize the results of the moves checking
		            // in the ordering so that we don't have to repeat this work later in negamax
		            if (legality == UNPROTECTED_CAPTURE) {
		                b.legalMoves[lwp]  [0] = from;
		                b.legalMoves[lwp++][1] = to;
		            }
		            else { 
		                // unprotected captures go into the legal moves, and other types wait their turn
		                // in this buffer
		                chessBoard::legalBuffer[bwp]  [0] = from;
		                chessBoard::legalBuffer[bwp++][1] = to;
		            }
		            // if (s != chessHelpers::wKing)
		            j++; // could modify to give squares different value?
		        }
		        to = *++candidates;
		    }
	        pScore += 500 * j; // 10000 score = 1 pawn, so 500 = 0.05 pawns per square of control
	    }
	}
	
	// add in the score of the king
	if (b.gamePhase == 0)
	    pScore += chessHelpers::p0kingtable[b.wKingPos];
	else if (b.gamePhase == 1)
	    pScore += chessHelpers::p1kingtable[b.wKingPos];
	else
	    pScore += chessHelpers::p2kingtable[b.wKingPos];
	// add in the value of the white castling flags
	if (b.plyCount < 25) {
	    if (b.validCastles > 0x3) { // this means the flags are greater than 0b0011, so a white flag exists
	        if (b.validCastles > 0xb) // this means the flags are greater than 0b1011, so both white flags must exist
	            pScore += chessHelpers::dCastleFlagValue[b.plyCount];
	        else
	            pScore += chessHelpers::castleFlagValue[b.plyCount]; 
	    }
	}
	
	// copy the other legalities into the legal moves
	for (uint8_t i = 0; i < bwp; i++) {
	    b.legalMoves[lwp]  [0] = chessBoard::legalBuffer[i][0];
	    b.legalMoves[lwp++][1] = chessBoard::legalBuffer[i][1];
	}
	
	b.legalValid = 1; // the legalities of all the potential white piece moves are valid,
	                  // as is the legal moves structure and check, so we can set legalValid
	return score + pScore;
}

int32_t chessBoard::scoreOnly(chessBoard::Board& b, const uint8_t positional) {
    // this is a reduction of the above function
    // note that this function has the option to ignore positional elements
    // because it is used in scoreMaterial. The above function must always
    // consider positional elements. While these two functions are extremely
    // similar, they are split for the sake of functional efficiency
    
    // since this function uses testLegality, it would be better for it to evaluate check on its
    // parent board
    
    chessBoard::updateCheck(b);
    
	int32_t score = 0;
	int32_t pScore = 0;
	const uint8_t* bSquares = reinterpret_cast<const uint8_t*>(b.ranks);
	uint8_t j = 0;
	for (uint8_t i = 0; i < 64; i++) { // a potential optimization to this would be if we could somehow know that
	                                   // we were at the end of the board, rather than constantly checking "is
	                                   // this square 63 yet" because we know how many times we're going to do 
	                                   // this operation, and it's always the same. 
	    uint8_t s = bSquares[i]; // note that this ignores ordering because this function does not create memos
	    // since all black pieces are 01XXXXXX and empty is 1XXXXXXX (hopefully empty is always 10000000 but 
	    // we try not to make that assumption), we know that a piece is white and not empty if it is less than the blackMask
	    if (!(s == chessHelpers::empty) && chessHelpers::isWhitePiece(s)) {
	    // if (s < chessHelpers::blackMask) { - this seems like it should work but I'm not sure
	        score += scoreTable[s]; // note that this will not add any score for the king
		    uint8_t* candidates = getMoveList(s, i);
		    while (true) {
		        const uint8_t to = *candidates++;
		        if (to == 0xff)
		            break;
		        const chessHelpers::moveType legality = chessBoard::testLegality(b, i, to); // this is probably where the time sink is
		        if (legality != ILLEGAL) {
		            // if (s != chessHelpers::wKing)
		            j++; // could modify to give squares different value?
		        }
		    }
	    }
	}
	
	pScore += 500 * j; // 10000 score = 1 pawn, so 500 = 0.05 pawns per square of control
	
    if (positional) {
        // add in the score of the king
        // the weird order is because the mid-game, phase 1, is most often
	    if (b.gamePhase == 1)
	        pScore += chessHelpers::p1kingtable[b.wKingPos];
	    else if (b.gamePhase == 0)
	        pScore += chessHelpers::p0kingtable[b.wKingPos];
	    else
	        pScore += chessHelpers::p2kingtable[b.wKingPos];
	    
	    // add in the value of the white castling flags
	    if (b.plyCount < 25) { // DO NOT LEAVE THIS AT ZERO
	        if (b.validCastles > 0x3) { // this means the flags are greater than 0b0011, so a white flag exists
	            if (b.validCastles > 0xb) // this means the flags are greater than 0b1011, so both white flags must exist
	                pScore += chessHelpers::dCastleFlagValue[b.plyCount];
	            else
	                pScore += chessHelpers::castleFlagValue[b.plyCount]; 
	        }
	    }
	    // combine the elements of the score together 
	    return score + pScore; 
	}
    else
        return score;
}

void chessBoard::updatePosDepFlags(chessBoard::Board& b) {
    // the assumption is that this won't be called unless we NEED to recalculate the score,
    // thus it's given that recalculating the memoization is understood as necessary
    // still, to be sure
    chessBoard::flipBoard(b, chessBoard::scratch2);
    b.score = chessBoard::pdfWhite(b); // sets legalValid and checkValid here
    b.score -= chessBoard::scoreOnly(scratch2); 
}

void chessBoard::scoreBoard(chessBoard::Board& b) {
    // this is a score-only (non-memoizing) version of above
    chessBoard::flipBoard(b, chessBoard::scratch2);
    b.score = chessBoard::scoreOnly(b);
    b.score -= chessBoard::scoreOnly(scratch2); 
}

uint32_t chessBoard::scoreMaterial(chessBoard::Board& b) {
    // this is a material-only (non-memoizing, non-modifying, non-positional) version of above
    chessBoard::flipBoard(b, chessBoard::scratch2);
    return chessBoard::scoreOnly(b, 0) + chessBoard::scoreOnly(scratch2, 0); 
}

void chessBoard::orderPieces(const chessBoard::Board& b, uint8_t indices[64]) {
    for (uint8_t i = 0; i < 8; i++) {
        reinterpret_cast<uint64_t*>(indices)[i] = 0xffffffffffffffffULL;
    }
    uint8_t pawns[8];    uint8_t pi = 0;
    uint8_t rooks[16];   uint8_t ri = 0;
    uint8_t knights[16]; uint8_t ni = 0;
    uint8_t bishops[16]; uint8_t bi = 0;
    uint8_t king = 0xff;
    uint8_t queen = 0xff;
    uint8_t piece;
    
    for (uint8_t i = 0; i < 64; i++) {
        piece = chessBoard::getSquare(b, i);
        switch (piece) {
            case chessHelpers::wPawn:
                pawns[pi++] = i;
                break;
            case chessHelpers::wRook:
                rooks[ri++] = i;
                break;
            case chessHelpers::wKnight:
                knights[ni++] = i;
                break;
            case chessHelpers::wBishop:
                bishops[bi++] = i;
                break;
            case chessHelpers::wKing:
                king = i;
                break;
            case chessHelpers::wQueen:
                queen = i;
                break;
            default:
                // either it's empty or it's a black piece
                break;
        }
    }
    
    uint8_t oi = 0;
    // this recombination order is what decides the evaluation order!
    if (queen != 0xff)
        indices[oi++] = queen;
    for (uint8_t i = 0; i < ri; i++) {
        indices[oi++] = rooks[i];
    }
    for (uint8_t i = 0; i < bi; i++) {
        indices[oi++] = bishops[i];
    }
    for (uint8_t i = 0; i < ni; i++) {
        indices[oi++] = knights[i];
    }
    for (uint8_t i = 0; i < pi; i++) {
        indices[oi++] = pawns[i];
    }
    if (king != 0xff)
        indices[oi++] = king;
}

/*
uint8_t chessBoard::enumerateMoves(const chessBoard::Board& b) {
	for (uint8_t i = 0; i < 32; i++) {
	    reinterpret_cast<uint64_t*>(b.legalMoves)[i] = 0xffffffffffffffffULL;
	}
    
	uint8_t indices[64];
	chessBoard::orderPieces(b, indices);
	
	uint8_t wp = 0;
	for (uint8_t i = 0; i < 64; i++) {
	    uint8_t index = indices[i]; // the actual index is indices[i]
		if (index != 0xff) {
			uint8_t* candidates = getMoveList(chessBoard::getSquare(b, index), index);
			uint8_t to = *candidates;
			while (to != 0xff) {
				if (chessBoard::testLegality(b, index, to) != ILLEGAL) {
					dest[wp]  [0] = index;
					dest[wp++][1] = to;
				}
				to = *++candidates;
			}
		}
		else
		    break;
	}
	
	return wp;
}

uint8_t chessBoard::enumerateMoves(const chessBoard::Board& b, const uint8_t from) {
	// dest is [128] (minsize)
	for (uint8_t i = 0; i < 16; i++) {
	    reinterpret_cast<uint64_t*>(dest)[i] = 0xffffffffffffffffULL;
    }

    // there's no point in using ordering here because it's only one piece -- ordering doesn't apply
    
	uint8_t piece = chessBoard::getSquare(b, from);
	uint8_t wp = 0;
	if (isWhitePiece(piece) && !(piece == empty)) {
	    uint8_t* candidates = getMoveList(piece, from);
	    uint8_t to = *candidates;
	    while (to != 0xff) {
		    if (chessBoard::testLegality(b, from, to) != ILLEGAL) {
			    dest[wp++] = to;
		    }
	    	to = *++candidates;
	    }
	}
	
	return wp;
}
*/

uint8_t chessBoard::containsPawns(const chessBoard::Board& b) {
	for (uint8_t p = 0; p < 64; p++) {
		uint8_t s = chessBoard::getSquare(b, p);
		if (s == wPawn || s == bPawn) return 1;
	}
	return 0;
}

uint8_t chessBoard::containsRooks(const chessBoard::Board& b) {
	for (uint8_t p = 0; p < 64; p++) {
		uint8_t s = chessBoard::getSquare(b, p);
		if (s == wRook || s == bRook) return 1;
	}

	return 0;
}

uint8_t chessBoard::containsQueens(const chessBoard::Board& b) {
	for (uint8_t p = 0; p < 64; p++) {
		uint8_t s = chessBoard::getSquare(b, p);
		if (s == wQueen || s == bQueen) return 1;
	}

	return 0;
}

uint8_t chessBoard::containsTwoSameSideBishops(const chessBoard::Board& b) {
	uint8_t wbc = 0;
	uint8_t bbc = 0;
	for (uint8_t p = 0; p < 64; p++) {
		uint8_t s = chessBoard::getSquare(b, p);
		if      (s == wBishop) wbc++;
		else if (s == bBishop) bbc++;
	}
	if (wbc > 1 || bbc > 1) return 1;
	else                    return 0;
}

uint8_t chessBoard::containsSameSideBishopAndKnight(const chessBoard::Board& b) {
	uint8_t wb = 0, wn = 0, bb = 0, bn = 0;
	for (uint8_t p = 0; p < 64; p++) {
		uint8_t s = chessBoard::getSquare(b, p);
		if      (s == wBishop) wb = 1;
		else if (s == wKnight) wn = 1;
		else if (s == bBishop) bb = 1;
		else if (s == bKnight) bn = 1;
	}

	if (wb && wn) return 1;
	if (bb && bn) return 1;

	return 0;
}

uint8_t chessBoard::hasMoves(const chessBoard::Board& b) {
    uint8_t piece = 0;
	for (uint8_t i = 0; i < 64; i++) {
		piece = chessBoard::getSquare(b, i);
		if (isWhitePiece(piece) && !(piece == empty)) {
			uint8_t* candidates = getMoveList(piece, i);
			uint8_t to = *candidates;
			while (to != 0xff) {
				if (chessBoard::testLegality(b, i, to) != ILLEGAL)
					return 1;
				to = *++candidates;
			}
		}
	}
	
	return 0;
}

resolution chessBoard::getGameResolution(chessBoard::Board& b) {
    if (!chessBoard::hasMoves(b)) {
        if (chessBoard::updateCheck(b))
        	return CHECKMATE;
        else
        	return STALEMATE;
    }
    
    if (b.halfmoveClock >= 50)
    	return DRAWBY50;
    
    // repetition draws not handled here due to insufficient info
    
    if (!chessBoard::containsPawns(b) && !chessBoard::containsQueens(b) && !chessBoard::containsRooks(b) && !chessBoard::containsTwoSameSideBishops(b) && !chessBoard::containsSameSideBishopAndKnight(b))
        return DRAWINSUFFICIENT;
    
    return NOEND;
}
