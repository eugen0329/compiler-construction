BISON   = bison
CC      = gcc

LDLIBS = -ly

BISON_SRC = syntax.y
BISON_TARGET = $(BISON_SRC:.y=.c)
BISON_FLAGS = 

TARGET = bin

all: $(TARGET)

$(TARGET): $(BISON_TARGET)
	$(CC) $(BISON_TARGET) -o $(TARGET) $(LDLIBS)

$(BISON_TARGET): $(BISON_SRC)
	$(BISON) -o $(BISON_TARGET) $(BISON_FLAGS) $(BISON_SRC)


.PHONY: clean
clean:
	rm -f $(TARGET) $(BISON_TARGET)
