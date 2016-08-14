.data
	# This shows you can use a .word and directly encode the value in hex
	# if you so choose
num1:	.word 0x58800000 	#first value
num2:	.float 1.0		#second value
num3: 	.word 0xd8800000	#third value to be summed
result:	.word 0
string: .asciiz "\n"

	.text
main:
	la $t0, num1
	lwc1 $f2, 0($t0)
	lwc1 $f4, 4($t0)
	la $t1, num3
	lwc1 $f5, 0($t1)
	# Print out the values of the summands

	li $v0, 2
	mov.s $f12, $f2	#print the first value to be added
	syscall

	li $v0, 4
	la $a0, string	#print a new line
	syscall

	li $v0, 2
	mov.s $f12, $f4	#print the next value to be added
	syscall
	
	li $v0, 4
	la $a0, string	#new line
	syscall
	
	li $v0, 2
	mov.s $f12, $f5	#print the last value to be added
	syscall

	li $v0, 4
	la $a0, string	#print some new lines
	syscall
	li $v0, 4
	la $a0, string
	syscall

	# Do the actual addition

	add.s $f12, $f2, $f5	#first we will add $f5 to $f2
	add.s $f12, $f12, $f4	#then we will add $f4 to that result.
	
	li $v0, 2	#now lets print the first sum
	syscall
	li $v0, 4
	la $a0, string  #prints a new line
	syscall

	#now lets sum them up the other way
	add.s $f12, $f2, $f4
	add.s $f12, $f12, $f5
	
	

	li $v0, 2
	syscall #print out the other sum and we see that it is different than the first sum
	li $v0, 4
	la $a0, string	#newline
	syscall