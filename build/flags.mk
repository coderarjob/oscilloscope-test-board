include ./build/config.mk

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

ifdef DEBUG
	cc_flags += -g
endif


