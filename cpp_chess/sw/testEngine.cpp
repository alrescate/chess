#include <engine.h>
#include <chrono>

// remember to include these wherever boards are being used by a main!

using namespace std::chrono;

int main(int argc, char** argv) {
    chessHelpers::setup();
    chessBoard::Board b;
#ifdef OP_WRITE
    std::cout << "library ieee;\n"
    "use ieee.std_logic_1164.all;\n"
    "use ieee.numeric_std.all;\n\n"
    
    "library soc_system;\n"
    "use soc_system.chess_rtl_pkg.all;\n\n"
    
    "entity black_ctrl is\n"
      "port (\n"
        "clk : in std_logic;\n"
        "board : in boardRecord;\n"
        "blackControlled : out std_logic_vector(63 downto 0)\n"
      ");\n"
    "end entity;\n\n"
    
    "architecture rtl of black_ctrl is\n"
      "signal isBlackControlled : std_logic_vector(63 downto 0);\n"
    "begin\n\n";
    uint8_t K = chessHelpers::wKing;
    uint8_t k = chessHelpers::bKing;
    for (uint8_t i = 0; i < 64; i++) {
        chessBoard::clearBoard(b);
        chessBoard::setSquare(b, K, i);
        if (i < 32)
            chessBoard::setSquare(b, k, 63);
        else
            chessBoard::setSquare(b, k, 0);
        chessBoard::isCheck(b);
    }
    std::cout << "blackControlled <= isBlackControlled when rising_edge(clk);\nend architecture;\n" << std::endl;   	
    
    return EXIT_SUCCESS;
    
#else
    const int32_t dAlpha = chessHelpers::minInfinity;
    const int32_t dBeta  = chessHelpers::maxInfinity;
    const char fen[] = "7k/n1n5/8/1P6/8/8/8/7K w - - 0 0";
    chessBoard::setFromFEN(b, fen);
    
    chessEngine::Engine e; 
    chessEngine::setEngine(e, &b, 0, 0, 0); // the last field is verbose
    
    chessBoard::toString(e.cBoard, chessEngine::tempTo);
    
    std::cout << chessEngine::tempTo << std::endl;
    
    auto start = high_resolution_clock::now();
    int32_t res = chessEngine::negamax(e, dAlpha, dBeta, 0);
    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start); 
    std::cout << "Time: " << duration.count() << std::endl;
    
    std::cout << res << std::endl;
    std::cout << e.nodeCount << std::endl;
    for (uint16_t m = 0; m < chessEngine::depthLimit; m++) {
        if (e.bestMoves[0][m][0] == 0xff)
        	break;
        else
        	if (m % 2 == 1)
        	    std::cout << chessHelpers::twoCharNamingTable[chessHelpers::mirrorIndex(e.bestMoves[0][m][0])] << chessHelpers::twoCharNamingTable[chessHelpers::mirrorIndex(e.bestMoves[0][m][1])] << std::endl;
        	else 
        		std::cout << chessHelpers::twoCharNamingTable[e.bestMoves[0][m][0]] << chessHelpers::twoCharNamingTable[e.bestMoves[0][m][1]] << std::endl;
    }
	
	return EXIT_SUCCESS;
#endif
}

/*
3r1rk1/1bp1qppp/pp2pb2/3n4/3P4/P2QBN2/1P3PPP/1B1RR1K1 w - - 0 0 // mate in one puzzle
7k/R7/1R6/8/8/8/8/7K w - - 0 0                                  // mate in one puzzle
rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w - - 0 0           // unspecified evaluation
k7/8/8/8/8/8/8/7K w - - 49 0                                    // scoring when draw is unnavoidable

3r1rk1/1bp1qppp/pp2pb2/3n4/3P4/P2QBN2/1P3PPP/1B1RR1K1 w - - 0 0 // for use with rigging of hashHistory so that preffered move is not beneficial anymore - draw
2bqkbn1/2pppp2/np2N3/r3P1p1/p2N2B1/5Q2/PPPPKPP1/RNB2r2 w KQkq - 0 1 // mate in two puzzle
8/6K1/1p1B1RB1/8/2Q5/2n1kP1N/3b4/4n3 w - - 0 1 // mate in two puzzle - solution is d6a3 for some reason
B7/K1B1p1Q1/5r2/7p/1P1kp1bR/3P3R/1P1NP3/2n5 w - - 0 1 // mate in two puzzle
8/2k2p2/2b3p1/P1p1Np2/1p3b2/1P1K4/5r2/R3R3 b - - 0 1 // mate in two puzzle
8/qQ5p/3pN2K/3pp1R1/4k3/7N/1b1PP3/8 w - - 0 0 // mate in two puzzle
r5rk/5p1p/5R2/4B3/8/8/7P/7K w - - 0 0 // mate in three puzzle
2q1nk1r/4Rp2/1ppp1P2/6Pp/3p1B2/3P3P/PPP1Q3/6K1 w - - 0 0 // mate in five puzzle
7R/r1p1q1pp/3k4/1p1n1Q2/3N4/8/1PP2PPP/2B3K1 w - - 1 0 // mate in four puzzle
7k/n1n5/8/1P6/8/8/8/7K w - - 0 0 // pruning example
*/