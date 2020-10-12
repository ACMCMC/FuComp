#ENUNCIADO
#Write a program, using the MIPS32 assembly language that reads a number N and prints the following:
#1
#1 2
#1 2 3 ...
#1 2 3 ... N-1 N

.data

.text
.globl main
main:
	#t0 = contador
	#t1 = N

	addi $v0, $zero, 5 #leemos un entero
	syscall
	add $t1, $zero, $v0 #lo guardamos en t1
	addi $t1, $t1, 1 #N++
	
	addi $sp, $sp, -2 #hacemos espacio para guardar nuestro contador y N en la pila (cada uno es 1 byte)
	
	inicio_for:
		addi $t0, $zero, 1 #contador = 1
	condicion_for:
		bne $t0, $t1, cuerpo_for #si t0 != t1 hacemos el bucle
			j fin_for #si se cumple salimos del bucle
	incremento_for:
		addi $t0, $t0, 1 #t0++
		j condicion_for
	cuerpo_for:
		sb $t0, 1($sp) #guardamos registros
		sb $t1, 0($sp)
		add $a0, $zero, $t0
		jal subrutina_imprimir_linea
		lb $t0, 1($sp) #restauramos registros
		lb $t1, 0($sp)
		
		add $a0, $zero, $v0 #a0 = resultado de la subrutina
		j incremento_for
	fin_for:
	addi $v0, $zero, 10
	syscall

subrutina_imprimir_linea: #(a0 = num_max)
	add $t2, $zero, $sp #guardamos sp
	addi $sp, $sp, -2 #hacemos espacio para nuestro '\0' y nuestro fin de linea
	sb $zero, 1($sp) #acabamos la cadena con un '\0'
	addi $t1, $zero, '\n' #caracter de nueva linea
	sb $t1, 0($sp)
	
	addi $t3, $zero, 10 #t3 = 10 (para hacer la division)
	
	#t0 = i
	
	inicializar_for_subrut:
		addi $t0, $a0, 0 #i = num_max
	condicion_for_subrut: #(i!=0)
		bne $t0, $zero, cuerpo_for_subrut
			j fin_for_subrut
	incremento_for_subrut:
		addi $t0, $t0, -1 #i--
		j condicion_for_subrut
	cuerpo_for_subrut:
		div $t0, $t3 #t0/10
		mfhi $t1
		addi $t1, $t1, '0' #t1 = i+'0'
		addi $sp, $sp, -1 #sp--
		sb $t1, 0($sp) #lo guardamos en sp
		mflo $t4 #t4 = cociente
		beq $t4, $zero, incremento_for_subrut #se acaba el cuerpo si no hay cociente
		
		loop_terminos_b10:
		add $t5, $zero, $sp #guardamos sp en t5
		div $t4, $t3 #t4/10
		mflo $t4 #t4 = cociente
		mfhi $t1 #t1 = resto
		addi $t1, $t1, '0' #t1 = i+'0'
		addi $sp, $sp, -1 #sp--
		sb $t1, 0($sp) #lo guardamos en sp
		bne $t4, $zero, loop_terminos_b10 #repetimos esto mientras aun haya cociente
		#ahora tenemos que darle la vuelta a las cosas del stack
		#add $t6, $zero, $sp #t6 = sp
		#dar_vuelta_stack:
		#	lb $t8, 0($t5) #les damos la vuelta a los elementos
		#	lb $t9, 0($t6)
		#	sb $t9, 0($t5)
		#	sb $t8, 0($t6)
		#	addi $t6, $t6, 1 #acercamos ambos elementos
		#	addi $t5, $t5, -1
		#	sle $t7, $t5, $t6 #t7 = (t5 <= t6)
		#	beq $t7, $zero, dar_vuelta_stack
		j incremento_for_subrut
	fin_for_subrut:
	add $a0, $zero, $sp #a0 = sp
	addi $v0, $zero, 4 #print_string
	syscall
	
	add $sp, $zero, $t2 #restauramos sp
	
	jr $ra #volvemos al inicio
