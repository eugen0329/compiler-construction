LEX     = flex
CC      = gcc

CC_FLAGS = -lfl

LEX_SRC = main.lex
LEX_TARGET = $(LEX_SRC:.lex=.c)

TARGET = bin

all: $(TARGET)

$(TARGET): $(LEX_TARGET)
	$(CC) -o $(TARGET) $(LEX_TARGET) $(CC_FLAGS)

$(LEX_TARGET): $(LEX_SRC)
	$(LEX) -o $(LEX_TARGET) $(LEX_SRC)


clean: c
c:
	rm -f $(TARGET) $(LEX_TARGET)
