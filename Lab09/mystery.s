
	.text

main:
	li $a0, 0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, 196
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -1
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	li $a0, -452
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall
	
	#li $a0, 2	#loads 2 into $a0
	li $a0, 7
	jal mystery	#jumps to mystery
	move $a0, $v0	#load the result of mystery into $a0 and call putdec
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li $a0, 3
	jal mystery
	move $a0, $v0
	jal putDec
	li $a0, '\n'
	li $v0, 11
	syscall

	li 	$v0, 10		# terminate program
	syscall

putDec: 	#a0 contains the argument to be printed
		li 	$s7, 10
		bne 	$a0, $0, checker
		zero:			#checking for if we have a 0 as the argument
			li $a0, '0'
			li $v0, 11
			syscall		#print it out
			jr $ra		#return back to who called us
		checker:
			slt	$t0, $a0, $0
			beq 	$t0, $0, loop
			
		negative: 
			move $t0, $a0
			li 	$a0, '-'
			li 	$v0, 11
			syscall		#print out the negative sign
			move $a0, $t0
			sub 	$a0, $0, $a0
		loopn:
		beq 	$a0, $0, done
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)
				
		remu 	$t7, $a0, $s7
		divu 	$a0, $a0, $s7
		addi 	$t7, $t7, 48	#t7 should hold 5
		sb	$t7, 4($sp)
		jal loopn
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		move 	$a0, $t7
		li	$v0, 11
		syscall
		addi 	$sp, $sp, 8
		jr $ra
	
		done:	
		jr	$ra		# returnv	
												
			
		loop:
		beq 	$a0, $0, done
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)
				
		remu 	$t7, $a0, $s7
		divu 	$a0, $a0, $s7
		addi 	$t7, $t7, 48	#t7 should hold 5
		sb	$t7, 4($sp)
		jal loop
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		move 	$a0, $t7
		li	$v0, 11
		syscall
		addi 	$sp, $sp, 8
		jr $ra
	
		jr	$ra		# returnv
		
		

mystery: bne $0, $a0, recur 	# 
 	li $v0, 0 		#
 	jr $ra 			#
 recur: sub $sp, $sp, 8 	#
 	sw $ra, 4($sp) 	#
 	sub $a0, $a0, 1 	#
 	jal mystery 		#
 	sw $v0, 0($sp) 	#
 	jal mystery 		#
 	
 	lw $t0, 0($sp) 	#
 	addu $v0, $v0, $t0 	#
 	addu $v0, $v0, 1 	#
 	add $a0, $a0, 1 	#
 	lw $ra, 4($sp) 	#
 	add $sp, $sp, 8 	#
 	jr $ra 			#
