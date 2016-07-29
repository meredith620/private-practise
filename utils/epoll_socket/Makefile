CC = gcc
CXX = g++
OPTIMISE = -O3 #-g -pg
WARN = -Wall -Wno-deprecated
#############################
SRC := $(wildcard *.c)
OBJ := $(patsubst %.c, %.o, $(SRC))
BIN := $(patsubst %.o, %, $(OBJ))

# rules #
.DEFAULT: all

all: $(BIN)
# obj: $(OBJ)
# %.o: %.c
# 	$(CC) $(WARN) $^ -c $@
# %: %.o
# 	$(CC) $(WARN) $^ -o $@

clean:
	rm -f $(OBJ) $(BIN)

.PHONY: all
