/*
 * Board.h
 *
 *  Created on: May 29, 2019
 *      Author: henry
 */

#include <stdint.h>
#include <string>
#include <chessHelpers.h>
#include <HRand.h>

#ifndef BOARD_H_
#define BOARD_H_

// #define OP_WRITE

// #define EXPANDED_STRUCT

namespace chessBoard {
    struct Board {
        uint64_t ranks[8];
        chessHelpers::moveType legalities[64][64]; // enumeration of moves keyed [from][to] = moveType (can be illegal)
        uint8_t                legalMoves[256][2]; // enumeration of moves keyed [i] = from, to
        uint64_t hash;
        int32_t score;
        uint16_t plyCount;
    	uint8_t validCastles;
    	uint8_t enPassantTarget;
    	uint8_t halfmoveClock;
    	uint8_t flipped;
    	uint8_t wKingPos;
    	uint8_t bKingPos;
    	uint8_t legalValid; // indicates the validity of both legalities and legalMoves
    	uint8_t gamePhase; // 0 = early game, 1 = middle game, 2 = late game
    	uint8_t restrictLegalities; // indicates whether this board is allowed to include non-captures in its legal moves
    	uint8_t inCheck;
    	uint8_t checkValid;
    	uint8_t pliesUntilLeafProduction; // this is set to the minDepth - 1 outside of a negamax call
    };

    extern HRand r;
    extern Board scratch1;
    extern Board scratch2;
    extern volatile void* mem_map;
    extern const uint32_t phase2mc;
    extern const uint8_t phase2pc;
    
    extern uint8_t legalBuffer[256][2];
    
    extern uint64_t knightCounter;
    extern uint64_t pawnCounter;
    extern uint64_t kingCounter;
    extern uint64_t controlQueries;
    extern uint64_t checkQueries;
    extern uint64_t bishopCounter;
    extern uint64_t rookCounter;
    
    // these functions are purely for display, and involve no changes to the board
    void convertCastles(const Board& b, std::string& target);
    void convertEnPassant(const Board& b, std::string& target);
    
    // these functions all have scoring responsibilities, but only
    // pdfWhite and scoreOnly contain any actual scoring algorithms
    int32_t pdfWhite(Board& b);
    int32_t scoreOnly(Board& b, const uint8_t positional = 1);
    void updatePosDepFlags(Board& b);
    void scoreBoard(Board& b);
    uint32_t scoreMaterial(Board& b);
    
    // these functions all have presence-testing responsibilities
    uint8_t containsPawns(const Board& b);
    uint8_t containsRooks(const Board& b);
    uint8_t containsQueens(const Board& b);
    uint8_t containsTwoSameSideBishops(const Board& b);
    uint8_t containsSameSideBishopAndKnight(const Board& b);
    uint8_t hasMoves(const Board& b);
    
    // a randomizer
    uint64_t next(const uint64_t u);
    
    // these are low processing-overhead board configuring functions
    void setFromBoard(Board& b, const Board& other, const uint8_t move_memos = 0);
    void clearBoard(Board& b);
    
    // these are relatively simple metadata calculation functions
    void rehash(Board& b);
    uint8_t calcPhase(Board& b, const uint8_t pc);
    
    // this is a high processing-overhead board configuring function
    void setFromFEN(Board& b, const char* const FEN);
    
    // these are purely display functions, and do not modify Board contents
    void toString(const Board& b, std::string& target);
    void boardToFEN(const Board& b, std::string& target);
    
    // these are board content-modifying functions 
    void randomizeBoard(Board& b); // this almost certainly produces illegal positions as-is
    void setSquare(Board& b, const uint8_t piece, const uint8_t i);
    void setSquare(Board& b, const uint8_t piece, const uint8_t r, const uint8_t c);
    void setFlag(Board& b, const uint8_t i);
    
    // these are board content-testing functions
    inline uint8_t getSquare(const chessBoard::Board& b, const uint8_t i) {
	    return *(reinterpret_cast<const uint8_t*>(b.ranks) + i);
    }
    inline uint8_t getSquare(const chessBoard::Board& b, const uint8_t r, const uint8_t c) {
	    return *(reinterpret_cast<const uint8_t*>(b.ranks[r])+c);
    }
    uint8_t equals(const Board& b, const Board& other);
    inline uint8_t isEmpty(const chessBoard::Board& b, const uint8_t i) {
   	    return chessBoard::getSquare(b, i) == chessHelpers::empty;
    }
    uint8_t isWhite(const Board& b, const uint8_t i);
    uint8_t isBlack(const Board& b, const uint8_t i);
    uint8_t isClearPath(const Board& b, const uint8_t from, const uint8_t to);
    uint8_t isBlackControlled(const Board& b, const uint8_t i);
    // uint8_t isBlackControlled_hw(const Board& b, const uint8_t i); // These would be needed if we
    // uint8_t isBlackControlled_sw(const Board& b, const uint8_t i); // wanted to do hw acceleration
    uint8_t updateCheck(Board& b);
    
    // these are the flipping functions
    void flipBoard(const Board& b,  Board& target);
    void flipBoard(Board& refl);
    
    // this is a legality-testing function for hypothetical moves
    chessHelpers::moveType testLegality(const Board& b, const uint8_t from, const uint8_t to);
    
    // these are the move-playing functions, with a subtle distinction predicated on whether
    // the function is expected to check for an illegal move in the moveType field
    // in makeMove, the function is expected to check. In playMove, it is not.
    uint8_t playMove(Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval, const chessHelpers::moveType move);
    uint8_t makeMove(Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval, const chessHelpers::moveType inheritedMemo);
    uint8_t makeMove(Board& b, const uint8_t from, const uint8_t to, const uint8_t promotion, const uint8_t eval);
    
    // this is a function which sorts the potential moves to acquire a higher pruning factor
    // when they are eventually made into children on the tree in negamax
    void orderPieces(const Board& b, uint8_t indices[64]);
    
    // uint8_t enumerateMoves(const Board& b, uint8_t from);
    // uint8_t enumerateMoves(const Board& b);
    
    // this is a function which evaluations the final resolution of a game
    chessHelpers::resolution getGameResolution(Board& b);

}

#endif /* BOARD_H_ */
