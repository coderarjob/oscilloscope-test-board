family = avr4

main.S.hex: main.S
	avra main.S -o main.S.hex -l main.lst -e main.S.eep.hex

.PHONY:
clean:
	rm -f main.S.hex main.lst main.S.eep.hex main.S.obj

