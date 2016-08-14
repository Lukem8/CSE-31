	.text
main:
	la	$a0,n1
	la	$a1,n2
	jal	swap
	li	$v0,1	# print n1 and n2; should be 27 and 14
	lw	$a0,n1
	syscall
	li	$v0,11
	li	$a0,' '
	syscall
	li	$v0,1
	lw	$a0,n2
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	li	$v0,10	# exit
	syscall

swap:	addi $sp, $sp, -4 #adjust the stack pointer
	sw $ra, 0($sp)		#put return address on the stack
	la $t3, temp
	
	lw $t0, 0($a0) #save the value 14 into t0
	sw $t0, 0($t3) #&t3 has 14
	lw $t1, 0($a1) #save the value 27 into t1
	#sw $t0, 0($a1)
	sw $t1, 0($a0)
	lw $t4, 0($t3) #14 into t4
	sw $t4, 0($a1) #14 into
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	

	.data
n1:	.word	14
n2:	.word	27
temp:	.word	