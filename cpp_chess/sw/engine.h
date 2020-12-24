#include <Board.h> // this acquires numerous other imports, including string and iostream
#ifndef ENGINE_H_
#define ENGINE_H_

// #define TIME_CHECK

#ifdef TIME_CHECK
#include <chrono>
#endif

namespace chessEngine {
    
    const uint8_t minDepth = 4; // this is the minimum depth to search to, or the "quick evaluation" depth
    const uint8_t maxDepth = minDepth + 6; // this is the deepest any search can go without cutting off
    const uint8_t depthLimit = maxDepth + 4;   // the maximum depth used to allocate arrays, 
                                               // which should always be larger than necessary
    
    const uint16_t hashDepth = 400; // presumed to be the max game length
    const uint8_t defaultPromotion = chessHelpers::wQueen;
    
    const int32_t  qCutoff = 22000;     // 2.2 pawns of change is considered to be "significant" and make a node unstable
    const int32_t nqCutoff = -qCutoff; // this is just to save time by pre-computing this operation
    
    extern std::string tempTo;
#ifdef TIME_CHECK
    extern std::chrono::time_point<std::chrono::high_resolution_clock> startTime;
    extern std::chrono::time_point<std::chrono::high_resolution_clock> stopTime;
    extern std::chrono::microseconds dif;
#endif
    
    struct Engine {
        chessBoard::Board cBoard; // the current state, more important in a UCI context but still useful here
        uint16_t hashIndex;       // the current stack access, sitting on the currently used index
        uint32_t nodeCount;       // how many nodes have been evaluated
        uint8_t verbose;          // to be altered if trying to debug

        chessBoard::Board boardStack[depthLimit + 4]; // thinking space for negamax
        uint64_t hashHistory[hashDepth];              // hash tracking
        uint8_t childMoves[depthLimit][128][2];       // for the negamax calls to write into - enumerateMoves will stuff it with 0xff for you

        chessHelpers::moveType typeStack[depthLimit]; // so that the move types in the current stack configuration are known
        
	    uint8_t bestMoves[depthLimit][depthLimit][2];
	    // Lengthy explanation: what is bestMoves, and how does it work?
        // It is the pair of move indices which indicate the best move sequence to reach the chosen leaf node from any given depth 
        // down to the leaf. This is maintained so that the lower stack depths can communicate their ideal moves lists down the 
        // stack without any new return information or other inconvenient tricks. The use of the array is triangular, following
        // the rule that you only begin writing from the stackAccess (aka depth) down. Thus...
        //       0    1    2    3    4 
        //  0    K    X    X    X    X
        //  1    L    L    X    X    X
        //  2    M    M    M    X    X
        //  3    N    N    N    N    X
        //  4 0xff 0xff 0xff 0xff 0xff <- this one is put here by the leaf
        // is built in reverse order (3 down to 0) for a depthLimit of 4.
	};

	void setEngine(Engine& e, const chessBoard::Board* b, const uint16_t hi = 0, const uint32_t nc = 0, const uint8_t v = 0);
	void setEngine(Engine& e, const char* const fen, const uint16_t hi = 0, const uint32_t nc = 0, const uint8_t v = 0);
	void setEngine(Engine& e, const uint16_t hi = 0, const uint32_t nc = 0, const uint8_t v = 0);
	void setEngine_root(Engine& e, const uint16_t hi, const uint32_t nc, const uint8_t v);
	
	void setStacks(Engine& e);
	
    uint8_t checkRepetitionDraw(Engine& e, const uint16_t stackAccess);

    void clrMovesBelow(Engine& e, const uint16_t stackOffset);
    
    int32_t negamax(Engine& e, int32_t alpha, const int32_t beta, const uint16_t stackAccess, const uint8_t prior_prune = 0);

}
#endif
