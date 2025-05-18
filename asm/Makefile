machine = atmega8a
clock = 12000000

main.hex: main.S
	avr-gcc -Wall -Wextra -Os -g -DF_CPU=${clock} -mmcu=${machine} main.S -o main.elf
	avr-objcopy -O ihex main.elf main.hex
	avr-objdump -dl main.elf > main.lst

.PHONY:
clean:
	rm -f main.elf main.hex main.o main.lst
