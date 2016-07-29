CC = gcc
CXX = g++
OPTIMISE = -O3 #-g -pg
WARN = -Wall -Wno-deprecated
LDFLAGS = -L ../contrib/hiredis/ -L ../contrib/libketama/
INCLUDES = -I ../include -I ../contrib/hiredis/ -I ../contrib/libketama/
LIBS = -lketama -lhiredis 
CXXFLAGS = $(WARN) $(OPTIMISE) $(LDFLAGS) $(LIBS) $(INCLUDES)
VPATH += ../include
###############################################
SRC := $(wildcard *.cc)
OBJ := $(patsubst %.cc, %.o, $(SRC))
BIN := $(patsubst %.o, %, $(OBJ))

all: libilcsider.so $(BIN)
obj: $(OBJ)
%.o: %.c
	$(CXX) $(CXXFLAGS) $(INCLUDES) $^ -c $<
###############################################
# %.o: %.cc
# 	$(CXX) $(CXXFLAGS) $(INCLUDES) $^ -c $<

libilcsider.so: ilcsider.cc ilcsider.h shine.cc shine.h
	$(CXX) $^ $(CXXFLAGS) -fPIC -shared -o $@

SERVICE_SOURCES = $(wildcard dataserver*.cc logmanager.cc protocol.cc)
SERVICE_OBJS	= $(patsubst %.c, %.o, $(patsubst %.cc, %.o, $(SERVICE_SOURCES)))

GUARD_SOURCES	= $(wildcard dataguard*.cc logmanager.cc resources.cc daemonize.cc heartbeat.cc protocol.cc)
GUARD_OBJS	= $(patsubst %.c, %.o, $(patsubst %.cc, %.o, $(GUARD_SOURCES)))

dataserver: $(SERVICE_OBJS)
	$(CXX) $(SERVICE_OBJS) ../common/logmanager.o -o $@ $(LDFLAGS)

dataguard: $(GUARD_OBJS)
	$(CXX) $(GUARD_OBJS) ../common/logmanager.o ../common/heartbeat.o -o $@ $(LDFLAGS)


# dep:
# 	g++ -MM $(INCLUDES) *.cc > dep

clean:
	rm -f libilcsider.so

.PHONY = all clean
