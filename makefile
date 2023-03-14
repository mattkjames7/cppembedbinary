CFLAGS=-lm -fPIC -std=c++17 -Wextra -O3

# Compiler
CCo=g++ -c $(CFLAGS)
CC=g++ $(CFLAGS)


all:
	$(CC) writebin.cc -o writebin
	./writebin
	ld -r -b binary data.bin -o data.o
	objdump -t data.o

clean:
	-rm -v writebin
	-rm -v data.bin
	-rm -v data.o