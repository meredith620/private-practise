# Top level makefile, the real shit is at src/Makefile

default: all

.DEFAULT:
	$(MAKE) -C contrib hiredis ketama
	$(MAKE) -C build $@

clean:
	$(MAKE) -C contrib $@
	$(MAKE) -C build $@
.PHONY: clean
