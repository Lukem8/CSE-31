
main:	add $t0, $s0, $zero
	add $t1, $s1, $zero
	add $t2, $t1, $t0
	add $t3, $t2, $t1
	add $t4, $t3, $t2
	add $t5, $t4, $t3
	add $t6, $t5, $t4
	add $t7, $t6, $t5
	addi    $a0, $t7, 0	#put the final value into $a0 to be printed
	li      $v0, 1		#put 1 into $v0 which will print $a0 in the syscall
	syscall			#prints the value in $a0 with this syscall
	li      $v0, 10		#put 10 into $v0 to terminate execution
	syscall			#exits and returns control back to os