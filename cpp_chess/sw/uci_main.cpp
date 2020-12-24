#include <uci_interface.h>

int main(int argc, char** argv) {
    chessHelpers::setup();
    
    const uint8_t verboseLevel = 10;
    
    chessBoard::Board b; // the board underlying the cBoard of the engine
    chessEngine::Engine e; // the engine for the UCI
    std::ofstream log("log.txt"); // this is an IO-level thing, so we do it in here
    log.write("--- Log opened ---\n", 19);  // WHY IS WRITE HERE ????
    log.write("--- WARNING ---\n", 16);
    log.write("verbose was set to ", 19);
    log << (uint16_t)verboseLevel << std::endl;
    chessBoard::setFromFEN(b, chessHelpers::start_pos); // this will probably be ignored, but it's good to make sure it starts in a known state
    chessEngine::setEngine(e, &b, 0, 0, verboseLevel); // edit the last field here to increase verbose level
    // chessEngine::negamax(e, chessHelpers::minInfinity, chessHelpers::maxInfinity, 0); // DON'T LEAVE THIS HERE
    
    while (1) {
        chessUCI::get_input(chessUCI::instruction, log);
        // std::cout << "Thought we just read in " << chessUCI::instruction << std::endl; // ABSOLUTELY DO NOT LEAVE THIS HERE
        if (chessUCI::instruction.compare(0, 4, "quit") == 0)
            break;
        chessUCI::respond(chessUCI::instruction, log, e);
        chessUCI::instruction.clear();
    }
    /*
    log << chessBoard::knightCounter << " calls to isBlackControlled resolved by knight control" << std::endl;
    log << chessBoard::pawnCounter << " calls to isBlackControlled resolved by pawn control" << std::endl;
    log << chessBoard::kingCounter << " calls to isBlackControlled resolved by king control" << std::endl;
    log << chessBoard::rookCounter << " calls to isBlackControlled resolved by rook control" << std::endl;
    log << chessBoard::bishopCounter << " calls to isBlackControlled resolved by bishop control" << std::endl;
    */
    log << "total control queries: " << chessBoard::controlQueries << std::endl;
    log << "check queries: " << chessBoard::checkQueries << std::endl;
    log.write("--- Log closing ---\n", 20); 
    log.close();
    
    return EXIT_SUCCESS;
}