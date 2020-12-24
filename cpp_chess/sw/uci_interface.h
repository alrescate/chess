#ifndef UCI_INTERFACE__H
#define UCI_INTERFACE__H

// #define UCI_NODE_INFO

#include <fstream>
#include <engine.h>

namespace chessUCI {
    const char name[] = "Storkfresh 2: Electric Boogaloo";
    const uint8_t name_size = 31;
    const char author[] = "Henry";
    const uint8_t author_size = 11;
    
    const char uci[] = "uci";
    const char isready[] = "isready";
    const char ucinewgame[] = "ucinewgame";
    const char position[] = "position ";
    const char go[] = "go";
    
    const char uciok[] = "uciok";
    const uint8_t uciok_size = 5;
    const char readyok[] = "readyok";
    const uint8_t readyok_size = 7;
    const char bestmove[] = "bestmove ";
    
    const char score[] = "info score cp ";
    const char line[] = "info pv ";
    
    extern std::string instruction;
    
    void get_input(std::string& ret, std::ofstream& log);
    void respond(const std::string& prompt, std::ofstream& log, chessEngine::Engine& e);
}

#endif
