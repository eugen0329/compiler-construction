BISON   = bison
CC      = gcc

LDLIBS = -ly

BISON_SRC = main.y
BISON_TARGET = $(BISON_SRC:.y=.c)
BISON_DEFINES = yccdefs.h

TARGET = bin

all: $(TARGET)

$(TARGET): $(BISON_TARGET)
	$(CC) $(BISON_TARGET) -o $(TARGET) $(LDLIBS)

$(BISON_TARGET): $(BISON_SRC)
	$(BISON) -o $(BISON_TARGET) --defines=$(BISON_DEFINES) $(BISON_FLAGS) $(BISON_SRC)


.PHONY: clean
clean:
	rm -f $(TARGET) $(BISON_TARGET) $(BISON_DEFINES)
