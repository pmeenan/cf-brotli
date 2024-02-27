CPP = emcc
CPPFLAGS = --bind -std=c++11 -s DYNAMIC_EXECUTION=0 -s MODULARIZE=1 -s ENVIRONMENT="web" -s EXPORTED_RUNTIME_METHODS='["cwrap", "setValue"]' -s ALLOW_MEMORY_GROWTH=1 --pre-js src/pre.js

COMMONDIR = brotli/c/common
ENCDIR = brotli/c/enc
ENCSRC = $(wildcard $(COMMONDIR)/*.c) $(wildcard $(ENCDIR)/*.c)
ENCSRCPP = src/cf-brotli.cpp
ENCOBJ = $(ENCSRC:.c=.o) $(ENCSRCPP:.cpp=.o)

all: bin/cf-brotli.js

.c.o .cc.o .cpp.o:
	$(CPP) -I brotli/c/include/ -c $< -o $@

bin/cf-brotli.js: src/pre.js $(ENCOBJ)
	mkdir -p bin/
	$(CPP) $(CPPFLAGS) $(ENCOBJ) -o bin/cf-brotli.js

clean:
	rm -rf $(ENCOBJ) bin/
