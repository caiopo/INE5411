.text
.globl main

main:

li $a0, 1
li $a1, 1
li $a2, 10

jal fib_iter

j exit

fib_iter:
	bnez $a2, else
	move $v0, $a1
	jr $ra
else:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	add $t0, $a0, $a1
	move $a1, $a0
	move $a0, $t0
	subi $a2, $a2, 1

	jal fib_iter

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

exit: