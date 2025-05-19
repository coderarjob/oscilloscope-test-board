machine ?= atmega8a
clock ?= 12000000

ld_flags := -mmcu=${machine}
cc_flags := -mmcu=${machine}      \
		    -mint8                \
		    -fpack-struct         \
		    -funsigned-char       \
		    -funsigned-bitfields  \
		    -fshort-enums         \
		    -Os                   \
		    -Wall                 \
		    -Wextra               \
		    -std=c99

ALL: main.hex main.lst

TARGET := main.hex
SRC := main.c usart.c

OBJS := $(SRC:.c=.o)

%.o: %.c
	avr-gcc -c ${cc_flags} -DF_CPU=${clock} $<

$(TARGET): $(OBJS)
	avr-gcc $(ld_flags) -o main.elf $(OBJS)
	avr-objcopy -O ihex main.elf main.hex
	avr-objdump -dSl main.elf > main.lst

.PHONY:
clean:
	rm -f $(TARGET) $(TARGET:.hex=.elf) $(TARGET:.hex=.lst) $(OBJS)
