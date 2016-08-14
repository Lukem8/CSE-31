main:	add $t5, $t0, $t0
	lui	$a0,0x8000
	jal	first1pos
	jal	printv0
	lui	$a0,0x0001
	jal	first1pos
	jal	printv0
	li	$a0,1
	jal	first1pos
	jal	printv0
	add	$a0,$0,$0
	jal	first1pos
	jal	printv0
	li	$v0,10
	syscall

first1pos:	lui	$t0,0x8000
		add $t1, $0, $0
		or $t0, $t0, $t1 #t0 holds our mask
	LOOP:		
		and $t2, $a0, $t0
		bne $t2, $0, END
		addi $t5, $t5, 1
		add $t6, $0, 31
		beq $t6, $t5, END	#check if weve moved over 31 bits, if so go return.
		srl $t0, $t0, 1
		slti $t4, $t5, 32	#checks if t5 (our counter is greater than or equal to 32)
		beq $t4, $0, RZERO	#if it is return -1
		j LOOP
		
END: addi $t0, $0, 31
     sub $v0, $t0, $t5
     jr $ra
RZERO: addi $v0, $0, -1	#returns -1 if we had a zero
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
