.include "m8def.inc"

    .org 0x00
    rjmp main

main:
    ldi r16, HIGH(RAMEND)
    out sph, r16

    ldi r16, LOW(RAMEND)
    out spl, r16

    rcall init

    rcall delay

    ldi zl, low(message << 1)
    ldi zh, high(message << 1)
    rcall usart_transmit_string

    ;ldi r16, 'A'
    ;rcall usart_transmit_char

halt:
    rjmp halt

;/*
;* ===========================================
;* Transmit a ASCIZ string using UART
;* Input: Z - Zero terminated ASCII string
;* Output: None
;* ===========================================
;*/
usart_transmit_string:
    push zl
    push zh
    push r16
loop:
    LPM r16, Z+
    cpi r16, 0
    breq fin
    rcall usart_transmit_char
    rjmp loop
fin:
    pop r16
    pop zh
    pop zl
    ret

;/*
;* ===========================================
;* Small delay
;* Input: None
;* Output: None
;* ===========================================
;*/
delay:
    push r16
    ldi r16, 255
l1:
    dec r16
    brne l1

    pop r16
    ret

;/*
;* ===========================================
;* Initialize various systems needed
;* Input: None
;* Output: None
;* ===========================================
;*/
init:
    rcall usart_init
    ret

;/*
;* ===========================================
;* Waits for previous trasmission to complete then transmits a single character
;* Input: R16  - Character to trasmit
;* Output: None
;* ===========================================
;*/
usart_transmit_char:
    sbis UCSRA, UDRE
    rjmp usart_transmit_char

    out UDR, r16
    ret

;/*
;* ===========================================
;* Sets up the USART module
;* Input: None
;* Output: None
;* ===========================================
;*/
usart_init:
    push r16
    push r17

    ; Setup of baud rate
    ldi r16, 0x4A
    ldi r17, 0x0
    out UBRRL, r16
    out UBRRH, r17

    ; 8 data bit, 1 stop bit, no parity
    ldi r16, (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0) | (1 << USBS)
    out UCSRC, r16

    ; Enable transmitter
    ldi r16, (1 << TXEN)
    out UCSRB, r16

    pop r17
    pop r16
    ret

;/*
;* ===========================================
;*  Data
;* ===========================================
;*/
message: 
    .db "Arjob", 0
