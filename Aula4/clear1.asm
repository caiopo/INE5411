.data
_array: .word 1,2,3,4,5,6,7,8,9,2,3
_size: .word 11

.text
.globl main

main:

jal clear1

li $v0, 10
syscall

clear1:
    la $a0, _array
    lw $a1, _size
    
    # prologo {
    add $t0, $zero, $zero
    # }

    # corpo {
    Loop1:
        slt $t3, $t0, $a1
        beq $t3, $zero, Exit

        sll $t1, $t0, 2
        add $t2, $a0, $t1
        sw $zero, 0($t2)

        addi $t0, $t0, 1

        j Loop1
    # }
    
    # epilogo {
    Exit:
        jr $ra
    # }