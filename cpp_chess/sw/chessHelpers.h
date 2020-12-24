#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <iomanip>
#include <iostream>
#include <string>
#ifndef CHESS_HELPERS_H
#define CHESS_HELPERS_H

// E C K Q B N R P
// 0 0 1 0 0 0 0 0 = White King
// 1 0 0 0 0 0 0 0 = Empty (empty with color bit set not allowed)

namespace chessHelpers {
    
    const uint8_t blackMask = 0x40;
    
    const uint8_t  empty     =                  0x80;
    const uint64_t emptyRank = 0x8080808080808080ULL;
    const uint8_t  wPawn     =                  0x01;
    const uint8_t  wRook     =                  0x02;
    const uint8_t  wKnight   =                  0x04;
    const uint8_t  wBishop   =                  0x08;
    const uint8_t  wQueen    =                  0x10;
    const uint8_t  wKing     =                  0x20;
    
    const uint8_t bPawn   = wPawn   | blackMask;
    const uint8_t bRook   = wRook   | blackMask;
    const uint8_t bKnight = wKnight | blackMask;
    const uint8_t bBishop = wBishop | blackMask;
    const uint8_t bQueen  = wQueen  | blackMask;
    const uint8_t bKing   = wKing   | blackMask;
    
    const int32_t scoreTable[] = {      1,  10000,  50000, 1,  32000, 1, 1, 1,   // 00000001 P, 00000010 R, 00000100 N
                                    34000,      1,      1, 1,      1, 1, 1, 1,   // 00001000 B
                                    88000,      1,      1, 1,      1, 1, 1, 1,   // 00010000 Q
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        0,      1,      1, 1,      1, 1, 1, 1,   // 00100000 K
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                       -1, -10000, -50000, 1, -32000, 1, 1, 1,   // 01000001 p, 01000010 r, 01000100 n
                                   -34000,      1,      1, 1,      1, 1, 1, 1,   // 01001000 b
                                   -88000,      1,      1, 1,      1, 1, 1, 1,   // 01010000 q
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        0,      1,      1, 1,      1, 1, 1, 1,   // 01100000 k
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        1,      1,      1, 1,      1, 1, 1, 1,   //
                                        0,      1,      1, 1,      1, 1, 1, 1,   // 10000000 Empty is zero!!!
                                        1,      1,      1, 1,      1, 1, 1, 1 }; // The table used to extend down here, but because colored empties are no longer possible, that isn't needed
    
    // the horrific metadata structure has been eliminated in favor of a class
    // arrays defined so that they can be looped through in methods like ranomizeBoard and isBlackControlled
    const uint8_t pieceArray[] = { wPawn, wRook, wKnight, wBishop, wQueen, wKing,
                                   bPawn, bRook, bKnight, bBishop, bQueen, bKing };
    const uint8_t enPassantTargets[] = { 16, 17, 18, 19, 20, 21, 22, 23, 
    		                             40, 41, 42, 43, 44, 45, 46, 47 };
    // const uint8_t brArray[] = { wRook, wBishop }; - this had a use which has now been removed
    
    // these are bit-fields which state what squares are adjacent to a certain square
    const uint64_t adjTable[] = { 0x302ULL,
                                  0x705ULL,
                                  0xe0aULL,
                                  0x1c14ULL,
                                  0x3828ULL,
                                  0x7050ULL,
                                  0xe0a0ULL,
                                  0xc040ULL,
                                  0x30203ULL,
                                  0x70507ULL,
                                  0xe0a0eULL,
                                  0x1c141cULL,
                                  0x382838ULL,
                                  0x705070ULL,
                                  0xe0a0e0ULL,
                                  0xc040c0ULL,
                                  0x3020300ULL,
                                  0x7050700ULL,
                                  0xe0a0e00ULL,
                                  0x1c141c00ULL,
                                  0x38283800ULL,
                                  0x70507000ULL,
                                  0xe0a0e000ULL,
                                  0xc040c000ULL,
                                  0x302030000ULL,
                                  0x705070000ULL,
                                  0xe0a0e0000ULL,
                                  0x1c141c0000ULL,
                                  0x3828380000ULL,
                                  0x7050700000ULL,
                                  0xe0a0e00000ULL,
                                  0xc040c00000ULL,
                                  0x30203000000ULL,
                                  0x70507000000ULL,
                                  0xe0a0e000000ULL,
                                  0x1c141c000000ULL,
                                  0x382838000000ULL,
                                  0x705070000000ULL,
                                  0xe0a0e0000000ULL,
                                  0xc040c0000000ULL,
                                  0x3020300000000ULL,
                                  0x7050700000000ULL,
                                  0xe0a0e00000000ULL,
                                  0x1c141c00000000ULL,
                                  0x38283800000000ULL,
                                  0x70507000000000ULL,
                                  0xe0a0e000000000ULL,
                                  0xc040c000000000ULL,
                                  0x302030000000000ULL,
                                  0x705070000000000ULL,
                                  0xe0a0e0000000000ULL,
                                  0x1c141c0000000000ULL,
                                  0x3828380000000000ULL,
                                  0x7050700000000000ULL,
                                  0xe0a0e00000000000ULL,
                                  0xc040c00000000000ULL,
                                  0x203000000000000ULL,
                                  0x507000000000000ULL,
                                  0xa0e000000000000ULL,
                                  0x141c000000000000ULL,
                                  0x2838000000000000ULL,
                                  0x5070000000000000ULL,
                                  0xa0e0000000000000ULL,
                                  0x40c0000000000000ULL };


    // early in the game, the king is encouraged to stay in the back rank of the board
    const int32_t p0kingtable[] = { -8000, -8000, -8000, -8000, -8000, -8000, -8000, -8000, 
                                    -4000, -4000, -4000, -4000, -4000, -4000, -4000, -4000, 
                                    -2000, -2000, -2000, -2000, -2000, -2000, -2000, -2000, 
                                    -1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000, 
                                     -500,  -500,  -500,  -500,  -500,  -500,  -500,  -500, 
                                     -100,   -75,   -50,   -25,   -10,   -25,   -50,   -75, 
                                        0,     0,     0,     0,     0,     0,     0,     0, 
                                        5,    10,    20,    50,   100,    50,    20,    10  };
    
    // in the middle of the game, the king is heavily encouraged to be in a post-castle position
    const int32_t p1kingtable[] = { -8000, -8000, -8000, -8000, -8000, -8000, -8000, -8000, 
                                    -4000, -4000, -4000, -4000, -4000, -4000, -4000, -4000, 
                                    -2000, -2000, -2000, -2000, -2000, -2000, -2000, -2000, 
                                    -1000, -1000, -1000, -1000, -1000, -1000, -1000, -1000, 
                                     -500,  -500,  -500,  -500,  -500,  -500,  -500,  -500, 
                                     -100,  -150,  -200,  -500,  -500,  -200,  -150,  -100, 
                                      150,   100,    50,   -50,   -50,    50,   100,   150, 
                                      500,  1000,  1000,     0,    50,     0,  1000,   500  };
    // in the end of the game, the king is encouraged to be central or toward the advanced positions
    const uint32_t p2kingtable[] = { 2000, 2000, 2000, 2000, 2000, 2000, 2000, 2000, 
                                     1500, 1500, 1500, 1500, 1500, 1500, 1500, 1500, 
                                     1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 
                                      750,  750,  800, 1000, 1000,  800,  750,  750, 
                                      500,  750,  800, 1000, 1000,  800,  750,  500, 
                                      250,  500,  750,  800,  800,  750,  500,  250, 
                                      170,  250,  500,  750,  750,  500,  250,  170, 
                                       50,  170,  250,  500,  500,  250,  170,   50 };
                             
    // a table specifying what value a castle flag possesses on a certain ply of the game
    // note that this produces a symmetric "decaying" effect for the value of castling's ability, 
    // which makes the engine more likely to see greater value in castling than it does in having
    // the ability to castle as the game progresses
    const uint32_t castleFlagValue[] = {
        500, 450, 450, 450, 400, 400, 400, 350, 350, 300, 
        300, 250, 250, 200, 200, 150, 100, 100,  50,  50,
         25,  25,  10,  10,   0 
    };
    
    // this second array exists purely as a minor optimization to avoid unnecessary
    // arithmetic during scoring evaluation
    const uint32_t dCastleFlagValue[] = {
        1000, 900, 900, 900, 800, 800, 800, 700, 700, 600, 
         600, 500, 500, 400, 400, 300, 200, 200, 100, 100,
          50,  50,  20,  20,   0 
    };
    
    // castle flags are KQkq bitwise
    const uint8_t allCastles  = 15;
    const uint8_t noCastles   =  0;
    const uint8_t noEnPassant = 0xff;
    
    const uint8_t flag = 0xfe;
    
    const uint8_t noTarget = 0xff;
    
    // declare the objects here, new them in the setup, delete them in the cleanup
    extern uint8_t flipTable[64];
    extern uint8_t pathTable[64][64][8];
    extern uint8_t physTable[33][64][32];
    const char start_pos[] = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0 ";
    
    // square index constants for testLegality
    const uint8_t kingStart          = 60;
    const uint8_t kingCastleThrough  = 61;
    const uint8_t kingCastleEnd      = 62;
    const uint8_t queenCastleThrough = 59;
    const uint8_t queenCastleEnd     = 58;
    
    const int32_t minInfinity = -100000000;
    const int32_t maxInfinity =  100000000;
    
    enum moveType {
    	STANDARD_LEGAL,
    	PROTECTED_CAPTURE,
    	UNPROTECTED_CAPTURE,
    	ILLEGAL,
    	CAPTURE_EN_PASSANT,
    	PAWN_MOVED_TWO,
    	CASTLE_KINGSIDE,
    	CASTLE_QUEENSIDE,
    	PROMOTION
    };
    
    enum resolution {
    	CHECKMATE,        // whiteish has lost
    	STALEMATE,        // draw-type
    	DRAWBY50,         // 50 plies without pawn move or capture
    	DRAWBYREPEAT,     // 3-fold repetition
    	DRAWINSUFFICIENT, // draw by insufficient material
    	NOEND             // game not over
    };
    
    const char twoCharNamingTable[][3] = { "a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8", 
                                           "a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7",
                                           "a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6",
                                           "a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5",
                                           "a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4",
                                           "a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3",
                                           "a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2",
                                           "a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1" };
                                           
    inline uint8_t itor(const uint8_t index) {
        return index >> 3;
    }
    
    inline uint8_t itoc(const uint8_t index) {
        return index & 7;
    }
    
    inline uint8_t rctoi(const uint8_t row, const uint8_t column) {
        return (row << 3) + column;
    }
    
    uint8_t colorChange(uint8_t piece);
    
    inline uint8_t isWhitePiece(const uint8_t piece) {
	    return (piece & blackMask) == 0;
    }
    
    inline uint8_t isBlackPiece(const uint8_t piece) {
	    return (piece & blackMask) != 0;
    }
    
    void itorc(const uint8_t i, uint8_t* rc);
    
    uint64_t swapRankColor(const uint64_t rank);
    
    void makeFlipTable(void);
    
    uint8_t twoCharToIndex(const char* twoChar);
    
    uint8_t charToCode(const char piece);
    
    char codeToChar(const uint8_t code);
    
    void makePathTable(void);
    
    uint8_t rcOnBoard(const uint8_t r, const uint8_t c);
    
    void listRookMoves(uint8_t fromIndex, uint8_t* dest);
    
    void listBishopMoves(uint8_t fromIndex, uint8_t* dest);
    
    void generateKnightDestinations(uint8_t r, uint8_t c, uint8_t dest[8][2]);
    
    void listKnightMoves(uint8_t fromIndex, uint8_t* dest);
    
    void listPawnMoves(uint8_t fromIndex, uint8_t* dest);
    
    void generateKingDestinations(uint8_t r, uint8_t c, uint8_t dest[][2]);
    
    void listKingMoves(uint8_t fromIndex, uint8_t* dest);
    
    void makePhysTable(void);
    
    inline uint8_t* getMoveList(const uint8_t piece, const uint8_t square) { // guaranteed 32 safe indicies from returned pointer
        return chessHelpers::physTable[piece][square];
    }
    
    inline uint8_t* getPassedThrough(const uint8_t fromI, const uint8_t toI) {
	    return chessHelpers::pathTable[fromI][toI];
    }
    
    inline uint64_t mirrorIndex(const uint64_t index) {
        return chessHelpers::flipTable[index];
    }

    
    void mirrorMovePair(const uint8_t* movePair, uint8_t* dest);
    
    void setup(void);
    
    void testAll(void);

}

/* Test answer key
6 6 is the r/c of 54
1 5 is the r/c of 13
7 7 is the r/c of 63
0 0 is the r/c of 0
--------------------
12 is the index of 1, 4
31 is the index of 3, 7
63 is the index of 7, 7
0 is the index of 0, 0
--------------------
500 is the score of R
350 is the score of N
350 is the score of B
800 is the score of Q
9999 is the score of K
100 is the score of P
-500 is the score of r
-350 is the score of n
-350 is the score of b
-800 is the score of q
9999 is the score of k
-100 is the score of p
--------------------
rnbqkbnrp is the swap of RNBQKBNRP
--------------------
22 flips to 46
13 flips to 53
31 flips to 39
0 flips to 56
--------------------
a4 is the 2-char of 32
b3 is the 2-char of 41
h1 is the 2-char of 63
a8 is the 2-char of 0
--------------------
10 255 is passed through between 1 and 19
255 is passed through between 5 and 16
9 18 27 36 45 54 255 is passed through between 0 and 63
9 18 27 36 45 54 255 is passed through between 63 and 0
--------------------
A rook   on 16 can go to 17 18 19 20 21 22 23 0 8 24 32 40 48 56 255
A queen  on 63 can go to 56 57 58 59 60 61 62 7 15 23 31 39 47 55 54 45 36 27 18 9 0 255
A king   on 60 can go to 62 58 51 52 53 59 61 255
A bishop on 33 can go to 42 40 26 24 51 19 60 12 5 255
A knight on 46 can go to 63 61 31 29 52 36 255
A pawn   on 52 can go to 44 36 43 45 255
A pawn   on 31 can go to 23 22 255
A pawn   on  8 can go to 0 1 255
 * */

#endif
