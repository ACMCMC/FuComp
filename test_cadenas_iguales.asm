.data
a: .space 100
b: .asciiz "Texto de prueba\n"
texto_iguales: .asciiz "Cadenas iguales"
diferentes: .asciiz "Cadenas diferentes"

.text
.globl main



	#ESTE PROGRAMA ESTA HECHO PARA EXPERIMENTAR CON LAS PILAS. NO USA EL MODO ESTANDAR DE PASO DE ARGUMENTOS DEL MIPS.



main:
	#vamos a leer una cadena
	la $a0, a #a0 tiene que ser la direccion donde empieza nuestra cadena
	addi $a1, $zero, 100 #a0 puede albergar hasta 100 bytes
	addi $v0, $zero, 8 #codigo de llamada al sistema para leer una cadena
	syscall #llamamos al sistema
	
	addi $sp, $sp, -12 #bajamos el puntero sp en 12 unidades (hacemos 3 huecos)
	la $a0, a #cargamos la direccion de a
	sw $a0, 8($sp) #la guardamos en sp (es nuestro argumento)
	la $a0, b #cargamos la direccion de b
	sw $a0, 4($sp) #la guardamos en sp (es nuestro argumento)
	
	jal test_equal
	lw $a0, 0($sp) #a0 = test_equal
	addi $sp, $sp, 12 #restauramos sp
	
	addi $v0, $zero, 4 #ponemos v0 en modo print_string
	
	beq $a0, $zero, no_iguales
		#a0 == 1
		la $a0, texto_iguales
		j end_if
	no_iguales:
		la $a0, diferentes
	
	end_if:
	syscall
	
	addi $v0, $zero, 10
	syscall
	
test_equal:
	lw $a0, 8($sp) #puntero al inicio de la palabra a
	lw $a1, 4($sp) #puntero al inicio de la palabra b
	#addi $a2, $zero, 0
	#addi $a3, $zero, 0
	j do_while #iniciamos el bucle do...while
	
	condicion_do_while:
		beq $a2, $zero, car_nulo #si encontramos un caracter nulo, vamos hacemos el if
		beq $a3, $zero, car_nulo
		j do_while #hacemos el bucle
		car_nulo: #se ha encontrado un caracter de fin de cadena
			addi $v0, $zero, 1 #ponemos un verdadero en v0
			j return
	
	do_while:
		lb $a2, 0($a0) #cargamos desde memoria el par de bytes
		lb $a3, 0($a1)
		beq $a2, $a3, iguales #si encontramos un caracter igual, saltamos el codigo del if (no iguales)
			addi $v0, $zero, 0 #ponemos el valor falso en v0
			j return
		iguales:
		addi $a0, $a0, 1 #incrementamos en 1 byte los punteros
		addi $a1, $a1, 1
		j condicion_do_while
	
	return:
	sw $v0, 0($sp) #guardamos v0 como retorno
	jr $ra #volvemos al inicio
