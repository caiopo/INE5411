.data

_a: .word 0x80808012
_b: .word 0xAAAAAAAA

.text
.globl main

main:

la $t1, _a
la $t2, _b

lb $t0, 0 ($t1)
sw $t0, 0($t2)
