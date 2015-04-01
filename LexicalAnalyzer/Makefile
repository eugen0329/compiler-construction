LEX     = flex
CC      = g++

LDLIBS =

LEX_SRC = lexis.lex
LEX_TARGET = $(LEX_SRC:.lex=.c)

TARGET = bin

all: $(TARGET)

$(TARGET): $(LEX_TARGET)
	$(CC) $(LEX_TARGET) -o $(TARGET) $(LDLIBS)

$(LEX_TARGET): $(LEX_SRC)
	$(LEX) -o $(LEX_TARGET) $(LEX_SRC)


.PHONY: clean
clean:
	rm -f $(TARGET) $(LEX_TARGET)
