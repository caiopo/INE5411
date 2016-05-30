# Exception Handler
# Interrupt: Excode = 0
# Overflow: ExCode = 12
# Status  $12
# Cause   $13
# EPC     $14

.kdata 0x90000000
# Espa�o para salvamento de contexto:
save: .word 0,0,0,0

# Espa�o para salvamento do valor que est� sendo digitado:
_temp: .word 0


.ktext 0x80000180	# Reloca o tratador para residir no endere�o emitido pelo HW
# Etapa 1: Salvamento de contexto em mem�ria (pilha n�o pode ser usada)
lui $k0,0x9000
sw $ra,0($k0)
sw $at,4($k0)
sw $t0,8($k0)
sw $t1,12($k0)

# Etapa 2: Decodifica��o do registrador Cause
# Completar: Isole o ExcCode do registrador Cause para identificar a exce��o (armazenar em $k0) ---
mfc0 $k0, $13
srl $k0, $k0, 2
andi $k0, $k0 0x1F

# -------------------------------------------------------------------------------------------------

# Etapa 3: Leitura de caracteres em caso de interrup��o
# Completar: Se o c�digo for o de uma interrup��o, chame o precedimento "lechar" e pule ----
#            para "done". Sen�o, pule para "_continua". ------------------------------------
bnez $k0, _continua
jal lechar
j done

# ------------------------------------------------------------------------------------------

# Etapa 4: Tratamento de overflow, se for o caso
# Completar: Se o c�digo for de overflow, o tratador deve, ao final de sua execu��o, -------
#            reiniciar o programa. Fa�o o teste apropriado e mude o registrador necess�rio -
#            para que o programa seja reiniciado apenas ao final do tratamento da exce��o.--
_continua:
addi $t1, $zero, 12
bne $k0, $t1, done

#li $k0,0x49
#lui $k1,0xffff
#sw $k0,12($k1)   # - Imprime algo no display

la $t0, main
mtc0 $t0, $14

# ------------------------------------------------------------------------------------------

# Etapa 5: Preparacao do sistema para novas excecoes
# Completar: Limpe o registrador Cause e habilite novas exce��es no registrador Status -----
done:
mtc0 $zero, $13
mfc0 $k1, $12
ori $k1, $k1, 1
mtc0 $k1, $12

# ------------------------------------------------------------------------------------------

# Etapa 6: Restauracao de contexto
lui $k0,0x9000
lw $ra,0($k0)
lw $at,4($k0)
lw $t0,8($k0)
lw $t1,12($k0)
  
# Etapa 7: Retorno ao fluxo normal de execucao
eret              # retorna para o endere�o indicado em EPC


# Fun��o para leitura do caractere
lechar:	lui $k0,0xffff
	lw $k0,4($k0)	 # - L� o valor digitado no teclado da mem�ria
	li $k1,0x0A      
	bne $k0,$k1,cont1 
	la $t0,_temp     # - Se o valor for ENTER (ASCII 0xA), grava o valor previamente 
	lw $k1,0($t0)    #   digitado na posi��o "argumento" de mem�ria. 
	sw $zero,0($t0)
	la $t0,argumento
	sw $k1,0($t0)
	j fim1
cont1:	addi $k0,$k0,-0x30  # Subtrai 0x30, convertendo ASCII para inteiro
	# Marca 1
	sltiu $k1,$k0,10    
	beq $k1,$zero,erro1		
	la $k1,_temp    # - Se o valor for num�rico (de 0 a 9), l� o valor armazenado em
	lw $t0,0($k1)   #   "_temp", multiplica por 10, e soma ao valor digitado.
	li $t1,10       #   Isso � feito para "construir" o n�mero a partir dos valores digitados.
	mul $t0,$t0,$t1	
	add $t0,$t0,$k0
	sw $t0,0($k1)
	# Marca 2
	addi $k0,$k0,0x30
	j fim1
erro1:  la $k1,_temp     # - Em caso de erro (digita��o de letras por exemplo) prepara "e" 
	sw $zero,0($k1)  #   para ser impresso no display.
	li $k0,0x65
fim1:	lui $k1,0xffff   
	sw $k0,12($k1)   # - Imprime algo no display e retorna
	jr $ra
