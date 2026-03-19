;========================================
; ATMEGA328P - Generar 100 números
; y ordenarlos con 2 algoritmos
;========================================

.include "m328pdef.inc"

;----------------------------------------
; REGISTROS
;----------------------------------------

.def temp = r16
.def temp2 = r17
.def i = r18
.def j = r19
.def rand = r20

;----------------------------------------
; MEMORIA
;----------------------------------------

.dseg

table_of_unsorted_numbers:     .byte 100
table_of_sorted_numbers_alg1:  .byte 100
table_of_sorted_numbers_alg2:  .byte 100

.cseg
.org 0x0000
rjmp START

;========================================
; INICIO
;========================================

START:

;----------------------------------------
; GENERAR NUMEROS PSEUDO ALEATORIOS
;----------------------------------------

ldi ZH, high(table_of_unsorted_numbers)
ldi ZL, low(table_of_unsorted_numbers)

ldi i, 100
ldi rand, 37

GEN_RANDOM:

    lsl rand
    eor rand, i

    st Z+, rand

    dec i
    brne GEN_RANDOM

;----------------------------------------
; COPIAR TABLA PARA ALGORITMO 1
;----------------------------------------

ldi ZH, high(table_of_unsorted_numbers)
ldi ZL, low(table_of_unsorted_numbers)

ldi YH, high(table_of_sorted_numbers_alg1)
ldi YL, low(table_of_sorted_numbers_alg1)

ldi i, 100

COPY1:

    ld temp, Z+
    st Y+, temp

    dec i
    brne COPY1

;----------------------------------------
; COPIAR TABLA PARA ALGORITMO 2
;----------------------------------------

ldi ZH, high(table_of_unsorted_numbers)
ldi ZL, low(table_of_unsorted_numbers)

ldi XH, high(table_of_sorted_numbers_alg2)
ldi XL, low(table_of_sorted_numbers_alg2)

ldi i, 100

COPY2:

    ld temp, Z+
    st X+, temp

    dec i
    brne COPY2

;
; ALGORITMO 1 - BUBBLE SORT

ldi i, 99

BUBBLE_OUTER:  ;Algoritmo 1

    ldi ZH, high(table_of_sorted_numbers_alg1)
    ldi ZL, low(table_of_sorted_numbers_alg1)

    mov j, i

BUBBLE_INNER:

    ld temp, Z
    ldd temp2, Z+1

    cp temp, temp2
    brlo NO_SWAP

    st Z, temp2
    std Z+1, temp

NO_SWAP:

    adiw ZL,1

    dec j
    brne BUBBLE_INNER

    dec i
    brne BUBBLE_OUTER

; ALGORITMO 2 - SELECTION SORT

ldi i, 0

SEL_OUTER:

    cpi i, 99
    brge END

    mov j, i
    inc j

SEL_INNER:

    cpi j, 100
    brge NEXT_SEL

    ldi ZH, high(table_of_sorted_numbers_alg2)
    ldi ZL, low(table_of_sorted_numbers_alg2)

    add ZL, i
    adc ZH, r1
    ld temp, Z

    ldi XH, high(table_of_sorted_numbers_alg2)
    ldi XL, low(table_of_sorted_numbers_alg2)

    add XL, j
    adc XH, r1
    ld temp2, X

    cp temp, temp2
    brlo NO_SWAP_SEL

    st Z, temp2
    st X, temp

NO_SWAP_SEL:

    inc j
    rjmp SEL_INNER

NEXT_SEL:

    inc i
    rjmp SEL_OUTER

; FIN

END:
rjmp END
