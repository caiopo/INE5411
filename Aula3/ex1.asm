.data
#_save: .word 6,6,2,7,6,5,6,0
_save: .word 6,6,6,6,6,6,6,6

_k: .word 6

.text
.globl main
main:

la $s6, _save
lw $s5, _k

Loop:
	sll $t1, $s3, 2
	add $t1, $t1, $s6
	lw $t0, 0($t1)
	bne $t0, $s5, Exit
	addi $s3, $s3, 1
	j Loop

Exit:
	addi $v0, $zero, 1
	add $a0, $zero, $s3
	syscall