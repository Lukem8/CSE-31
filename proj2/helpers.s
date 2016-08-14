
# ////////////////////	In this file, im going to implement all of the in between helper functions, before we jump to signed ////////////////

sprintf:	#we are going to have to add characters to a0, character by character from a1, once we run into a formatting option we will handle it accordingly.

	addi 	$sp, $sp, -16
	sw 	$ra, 0($sp)

	add 	$s0, $s0, $0	#$s0 will hold our count of the characters in the buffer
	li 	$s1, '%'
	li 	$s4, 0
	
	move	$s2, $a0 	#s2 will be the register to input characters into
	move 	$s3, $a1	#s3 will hold our current character
	add 	$s6, $0, $0	#s6 will be our argument counter
whileloop:	
	lb 	$t0, 0($s3)		#get the next character from the string
	beq 	$t0, $0, end		#if the character is the NULL Character 0, then were done
	beq 	$t0, $s1, check		#checking for %'s, if we find one, check the next char, and that decides the format of the correct char.
	sb 	$t0, 0($s2)		#store the current char in our buffer
	addi 	$s0, $s0, 1		#add 1 to our total character count
	addi 	$s2, $s2, 1		#increment our buffer, and our copying string
	addi 	$s3, $s3, 1
	j 	whileloop		#repeat the loop


	check:  
	addi 	$s6, $s6, 1		#add one to our argument counter
	addi 	$s0, $s0, 1		#add one to total character counter
	addi 	$s3, $s3, 1		#move to the next char, to check what kind of format is needed
	lb 	$t0, 0($s3)
	beq 	$t0, 117, unsigned	#u 	FINISHED
	beq	$t0, 120, hex		#x 	FINISHED
	beq 	$t0, 111, octal		#o	FINISHED
	beq 	$t0, 115, string	#s	Majok will do
	beq 	$t0, 100, toSigned	#dq	FINISHED
	beq 	$t0, 46, period		#.	Almost finished, just need to fixed signed function
	beq 	$t0, 45, hyphen 	#-	Almost finished, just need to fixed signed function
	beq	$t0, 43, positive	#+	^
	ble	$t0, 57, num		#(0-9)	^		#if its less than or equal to 9
	
	# ///////// NOW WITH ALL OF THESE HELPER FUNCTIONS, WE NEED TO MOVE THE STACK POINTER DOWN UNIFORMLY /////////////////////////////// #
	
	
	period:
		addi $sp, $sp, -20
		sw $ra 16($sp)	#ra will always be stored 16 off of stack
		addi $s3, $s3, 1
		sb $t0, 12($sp)
		lb $t0, 0($s3)	#now load the number
		sb $t0, 8($sp) 	#store the number on the stack
		addi $s3, $s3, 1
		lb $t0, 0($s3)	#now load the next value
		beq $t0, 100, toSigned
	
	toSigned:
		jal signed	#signed will need to be fixed to check values on the stack and implemented accordingly
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		
	hyphen:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)	#store the hyphen
		lb $t0, 0($s3)	
		beq $t0, 100, toSigned
		sb $t0, 8($sp)	#if theres a number after the hyphen, then store the number
		addi $s3, $s3, 1	
		j toSigned	#we know nothing can come after that number, so we can jump to toSigned
		
	positive:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)	#store the +
		lb $t0, 0($s3)	
		beq $t0, 100, toSigned
		sb $t0, 8($sp)	#if theres a number after the +, then store the number
		addi $s3, $s3, 1	
		j toSigned	#we know nothing can come after that number, so we can jump to toSigned
		
	num:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)		#store the first number
		lb $t0, 0($s3)
		beq $t0, 100, toSigned	#if we already hit the d, then we can jump
		sb $t0, 8($sp)	#store the next char, it has to be a '.'
		addi $s3, $s3, 1
		lb $t0, 0($s3)	#now load the next char
		sb $t0, 4($sp)
		addi $s3, $s3, 1
		lb $t0, 0($s3)
		beq $t0, 100, toSigned
		
		
			
# 	s6 holds our argument counter, so if its at 1->a2, 2->a3, 3 -> 	52($sp), 4-> 56($sp), 5->60($sp)	
signed:
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, basecase1
	beq $s6, $t6, basecase2
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	move $t6, $sp
	sub $t5, $t6, $s6
	move $s6, $t6
	addi $s6, $s6, 1
	lw $t0, 0($t5)	#t0 should pull the argument off of the stack
	j start
	
	basecase1:
		move $t0, $a2
		j start
	basecase2:
		move $t0, $a3
		j start
		
	start:
	
	lb $t4, 12($sp)		#gets the first value in our "5.5d" string
	beq $t4, 46, atMost
	lb $t5, 8($sp)
	beq $t5, 46, numdnum	#we know the format would have to be "5.5"
	
	numdnum:
		li $t4, 0	#hold our counter
		lb $t0, 12($sp)	#holds the first number
		lb $t1, 4($sp)	#holds the seconds number in the sequence "5.5"
		li $t5, 1	#t5 holds 1 for a true value
		j begin
	
	atMost:
		li $t4, 0	#0 will hold the count for the current iteration
		lb $t5, 8($sp)	#t5 will hold the max number that we can print to
		li $t6, 1	#t6 will hold 1 "true value for '.' "
		j begin
		
	begin:
	li 	$s7, 10	
	bne 	$t0, $0, checker	#as long as the argument is not zero we will do the algorithm, othrwise, put 0 and return
	
		zero:			#checking for if we have a zero as the argument
			li 	$t7, '0'
			sb 	$t7, 0($s2)
			addi 	$s2, $s2, 1
			j done
		checker:
			slt  	$t1, $t0, $0	#t1 = t0 < 0;
			bne 	$t1, $0, negative
			
			
		loop3:
		beq 	$t0, $0, done
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)
				
		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t7, $t7, 48	#t7 should hold 5
		sb	$t7, 4($sp)
		jal loop3
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		#before we store
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1
		addi 	$sp, $sp, 8
		jr $ra
	
		addi 	$s3, $s3, 1
		j whileloop	
			
		negative: 
			li 	$t7, '-'
			sb 	$t7, 0($s2)
			addi 	$s2, $s2, 1
			addi 	$s0, $s0, 1
			sub 	$t0, $0, $t0	#make the number positive
		loopn:
		beq 	$t0, $0, finish
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)
				
		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t7, $t7, 48	#t7 should hold 5
		sb	$t7, 4($sp)
		jal loopn
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		# "before we store we need to check if(t6 != 1) store; else if (t6 == 1) {, if (t4 < t5) store; , else dont store; }
		li 	$s1 1
		beq 	$t6, $s1, max
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish
		max:
		slt 	$t3, $t4, $t5
		bne	$t3, $s1, here
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish
		here:
		addi 	$sp, $sp, 8	#return the sp
		
										
		finish: jr $ra
		
		
		
string:	
	beq $s6, 1, first
	#beq $s6, 2, second
	first:
		
		loop:
			lb 	$t0, 0($a2)
			beq 	$t0, $0, done 	#if a2 is null
			sb 	$t0, 0($s2)
			addi	$s0, $s0, 1 	#increment character counter
			addi 	$a2, $a2, 1
			addi 	$s2, $s2, 1
			j loop
			
		done: 	
			addi $s3, $s3, 1	#move to the next char, the current one is still a formatter
			j whileloop		#jump back to the regular checking
			
			
	#	second:
	#	loop2:
	
	#		lb 	$t0, 0($a3)
	#		beq 	$t0, $0, done 	#if a2 is null
	#		sb 	$t0, 0($s2)
	#		addi	$s0, $s0, 1 	#increment character counter
	#		addi 	$a3, $a3, 1
	#		addi 	$s2, $s2, 1
	#		j loop2
			
		
	
	
	
unsigned:	#we want to copy the  value from a3 over to our buffer s2
	beq $s6, 1, first1
	beq $s6, 2, second1
		first1:
			li 	$s7, 10
			
			remu	$t7, $a2, $s7
			divu 	$a3, $a2, $s7
			addi 	$t7, $t7, 48	#t6 should hold 5
			
			remu	$t6, $a2, $s7
			divu 	$a3, $a2, $s7
			addi 	$t6, $t6, 48	#t6 should hold 5
			
			remu	$t5, $a2, $s7
			divu 	$a3, $a2, $s7
			addi 	$t5, $t5, 48	#t5 should hold 2
			
			sb 	$t5, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			sb 	$t6, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			sb 	$t7, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			
			addi 	$s3, $s3, 1
			j whileloop
	
		second1:
			li 	$s7, 10
			
			remu 	$t7, $a3, $s7
			divu 	$a3, $a3, $s7
			addi 	$t7, $t7, 48	#t7 should hold 5
				
			remu	$t6, $a3, $s7
			divu 	$a3, $a3, $s7
			addi 	$t6, $t6, 48	#t6 should hold 5
			
			remu	$t5, $a3, $s7
			divu 	$a3, $a3, $s7
			addi 	$t5, $t5, 48	#t5 should hold 2
			
			sb 	$t5, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			sb 	$t6, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			sb 	$t7, 0($s2)
			addi 	$s0, $s0, 1	#add one to char counter
			addi 	$s2, $s2, 1
			fin:
			addi 	$s3, $s3, 1
			j whileloop
			
			
	hex:	
	li $s7, 16
	li $t1, 9			#we gotta find out argument on the stack.
	lw $t0, 32($sp)		#t0 holds the argument.
	#now lets start the algorithm
	repeat:
		beq 	$t0, $0, fin		#while were not at 0
		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		ble 	$t7, $t1, normal	#if the remainder is less than or equal to 9, do a normal store
		addi	$t7, $t7, -10
		addi 	$t7, $t7, 97		#else add 'A' to the remainder and store
		sb 	$t7, 0($s2)
		addi 	$s2, $s2, 1
		j repeat
	normal:
		sb 	$t7, 0($s2)
		addi 	$s2, $s2, 1
		j repeat
octal:
	li 	$s7, 8
	
	lw 	$t0, 36($sp)		#t0 holds the argument.
	#now lets start the algorithm
	repeat2:
		
		beq 	$t0, $0, 		#while were not at 0
		
		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t7, $t7, 48		#else add 'A' to the remainder and store
		
		remu 	$t6, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t6, $t6, 48
		
		remu 	$t5, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t5, $t5, 48
		
		sb 	$t5, 0($s2)
		addi 	$s2, $s2, 1
		
		sb 	$t6, 0($s2)
		addi 	$s2, $s2, 1
		
		sb 	$t7, 0($s2)
		addi 	$s2, $s2, 1
		
		addi	$s3, $s3, 1
		j whileloop

	
end:	addi 	$s2, $s2, 1	#move the buffer forward one for our null terminator
	sb 	$s4, 0($s2)
	move	$v0, $s0	#put our char counter into v0
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 16
	jr	$ra		#this sprintf implementation rocks!

