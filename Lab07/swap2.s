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
	
	la $t2, temp	#t2 holds address of temp
	lw $t0, 0($a0)	#load 14 into t0
	sw $t0, 0($t2)	#store 14 into the address of temp
	lw $t3, 0($t2)	#load the value 14 into t3
	lw $t1, 0($a1)	#load the value 27 into t1
	sw $t1, 0($a0)
	sw $t3, 0($a1) 
	
	addi $sp, $sp, 4	#adjust stack pointer
	jr $ra		#jump back to where we were called from.
	

	.data
n1:	.word	14
n2:	.word	27
temp:	.word		#create new .word so we can store the address in our swap procedure.
