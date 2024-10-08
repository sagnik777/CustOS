/* Generic printk and supporint functions
*  To read the kernel logs and prints
*
*  Author : Sagnik
*  Created : 27/4/2022
*/

#include "print.h"
#include "uart.h"

/* Static declarations */
static int read_string(char* buffer, int position, const char *string);
static int hex_to_string(char *buffer, int position, uint64_t digits);
static int unsign_decimal_to_string(char *buffer, int position, uint64_t digits);
static int sign_decimal_to_string(char *buffer, int position, int64_t digits);
static void write_console(const char *buffer, int size);

/* ---------------- Code Starts ---------------- */
int printk(const char *format, ...) {
    char buffer[MAX_CAPTURES];
    int buffer_size = 0;
    long integer = 0;
    char *string = 0;
    va_list args;

    va_start(args, format);

    for (int i = 0; format[i] != '\0'; i++) {
        if (format[i] != '%' ) {
            buffer[buffer_size++] = format[i];
        } else {
            switch ( format[++i] ) {
                case 'x':
                    integer = va_arg(args, int64_t);
                    buffer_size += hex_to_string(buffer, buffer_size, (uint64_t)integer);
                    break;
                case 'u':
                    integer = va_arg(args, int64_t);
                    buffer_size += unsign_decimal_to_string(buffer, buffer_size, (uint64_t)integer);
                    break;
                case 'd':
                    integer = va_arg(args, int64_t);
                    buffer_size += sign_decimal_to_string(buffer, buffer_size, integer);
                    break;
                case 's':
                    string = va_arg(args, char*);
                    buffer_size += read_string(buffer, buffer_size, string);
                    break;
                default:
                    buffer[buffer_size++] = '%';
                    i--;
                    break;
            }
        }
    }
    
    write_console(buffer, buffer_size);
    va_end(args);
    
    return buffer_size;
}

static int read_string(char* buffer, int position, const char *string) {
    int index = 0;

    for(index = 0; string[index] != '\0'; index++) {
        buffer[position++] = string[index];
    }

    return index;
}

static int hex_to_string(char *buffer, int position, uint64_t digits) {
    char digits_buffer[25];
    char digits_map[16] = "0123456789ABCDEF";
    int size = 0;

    do {
        digits_buffer[size++] = digits_map[digits % 16];
        digits /= 16;
    } while(digits != 0);

    for (int i = size-1; i >= 0; i--) {
        buffer[position++] = digits_buffer[i];
    }

    buffer[position++] = 'H';

    return (size+1);
}

static int unsign_decimal_to_string(char *buffer, int position, uint64_t digits) {
    char digits_map[10] = "0123456789";
    char digits_buffer[25];
    int size = 0;

    do {
        digits_buffer[size++] = digits_map[digits % 10];
        digits /= 10;
    } while (digits != 0);

    for (int i = size-1; i >= 0; i--) {
        buffer[position++] = digits_buffer[i];
    }

    return size;
}

static int sign_decimal_to_string(char *buffer, int position, int64_t digits) {
    int size = 0;

    if(digits < 0) {
        digits = -digits;
        buffer[position++] = '-';
        size = 1;
    }

    size += unsign_decimal_to_string(buffer, position, (uint64_t)digits);
    return size;
}

static void write_console(const char *buffer, int size) {
    for (int i = 0; i < size; i++) {
        uart_write_char(buffer[i]);
    }
}