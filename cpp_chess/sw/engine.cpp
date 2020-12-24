#include <engine.h>

// #define NODE_CHECK
// #define UCI_NODE_INFO // only here until I figure out what the problem is with forward definition

// #define TREE
// #define LPRUNE
#define PRUNE

std::string chessEngine::tempTo;

#ifdef TIME_CHECK
std::chrono::time_point<std::chrono::high_resolution_clock> chessEngine::startTime = std::chrono::high_resolution_clock::now();
std::chrono::time_point<std::chrono::high_resolution_clock> chessEngine::stopTime  = std::chrono::high_resolution_clock::now();
std::chrono::microseconds chessEngine::dif                                         = std::chrono::duration_cast<std::chrono::microseconds>(chessEngine::stopTime - chessEngine::startTime); 
#endif

void chessEngine::setEngine(chessEngine::Engine& e, const chessBoard::Board* b, const uint16_t hi, const uint32_t nc, const uint8_t v) {
    // copy the board object into the cBoard
    e.cBoard = *b;
    chessEngine::setEngine_root(e, hi, nc, v);
}

void chessEngine::setEngine(chessEngine::Engine& e, const char* const fen, const uint16_t hi, const uint32_t nc, const uint8_t v) {
    // set from an FEN
    chessBoard::setFromFEN(e.cBoard, fen);
    chessEngine::setEngine_root(e, hi, nc, v);
}

void chessEngine::setEngine(chessEngine::Engine& e, const uint16_t hi, const uint32_t nc, const uint8_t v) {
    // for the sake of being nice, a null board reference is treated as a request to set
    // the start position, even though it would be potentially viable to do nothing.
    chessBoard::setFromFEN(e.cBoard, chessHelpers::start_pos);
    chessEngine::setEngine_root(e, hi, nc, v);
}

void chessEngine::setEngine_root(chessEngine::Engine& e, const uint16_t hi, const uint32_t nc, const uint8_t v) {
    // no matter which above option we used to configure the board, these actions are in common
    e.hashIndex = hi;
    e.nodeCount = nc;
    e.verbose = v;
    chessEngine::setStacks(e);
}

void chessEngine::setStacks(chessEngine::Engine& e) {
    // configure stack tops to be up-to-date
    e.boardStack[0] = e.cBoard;
    e.hashHistory[e.hashIndex++] = e.cBoard.hash;
}

uint8_t chessEngine::checkRepetitionDraw(chessEngine::Engine& e, const uint16_t stackAccess) {
    // stackAccess is...
    //   - the index to the newest board in the boardStack (furthest down)
    //   - the number of hashes added to hashHistory temporarily
    // hashIndex moves, but is later put back in this method.
    uint8_t ret = 0;
	for (uint16_t i = stackAccess; i > 0; i--) {
	    // hashIndex is post-incrememnted, so we can fill in the temp values
	    // from the board stack using this method. Stack access is being used
	    // as an index, decrementing back through the boards
	    e.hashHistory[e.hashIndex++] = e.boardStack[i].hash;
	}
	
	for (uint16_t i = 0; i < stackAccess; i++) {
	    // we didn't write boardStack[0] above because it's the current state, so 
	    // when we count it here (as the last hash in hashHistory), it would be 
	    // overrepresented, which is bad (obviously)
	    uint8_t reps = 0;
	    for (uint16_t j = e.hashIndex - 2; j > 0; j--) {
	        // we start j at two before the bottom because the bottom is writeable
	        // and the value above that being used as the constant to be compared against
	        if (e.hashHistory[e.hashIndex - 1] == e.hashHistory[j]) 
	        	reps++;
	        if (reps >= 3) // though this could be a == 3, >= is safer
	        	ret = 1; // do not optimize this away - hashIndex will fly off into the ether
	    }
	    
	    e.hashIndex--; // back up through the list to only check the boards we
	                 // added (see loop constraint) because there can't be
	                 // three full repetitions above us - game would have 
	                 // already ended
	}
	
	return ret;
}

void chessEngine::clrMovesBelow(chessEngine::Engine& e, const uint16_t stackOffset) {
    // wipe the moves in bestMoves at the indicated stackOffset
    // used in cases where no move chain is valid (checkmate, stalemate, pruning, etc.)
    // NOTE: clears straight down from stackOffset, does not clear depths below that
    //       (leaves garbage since it doesn't matter, that's beyond the 0xff's)
    for (uint16_t tempIndex = stackOffset; tempIndex != chessEngine::depthLimit; tempIndex++) {
        e.bestMoves[stackOffset][tempIndex][0] = 0xff;
        e.bestMoves[stackOffset][tempIndex][1] = 0xff;
    }
}

// the top level board (stackAccess = 0) is created newly, from an FEN string, prior to each original call
// to this function. The board itself does not persist from move to move of evaluation.
int32_t chessEngine::negamax(chessEngine::Engine& e, int32_t alpha, const int32_t beta, const uint16_t stackAccess, const uint8_t prior_prune) {
#ifdef TREE
    for (uint8_t i = 0; i < stackAccess; i++) {
        std::cout << "-";
    }
    if (prior_prune)
        std::cout << "P";
    std::cout << (uint16_t)stackAccess << std::endl;
#endif
    // for reference, alpha starts at minInfinity and beta starts at maxInfinity for entry calls, also stackAccess starts 0
    if (e.verbose >= 20)
    	std::cout << "Called into negamax with alpha = " << alpha << ", beta = " << beta << ", and depth " << stackAccess << std::endl;
    // KEY POINT: stackAccess and the depth are the depth are the same thing, but we use it to access the stack more, so that's what its called
    
    // first, handle arriving at the quickEval depth and having a quiet node
    if (stackAccess == chessEngine::minDepth) {
        // the children of protected captures cannot be quiet because retaliation must be considered
        if (e.typeStack[stackAccess] != chessHelpers::moveType::PROTECTED_CAPTURE) {
            chessBoard::scoreBoard(e.boardStack[stackAccess]); // this has to be done because the score is invalid - we didn't let makeMove update it
            int32_t scoreDiff = e.boardStack[stackAccess].score - e.boardStack[stackAccess - 1].score;
            if ((scoreDiff > chessEngine::nqCutoff) && (scoreDiff < chessEngine::qCutoff)) {
                // having a score difference contained within the q-cutoff means that
                // this node can be considered "quiet", which means it is safe to return here
                if (e.verbose >= 20) 
            	    std::cout << "Returning from minDepth (quiet) leaf clause with value " << e.boardStack[stackAccess].score << std::endl;
            	e.bestMoves[stackAccess][stackAccess][0] = 0xff; // these are here because there is no move here, and we need to mark that 
                e.bestMoves[stackAccess][stackAccess][1] = 0xff;
                return e.boardStack[stackAccess].score;
            }
        }
    }
    // next, let's consider the deep search leaves
    // only an unprotected capture can end a deep search, but unprotected captures don't
    // terminate normal (quick eval) branches
    // NOTE that it doesn't matter if the previous unprotected capture would have left this node
    // in check (recall that this node is flipped, so the previous move made by "white" could
    // have left "white which looked like black above" at this node in check), because 
    // unprotected captures are still stable enough to treat as the real value of the board
    else if ((stackAccess > chessEngine::minDepth) && (e.typeStack[stackAccess] == chessHelpers::moveType::UNPROTECTED_CAPTURE)) {
        chessBoard::scoreBoard(e.boardStack[stackAccess]); // this has to be done because the score is invalid - we didn't let makeMove update it
        if (e.verbose >= 20) 
        	std::cout << "Returning from unprotected capture (deep search) leaf clause with value " << e.boardStack[stackAccess].score << std::endl;
        e.bestMoves[stackAccess][stackAccess][0] = 0xff; // these are here because there is no move here, and we need to mark that 
        e.bestMoves[stackAccess][stackAccess][1] = 0xff;
        return e.boardStack[stackAccess].score;
    }
    // finally, let's look at the last way we can hit a leaf, which is arriving at the true maxDepth
    // it should be noted that while the bodies of these last two leaf clauses are essentially completely identical, 
    // they're kept separate so that they can be debugged independently
    else if (stackAccess == chessEngine::maxDepth) {
        chessBoard::scoreBoard(e.boardStack[stackAccess]); // this has to be done because the score is invalid - we didn't let makeMove update it
        if (e.verbose >= 20) 
        	std::cout << "Returning from maxDepth leaf clause with value " << e.boardStack[stackAccess].score << std::endl;
        e.bestMoves[stackAccess][stackAccess][0] = 0xff; // these are here because there is no move here, and we need to mark that 
        e.bestMoves[stackAccess][stackAccess][1] = 0xff;
        return e.boardStack[stackAccess].score;
    }
    
    
    if (e.verbose >= 30) {
        chessBoard::toString(e.boardStack[stackAccess], chessEngine::tempTo);
        std::cout << "Parent board of nodes is: \n" << chessEngine::tempTo;
        chessBoard::boardToFEN(e.boardStack[stackAccess], chessEngine::tempTo);
        std::cout << " FEN: " << chessEngine::tempTo << std::endl;
    }
    
    chessBoard::Board* parent = e.boardStack + stackAccess;
    
    uint8_t playableChildren =                0;
    uint8_t pruned           =                0;
    int32_t bestValue        =        -99999999; // sentinel - 8 nines
                                                 // note that it is actually acceptable to return this value, because
                                                 // it would indicate that this node is guaranteed to be worse
                                                 // than alpha says its color can attain on a different branch,
                                                 // so returning this is perfectly okay and not an indication of a bug

    if ((stackAccess > chessEngine::minDepth)) { 
        // note that this flag might not stick around because pdfWhite under updatePosDepFlags might 
        // detect that we're in check, which will overwrite this assertion to prevent "imaginary" checkmates
        (*parent).restrictLegalities = 1;
    }
    
    if (e.verbose >= 40)
        std::cout << "Trying to check if the legal moves are memoized @ parent " << parent << std::endl;
    if (!(*parent).legalValid) {
        if (e.verbose >= 40)
            std::cout << "Found that the legal moves were not valid (as expected)!" << std::endl;
        chessBoard::updatePosDepFlags(*parent); // score the board to update its fields - note that this populates the legalities and legal moves
                                                // so if above we set this board's restrict flag, it can prevent this step from enumerating
                                                // any moves which aren't captures as being legal
                                                // BIG NOTE: I think this rescores the board, which shouldn't be happening -- there's no
                                                //           reason to take the time to do an operation like this considering that we don't use the 
                                                //           score on nodes which aren't leaves. However, if you already need to get the memos,
                                                //           then comparatively scoring is a light operation since the things that make it 
                                                //           heavy are still necessary for the memoization process
    }
    // if the legal was valid then we don't need to update anything (but it shouldn't be)
    
    const uint8_t parentInCheck = (*parent).inCheck;
    
    if (e.verbose >= 30) {
    	chessBoard::toString(e.boardStack[stackAccess], chessEngine::tempTo);
        std::cout << "Determined parent board check status as " << (uint16_t)parentInCheck << ". Parent board is: \n" << chessEngine::tempTo;
        chessBoard::boardToFEN(e.boardStack[stackAccess], chessEngine::tempTo);
        std::cout << " FEN: " << chessEngine::tempTo << std::endl;
    }
    
    // begin child-handling
    if (e.verbose >= 80) {
        std::cout << "The current plausible moves are: ";
        for (uint8_t testCI = 0; testCI < 128; testCI++) {
            if ((*parent).legalMoves[testCI][0] != 0xff) {
                uint8_t test_from = (*parent).legalMoves[testCI][0];
                uint8_t test_to = (*parent).legalMoves[testCI][1];
                std::cout << chessHelpers::twoCharNamingTable[(uint16_t)(test_from)] << chessHelpers::twoCharNamingTable[(uint16_t)(test_to)] << " "; 
            }
        }
        std::cout << std::endl;
    }
    for (uint8_t childIndex = 0; childIndex < 128; childIndex++) {
        if ((*parent).legalMoves[childIndex][0] != 0xff) {
            playableChildren = 1; // we have something to play
            chessBoard::Board& child = e.boardStack[stackAccess + 1];
            chessBoard::setFromBoard(child, *parent); // because we let the third field default, this won't try to copy the memos
            if (e.verbose >= 100)
                std::cout << "Copied board from parent down to child" << std::endl;
            uint8_t from = (*parent).legalMoves[childIndex][0];
            uint8_t to = (*parent).legalMoves[childIndex][1];
            // the child board's legalities are absolutely not okay at this point (as in, we didn't copy them, so literally anything 
            // could be in memory at this point) - the ONLY way to use memos is to hand them down
            uint8_t s = chessBoard::makeMove(child, from, to, defaultPromotion, 0, (*parent).legalities[from][to]);
            e.typeStack[stackAccess + 1] = (*parent).legalities[from][to]; // this records the type of move we made the child with at the child's
                                                                           // stack depth - only really matters if the child is part of the deep evaluation
                                                                           // since that's the only time when we use move type (for capture distinctions)
            if (e.verbose >= 100) {
                std::cout << "Did we successfully play a move on the child? " << (uint16_t)s << " (this should never fail)" << std::endl;
            }
            // hashHistory not modified here because checkRepetitionDraw does this work itself
            // eval set to 0 because we don't want to validate the score here - that would 
            // lead to repeating work at the next node (because of the flip). Instead,
            // we should always do the update above and only do the rescore (without memos)
            // at leaves. Still, keep in mind that the score on the child is wrong.
            
            // uint8_t childInCheck = chessBoard::isCheck(child); // I highly suspect this isn't necessary, because testLegality already does this test - should be removed soon!
            if (e.verbose >= 20)
            	std::cout << "Made child with move " << chessHelpers::twoCharNamingTable[(uint16_t)(from)] << " " << chessHelpers::twoCharNamingTable[(uint16_t)(to)] << std::endl;
            if (e.verbose >= 30) {
            	chessBoard::toString(child, chessEngine::tempTo);
            	std::cout << "child board is: \n" << chessEngine::tempTo;
                chessBoard::boardToFEN(child, chessEngine::tempTo);
                std::cout << " FEN: " << chessEngine::tempTo << std::endl;
            }
            
            // we haven't flipped yet, so the white-ish king from the parent is being evaluated for check.
            // this makes sense, because it means that childInCheck is an indication of whether the move
            // we just made put ourselves in check
            
            int32_t cValue = -999999999; // sentinel - nine 9s
            
            // we need to run pre-recursion checks, because this child may be resolved
            if (child.halfmoveClock >= 50) {
                cValue = -1; // draw reluctance
                chessEngine::clrMovesBelow(e, stackAccess + 1);
                if (e.verbose >= 20)
                	std::cout << "No recursion due to 50 move draw rule" << std::endl;
            }
            else if (chessEngine::checkRepetitionDraw(e, stackAccess + 1)) {
                cValue = -1;
                chessEngine::clrMovesBelow(e, stackAccess + 1);
                if (e.verbose >= 20) 
                	std::cout << "Did not recur due to 3x repetition rule" << std::endl;
            }
            else {
                // now that the pre-recursion checks have passed, we can safely flip and recur
                chessBoard::flipBoard(child);
                
                cValue = -1 * chessEngine::negamax(e, -beta, -alpha, stackAccess + 1, prior_prune | pruned); // see Wikipedia or other resources for why alpha/beta are switched and negated
                if (e.verbose >= 20) {
                	std::cout << "Completed recursion to depth " << stackAccess + 1 << " and returned to depth " << stackAccess << std::endl;
                	if (e.verbose >= 40) {
                	    chessBoard::toString(e.boardStack[stackAccess], chessEngine::tempTo);
                        std::cout << "As a reminder, parent board is: \n" << chessEngine::tempTo;
                    }
                }
                e.nodeCount++;
                // OPTIONAL: do not include in speed-optimized versions
#ifdef NODE_CHECK
                if (e.nodeCount % 100000 == 0) {
#ifdef TIME_CHECK
                    chessEngine::stopTime = std::chrono::high_resolution_clock::now();
                    chessEngine::dif = std::chrono::duration_cast<std::chrono::microseconds>(chessEngine::stopTime - chessEngine::startTime);
#ifndef UCI_NODE_INFO
                    std::cout << "Time elapsed: " << dif.count() << " Nodes: ";
#endif
                    chessEngine::startTime = std::chrono::high_resolution_clock::now();
#endif
#ifndef UCI_NODE_INFO
                	std::cout << e.nodeCount << std::endl;
#else
                    std::cout << "info nodes " << e.nodeCount << std::endl;
#endif
                }
#endif
            }
                
            // e.bestMoves must have something in stackAccess + 1, even if it's empty sentinels
            // if we have a new best move, it must be copied up
            if (cValue > bestValue) {
                if (e.verbose >= 20)
                	std::cout << "Determined cValue " << cValue << " was greater than bestValue " << bestValue << std::endl;
                	
                bestValue = cValue;
                
                // put new best move on top, copy in best moves below
                
                e.bestMoves[stackAccess][stackAccess][0] = (*parent).legalMoves[childIndex][0];
                e.bestMoves[stackAccess][stackAccess][1] = (*parent).legalMoves[childIndex][1];
                
                e.bestMoves[stackAccess][stackAccess + 1][0] = 0xff;
                e.bestMoves[stackAccess][stackAccess + 1][1] = 0xff;
                
                if ((e.verbose >= 10) && (stackAccess == 0)) {
                    std::cout << "info pv ";
                    if ((*parent).flipped) {
                        std::cout << chessHelpers::twoCharNamingTable[chessHelpers::flipTable[(*parent).legalMoves[childIndex][0]]]
                                  << chessHelpers::twoCharNamingTable[chessHelpers::flipTable[(*parent).legalMoves[childIndex][1]]]
                                  << " ";
                    }
                    else {
                        std::cout << chessHelpers::twoCharNamingTable[(*parent).legalMoves[childIndex][0]]
                                  << chessHelpers::twoCharNamingTable[(*parent).legalMoves[childIndex][1]]
                                  << " ";
                    }
                }
                uint16_t tempIndex = stackAccess + 1;
                for (; tempIndex < chessEngine::maxDepth; tempIndex++) {
                    // this is copying the best moves from beneath where you currently are - think of it like
                    // horizontally transfering a stack of blocks into position underneath you (and see the explanation
                    // in engine.h). This is why the bestMoves are copied from stackAcces + 1.
                    e.bestMoves[stackAccess][tempIndex][0] = e.bestMoves[stackAccess + 1][tempIndex][0];
                    e.bestMoves[stackAccess][tempIndex][1] = e.bestMoves[stackAccess + 1][tempIndex][1];
                    if (e.bestMoves[stackAccess + 1][tempIndex][0] == 0xff)
                        // once we've hit and copied the 0xff, the line is over, so we can break
                        break;
                    if ((e.verbose >= 10) && (stackAccess == 0)) {
                        if (((*parent).flipped && (tempIndex % 2 == 0)) || (!((*parent).flipped) && (tempIndex % 2 == 1))) {
                            std::cout << chessHelpers::twoCharNamingTable[chessHelpers::flipTable[e.bestMoves[stackAccess + 1][tempIndex][0]]]
                                      << chessHelpers::twoCharNamingTable[chessHelpers::flipTable[e.bestMoves[stackAccess + 1][tempIndex][1]]]
                                      << " ";
                        }
                        else {
                            std::cout << chessHelpers::twoCharNamingTable[e.bestMoves[stackAccess + 1][tempIndex][0]]
                                      << chessHelpers::twoCharNamingTable[e.bestMoves[stackAccess + 1][tempIndex][1]]
                                      << " ";
                        }
                    }
                }
                
                if ((e.verbose >= 10) && (stackAccess == 0)) {
                    std::cout << "score cp "
                              << ((int32_t)(bestValue / 100))*(e.cBoard.flipped?-1:1)
                              << " depth " 
                              << tempIndex
                              << std::endl;
                }
                
                if (e.verbose >= 50)
                	std::cout << "Completed copy of e.bestMoves without infinite looping" << std::endl;
            
                // update alpha
                if (e.verbose >= 60) 
                	std::cout << "Updating alpha" << std::endl;
                alpha = bestValue; // no need to check which is greater, we already know from the condition above
                
                // we compare our alpha to beta because of the following logic:
                //     1. The node above us has the opposite "sense" to us; if we are black, they are white.
                //     2. The value in beta right now is the node above us' "-alpha"
                //     3. If we find something >= beta, that will become a value < alpha at the upper layer
                //        ex. We find -2 when beta is -3, which will appear above us to be 2 vs. 3 (worse than alpha)
                //     4. We are pruning to help the node above us, which is why we are comparing to THEIR alpha (in the form of beta).
                if (alpha >= beta) {
#ifdef PRUNE
                    pruned = 1; // AT LEAST this bad - we might not have found the worst, so we cannot let this node tie with anyone
                    if (e.verbose >= 20) 
                    	std::cout << "Determined alpha " << alpha << " was >= beta " << beta << " and pruned the node" << std::endl;
                    break;
#else 
#ifdef LPRUNE
                    pruned = 1; // don't break, but indicate that this node was pruned
#endif
#endif
                }
            }
        }
        // this line is associated with the same scope as 219,
        // within the child checking loop. We will not get here from 
        // a pruning break. We are only here to break because there are
        // no more children to evaluate
        else break;
    }
    
    // outside the child checking loop
    if (!playableChildren) {
        // with no playable children, a checkmate/stalemate resolution has to be made
        if (parentInCheck) {
            // unresolved check from parent = checkmate
            chessEngine::clrMovesBelow(e, stackAccess);
            if (e.verbose >= 20) {
            	std::cout << "Determined checkmate at depth " << stackAccess << " and returned depth-sensitive sentinel" << std::endl;
            }
            return -99999999 + stackAccess; // more distant checkmates are less bad then less distant ones
                                            // note that, to the node above us, this means more immediate
                                            // checkmates are better
        }
        else {
            // stalemate
            chessEngine::clrMovesBelow(e, stackAccess);
            if (e.verbose >= 20) {
            	std::cout << "Determined stalemate at depth " << stackAccess << " and returned -1" << std::endl;
            }
            return -1; // contempt of draw
                       // note that I'm not convinced this shouldn't be 1
        }
    }
    
    else if (pruned) {
        // a pruned node found ONE child that was worse than the bottom line, but might have had
        // even worse children which were never score. Thus, a pruned node is potentially
        // infinitely bad
        chessEngine::clrMovesBelow(e, stackAccess);
        if (e.verbose >= 30) {
        	std::cout << "Determined pruned exit from depth " << stackAccess << " and returned sentinel" << std::endl;
        }
        return chessHelpers::maxInfinity; // most aggressive possible negative sentinel - max because this node must look bad to the node
                                          // ABOVE us so that they don't pick it, since that's who determined if we pruned it to begin with.
    }
    
    else {
        // return the best value with e.bestMoves in place
        if (e.verbose >= 40) {
        	std::cout << "Made normal exit from depth " << stackAccess << " returning value " << bestValue << std::endl;
        }
        return bestValue;
    }
}
