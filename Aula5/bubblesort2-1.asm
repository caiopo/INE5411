.data
_v: .word 29,28,27,26,25,24,23,22,21,-1
_n: .word 10

.text
.globl main

main:
  la   $a0,_v  
  lw   $a1,_n 
  jal sort
  li  $v0,10      #Exit syscall
  syscall
  
# procedure sort 
sort:
  # preservacao de registradores armazenando seus conteudos na pilha
  addi $sp,$sp,-12
  sw   $ra,8($sp)
  sw   $s1,4($sp) 
  sw   $s0,0($sp)
   
  move $s0,$zero   # inicializacao de i
  # inicio do corpo do laco externo
for1tst:
  nop #MARCA 1
  slt  $t0,$s0,$a1 # for1st
  beq  $t0,$zero,exit1  
  addi $s1,$s0,-1  
  # inicio do corpo do laco interno
for2tst:
  slti $t0,$s1,0  # for2st
  bne  $t0,$zero,exit2 
  sll  $t1,$s1,2   
  add  $t2,$a0,$t1 
  lw   $t3,0($t2)
  lw   $t4,4($t2)
  slt  $t0,$t4,$t3
  beq  $t0,$zero,exit2

  nop # MARCA 2
  jal  swap 	# chamada de swap
  addi $s1,$s1,-1
  j    for2tst
  # fim do corpo do laco interno
exit2:
  addi $s0,$s0,1
  j    for1tst
  # fim do corpo do laco externo
exit1:
  # restauracao de conteudos de registradores preservados na pilha
  lw   $s0,0($sp)  
  lw   $s1,4($sp)
  lw   $ra,8($sp)
  addi $sp,$sp,12
  # retorno ao procedimento chamador 
  jr   $ra

 # codificacao da procedure swap 
swap:
	sll $t0, $a1, 2
	add $t0, $t0, $a0

	lw $t1, 0($t0)
	lw $t2, 4($t0)

	sw $t1, 4($t0)
	sw $t2, 0($t0)

	jr $ra
