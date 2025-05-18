#include <avr/io.h>
#include "main.h"

.global main
.section .text

main:
    rcall init

    rcall delay

reset_index:
    ldi r16, 'A'

again:
    ldi zl, lo8(message)
    ldi zh, hi8(message)
    rcall usart_transmit_string

    rcall usart_transmit_char

    rcall delay

    inc r16
    cpi r16, 'Z' + 1
    breq reset_index
    rjmp again

    ret

/*
* ===========================================
* Transmit a ASCIZ string using UART
* Input: Z - Zero terminated ASCII string
* Output: None
* ===========================================
*/
usart_transmit_string:
    push zl
    push zh
    push r16
1:
    LPM r16, Z+
    cpi r16, 0
    breq 2f
    rcall usart_transmit_char
    rjmp 1b
2:
    pop r16
    pop zh
    pop zl
    ret

/*
* ===========================================
* Small delay
* Input: None
* Output: None
* ===========================================
*/
delay:
    push r16
    ldi r17, 255
2:
    ldi r16, 255
1:
    dec r16
    brne 1b

    dec r17
    brne 2b

    pop r16
    ret
/*
* ===========================================
* Initialize various systems needed
* Input: None
* Output: None
* ===========================================
*/
init:
    rcall usart_init
    ret

/*
* ===========================================
* Waits for previous trasmission to complete then transmits a single character
* Input: R16  - Character to trasmit
* Output: None
* ===========================================
*/
usart_transmit_char:
    sbis _SFR_IO_ADDR(UCSRA), UDRE
    rjmp usart_transmit_char

    out _SFR_IO_ADDR(UDR), r16
    ret

/*
* ===========================================
* Sets up the USART module
* Input: None
* Output: None
* ===========================================
*/
usart_init:
    push r16
    push r17

    ; Setup of baud rate
    ldi r16, lo8(USART_BAUD_COUNTER)
    ldi r17, hi8(USART_BAUD_COUNTER)
    out _SFR_IO_ADDR(UBRRL), r16
    out _SFR_IO_ADDR(UBRRH), r17

    ; 8 data bit, 2 stop bit, no parity
    ldi r16, (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0) | (1 << USBS)
    out _SFR_IO_ADDR(UCSRC), r16

    ; Enable transmitter
    ldi r16, (1 << TXEN)
    out _SFR_IO_ADDR(UCSRB), r16

    pop r17
    pop r16
    ret

/*
* ===========================================
*  Data
* ===========================================
*/
message: 
    .asciz "Arjob"
