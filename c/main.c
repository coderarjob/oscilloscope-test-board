#include <avr/io.h>
#include <util/delay_basic.h>
#include <avr/interrupt.h>
#include <stdbool.h>
#include "main.h"

#define SWITCH_PIN_NO PD2
#define SWITCH_PORT   PORTD
#define SWITCH_PIN    PIND
#define SWITCH_DDR    DDRD

#define STATUS_PIN_NO PB1
#define STATUS_PORT   PORTB
#define STATUS_PIN    PINB
#define STATUS_DDR    DDRB

typedef enum TestModes {
    UNKNOWN_TEST,
    USART_TEST,
    HOLDOFF_TEST,
    TEST_COUNT
} TestModes;

static TestModes mode;
static bool mode_isDirty;

static void usart_test();
static void holdoff_test();

ISR (INT0_vect)
{
    if (++mode >= TEST_COUNT) {
        mode = USART_TEST;
    }

    mode_isDirty = true;

    BIT_SET (STATUS_PORT, STATUS_PIN_NO);

    // Wait for the pin to be high
    while (!IS_BIT_SET (SWITCH_PIN, SWITCH_PIN_NO))
        ;

    BIT_CLEAR (STATUS_PORT, STATUS_PIN_NO);
}

void setup_io()
{
    // Make the Interrupt 0 pin as the input
    MAKE_PIN_INPUT_PULLUP (SWITCH_DDR, SWITCH_PORT, SWITCH_PIN_NO);

    // Enable interrupt
#if SWITCH_PIN_NO != PD2
    #error "Wrong switch pin set"
#endif

    BIT_CLEAR_MASK (MCUCR, (1 << ISC01 | 1 << ISC00)); // Trigger at Low level
    BIT_SET_MASK (GICR, (1 << INT0));                  // Enable the interrupt

    // Status port
    MAKE_PIN_OUTPUT (STATUS_DDR, STATUS_PIN_NO);
    BIT_CLEAR (STATUS_PORT, STATUS_PIN_NO);

    sei();
}

__attribute__ ((noreturn)) void main (void)
{
    mode         = USART_TEST;
    mode_isDirty = true;

    setup_io();

    while (1) {
        mode_isDirty = false;
        switch (mode) {
        case USART_TEST:
            usart_test();
            break;
        case HOLDOFF_TEST:
            holdoff_test();
            break;
        default:
            BIT_SET (STATUS_PORT, STATUS_PIN_NO);
            break;
        }
    }
}

void holdoff_test()
{
#define OUTPUT_PIN_NO PD1
#define OUTPUT_PORT   PORTD
#define OUTPUT_PIN    PIND
#define OUTPUT_DDR    DDRD

}

void usart_test()
{
    usart_on();
    for (char c = 'A'; !mode_isDirty; c + 1 > 'Z' ? c = 'A' : c++) {
        _delay_loop_2 (65535);
        usart_send_string ("Arjob");
        usart_send_char (c);
    }
    usart_off();
}
