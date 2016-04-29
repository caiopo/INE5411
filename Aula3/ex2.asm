.data
_save: .word 99999,8,6,6,6,6,6,6,6,6
#_save: .word 99999,8,6,6,3,6,6,5,6,0
_k: .word 6
_error: .asciiz "Index Out of Bounds Exception"

.text
.globl main
main:

la $s6, _save # endereco base de save
lw $s5, _k # endereco base de k
lw $t2, 4($s6) # tamanho de save

Loop:

	# testa limite do arranjo
	sltu $t3, $s3, $t2
	beq $t3, $zero, IndexOutOfBounds	

	sll $t1, $s3, 2
	add $t1, $t1, $s6
	
	lw $t0, 8($t1)
	bne $t0, $s5, Exit
	addi $s3, $s3, 1
	j Loop

Exit:
	addi $v0, $zero, 1
	add $a0, $zero, $s3
	syscall
	j End

IndexOutOfBounds:
	addi $v0, $zero, 4
	la $a0, _error
	syscall

End: