CC := gcc
CXX := g++
OPTIMISE := -O3 #-g -pg #-O3
WARN := -Wall -Wno-deprecated
LDFLAGS := -L ../build -L ../contrib/hiredis -L ../contrib/libketama
INCLUDES := -I ../include -I ../contrib/hiredis -I ../contrib/libketama -I gtest-1.6.0/include
LIBS := -lilcsider
CXXFLAGS := $(WARN) $(OPTIMISE) $(LDFLAGS) $(LIBS) $(INCLUDES)
VPATH := ../include
GTLIBS := -lpthread

SRC := $(wildcard *.cc)
OBJ := $(patsubst %.cc, %.o, $(SRC))
BIN := $(patsubst %.o, %, $(OBJ))

#command bin
CBIN := rtest generate
CSRC := $(patsubst %, %.cc, $(CBIN))
#unittest bin
TBIN := $(filter-out $(CBIN), $(BIN))
TSRC := $(patsubst %, %.cc, $(TBIN))

all: $(CBIN) $(TBIN)
obj: $(OBJ)
%.o: %.c	
	$(CXX) $(CXXFLAGS) -c $< -o $@
# %.o: %.cc
# 	$(CXX) $(CXXFLAGS) -c $< -o $@

$(CBIN): $(CSRC)
	@if [[ ! -e ../build/libilcsider.so ]];then cd .. && make;fi
	$(CXX) $(patsubst %, %.cc, $@) $(CXXFLAGS) -o $@

$(TBIN): $(TSRC)
	@if [[ ! -e gtest-1.6.0/make/gtest_main.a ]];then cd gtest-1.6.0/make && make; fi
	$(CXX) $(patsubst %, %.cc, $@) $(CXXFLAGS) gtest-1.6.0/make/gtest_main.a $(GTLIBS) -o $@

test: $(TBIN)
	@export LD_LIBRARY_PATH=../build; for x in $(TBIN); do ./$$x 2>/dev/null; done

clean:
	rm -f $(BIN) *.o

.PHONY: all clean test obj
