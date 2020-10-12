.data
a: .word 10, 10, 10, 10, 6, 5, 10, 10, 7, 8, 9

.text
.globl main
main:
	addi $s1, $zero, 10
	addi $s0, $zero, 0
	la $s5, a
	cond_while:
		sll $t0, $s0, 2 #t0 = 4*i
		add $t0, $t0, $s5
		lw $t1, 0($t0)
		beq $t1, $s1, while
		j fin_while
	while:
		addi $s0, $s0, 1
		j cond_while
	fin_while:
	addi $v0, $zero, 10
	syscall
