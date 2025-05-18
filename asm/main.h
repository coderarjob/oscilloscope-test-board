#pragma once

#define USART_BAUD 10000
#define USART_BAUD_COUNTER ((F_CPU/(16 * USART_BAUD)) - 1)

#define HIGH(v) ((v >> 8) & 0xFF)
#define LOW(v) ((v) & 0xFF)

