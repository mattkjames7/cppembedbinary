CFLAGS=-lm -fPIC -std=c++17 -Wextra -O3

# Compiler
CCo=g++ -c $(CFLAGS)
CC=g++ $(CFLAGS)

# find out what OS we are on
ifneq ($(OS),Windows_NT)
	OS=$(shell uname -s)
endif

#work out if we should use xxd or ld to embed the data
ifeq ($(OS),Darwin)
	USELD=false
else
	USELD=true
endif

# rm or del
ifeq ($(OS),Windows_NT)
	RM=del
else
	RM=rm -v
endif

all: writebin data readbin


writebin:
	$(CC) writebin.cc -o writebin
	./writebin

data:
ifeq ($(USELD),false)
	xxd -i data.bin > data.cc
	$(CCo) data.cc -o data.o
	touch data.h
else
	ld -r -b binary data.bin -o data.o
ifeq ($(OS),Windows_NT)
	echo #define DATAFMTLD > data.h
else
	echo '#define DATAFMTLD' > data.h
endif
endif
	objdump -t data.o

readbin:
	$(CC) readbin.cc data.o -o readbin
	./readbin

clean:
	-$(RM) writebin
	-$(RM) data.bin
	-$(RM) data.o
	-$(RM) readbin
	-$(RM) data.h
	-$(RM) data.cc