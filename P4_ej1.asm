.data
array: .word 1, 2, 3, 4, 5, 6
count: .word 6

.text
.globl main
main:
	jal suma
	
	add $a0, $zero, $v0 #a0 = v0
	
	addi $v0, $zero, 1 #Ponemos v0 en modo print_int
	syscall
	
	addi $v0, $zero, 10
	syscall
	
suma:
	#el ejercicio declara las variables contador, i, acum (todas son ints)
	#int contador = t0
	#int i = t1
	#int acum = t2
	
	la $t0, count #contador = count
	lw $t0, 0($t0)
	
	add $t1, $zero, $zero #i = 0
	
	add $t2, $zero, $zero #acum = 0
	
	cond_while_suma:
		beq $t0, $zero, return_suma
		j while_suma

	while_suma:
		#necesitamos un elemento temporal para guardar i, va a ser t3. Tambien podriamos incrementar el puntero, pero en esta practica vamos a hacerlo usando i
		addi $t4, $zero, 4 #t4 = 4
		mult $t1, $t4 #multiplicamos i*4 y lo guardamos en t4
		mflo $t4 #guardamos el resultado en t4
		la $t3, array #t3 = &array
		add $t3, $t3, $t4 #t3 = &array + i*sizeof(int)
		lw $t3, 0($t3) #t3 = array[i]
		add $t2, $t2, $t3 #acum += array[i]
		addi $t1, $t1, 1 #i++
		addi $t0, $t0, -1 #contador--
		j cond_while_suma

	return_suma:
	add $v0, $zero, $t2
	jr $ra
