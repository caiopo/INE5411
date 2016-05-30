.data
.globl argumento
argumento: .word 0
anterior: .word 0
resultado: .word 0

.text
.globl main
main: la $s1,argumento  # - Coloca o endere�o de "argumento" em $s1
	sw $zero,0($s1)   # - Zera as vari�veis no in�cio do programa.
	sw $zero,4($s1)
	move $t2,$zero
	lui $s0,0xffff    # - Seta $s0 com o endere�o base dos registradores de MMIO
	# Completar: Habilite as interrup��es para entradas de teclado ------------------
	lw $t0, 0($s0)
	ori $t0, $t0, 2
	sw $t0, 0($s0)
	# -------------------------------------------------------------------------------	
	addi $a0,$zero,0x49 # / Estas 4 instru��es s�o utilizadas para escrever um "I"
	jal putc            # | na sa�da (display) indicando o in�cio da execu��o do 
	addi $a0,$zero,0x0A # | programa.
	jal putc            # \	
mloop: nop               
	nop	          # - V�rios nops foram utilizados para crescer o la�o principal.
	nop               #   Nessa parte, o programa poderia fazer algum outro trabalho �til,
	nop               #   se isso fosse importante ou necess�rio.
	nop	
	lw $t0,0($s1)      # - L� argumento atual
	lw $t1,4($s1)      # - L� argumento anterior
	beq $t1,$t0,mloop  # - Se o atual for diferente do anterior (argumento mudou
	sw $t0,4($s1)      #   em fun��o de I/O), calcula o n�mero da s�rie de Fibonacci
	addi $t1,$zero,0   
	addi $t2,$zero,1
loop:
	beq $t0,$zero,cont # - Neste loop, o n�mero da s�rie de Fibonacci � calculado
	add $t3,$t2,$t1
	move $t1,$t2
	move $t2,$t3	
	addi $t0,$t0,-1
	j loop
cont: sw $t1,8($s1)    # - Grava o resultado na posi��o resultado de mem�ria        
    # As pr�ximas instru��es s�o destinadas � impress�o do valor calculado no display.
	move $s6,$t1	
	ori $a0,$zero,0x30 # / - 4 instru��es utilizadas para imprimir "0x" no display
	jal putc           # | indicando que o valor que ser� impresso est� em hexadecimal
	ori $a0,$zero,0x78 # |
	jal putc	   # \	
	addi $s7,$zero,28    # / - Instru��es utilizadas para imprimir, no display, o 
loop2: srlv $a0,$s6,$s7     # | resultado obtido a partir do c�lculo do n�mero da s�rie
	andi $a0,$a0,0x000F  # | de Fibonacci. A impress�o � feita em hexadecimal e, por isso,
	slti $t0,$a0,10      # | o valor gravado no registrador � separado em grupos de 4 bits, 
	bne $t0,$zero,pula   # | realizando a impress�o do s�mbolo correspondente ao valor de  
	addi $a0,$a0,7       # | cada grupo. 
pula: addi $a0,$a0,0x30    # |
	jal putc             # |
	addi $s7,$s7,-4      # |
	slt $t0,$s7,$zero    # |
	beq $t0,$zero,loop2  # |
	addi $a0,$zero,0x0A  # |
	jal putc             # \
	j mloop

putc: lui $a1,0xffff	   # / O procedimento putc simplesmente imprime um caracter ASCII
	sw $a0,0x0C($a1)   # | no dispositivo de sa�da (display) usando a MMIO. O procedimento,
wait: lw $a0,8($a1)      # | al�m de realizar a impress�o gravando o c�digo ASCCII na posi��o
	beq $a0,$zero,wait # | de mem�ria apropriada, tamb�m testa o bit que indica que o caractere
	jr $ra             # \ foi efetivamente impresso no display.
	

