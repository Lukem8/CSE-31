main:	add $t5, $t0, $t0
	lui	$a0,0x8000 #should be 31
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001	#should be 16
	jal	first1pos
	jal	printv0
	li	$a0,1	#should be 0
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0	#should be -1
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall
	
first1pos:	# your code goes here
	slt $t0, $a0, $0	#if a0 is negative, jump to the end
	bne $t0, $0, END
	sll $a0, $a0, 1		#shift it left once
	addi $t5, $t5, 1	#add one to our counter
	add $t6, $0, 31
	beq $t6, $t5, END	#check if weve moved over 31 bits, if so go return.
	
	#addi $t3, $0, 32	#put 32 into t3
	#sub $t3 $t3, $t5	#subtracts t3 from our counter t5
	slti $t4, $t5, 32	#checks if t5 (our counter is greater than or equal to 32)
	beq $t4, $0, RZERO	#if it is return -1
	j first1pos	
END: addi $t0, $0, 31
     sub $v0, $t0, $t5
     jr $ra
RZERO: addi $v0, $0, -1
	jr $ra

printv0:
	addi	$sp,$sp,-4
	sw	$ra,0($sp)
	add	$a0,$v0,$0
	li	$v0,1
	syscall
	li	$v0,11
	li	$a0,'\n'
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra
