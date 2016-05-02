.text
.globl main

main:

li $t0, 0x0001000

slt $t2, $t0, $t0
bnez $t2, Else
j Done
Else:
addi $t2, $t2, 2
Done: