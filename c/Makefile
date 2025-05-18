machine := atmega8a
clock := 12000000

main.hex: main.c
	avr-gcc -ffreestanding -Os -DF_CPU=${clock} -mmcu=${machine} -c main.c -std=c99
	avr-gcc -ffreestanding -DF_CPU=${clock} -mmcu=${machine} -o main.elf main.o
	avr-objcopy -O ihex main.elf main.hex
	avr-objdump -DSl main.elf > main.lst

.PHONY:
clean:
	rm -f main.elf main.hex main.o main.lst
