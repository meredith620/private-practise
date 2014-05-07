# Top level makefile, the real shit is at src/Makefile

default: all

.DEFAULT:
	cd contrib && $(MAKE) hiredis ketama
	cd build && $(MAKE) $@

clean:
	cd contrib && $(MAKE) clean
	cd build && $(MAKE) clean
.PHONY: clean
