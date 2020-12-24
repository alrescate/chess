#
TARGET = TEST_RAM

#
ALT_DEVICE_FAMILY ?= soc_cv_av
SOCEDS_ROOT ?= $(SOCEDS_DEST_ROOT)
HWLIBS_ROOT = $(SOCEDS_ROOT)/ip/altera/hps/altera_hps/hwlib
CHESS_ROOT = $(HOME)/work/source/cppChess/cppChess_Comp
CROSS_COMPILE = arm-linux-gnueabihf-
SOCLOC = $(HOME)/work/source/temp_pars/July19A_restored/soc_system
CFLAGS = -g -Wall  -D$(ALT_DEVICE_FAMILY) -I$(HWLIBS_ROOT)/include/$(ALT_DEVICE_FAMILY)   -I$(HWLIBS_ROOT)/include/ -I$(CHESS_ROOT) -std=c++11
LDFLAGS =  -g -Wall
CC = $(CROSS_COMPILE)g++
ARCH= arm

build: $(TARGET)
$(TARGET): main.o
	$(CC) $(LDFLAGS)   $^ -o $@

%.o : %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

%.o : %.c
	$(CC) $(CFLAGS) -c $< -o $@

profARM:
	$(CROSS_COMPILE)gprof main gmon.out > testEngine.output
	
engineLOC:
	g++ $(CFLAGS) -O3 main.cpp $(CHESS_ROOT)/engine.cpp $(CHESS_ROOT)/Board.cpp $(CHESS_ROOT)/chessHelpers.cpp $(CHESS_ROOT)/HRand.cpp -o main

engineARM:
	$(CC) $(CFLAGS) -O3 main.cpp $(CHESS_ROOT)/engine.cpp $(CHESS_ROOT)/Board.cpp $(CHESS_ROOT)/chessHelpers.cpp $(CHESS_ROOT)/HRand.cpp -o main

ARM_testEngine:
	$(CC) $(CFLAGS) -O3 $(CHESS_ROOT)/testEngine.cpp $(CHESS_ROOT)/engine.cpp $(CHESS_ROOT)/Board.cpp $(CHESS_ROOT)/chessHelpers.cpp $(CHESS_ROOT)/HRand.cpp -o main

qsys:
	qsys-generate --synthesis=verilog $(SOCLOC)/soc_system.qsys

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~
