######################################################################
# spf-main.s
# 
# This is the main function that tests the sprintf function

# The "data" segment is a static memory area where we can 
# allocate and initialize memory for our program to use.
# This is separate from the stack or the heap, and the allocation
# cannot be changed once the program starts. The program can
# write data to this area, though.
	.data
	
# Note that the directives in this section will not be 
# translated into machine language. They are instructions 
# to the assembler, linker, and loader to set aside (and 
# initialize) space in the static memory area of the program. 
# The labels work like pointers-- by the time the code is 
# run, they will be replaced with appropriate addresses.

# For this program, we will allocate a buffer to hold the
# result of your sprintf function. The asciiz blocks will
# be initialized with null-terminated ASCII strings.

buffer:	.space	2000			# 2000 bytes of empty space 
					# starting at address 'buffer'
	
format:	.asciiz "string: %5.5s\n%5.5s\n"# null-terminated string of 
					# ascii bytes.  Note that the 
					# \n counts as one byte: a newline 
					# character.
str1:	.asciiz "abcdefg"		# null-terminated string at
					# address 'str1'
str2:   .asciiz "abc" 			# null-terminated string at
                                        # address 'str2'
chrs:	.asciiz " characters:\n"	# null-terminated string at 
					# address 'chrs'

# The "text" of the program is the assembly code that will
# be run. This directive marks the beginning of our program's
# text segment.

	.text
	
# The sprintf procedure (really just a block that starts with the
# label 'sprintf') will be declared later.  This is like a function
# prototype in C.

	.globl sprintf
		
# The special label called "__start" marks the start point
# of execution. Later, the "done" pseudo-instruction will make
# the program terminate properly.	

main:
	addi	$sp,$sp,-20	# reserve stack space

	# $v0 = sprintf(buffer, format, str1, str2)
	
	la	$a0,buffer	# arg 0 <- buffer
	la	$a1,format	# arg 1 <- format
	la	$a2,str1	# arg 2 <- str1
	la 	$a3,str2        # arg 3 <- str2	
	
	sw	$ra,16($sp)	# save return address
	jal	sprintf		# $v0 = sprintf(...)

	# print the return value from sprintf using
	# putint()

	add	$a0,$v0,$0	# $a0 <- $v0
	jal	putint		# putint($a0)

	## output the string 'chrs' then 'buffer' (which
	## holds the output of sprintf)

 	li 	$v0, 4	
	la     	$a0, chrs
	syscall
	#puts	chrs		# output string chrs
	
	li	$v0, 4
	la	$a0, buffer
	syscall
	#puts	buffer		# output string buffer
	
	addi	$sp,$sp,20	# restore stack
	li 	$v0, 10		# terminate program
	syscall

# putint writes the number in $a0 to the console
# in decimal. It uses the special command
# putc to do the output.
	
# Note that putint, which is recursive, uses an abbreviated
# stack. putint was written very carefully to make sure it
# did not disturb the stack of any other functions. Fortunately,
# putint only calls itself and putc, so it is easy to prove
# that the optimization is safe. Still, we do not recommend 
# taking shortcuts like the ones used here.

# HINT:	You should read and understand the body of putint,
# because you will be doing some similar conversions
# in your own code.
	
putint:	addi	$sp,$sp,-8	# get 2 words of stack
	sw	$ra,0($sp)	# store return address
	
	# The number is printed as follows:
	# It is successively divided by the base (10) and the 
	# reminders are printed in the reverse order they were found
	# using recursion.

	remu	$t0,$a0,10	# $t0 <- $a0 % 10
	addi	$t0,$t0,'0'	# $t0 += '0' ($t0 is now a digit character)
	divu	$a0,$a0,10	# $a0 /= 10
	beqz	$a0,onedig	# if( $a0 != 0 ) { 
	sw	$t0,4($sp)	#   save $t0 on our stack
	jal	putint		#   putint() (putint will deliberately use and modify $a0)
	lw	$t0,4($sp)	#   restore $t0
	                        # } 
onedig:	move	$a0, $t0
	li 	$v0, 11
	syscall			# putc #$t0
	#putc	$t0		# output the digit character $t0
	lw	$ra,0($sp)	# restore return address
	addi	$sp,$sp, 8	# restore stack
	jr	$ra		# return




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
	#addi 	$s0, $s0, 1		#add one to total character counter
	addi 	$s3, $s3, 1		#move to the next char, to check what kind of format is needed
	lb 	$t0, 0($s3)
	beq 	$t0, 117, toUnsigned	#u 	FINISHED
	beq	$t0, 120, toHex		#x 	FINISHED
	beq 	$t0, 111, tooctal		#o	FINISHED
	beq 	$t0, 115, tostring	#s	Majok will do
	beq 	$t0, 100, toS		#dq	FINISHED
	beq 	$t0, 46, period		#.	Almost finished, just need to fixed signed function
	beq 	$t0, 45, hyphen 	#-	Almost finished, just need to fixed signed function
	beq	$t0, 43, positive	#+	^
	ble	$t0, 57, num		#(0-9)	^		#if its less than or equal to 9
	
	# ///////// NOW WITH ALL OF THESE HELPER FUNCTIONS, WE NEED TO MOVE THE STACK POINTER DOWN UNIFORMLY /////////////////////////////// #
	tostring:
		addi $sp, $sp, -20
		sw $ra 16($sp)
		jal string
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
	tooctal:
		addi $sp, $sp, -20
		sw $ra 16($sp)
		jal octal
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
	toHex:
		addi $sp, $sp, -20
		sw $ra 16($sp)
		jal hex
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
	toUnsigned:
		addi $sp, $sp, -20
		sw $ra 16($sp)
		jal unsigned
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
	period:
		addi $sp, $sp, -20
		sw $ra 16($sp)	#ra will always be stored 16 off of stack
		addi $s3, $s3, 1
		sb $t0, 12($sp)	#stores period
		lb $t0, 0($s3)	#now load the number
		sb $t0, 8($sp) 	#store the number on the stack
		addi $s3, $s3, 1
		lb $t0, 0($s3)	#now load the next value
		beq $t0, 100, jdec
		jal string
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		jdec:	
		jal signed
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		jstr:	
		jal string
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		
	toS:
		addi $sp, $sp, -20
		sw $ra 16($sp)
		jal signed
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
	
	hyphen:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)	#store the hyphen
		lb $t0, 0($s3)	
		beq $t0, 100, toS
		sb $t0, 8($sp)	#if theres a number after the hyphen, then store the number
		addi $s3, $s3, 1	
		jal string
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		
		
	positive:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)	#store the +
		lb $t0, 0($s3)	
		beq $t0, 100, toS
		sb $t0, 8($sp)	#if theres a number after the +, then store the number
		addi $s3, $s3, 1	
		jal string
		lw $ra 16($sp)
		addi $sp, $sp, 20
		j done
		
	num:
		addi $sp, $sp, -20
		sw $ra, 16($sp)
		addi $s3, $s3, 1
		sb $t0, 12($sp)		#store the first number
		lb $t0, 0($s3)	
		beq $t0, 100, jdec	#if we already hit the d, then we can jump
		beq $t0, 115, jstr
		sb $t0, 8($sp)	#store the next char, it has to be a '.'
		addi $s3, $s3, 1
		lb $t0, 0($s3)	#now load the next char
		sb $t0, 4($sp)	#has to be a number
		addi $s3, $s3, 1
		lb $t0, 0($s3)
		beq $t0, 100, jdec
		beq $t0, 115, jstr
		
		
			
# 	s6 holds our argument counter, so if its at 1->a2, 2->a3, 3 -> 	52($sp), 4-> 56($sp), 5->60($sp)	
signed:
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, basecase1	#if we only have one argument in our counter
	beq $s6, $t6, basecase2	#if we only have two arguments in our counter
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	move $t6, $sp
	add $t5, $sp, $s6
	move $s6, $t6
	#addi $s6, $s6, 1
	lw $t0, 0($t5)
	j begin 
	
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
			jr $ra
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
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, bc	#if we only have one argument in our counter
	beq $s6, $t6, bc2	#if we only have two arguments in our counter
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	move $t6, $sp
	add $t5, $sp, $s6
	move $s6, $t6
	lw $t1, 0($t5)
	
	lb $t2, 8($sp)	#look at the char
	lb $t3, 12($sp)#holds first num
	lb $t4, 4($sp) #holds second num
	li $t5, 0 #will hold the counter to keep track
	beq $t2, 46, numS#if we have a '.' in between two numbers
	j loop 
	
	bc:
		move $t1, $a2
		lb $t2, 8($sp)	#look at the char
		lb $t3, 12($sp)#holds first num
		addi $t3, $t3, -48 #char to num
		lb $t4, 4($sp) #holds second num
		addi $t4, $t4, -48	#to get the number 5
		li $t5, 0 #will hold the counter to keep track
		beq $t2, 46, numS#if we have a '.' in between two numbers
		j loop
	bc2:
		move $t1, $a3
		lb $t2, 8($sp)	#look at the char
		lb $t3, 12($sp)#holds first num
		lb $t4, 4($sp) #holds second num
		li $t5, 0 #will hold the counter to keep track
		beq $t2, 46, numS#if we have a '.' in between two numbers
		j loop
				#so, if 8($sp) is a '.' then we know were gonna have to print between 12($sp) and 4($sp)
	
		loop:
			lb 	$t0, 0($t1)
			beq 	$t0, $0, rt 	#if a2 is null
			addi 	$sp, $sp, -8
			sw	$ra, 0($sp)
			sb 	$t0, 0($s2)
			addi 	$s2, $s2, 1
			addi 	$t1, $t1, 1
			jal loop
			lw	$ra, 0($sp)
			addi	$s0, $s0, 1 	#increment character counter
			addi 	$sp, $sp, 8
			j rt
			
		rt: jr $ra
		
		#this will be the implementation for the "5.5" format
		#print between $t3 and $t4 number of characters, $t5 holds our current counter
		bgn:	move $s1, $t0
			li $s2, 0
			#this needs to be a loop to get the length of the current string, if its less than the first char, then we needto print out spaces
			rr: beq $s1, $0, size 	#if a2 is null
			    addi $s5, $s5, 1
			    addi $s1, $s1, 1
			size:	#s2 will hold the size of the string, if its less than the first number, lets insert some ' '
			   	slt $s1, $s5, $t3	#t3 is the first num
			   	beq $s1, $0, numS
			   	li $s5, ' '
			   	sb $s5, 0($s2)
			   	addi $s2,$s2 , 1
			   	j size
		numS:   li $t7, 5
			lb 	$t0, 0($t1)
			beq 	$t0, $0, rt2 	#if a2 is null
			addi 	$sp, $sp, -8
			sw	$ra, 0($sp)
			beq 	$t5, $t4, rt2
			slt	$t7, $t5, $t3 	#checks the first num of the 5.5 must be a 1
			beq 	$t7, $0, rt2
			sb 	$t0, 0($s2)
			addi	$s0, $s0, 1 	#increment character counter
			addi	$t5, $t5, 1 #add 1 to current iteration
			addi 	$s2, $s2, 1
			addi 	$t1, $t1, 1
			jal numS
			lw	$ra, 0($sp)
			addi 	$sp, $sp, 8
			j rt2
			bb:
			addi	$t5, $t5, 1 #add 1 to current iteration
			jal numS
			lw	$ra, 0($sp)
			
			addi 	$sp, $sp, 8
			j rt2
		rt2: jr $ra
		
			
		done: 	
			addi $s3, $s3, 1	#move to the next char, the current one is still a formatter
			j whileloop		#jump back to the regular checking
	
	
unsigned:	
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, basecase11	#if we only have one argument in our counter
	beq $s6, $t6, basecase22	#if we only have two arguments in our counter
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	move $t6, $sp
	add $t5, $sp, $s6
	move $s6, $t6
	lw $t0, 0($t5)
	j begin2 
	
	basecase11:
		move $t0, $a2
		j begin2
	basecase22:
		move $t0, $a3
		j begin2
			
			
	begin2:
	
	li 	$s7, 10	
	bne 	$t0, $0, loop4	#as long as the argument is not zero we will do the algorithm, othrwise, put 0 and return
	
		
	li 	$t7, '0'
	sb 	$t7, 0($s2)
	addi 	$s2, $s2, 1
	jr $ra
		loop4:
		beq 	$t0, $0, finish2
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)
				
		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		addi 	$t7, $t7, 48	#t7 should hold 5
		sb	$t7, 4($sp)
		jal loop4
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish2
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish2
		
		addi 	$sp, $sp, 8	#return the sp
		
										
		finish2: jr $ra
		
			
hex:	
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, basecase111	#if we only have one argument in our counter
	beq $s6, $t6, basecase222	#if we only have two arguments in our counter
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	add $t5, $sp, $s6
	move $s6, $t6
	lw $t0, 0($t5)
	j begin3
	
	basecase111:
		move $t0, $a2
		j begin3
	basecase222:
		move $t0, $a3
		j begin3
			
			
	begin3:
	li 	$t1, 9
	li 	$s7, 16	
	bne 	$t0, $0, loop5	#as long as the argument is not zero we will do the algorithm, othrwise, put 0 and return
		
	li 	$t7, '0'
	sb 	$t7, 0($s2)
	addi 	$s2, $s2, 1
	jr $ra
		loop5:
		beq 	$t0, $0, finish3
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)

		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		ble  	$t7, $t1, normal	#if the remainder is less than or equal to 9, do a normal store
		addi	$t7, $t7, -10
		addi 	$t7, $t7, 97		#else add 'a' to the remainder and store
		sb 	$t7, 4($sp)
		jal loop5
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish3
	normal:
		sb 	$t7, 4($sp)
		jal loop5
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish3
			
	finish3: jr $ra

octal:
	li $t5, 1
	li $t6, 2
	beq $s6, $t5, basecase1111	#if we only have one argument in our counter
	beq $s6, $t6, basecase2222	#if we only have two arguments in our counter
	move $t6, $s6	#save our arg counter, cuz were gonna change it
	addi $s6, $s6, -3	#sub 3 from argc
	sll $s6, $s6, 2	#multiply argc by 4
	addi $s6, $s6, 52	#offset
	add $t5, $sp, $s6
	move $s6, $t6
	lw $t0, 0($t5)
	j begin4
	
	basecase1111:
		move $t0, $a2
		addi $s6, $s6, 1
		j begin4
	basecase2222:
		move $t0, $a3
		addi $s6, $s6, 1
		j begin4
			
			
	begin4:
	
	li 	$s7, 8	
	bne 	$t0, $0, loop6	#as long as the argument is not zero we will do the algorithm, othrwise, put 0 and return
		
	li 	$t7, '0'
	sb 	$t7, 0($s2)
	addi 	$s2, $s2, 1
	jr $ra
		loop6:
		beq 	$t0, $0, finish4
		addi 	$sp, $sp, -8
		sw	$ra, 0($sp)

		remu 	$t7, $t0, $s7
		divu 	$t0, $t0, $s7
		addi	$t7, $t7, 48
		sb 	$t7, 4($sp)
		jal loop6
		lw 	$ra, 0($sp)
		lb	$t7, 4($sp)
		sb 	$t7, 0($s2)
		addi 	$t4, $t4, 1 	#add 1 for the argument counter
		addi 	$s2, $s2, 1	#move our buffer forward
		addi 	$s0, $s0, 1	#add one to character counter
		addi 	$sp, $sp, 8
		j finish4
	
			
	finish4: jr $ra

end:	addi 	$s2, $s2, 1	#move the buffer forward one for our null terminator
	sb 	$s4, 0($s2)
	move	$v0, $s0	#put our char counter into v0
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 16
	jr	$ra		#this sprintf implementation rocks!
