#include <uci_interface.h>

std::string chessUCI::instruction;

double exp(const double base, const uint8_t pow) {
    double ans = 1;
    for (uint8_t i = 0; i < pow; i++)
        ans *= base;
    
    return ans;
}

double calculateEst(const double bfe, const uint8_t depth) {
    double val = 0;
    for (uint8_t i = depth; i > 0; i--) {
        val += exp(bfe, i);
    }
    
    return val+1;
}

double calculateBF(const uint32_t nodes, const uint8_t depth, std::ofstream& log) {
    double ne = 0;
    double be = 1;
    double lower = 0;
    double higher = 100; // this is an assumption, that there will never be a tree with a branching factor above 100
    
    // log << "actually entered function for BF" << std::endl;
    
    while (!(((ne - nodes) < 100.0) && ((ne - nodes) > -100.0))) {
        // log << "actually entered the loop for BF" << std::endl;
        ne = calculateEst(be, depth); // calculate the number of nodes expected with our current base estimate
        if (ne < nodes) // if this is an underestimate
            lower = be;
        else if (ne > nodes) // if this is an overestimate
            higher = be;
        else
            break; // if we somehow got it exactly right, go us
        
        be = (lower + higher) / 2.0;
        // log << "trying branching factor " << be << std::endl;
    }
    
    return be;
}

void chessUCI::get_input(std::string& ss, std::ofstream& log) {
    char c = std::cin.get();
    while (c != '\n') {
        ss += c;
        c = std::cin.get();
    }
    
    log.write(ss.c_str(), ss.length()).put('\n');
}

// to simulate GUI function, type the following things into the terminal after running the uciEngine:
//     "uci"
//     -> "info name cppChess"
//     -> "info author Henry"
//     -> "uciok"
//     "isready"
//     -> "readyok"
//     "ucinewgame"
//     -> no response expected
//     "position fen [FEN string, properly formatted]
//     -> should get no response, if the string is bad it will show up in the log
//     ALTERNATIVELY
//     "position startpos moves [moves using only square two-chars without changing sense]
//     -> again, no response is expected
//     "go"
//     -> 

void chessUCI::respond(const std::string& prompt, std::ofstream& log, chessEngine::Engine& e) {
    // the prompt EXCLUDES the \n char
    if (prompt.compare(chessUCI::uci) == 0) {
        // the prompt is "uci"
        // we send "info name cppChess\n"
        // we send "info author Henry\n"
        // we respond with "uciok\n"
        std::cout << "id name " << chessUCI::name << std::endl;   log.write("id name ", 8).write(chessUCI::name, chessUCI::name_size).put('\n');
        std::cout << "id author " << chessUCI::author << std::endl; log.write("id author ", 10).write(chessUCI::author, chessUCI::author_size).put('\n');
        std::cout << chessUCI::uciok << std::endl;  log.write(chessUCI::uciok, chessUCI::uciok_size).put('\n');
    }
    else if (prompt.compare(chessUCI::isready) == 0) {
        // the prompt is "isready"
        // we respond with "readyok"
        std::cout << chessUCI::readyok << std::endl; log.write(chessUCI::readyok, chessUCI::readyok_size).put('\n');
    }
    else if (prompt.compare(chessUCI::ucinewgame) == 0) {
        // the prompt is "ucinewgame"
        // we aren't expected to respond, but we're being told a new game is starting
        // to make sure we're prepared for this, we wipe the old board by letting it default
        // to the startpos values. However, be sure to explicitly preserve verbose (the 0s are node count and hash index)
        chessEngine::setEngine(e, 0, 0, e.verbose);
    }
    else if (prompt.compare(0, 9, chessUCI::position) == 0) {
        // the first 9 characters match against "position ",
        // so now we either have to read an FEN string or "startpos moves..."
        uint16_t end_segment = 13;
        if (prompt.compare(9, 4, "fen ") == 0) {
            // the next token was "fen ", meaning that we now expect a fully formed FEN string
            // and have to find its end to know where the end_segment is
            while ((prompt[end_segment] != 'm') && (end_segment < prompt.length())) {
                // check for landing on the start of the "moves" token 
                // log.write("It's not m, it's ", 17).put(prompt[end_segment]).put('\n'); 
                end_segment++;
            }
            // at this point we have either found 
            //    - the last character of the string, or
            //    - the first character of a moves segment
            // either way, all the characters up to and excluding this point are in the FEN subsegment
            chessEngine::setEngine(e, prompt.substr(13, end_segment).c_str(), 0, 0, e.verbose);
            log.write(prompt.substr(13, end_segment).c_str(), end_segment-13).put('\n'); 
            // (log << (uint16_t)end_segment).put('\n');
            // (log << (uint16_t)(end_segment-13)).put('\n');
        }
        else if (prompt.compare(9, 8, "startpos") == 0) {
            // the next token was "startpos ", meaning that we now have to set the startpos
            // and configure the end_segment value to 9 more than 9, aka 18
            // IN DEPTH: why not 17? 
            //     Above, the segment was tested against "fen " (note the space afterwards)
            //     because if it matches there MUST be an FEN string after it separated by a space.
            //     The space isn't part of the FEN string, so it can be detected ahead of time.
            //     In this case, a space following the startpos is NOT guaranteed because
            //     there isn't necessarily a "moves" segment after this. Thus if we tried to 
            //     detect a "startpos " segment here we could have a false negative when the
            //     end of the string is found ahead of that space. However, we want to be at 18
            //     for checking the "m" character in "moves" if it's there, so we don't want
            //     to pick 17 (as that would leave us on the space IF the string wasn't over).
            //     In order to safely use 18, we need to test against the length first, but that
            //     would've happened with either fen or startpos, so the only safe option is to test
            //     against 8 characters but start checking the next segment 9 after.
            chessEngine::setEngine(e, 0, 0, e.verbose); // default setEngine sets start position
            end_segment = 18;
        }
        
        else {
            // if we got here the command is probably malformed, so issue some kind of horrible error
            // log message or something
            log.write("position string appeared malformed!", 35).put('\n'); 
        }
        
        if (end_segment < prompt.length()) {
            // we didn't hit the edge or exceed it in the above cases, so now we SHOULD
            // be sitting on the m of the "moves" command at end_segment
            if (prompt.compare(end_segment, 6, "moves ") == 0) {
                // we matched against the moves command, so first update the segment position
                end_segment += 6;
                uint16_t start_segment = end_segment;
                uint8_t promotion = chessHelpers::wQueen; // default to queen promotion (even though this actually shouldn't be used)
                
                while (end_segment < prompt.length()) {
                    // while we haven't hit the end (end_segment and start_segment should always be 
                    // in sync at this point so we could test either, but end makes more sense)
                    // check the next 6 characters for valid move statements (could be ex "a7a8q "
                    // at longest)
                    for (uint8_t i = 0; i < 6; i++) {
                        // check the character at this offset from the start for being a space
                        // or for being the end of the string - if not, move up the end
                        if ((end_segment < prompt.length()) && (prompt[end_segment] != ' ')) {
                            end_segment++;
                            if (i == 4) {
                                // if we added a character in position 4 it must be a promotion flag,
                                // so update the promotion field (note, color may be wrong)
                                promotion = (chessHelpers::charToCode(prompt[end_segment-1]) & (chessHelpers::blackMask - 1));
                                log << "thought we attempted a promotion to " << chessHelpers::codeToChar(promotion) << std::endl;
                            }
                        } 
                    }
                    
                    // at this point the range [start, end) contains the characters of the move,
                    // with the potential for a castle flag to be included (so we need to look at
                    // only 0 - 3 for decoding the two char fields)
                    // Additionally, we may need to flip this move, depending on whether or not
                    // the board is currently flipped (we can't rely on which move we're evaluating
                    // by ordinal because we could have had an FEN stating black to move, but we
                    // can rely on the board flipped state since that will be updated and furthermore
                    // that's the only reason we would have to flip a move -- to keep in sync with that)
                    if ((end_segment - start_segment) > 3) {
                        // now that we know that we have enough characters to attempt to read an actual
                        // move, split the fields
                        const char* const from_ch = prompt.c_str() + start_segment;
                        const char* const   to_ch = prompt.c_str() + start_segment + 2;
                        
                        uint8_t from_i = chessHelpers::twoCharToIndex(from_ch);
                        uint8_t   to_i = chessHelpers::twoCharToIndex(to_ch);
                        
                        if (e.cBoard.flipped) {
                            from_i = chessHelpers::flipTable[from_i];
                            to_i   = chessHelpers::flipTable[to_i];
                        }
                        
                        // at this point the from_i and to_i values are valid to use on cBoard
                        // so we can play the move on the board and then flip
                        // ((log.write("Playing from ", 13) << (uint16_t)from_i).write(" to ", 4) << (uint16_t)to_i).put('\n'); 
                        chessBoard::makeMove(e.cBoard, from_i, to_i, promotion, 1); // eval really doesn't cost us anything here
                        chessBoard::flipBoard(e.cBoard);
                        // (log.write("e.cBoard.flipped is now ", 24) << (uint16_t)e.cBoard.flipped).put('\n'); 
                    }
                    else {
                        // in theory this shouldn't ever happen since we're assuming that the GUI
                        // isn't going to issue an illegal command (that would be wack and that's the
                        // only way we get here since we would read to the end of the string unless
                        // that end came before we got 4 characters, but less than 4 characters isn't
                        // a move)
                        // log some sort of bad message about thinking we found something illegal
                        log.write("illegal moves sequence! ", 24).write(prompt.c_str(), prompt.length()).put('\n');
                        ((log << (uint16_t)end_segment).put(' ') << (uint16_t)start_segment).put('\n');
                        break;
                    }
                    
                    // whether we played a move or we found some sort of terrible problem, 
                    // we need to shift the start up to the end to target the next move segment
                    // note, this won't matter if we failed the error check above since no matter what
                    // we should be able to keep shifting the markers until the end finds the EOS
                    start_segment = ++end_segment;
                }
                
                // at this point, we no longer have any remaining characters to consume in the string
                // so we're at the end of the moves segment and thus at the end of the string
                // we've already updated the cBoard as far as we have to, but that doesn't
                // mean that cBoard has made it to the top of the stack (where it needs to 
                // be to be negamax'd) so fix that by copying the cBoard & its hash
                
                // note that we need to set the "time to live" for the use of the expanded capture legality 
                // understanding to minDepth - 1 here so that negamax will use it accurately. 
                e.cBoard.pliesUntilLeafProduction = chessEngine::minDepth - 1;
                chessEngine::setStacks(e);
            }
        }
    }
    else if (prompt.compare(0, 2, chessUCI::go) == 0) {
        // the prompt is "go"
        // to which we respond by running a full evaluation cycle 
        // and then replying with "bestmove [move]"
        
        // before starting, tell the GUI the depth
        // std::cout << "info depth " << (uint16_t)chessEngine::maxDepth << std::endl;
        // (log.write("info depth ", 11) << (uint16_t)chessEngine::maxDepth).put('\n');
        
        // now we need to think and send periodic statements back up the chain
        // about the nodes and rate -- this information is borderline impossible
        // to refer up to this level, so instead the header for this file will give a 
        // #define field to the engine to reformat the output
        
        // anyways, call into negamax on the engine and take the best value
        const int32_t value = chessEngine::negamax(e, chessHelpers::minInfinity, chessHelpers::maxInfinity, 0);
        
        (log.write("nodes: ", 7) << e.nodeCount).put('\n');
        
        // extract the best move from the top of the bestMoves structure
        // and use the whole thing for the pv
        std::string best("");
        std::string pv("");
        uint8_t i1 = e.bestMoves[0][0][0];
        uint8_t i2 = e.bestMoves[0][0][1];
        if (e.cBoard.flipped) {
            i1 = chessHelpers::flipTable[i1];
            i2 = chessHelpers::flipTable[i2];
        }
        best += chessHelpers::twoCharNamingTable[i1];
        best += chessHelpers::twoCharNamingTable[i2];
        std::cout << "bestmove " << best << std::endl;
        log.write("bestmove ", 9).write(best.c_str(), 4).put('\n');
        
        for (uint8_t i = 1; i < chessEngine::maxDepth; i++) {
            if (e.bestMoves[0][i][0] == 0xff) // this detects the end of a line WITHOUT reading the 0xffs into pv
                break;
            uint8_t f = e.bestMoves[0][i][0];
            uint8_t t = e.bestMoves[0][i][1];
            if (e.cBoard.flipped) {
                if (i % 2 == 0) {
                    // if the top level is flipped then EVEN depths will be from black's perspective,
                    // requiring that we flip them
                    f = chessHelpers::flipTable[f];
                    t = chessHelpers::flipTable[t];
                }
            }
            else {
                if (i % 2 == 1) {
                    // if the top level is not flipped then ODD depths will be from black's perspective,
                    // requiring that we flip them
                    f = chessHelpers::flipTable[f];
                    t = chessHelpers::flipTable[t];
                }
            }
            pv += chessHelpers::twoCharNamingTable[f];
            pv += chessHelpers::twoCharNamingTable[t];
            pv += ' ';
        }
        
        // remember to attach best in front of the other moves, which were excluded initially
        std::cout << "info score cp " << ((int32_t)(value / 100))*(e.cBoard.flipped?-1:1) << " ";
        (log.write("info score cp ", 8) << ((int32_t)(value / 100))*(e.cBoard.flipped?-1:1)).put('\n');
        std::cout << "pv " << best << " " << pv << std::endl;
        log.write("info pv ", 8).write(best.c_str(), 4).put(' ').write(pv.c_str(), pv.length()).put('\n');
        log << "node count was " << e.nodeCount << std::endl;
        log << "estimated branching factor was " << calculateBF(e.nodeCount, chessEngine::depthLimit, log) << std::endl;
    }
    else if (prompt.compare(0, 3, "!>b") == 0) {
        std::string boardContent("");
        chessBoard::toString(e.cBoard, boardContent);
        log.write(boardContent.c_str(), boardContent.length());
    }
    else {
        // we got something we couldn't read!
        log.write("got input we couldn't read!", 27);
        // std::cout << "We don't understand that!" << std::endl; // DO NOT LEAVE THIS HERE ABSOLUTELY DO NOT
    }
}
