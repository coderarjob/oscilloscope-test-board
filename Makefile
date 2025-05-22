include ./build/config.mk
include ./build/flags.mk

BUILD_DIR ?= out
OBJ_DIR := $(BUILD_DIR)/obj
SRC_DIR := src

TARGET := $(BUILD_DIR)/main.hex

all: $(TARGET)

SRC := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Implicit rules
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	avr-gcc -c ${cc_flags} -DF_CPU=${clock} $< -o $@

$(BUILD_DIR)/%.elf: $(OBJS)
	avr-gcc $(ld_flags) $^ -o $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	avr-objcopy -O ihex $^ $@
	avr-objdump -dSl $^ > $(@:%.hex=%.lst)

$(OBJ_DIR):
	mkdir -p $@

clean:
	rm -fr $(BUILD_DIR)

program: $(TARGET)
	avrdude -c usbasp -p m8a -U flash:w:$(TARGET):i

restart:
	avrdude -c usbasp -p m8a -U signature:r:-:h

.PHONY: program restart clean all
.PRECIOUS: $(BUILD_DIR)/%.elf $(OBJ_DIR)/%.o
