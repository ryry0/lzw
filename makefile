SOURCE_EXT=c
OBJ_EXT=o
HEAD_EXT=h
OBJ_HEAD_EXT=gch
CC=gcc
CFLAGS=-c -I. -std=c11
LDFLAGS=
DFLAGS=-DDEBUG -ggdb -g3 -Wall
DEFAULT_DEBUG=y

EXECUTABLE=compress.x

SOURCES=$(wildcard *.$(SOURCE_EXT))
OBJECTS=$(SOURCES:.$(SOURCE_EXT)=.$(OBJ_EXT))

.PHONY: clean cleanall run test debug

ifeq ($(DEFAULT_DEBUG),y)
ALL_TARGET=debug
else
ALL_TARGET=$(SOURCES) $(EXECUTABLE)
endif

all: $(ALL_TARGET)

debug: CFLAGS += $(DFLAGS)
debug: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

%.$(OBJ_EXT): %.$(SOURCE_EXT) $(wildcard *.$(HEAD_EXT))
	$(CC) $(CFLAGS) $< -o $@


cleanall: clean
	rm -f $(EXECUTABLE)

proper: clean cleanall

re: proper all

redo: proper debug

clean:
	rm -f $(wildcard *.$(OBJ_EXT)) $(wildcard *.$(OBJ_HEAD_EXT))

tags:
	ctags -R --c++-kinds=+p --fields=+iaS --extra=+q

run:
	./$(EXECUTABLE)

test:
	gdb -tui -q $(EXECUTABLE)
