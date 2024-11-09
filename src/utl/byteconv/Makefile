
DIR=../../../
include $(DIR)config.mk

TARGETS=$(BIN)sacsun2dec$(EXE)

all: $(TARGETS)

clean:
	$(CLEAN) $(TARGETS) $(OBJ)

$(BIN)%$(EXE): %.o
	$(CC) $(CFLAGS) $^ $(LIBS) -o $@
