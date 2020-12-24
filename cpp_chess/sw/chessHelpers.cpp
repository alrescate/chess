/*
 * chessHelpers.cpp
 *
 *  Created on: Jun 2, 2019
 *      Author: henry
 */

#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <iomanip>
#include <iostream>
#include <string>
#include <chessHelpers.h>

uint8_t chessHelpers::colorChange(uint8_t piece) {
	// the C++ version does not check piece code validity - that's the caller's problem
	piece ^= chessHelpers::blackMask;
	if (piece == (chessHelpers::empty | chessHelpers::blackMask)) return chessHelpers::empty;
	else                              return piece;
}

void chessHelpers::itorc(const uint8_t i, uint8_t* rc) {
	// fills into an array reference taken as a parameter so that arrays need not be returned
	rc[0] = i/8;
	rc[1] = i%8;
}

// allocate necessary space, fill in the tables in setup

uint64_t chessHelpers::swapRankColor(const uint64_t rank) {
  return (rank ^ 0x4040404040404040ULL) & ~((rank & 0x8080808080808080ULL) >> 1); // mask all but empty bits, shift right to color bits (leading zero introduced)
                                                                                  // bitwise not make mask for all color bits of empty squares
                                                                                  // and to remove color bit on empty squares - all empties marked white
}

void chessHelpers::makeFlipTable(void) {
  for (uint8_t r = 0; r < 8; r++) { // this would have been 4, but including the whole board made it usuable for mirrorIndex
    for (uint8_t c = 0; c < 8; c++) {
      chessHelpers::flipTable[rctoi(r, c)] = rctoi(7-r, c);
    }
  }
}

uint8_t chessHelpers::twoCharToIndex(const char* twoChar) {
  char letter = twoChar[0];
  uint8_t index = (8 - ((uint8_t)twoChar[1] - (uint8_t)'0')) << 3;
  switch (letter) {
    case 'a': index += 0; break;
    case 'b': index += 1; break;
    case 'c': index += 2; break;
    case 'd': index += 3; break;
    case 'e': index += 4; break;
    case 'f': index += 5; break;
    case 'g': index += 6; break;
    case 'h': index += 7; break;
  }

  return index;
}

uint8_t chessHelpers::charToCode(const char piece) {
  uint8_t code = 128;
  switch (piece) {
    case 'p': code = chessHelpers::bPawn;   break;
    case 'r': code = chessHelpers::bRook;   break;
    case 'n': code = chessHelpers::bKnight; break;
    case 'b': code = chessHelpers::bBishop; break;
    case 'q': code = chessHelpers::bQueen;  break;
    case 'k': code = chessHelpers::bKing;   break;
    case 'P': code = chessHelpers::wPawn;   break;
    case 'R': code = chessHelpers::wRook;   break;
    case 'N': code = chessHelpers::wKnight; break;
    case 'B': code = chessHelpers::wBishop; break;
    case 'Q': code = chessHelpers::wQueen;  break;
    case 'K': code = chessHelpers::wKing;   break;
  }

  return code;
}

char chessHelpers::codeToChar(const uint8_t code) {
  char piece = ' ';
  switch (code) {
    case chessHelpers::bPawn:   piece = 'p'; break;
    case chessHelpers::bRook:   piece = 'r'; break;
    case chessHelpers::bKnight: piece = 'n'; break;
    case chessHelpers::bBishop: piece = 'b'; break;
    case chessHelpers::bQueen:  piece = 'q'; break;
    case chessHelpers::bKing:   piece = 'k'; break;
    case chessHelpers::wPawn:   piece = 'P'; break;
    case chessHelpers::wRook:   piece = 'R'; break;
    case chessHelpers::wKnight: piece = 'N'; break;
    case chessHelpers::wBishop: piece = 'B'; break;
    case chessHelpers::wQueen:  piece = 'Q'; break;
    case chessHelpers::wKing:   piece = 'K'; break;
    case chessHelpers::empty:   piece = '.'; break;
  }

  return piece;
}

uint8_t chessHelpers::flipTable[64];
uint8_t chessHelpers::pathTable[64][64][8];
uint8_t chessHelpers::physTable[33][64][32];

void chessHelpers::makePathTable(void) {
  // stuff dest for safe non-path accessing
  for (int o = 0; o < 64; o++) {
	  for (int i = 0; i < 64; i++) {
			for (int j = 0; j < 8; j++) {
				chessHelpers::pathTable[o][i][j] = 0xff;
			}
		}
	}
  for (uint8_t fromIndex = 0; fromIndex < 64; fromIndex++) {
    for (uint8_t toIndex = 0; toIndex   < 64; toIndex++) {

      uint8_t lowerIndex = std::min(fromIndex, toIndex);
      uint8_t upperIndex = std::max(fromIndex, toIndex);

      uint8_t lowerIndexRow = chessHelpers::itor(lowerIndex);
      uint8_t lowerIndexCol = chessHelpers::itoc(lowerIndex);
      uint8_t upperIndexRow = chessHelpers::itor(upperIndex);
      uint8_t upperIndexCol = chessHelpers::itoc(upperIndex);

      uint8_t foundPath = 0;

      uint8_t start = 0;
      uint8_t  stop = 0;
      uint8_t  step = 0;

           if (upperIndexRow == lowerIndexRow) { start = lowerIndex + 1; stop = upperIndex; step = 1; foundPath = 1; } // rankwise
      else if (upperIndexCol == lowerIndexCol) { start = lowerIndex + 8; stop = upperIndex; step = 8; foundPath = 1; } // columnwise
      else {
        // diagonals are fundamentally different from straight motions, so they are stylistically separated
        if      ((upperIndexCol < lowerIndexCol) && ((upperIndex - lowerIndex) % 7) == 0) { start = lowerIndex+7; stop = upperIndex; step = 7; foundPath = 1; }
		else if ((upperIndexCol > lowerIndexCol) && ((upperIndex - lowerIndex) % 9) == 0) { start = lowerIndex+9; stop = upperIndex; step = 9; foundPath = 1; }
      }

      if (foundPath) {
        for (int destination = start, writePointer = 0; destination < stop; destination += step, writePointer++) {
          chessHelpers::pathTable[fromIndex][toIndex][writePointer] = destination;
        }
      }
    }
  }
}

uint8_t chessHelpers::rcOnBoard(uint8_t r, uint8_t c) {
  // even though the value will underflow and become 255 when we subtract 1 from 0,
  // it will still be greater than 8, so we actually detect both problems with < 8.
  return (r < 8) && (c < 8);
}

void chessHelpers::listRookMoves(uint8_t fromIndex, uint8_t* dest) {

  uint8_t fromIndexRow = chessHelpers::itor(fromIndex);
  uint8_t fromIndexCol = chessHelpers::itoc(fromIndex);

  for (uint8_t i = 0; i < 32; i++) { // 4 64 bit writes can be used here - pointer abuse
    dest[i] = 0xff;
  }

  uint8_t writePointer = 0;

  for (uint8_t c = 0; c < 8; c++) {
    // row-constant
    if (c != fromIndexCol) {
      dest[writePointer] = chessHelpers::rctoi(fromIndexRow, c); // these are technically uint64_t returns, will it cast them for me?
      writePointer++;
    }
  }

  for (uint8_t r = 0; r < 8; r++) {
    // column-constant
    if (r != fromIndexRow) {
      dest[writePointer] = chessHelpers::rctoi(r, fromIndexCol);
      writePointer++;
    }
  }
}

void chessHelpers::listBishopMoves(uint8_t fromIndex, uint8_t* dest) {

  uint8_t fromIndexRow = chessHelpers::itor(fromIndex);
  uint8_t fromIndexCol = chessHelpers::itoc(fromIndex);

  for (int i = 0; i < 32; i++) { // 4 64 bit writes can be used here - pointer abuse
    dest[i] = 0xff;
  }

  int writePointer = 0;

  for (uint8_t offset = 1; offset < 8; offset++) {
    // save some time and do all these operations at the start
    uint8_t rowDecremented = fromIndexRow - offset;
    uint8_t colDecremented = fromIndexCol - offset;
    uint8_t rowIncremented = fromIndexRow + offset;
    uint8_t colIncremented = fromIndexCol + offset;

    // work outward along the legs of bishop motion
    // abuse of unsigned underflow behavior -> 0 - 1 = 255, 255 > 8
    // using property that < 8 means bit 3 upwards unset
    if (rowIncremented < 8) {
      if (colIncremented < 8) {
        dest[writePointer] = chessHelpers::rctoi(rowIncremented, colIncremented);
        writePointer++;
      }
      if (colDecremented < 8) {
        dest[writePointer] = chessHelpers::rctoi(rowIncremented, colDecremented);
        writePointer++;
      }
    }
    if (rowDecremented < 8) {
      if (colIncremented < 8) {
        dest[writePointer] = chessHelpers::rctoi(rowDecremented, colIncremented);
        writePointer++;
      }
      if (colDecremented < 8) {
        dest[writePointer] = chessHelpers::rctoi(rowDecremented, colDecremented);
        writePointer++;
      }
    }
  }
}

void chessHelpers::generateKnightDestinations(uint8_t r, uint8_t c, uint8_t dest[8][2]) {
  dest[0][0] = r + 2; // up 2
  dest[0][1] = c + 1; // right 1

  dest[1][0] = r + 2; // up 2
  dest[1][1] = c - 1; // left 1

  dest[2][0] = r - 2; // down 2
  dest[2][1] = c + 1; // right 1

  dest[3][0] = r - 2; // down 2
  dest[3][1] = c - 1; // left 1

  dest[4][0] = r + 1; // up 1
  dest[4][1] = c + 2; // right 2

  dest[5][0] = r - 1; // down 1
  dest[5][1] = c + 2; // right 2

  dest[6][0] = r + 1; // up 1
  dest[6][1] = c - 2; // left 2

  dest[7][0] = r - 1; // down 1
  dest[7][1] = c - 2; // left 2
}

void chessHelpers::listKnightMoves(uint8_t fromIndex, uint8_t* dest) {

  uint8_t fromIndexRow = chessHelpers::itor(fromIndex);
  uint8_t fromIndexCol = chessHelpers::itoc(fromIndex);

  for (int i = 0; i < 32; i++) { // 4 64 bit writes can be used here - pointer abuse
    dest[i] = 0xff;
  }

  uint8_t writePointer = 0;

  uint8_t candidateDestinations[8][2];

  chessHelpers::generateKnightDestinations(fromIndexRow, fromIndexCol, candidateDestinations);

  for (uint8_t i = 0; i < 8; i++) {
    uint8_t candidateRow = candidateDestinations[i][0];
    uint8_t candidateCol = candidateDestinations[i][1];
    if (chessHelpers::rcOnBoard(candidateRow, candidateCol)) {
      dest[writePointer++] = chessHelpers::rctoi(candidateRow, candidateCol);
    }
  }
}

void chessHelpers::listPawnMoves(uint8_t fromIndex, uint8_t* dest) {

  uint8_t fromIndexRow = chessHelpers::itor(fromIndex);
  uint8_t fromIndexCol = chessHelpers::itoc(fromIndex);

  for (int i = 0; i < 32; i++) { // 4 64 bit writes can be used here - pointer abuse
    dest[i] = 0xff;
  }

  if (fromIndexRow != 0) {
    uint8_t writePointer = 0;

    dest[writePointer] = chessHelpers::rctoi(fromIndexRow - 1, fromIndexCol);
    writePointer++;

    // the line breaks are because of breakpoints. I can't insert them without a unique line
    if (fromIndexRow == 6)
      dest[writePointer++] = chessHelpers::rctoi(fromIndexRow - 2, fromIndexCol);
    if (fromIndexCol  > 0)
      dest[writePointer++] = chessHelpers::rctoi(fromIndexRow - 1, fromIndexCol - 1);
    if (fromIndexCol  < 7)
      dest[writePointer++] = chessHelpers::rctoi(fromIndexRow - 1, fromIndexCol + 1);
  }
}

void chessHelpers::generateKingDestinations(uint8_t r, uint8_t c, uint8_t dest[][2]) {

  dest[0][0] = r - 1;  dest[1][0] = r - 1;  dest[2][0] = r - 1;
  dest[0][1] = c - 1;  dest[1][1] = c;      dest[2][1] = c + 1;

  dest[3][0] = r;         /*yourself*/      dest[4][0] = r;
  dest[3][1] = c - 1;     /*  here  */      dest[4][1] = c + 1;

  dest[5][0] = r + 1;  dest[6][0] = r + 1;  dest[7][0] = r + 1;
  dest[5][1] = c - 1;  dest[6][1] = c;      dest[7][1] = c + 1;

}

void chessHelpers::listKingMoves(uint8_t fromIndex, uint8_t* dest) {

  uint8_t fromIndexRow = chessHelpers::itor(fromIndex);
  uint8_t fromIndexCol = chessHelpers::itoc(fromIndex);

  for (int i = 0; i < 32; i++) { // 4 64 bit writes can be used here - pointer abuse
    dest[i] = 0xff;
  }

  uint8_t writePointer = 0;

  // special snowflake castling positions
  if (fromIndex == 60) {
    dest[0] = 62;
    dest[1] = 58;
    writePointer = 2;
  }

  uint8_t candidateDestinations[8][2];

  chessHelpers::generateKingDestinations(fromIndexRow, fromIndexCol, candidateDestinations);

  for (uint8_t i = 0; i < 8; i++) {
    uint8_t candidateRow = candidateDestinations[i][0];
    uint8_t candidateCol = candidateDestinations[i][1];
    if (chessHelpers::rcOnBoard(candidateRow, candidateCol)) {
      dest[writePointer++] = chessHelpers::rctoi(candidateRow, candidateCol);
    }
  }
}

void chessHelpers::makePhysTable(void) {
    for (int square = 0; square < 64; square++) {   chessHelpers::listPawnMoves(square, physTable[chessHelpers::wPawn]  [square]); }
	for (int square = 0; square < 64; square++) {   chessHelpers::listRookMoves(square, physTable[chessHelpers::wRook]  [square]); }
	for (int square = 0; square < 64; square++) { chessHelpers::listKnightMoves(square, physTable[chessHelpers::wKnight][square]); }
	for (int square = 0; square < 64; square++) { chessHelpers::listBishopMoves(square, physTable[chessHelpers::wBishop][square]); }
	for (int square = 0; square < 64; square++) {   chessHelpers::listRookMoves(square, physTable[chessHelpers::wQueen] [square]); } // rook used in queen position because queen is not actually unique, it's bishop | rook
	for (int square = 0; square < 64; square++) {   chessHelpers::listKingMoves(square, physTable[chessHelpers::wKing]  [square]); }

	// handle the specialness of the queen
	for (int square = 0; square < 64; square++) {
		// there's no need to fill the physTable before this step because
		// the above calls already stuffed 0xff into the inactive slots
		int qptr = 0; while (chessHelpers::physTable[chessHelpers::wQueen][square][qptr] != 0xff) qptr++;
		int bptr = 0;
		while (chessHelpers::physTable[chessHelpers::wBishop][square][bptr] != 0xff) {
			// copy from the start of the bishop table to the end of the queen table
			// for this square, making queen = rook + bishop
			chessHelpers::physTable[chessHelpers::wQueen][square][qptr++] = chessHelpers::physTable[chessHelpers::wBishop][square][bptr++];
		}
	}
}

void chessHelpers::mirrorMovePair(const uint8_t* movePair, uint8_t* dest) {
  dest[0] = chessHelpers::mirrorIndex(movePair[0]);
  dest[1] = chessHelpers::mirrorIndex(movePair[1]);
}

void chessHelpers::setup(void) {
  // filling tables
  chessHelpers::makeFlipTable();
  chessHelpers::makePathTable();
  chessHelpers::makePhysTable();
}

void chessHelpers::testAll(void) {
  chessHelpers::setup();
  uint8_t rc[2];
  chessHelpers::itorc(54, rc);
  std::cout << (uint16_t)rc[0] << " " << (uint16_t)rc[1] << " is the r/c of 54" << std::endl;
  chessHelpers::itorc(13, rc);
  std::cout << (uint16_t)rc[0] << " " << (uint16_t)rc[1] << " is the r/c of 13" << std::endl;
  chessHelpers::itorc(63, rc);
  std::cout << (uint16_t)rc[0] << " " << (uint16_t)rc[1] << " is the r/c of 63" << std::endl;
  chessHelpers::itorc(0, rc);
  std::cout << (uint16_t)rc[0] << " " << (uint16_t)rc[1] << " is the r/c of 0" << std::endl;
  std::cout << "--------------------" << std::endl;

  std::cout << (uint16_t)chessHelpers::rctoi(1, 4) << " is the index of 1, 4" << std::endl;
  std::cout << (uint16_t)chessHelpers::rctoi(3, 7) << " is the index of 3, 7" << std::endl;
  std::cout << (uint16_t)chessHelpers::rctoi(7, 7) << " is the index of 7, 7" << std::endl;
  std::cout << (uint16_t)chessHelpers::rctoi(0, 0) << " is the index of 0, 0" << std::endl;
  std::cout << "--------------------"                 << std::endl;

  std::cout << chessHelpers::scoreTable[chessHelpers::wRook]   << " is the score of R" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::wKnight] << " is the score of N" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::wBishop] << " is the score of B" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::wQueen]  << " is the score of Q" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::wKing]   << " is the score of K" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::wPawn]   << " is the score of P" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bRook]   << " is the score of r" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bKnight] << " is the score of n" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bBishop] << " is the score of b" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bQueen]  << " is the score of q" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bKing]   << " is the score of k" << std::endl;
  std::cout << chessHelpers::scoreTable[chessHelpers::bPawn]   << " is the score of p" << std::endl;
  std::cout << "--------------------"                          << std::endl;

  std::cout << chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('R'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('N'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('B'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('Q'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('K'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('B'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('N'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('R'))) <<
		       chessHelpers::codeToChar(chessHelpers::colorChange(chessHelpers::charToCode('P'))) <<
		       " is the swap of RNBQKBNRP"                                                        << std::endl;
  std::cout << "--------------------"                                                             << std::endl;

  std::cout << "22 flips to " << (uint16_t)chessHelpers::flipTable[22] << std::endl;
  std::cout << "13 flips to " << (uint16_t)chessHelpers::flipTable[13] << std::endl;
  std::cout << "31 flips to " << (uint16_t)chessHelpers::flipTable[31] << std::endl;
  std::cout << "0 flips to "  << (uint16_t)chessHelpers::flipTable [0] << std::endl;
  std::cout << "--------------------"                                  << std::endl;

  std::cout << chessHelpers::twoCharNamingTable[32] << " is the 2-char of 32" << std::endl;
  std::cout << chessHelpers::twoCharNamingTable[41] << " is the 2-char of 41" << std::endl;
  std::cout << chessHelpers::twoCharNamingTable[63] << " is the 2-char of 63" << std::endl;
  std::cout << chessHelpers::twoCharNamingTable [0] << " is the 2-char of 0"  << std::endl;
  std::cout << "--------------------"                                         << std::endl;

  uint8_t* passedThrough;
  passedThrough = chessHelpers::getPassedThrough(1, 19);
  for (int i = 0; i < 8; i++) {
  	std::cout << (uint16_t)passedThrough[i] << " ";
	  if (passedThrough[i] == 255) break;
  }
  std::cout << "is passed through between 1 and 19" << std::endl;

  passedThrough = chessHelpers::getPassedThrough(5, 16);
  for (int i = 0; i < 8; i++) {
  	std::cout << (uint16_t)passedThrough[i] << " ";
	  if (passedThrough[i] == 255) break;
  }
  std::cout << "is passed through between 5 and 16" << std::endl;

  passedThrough = chessHelpers::getPassedThrough(0, 63);
  for (int i = 0; i < 8; i++) {
  	std::cout << (uint16_t)passedThrough[i] << " ";
	  if (passedThrough[i] == 255) break;
  }
  std::cout << "is passed through between 0 and 63" << std::endl;

  passedThrough = chessHelpers::getPassedThrough(63, 0);
  for (int i = 0; i < 8; i++) {
  	std::cout << (uint16_t)passedThrough[i] << " ";
  	if (passedThrough[i] == 255) break;
  }
  std::cout << "is passed through between 63 and 0" << std::endl;
  std::cout << "--------------------"               << std::endl;

  uint8_t* physicalMoves;
  physicalMoves = chessHelpers::getMoveList(chessHelpers::wRook, 16);
  std::cout << "A rook   on 16 can go to ";
  for (int i = 0; i < 32; i++) {
  	std::cout << (uint16_t)physicalMoves[i] << " ";
  	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wQueen, 63);
  std::cout << "A queen  on 63 can go to ";
  for (int i = 0; i < 32; i++) {
  	std::cout << (uint16_t)physicalMoves[i] << " ";
  	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wKing, 60);
  std::cout << "A king   on 60 can go to ";
  for (int i = 0; i < 32; i++) {
  	std::cout << (uint16_t)physicalMoves[i] << " ";
  	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wBishop, 33);
  std::cout << "A bishop on 33 can go to ";
  for (int i = 0; i < 32; i++) {
  	std::cout << (uint16_t)physicalMoves[i] << " ";
  	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wKnight, 46);
  std::cout << "A knight on 46 can go to ";
  for (int i = 0; i < 32; i++) {
  	std::cout << (uint16_t)physicalMoves[i] << " ";
  	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wPawn, 52);
  std::cout << "A pawn   on 52 can go to ";
  for (int i = 0; i < 32; i++) {
	std::cout << (uint16_t)physicalMoves[i] << " ";
	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wPawn, 31);
  std::cout << "A pawn   on 31 can go to ";
  for (int i = 0; i < 32; i++) {
	std::cout << (uint16_t)physicalMoves[i] << " ";
	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;

  physicalMoves = chessHelpers::getMoveList(chessHelpers::wPawn, 8);
  std::cout << "A pawn   on  8 can go to ";
  for (int i = 0; i < 32; i++) {
	std::cout << (uint16_t)physicalMoves[i] << " ";
	if (physicalMoves[i] == 255) break;
  }
  std::cout << std::endl;
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


