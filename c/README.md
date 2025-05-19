## Demo board or oscilloscope testing

This is a hardware project based on Atmega8A microcontroller. This project again from a personal
need to have a demo board to test my new oscilloscope. I plan to create a complete PCB along with
firmware in this repo.

### Goals

- [X] Firmware: RS232 sample output (positive)
- [ ] Firmware: RS232 sample output (negative)
- [ ] Firmware: Holdoff test
- [ ] Firmware: I2C sample output
- [ ] Firmware: Runt pulse
- [ ] Firmware: Sine wave pattern
- [ ] Firmware: Burst data in two lines
- [ ] Unittests: Add unittests for utils

## Building prerequisites

1. Requires Linux environment for building.
2. GNU Make
3. avr-gcc
4. avr-libc

Building is simple just call `make` from the source directory.

# Feedback

Open a GitHub issue or drop a email at arjobmukherjee@gmail.com. I would love to hear your
suggestions and feedbacks.
