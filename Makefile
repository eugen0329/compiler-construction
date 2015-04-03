CC      = g++
CCFLAGS =

LEX     = flex
BISON   = bison

#LDLIBS = -ly
LDLIBS = -lfl

BISON_SRC = ./SyntaxAnalyzer/syntax.y
BISON_DEFINES = ./SyntaxAnalyzer/yccdefs.h
BISON_TARGET = $(BISON_SRC:.y=.c)

BISON_FLAGS = -dt

LEX_SRC = ./LexicalAnalyzer/lexis.lex
LEX_TARGET = $(LEX_SRC:.lex=.c)

INCL_DIRS = ./SyntaxAnalyzer

TARGET = bin

all: CCFLAGS += -Wno-write-strings
all: $(TARGET)

debug: BISON_FLAGS += -v
debug: CCFLAGS += -DDEBUG -pedantic -Wall
debug: $(TARGET)

$(TARGET): $(BISON_TARGET) $(LEX_TARGET)
	$(CC) $(CCFLAGS) $(BISON_TARGET) $(LEX_TARGET) -o $(TARGET) -I $(INCL_DIRS) $(LDLIBS)

$(BISON_TARGET): $(BISON_SRC)
	$(BISON) -o $(BISON_TARGET) --defines=$(BISON_DEFINES) $(BISON_FLAGS) $(BISON_SRC)

$(LEX_TARGET): $(LEX_SRC)
	$(LEX) -o $(LEX_TARGET) $(LEX_SRC)


.PHONY: c
c: clean

.PHONY: clean
clean:
	rm -f $(TARGET) $(LEX_TARGET) $(BISON_TARGET) $(BISON_DEFINES)

