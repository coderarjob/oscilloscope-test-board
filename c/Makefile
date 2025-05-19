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

main.o: main.c
	avr-gcc -c ${cc_flags} -DF_CPU=${clock} main.c

main.elf main.lst &: main.o
	avr-gcc ${ld_flags} -o main.elf main.o
	avr-objdump -DSl main.elf > main.lst

main.hex: main.elf
	avr-objcopy -O ihex main.elf main.hex

.PHONY:
clean:
	rm -f main.elf main.hex main.o main.lst
