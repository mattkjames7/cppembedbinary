CFLAGS=-lm -fPIC -std=c++17 -Wextra -O3

# Compiler
CCo=g++ -c $(CFLAGS)
CC=g++ $(CFLAGS)


all:
	$(CC) writebin.cc -o writebin
	./writebin



clean:
	-rm -v writebin
	-rm -v data.bin