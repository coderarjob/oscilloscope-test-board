#include <avr/io.h>
#include <util/delay_basic.h>

#define BAUD 10000
#define BAUD_COUNTER (((unsigned int)F_CPU/(16 * BAUD)) - 1)

#define HIGH8(v) ((v >> 8) & 0xFF)
#define LOW8(v) (v & 0xFF)

void usart_setup();
void usart_send_char(char c);
void usart_send_string(const char* str);

__attribute__((noreturn))
void main(void) {
    usart_setup();

    for(char c = 'A'; ; c+1 > 'Z' ? c = 'A' : c++) {
        _delay_loop_2(65535);
        usart_send_string("Arjob");
        usart_send_char(c);
    }
    while(1);
}

void usart_setup()
{
    UBRRH = 0; //HIGH8(BAUD_COUNTER);
    UBRRL = 0x4A; //LOW8(BAUD_COUNTER);

    UCSRC = (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0) | (1 << USBS);
    UCSRB = (1 << TXEN);
}

void usart_send_string(const char* str)
{
    char c;
    while ((c = *str++)) {
        usart_send_char(c);
    }
}

void usart_send_char(char c)
{
    while ((UCSRA & (1 << UDRE)) == 0);
    UDR = c;
}
