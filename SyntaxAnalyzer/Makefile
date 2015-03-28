BISON   = bison
CC      = gcc

LDLIBS = -ly

BISON_SRC = main.y
BISON_TARGET = $(LEX_SRC:.y=.c)

TARGET = bin

all: $(TARGET)

$(TARGET): $(LEX_TARGET)
	$(CC) $(LEX_TARGET) -o $(TARGET) $(LDLIBS)

$(BISON_TARGET): $(BISON_SRC)
	$(BISON) -o $(BISON_TARGET) $(BISON_SRC)


.PHONY: clean
clean:
	rm -f $(TARGET) $(BISON_TARGET)
