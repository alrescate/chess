#
TARGET = HPS_FPGA_LED

#
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CROSS_COMPILE = arm-linux-gnueabihf-
CFLAGS = -g -Wall   -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/
LDFLAGS =  -g -Wall 
CC = $(CROSS_COMPILE)g++
ARCH= arm

debugBoard:
	g++ -g -Wall -I. testBoard.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testBoard

debugEngine:
	g++ -g -pg -Wall -I. testEngine.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testEngine
	
releaseBoard:
	g++ -O3 -Wall -I. testBoard.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testBoard

releaseEngine:
	g++ -O3 -Wall -I. testEngine.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testEngine
	
debugUCI:
	g++ -O3 -g -Wall -I. uci_main.cpp uci_interface.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o uciEngine

releaseUCI:
	g++ -O3 -Wall -I. uci_main.cpp uci_interface.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o uciEngine
	
profUCIcomp:
	g++ -pg -O3 -Wall -I. uci_main.cpp uci_interface.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o uciEngine
	
#testBoard.exe:
#	g++ -I. testBoard.cpp HRand.cpp -o testBoard.exe
  
armEngine:
	$(CC) $(CFLAGS) -O3 -I. testEngine.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testEngine
	
profARMComp:
	$(CC) -pg -O3 -I. testEngine.cpp engine.cpp Board.cpp chessHelpers.cpp HRand.cpp -o testEngine

profARM:
	$(CROSS_COMPILE)gprof testEngine gmon.out > testEngine.output