include ./build/config.mk
include ./build/flags.mk

BUILD_DIR ?= out
OBJ_DIR := $(BUILD_DIR)/obj
SRC_DIR := src

TARGET := $(BUILD_DIR)/main.hex

all: $(TARGET)

SRC = $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

ELF_FILE := $(TARGET:%.hex=%.elf)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	avr-gcc -c ${cc_flags} -DF_CPU=${clock} $< -o $@

$(ELF_FILE): $(OBJS)
	avr-gcc $(ld_flags) -o $@ $^

$(TARGET): $(ELF_FILE)
	avr-objcopy -O ihex $^ $@
	avr-objdump -dSl $^ > $(TARGET:%.hex=%.lst)

$(OBJ_DIR):
	mkdir -p $@

clean:
	rm -fr $(TARGET) $(BUILD_DIR)

program: $(TARGET)
	avrdude -c usbasp -p m8a -U flash:w:$(TARGET):i

restart:
	avrdude -c usbasp -p m8a -U signature:r:-:h

.PHONY: program
.PHONY: restart
.PHONY: clean
.PHONY: all
