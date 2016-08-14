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
	sb 	$t0, 0($s2)		#store the current char in a0
	addi 	$s0, $s0, 1		#add 1 to our total character count
	addi 	$s2, $s2, 1
	addi 	$s3, $s3, 1
	j 	whileloop
	
	#the current char is a %
check:  
	addi 	$s6, $s6, 1		#add one to our argument counter
	addi 	$s0, $s0, 1		#add one to total character counter
	addi 	$s3, $s3, 1		#move to the next char, to check what kind of format is needed
	lb 	$t0, 0($s3)
	beq 	$t0, 117, unsigned
	beq	$t0, 120, hex
	beq 	$t0, 111, octal
	beq 	$t0, 115, string
	beq 	$t0, 100, signed
	
	
				##############           TODO   	###############
				#We will need to do number checking, negative checking, and '.' checking in check above^ , or in another methhod once we find one of those characters.
				#I think all we still have to do is fix signed and string function for the other two files. Also signed still not working perfect rn.

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
	
signed:
	lb 	$t0, 40($sp)	#t0 holds the argument
	
	li 	$s7, 10
	or	$t1, $t0, $0	
	#slt 	$t2, $t1, $0	#check if its negative
	#beq 	$t2, $0, skip	#these dont work properly for some reason.
	sub	$t0, $0, $t1
	skip:
			
	remu 	$t7, $t0, $s7
	divu 	$t0, $t0, $s7
	addi 	$t7, $t7, 48	#t7 should hold 5
				
	remu	$t6, $t0, $s7
	divu 	$t0, $t0, $s7
	addi 	$t6, $t6, 48	#t6 should hold 5 
			
	remu	$t5, $t0, $s7
	divu 	$t0, $t0, $s7
	addi 	$t5, $t5, 48	#t5 should hold 2 
	
	li $t0, '-'
	sb $t0, 0($s2)
	addi $s2, $s2 1
			
	sb 	$t5, 0($s2)	#put the 2
	addi 	$s0, $s0, 1	#add one to char counter
	addi 	$s2, $s2, 1
	#addi 	$t6, $t6, -4	#this should be here, but this gives us the correct output wtf
	sb 	$t6, 0($s2)	#putting 9?
	addi 	$s0, $s0, 1	#add one to char counter
	addi 	$s2, $s2, 1
	sb 	$t7, 0($s2)
	addi 	$s0, $s0, 1	#add one to char counter
	addi 	$s2, $s2, 1
	
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
		
		beq 	$t0, $0, fin		#while were not at 0
		
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
	addi 	$s0, $s0, 1	#add one more to character  counter for the null terminator
	move	$v0, $s0
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 16
	jr	$ra		#this sprintf implementation rocks!