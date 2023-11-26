#
.data ## Data declaration section
out_string1: .asciiz "\nPlease enter the 1st Number:\n" ## String to be printed
out_string2: .asciiz "\nPlease enter the operation: \n"
out_string3: .asciiz "\nPlease enter the 2nd Number:\n"
out_string4: .asciiz "\nThe result is:\n"
out_string5: .asciiz "\nError...\n"

.text ## Assembly language instructions go in text segment

main: ## Start of code section

## print the first string
li $v0, 4
la $a0, out_string1
syscall

## enter first number
li $v0, 5
syscall

move $t0 , $v0
 
## print the second string
li $v0, 4
la $a0, out_string2
syscall

## enter a character
li $v0, 12
syscall

move $t1, $v0

## print the third string
li $v0, 4
la $a0, out_string3
syscall

## enter second number
li $v0, 5
syscall

move $t2, $v0

## print the result
li $v0, 4
la $a0, out_string4
syscall

addi $t3, $zero, 43           ## save number 43 in the t3 register 
addi $t4, $zero, 45           ## save number 45 in the t4 register 
addi $t5, $zero, 42           ## save number 42 in the t5 register 
addi $t6, $zero, 47           ## save number 47 in the t6 register 

beq $t3, $t1, addition        ## equality check in code ASCII between t3 register and t1 register
beq $t4, $t1, subtraction     ## equality check in code ASCII between t4 register and t1 register
beq $t5, $t1, multiplication  ## equality check in code ASCII between t5 register and t1 register
beq $t6, $t1, division        ## equality check in code ASCII between t6 register and t1 register


li $v0,4                      ## print "Error..." if the above cheks are incorrect
la $a0, out_string5
syscall
j out

## 1st label for the addition
addition: 
	add $t3, $t0, $t2
	li $v0, 1
	move $a0, $t3
	syscall
	j out


## 2nd label for the subtraction
subtraction: 
	sub $t4, $t0, $t2
	li $v0, 1
	move $a0, $t4
	syscall
	j out
	

## 3rd label for the multiplication
multiplication: 
	mul $t5, $t0, $t2
	li $v0, 1
	move $a0, $t5
	syscall
	j out

## 4th label for the division
division:
   	div $t6, $t0, $t2
   	li $v0, 1
   	move $a0, $t6
   	syscall
	
out:

li $v0, 10 # terminate program
syscall 

