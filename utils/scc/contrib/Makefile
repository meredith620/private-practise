# ilcsider dependency Makefile

all:
	@echo -e "\tyou should choose which target to built: hiredis, ketama"	

hiredis:
	cd hiredis && $(MAKE) static
.PHONY: hiredis

ketama:
	cd libketama && $(MAKE) static
.PHONY: ketama

clean:
	cd hiredis && $(MAKE) clean
	cd libketama && $(MAKE) clean
.PHONY: clean

