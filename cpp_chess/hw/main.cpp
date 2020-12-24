/*
This program demonstrate how to use hps communicate with FPGA through light AXI Bridge.
uses should program the FPGA by GHRD project before executing the program
refer to user manual chapter 7 for details about the demo
*/

// #include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"
#include <engine.h>
#include <chrono>

#define HW_REGS_BASE ( 0xc0000000 )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

/*
chessBoard::Board chessBoard::scratch;
HRand             chessBoard::r;
std::string       chessEngine::tempTo;
volatile void*    chessBoard::mem_map = NULL;
*/

// #define TEST_BC
// #define HW_ENABLE
#define NATIVE
int main() {
    
    // remember to include these wherever boards are being used by a main!
    chessHelpers::setup();
#ifndef NATIVE
	void *virtual_base;
	int fd;
	volatile void *h2p_chess_addr;
	
	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
    //ALT_H2F_OFST	ALT_LWFPGASLVS_OFST
	h2p_chess_addr=virtual_base + ( ( unsigned long  )( CHESS_TOP_0_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
#endif

	// const char fen[] = "8/6K1/1p1B1RB1/8/2Q5/2n1kP1N/3b4/4n3 w - - 0 1"; // known 1099 on a 6 ply depth
	// const char fen[] = "q7/8/8/3p4/8/8/4k3/1K6 w - - 0 1"; // nearly empty board for verifying black control data
	// const char fen[] = "8/8/8/8/8/8/4k3/1K6 w - - 0 1"; // as above, nearly empty for black control verifications
	const char fen[] = "2bqkbn1/2pppp2/np2N3/r3P1p1/p2N2B1/5Q2/PPPPKPP1/RNB2r2 w KQkq - 0 1"; // known 3404 on 6 ply depth
	// const char fen[] = "7k/R7/1R6/8/8/8/8/7K w - - 0 0"; // mate in one in an extremely simple case
	// const char fen[] = "7R/r1p1q1pp/3k4/1p1n1Q2/3N4/8/1PP2PPP/2B3K1 w - - 1 0"; // mate in 4, don't give to engines right now unless you want to wait around for a day
	// const char fen[] = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 0"; // starting position
	
	std::string temp("");
    chessBoard::Board b;
    chessBoard::setFromFEN(b, fen);
#ifdef TEST_BC
#ifndef NATIVE
    // chessBoard::randomizeBoard(b);
    chessBoard::toString(b, temp);
    
    std::cout << temp << std::endl;
    // std::cout << "Write #" << i << std::endl;
    
    *((chessBoard::Board*)h2p_chess_addr) = b;
	uint64_t black_controlled = *((uint64_t*)h2p_chess_addr + 12);
	printf( "%llu\n", black_controlled);
	uint64_t black_king = *((uint64_t*)h2p_chess_addr + 13);
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
	    printf( "  %u ", chessBoard::isBlackControlled(b, s));
	    cbc |= ((uint64_t)chessBoard::isBlackControlled(b, s) << (uint8_t)(s));
	}
	black_controlled = *((uint64_t*)h2p_chess_addr + 12);
	if (cbc != black_controlled)
	    printf("\nFailed the equality check! %llx vs %llx", black_controlled, cbc); 
	printf("\n");
	
	uint64_t test_read = *((uint64_t*)h2p_chess_addr + 14);
	printf( "%llu\n", test_read);
#endif
#else
#ifdef HW_ENABLE
#ifndef NATIVE
    chessBoard::mem_map = h2p_chess_addr;
    uint64_t ID = *((uint64_t*)chessBoard::mem_map + 14);
    if (ID != 0x456723891290abdf) {
        printf("WARNING: Hardware doesn't appear to be configured! Expected 0x456723891290abdf and got %llx\n", ID);
    }
#endif
#endif
    const int32_t dAlpha = chessHelpers::minInfinity;
    const int32_t dBeta  = chessHelpers::maxInfinity;
    
    std::cout << sizeof(b) << std::endl;
    
    chessEngine::Engine e; 
    chessEngine::setEngine(e, &b, 0, 0, 0);
    
    chessBoard::toString(e.cBoard, chessEngine::tempTo);
    
    std::cout << chessEngine::tempTo << std::endl;
    
    auto start = std::chrono::high_resolution_clock::now();
    int32_t res = chessEngine::negamax(e, dAlpha, dBeta, 0);
    auto stop = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::microseconds>(stop - start); 
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
#endif
#ifndef NATIVE
    // clean up our memory mapping and exit
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}
    
    close( fd );
#endif
	return( 0 );
}
