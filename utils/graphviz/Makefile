DOT = dot
RM = rm
#######################################
SRC := $(wildcard *.dot)
TAR := $(patsubst %.dot, %.png, $(SRC))

all: $(TAR)

%.png: %.dot
	$(DOT) -Tpng $< -o $@

clean:
	@$(RM) -f $(TAR)

.PHONY: all clean
