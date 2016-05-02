.text
.globl main

main:

addi $a0, $zero, 103
addi $a1, $zero, 5
jal modulo
j Exit


modulo:
div $a0, $a1
mfhi $v0
jr $ra


Exit:

movn