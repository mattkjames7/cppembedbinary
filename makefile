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
	echo '#define DATAFMTLD' > data.h
endif
	objdump -t data.o

readbin:
	$(CC) readbin.cc data.o -o readbin
	./readbin

clean:
	-rm -v writebin
	-rm -v data.bin
	-rm -v data.o
	-rm -v readbin
	-rm -v data.h
	-rm -v data.cc