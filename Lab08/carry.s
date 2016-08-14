


	addi $t3, $0, 0xffffffff
	addi $t4, $0, 1
	addu $t2, $t3, $t4
	slti $t2, $t2, 1 #will be a 1 if its a 0, will be a 0 if its a 1