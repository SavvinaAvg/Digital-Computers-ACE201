.data
    
prompt_int:   .asciiz "\nPlease enter a number in the range 0-24 or 'Q'  for exit:\n"    	## User prompt String
out_string1:  .asciiz "\nThis number is outside the allowable range. \n" 		
out_string2:  .asciiz "\nThe Fibonacci number F   is: "
exit_string:  .asciiz "\nEnd of programm.\n"

.align 2

#-----INPUT STRING-----
input: .space 3 
.text
#####################################################################################################################################################
#				REGISTER MAPS
# main:	
#	$t0 -> user input  
#	$t2 -> user string
#	$t4 -> loads in t4 the out_string2 (answer string)
#	$t6 -> the fibonacci result
# continue:
#	$t0 -> initialize $t0=32 (in code ascci 32='space') 
#	$t4 -> the new string
#	$t6 -> the fibonacci result
# fibonacci:
# 	$t1 -> initialize $t1=1
#	$t2 -> now in $t2 we save the n-1 , then first jal fibonacci in $t2 we save the n-2
#	$t3 -> in fibonacci user integer now in $t3
#	$t4 -> in $t4 we save the fibonacci(n-1)
#	$t6 -> at first we save the fibonacci(n-1),at second time we save the fibonacci(n-2),at the end we save the fibonacci(n-1) + fibonacci(n-2)
# convert:
#	$t0 -> user input
#	$t2 -> 1st byte of t0 , and then we save in t2 the 1-digit of int
#	$t4 -> 2nd byte of t0 , and then we save in t2 the 2-digit of int
#####################################################################################################################################################
main:
        li $v0, 4             	# system call code for printing string = 4 
	la $a0, prompt_int 		# load address of string to be printed into $a0 
        syscall               		
	
	la $a0,input			# loads input in register a0
	li $a1,3
	li $v0,8			# system call code for reading string = 8 (read string) 
	syscall	

	la $t2,input			# loads input in t2
	lb $t0, ($t2)			# loads the first byte of string input in t0
	beq $t0, 81, exit		# if t0=81 (in code ascii 81='Q') and jump to 'exit'

	move $a0, $t2
	jal convert				

	move $a0,$v0			# stores the v0 (user input) in a0 
	move $t0,$a0			# stores a0 in t0 
	bgt $t0, 24, try_again		# if t0>24 (t0 is the user input->metetrameno se int), jumps to label 'try_again'
	blt $t0, 0, try_again		# if t0<0 (t0 is the user input->metetrameno se int), jumps to label 'try_again'

	jal fibonacci			# call fibonacci()

	
	la $t2, input			# loads input number in t2
	la $t4, out_string2		# loads the out_string2(is the answer string) in t4
	
	lb $t0, ($t2)			# loads the value of t0 in t2
	sb $t0, 23($t4)		# locates t0 in the 23rd position in t4's string
	lb $t0, 1($t2)			# loads the 2nd entity of t2 in t0
	beq $t0, 10, continue		# if $t0==10(in code ascii 10='\n'), jumps to 'continue'
	sb $t0, 24($t4)		# stores t0 in the 24th position of t4's contents
	move $a0, $t4			# stores the new string in a0
	li $v0, 4			# prints the completed string
	syscall
	
	li $v0, 1			# prints the fibonacci number
	add $a0, $t6, $zero		# add $t6 and $zero and the result save in $a0				
	syscall
	
	j main	

############################### LABEL CONTINUE #############################################################	
continue:
	li $t0,32			# loads a 32(in code ascii 32='space') in t0
	sb $t0,24($t4)			# stores t0 in the 24th position of t4's contents
	move $a0,$t4			# stores the new string in a0
	li $v0,4			# prints the completed string
	syscall
	
	li $v0,1			# prints the fibonacci number
	add $a0, $t6, $zero		# add $t6 and $zero and the result save in $a0	
	syscall
	
	j main				# return in main		
############################### LABEL EXIT #############################################################
exit:	 	
	li $v0, 4             		# system call code for printing string = 4 
	la $a0, exit_string 		# load address of string to be printed into $a0 
        syscall 
				
	li $v0, 10      		# terminate programm       		
        syscall
############################### LABEL TRY AGAIN ##########################################################
try_again:
	li $v0, 4             		# system call code for printing string = 4 
        la $a0, out_string1 		# load address of string to be printed into $a0 
        syscall               	# call operating system to perform operation # specified in $v0 
 	j main				# return in main

############################# FUNCTION FIBONACCI ########################################################

fibonacci:	################################################
		# t2=n				   	       #
		# if (n==0) return 0;		  	       #
		# if else (n==1) return 1;	   	       #
		# else return( fibonacci(n-1)+fibonacci(n-2) );#
		################################################

	addi $sp, $sp, -12 		# enlarge the stack, to make room for three more words
	sw $ra, 0 ($sp)		# save return address to stack
	sw $t3, 4 ($sp)		# save t3 to stack
	sw $t4, 8 ($sp)		# save t4 to stack
	 

	addi $t3, $t2, 0		# put $t2 in $t3 (dld bazw to n apo to t2 pou htan arxika sto t3)

	addi $t1, $zero, 1		# $t1 = $zero + 1 = 1
	beq $t3, $zero, if		# check if $t3 = $zero and jump to label 'if'
	beq $t3, $t1, if_else		# check if $t3 = $t1 and jump to label 'if_else'
	addi $t2, $t3, -1		# $t2 = $t3 + (-1) = n-1
	
	jal fibonacci			# call fibonacci->(wste na ftiaxtei to $t6=fibonacci(n-1)
	
 	add $t4, $zero, $t6    		# t4 = $t6+$zero = fibonacci(n-1)+0 = fibonacci(n-1)
	addi $t2, $t3, -2		# $t2 =$t3+(-2) = n-2

	jal fibonacci              	# call fibonacci->(wste na ftiaxtei to $t6=fibonacci(n-2) )
	add $t6, $t6, $t4       	# $t6 = $t6+$t4 = fibonacci(n-2) + fibonacci(n-1)	
#------------------------------------------------------------------------------------------------------
else:	
	lw $ra, 0 ($sp)       		# take the return address from top of stack
	lw $t3, 4 ($sp)		# take the t3 of stack
	lw $t4, 8 ($sp)		# take the t4 of stack
	addi $sp, $sp, 12   	 	# bring back stack pointer--shrink the stack to its former size 
	jr $ra				# return, where it left off
if:    
	li $t6, 0			# initialize $t6==0
 	j else				# jump to label 'else'

if_else:
 	li $t6, 1			# initialize $t6==1
	j else				# jump to label 'else'

############################# FUNCTION CONVERT ########################################################
convert:				
	move $t0, $a0			# loads input in t0
	lb $t4, 1($t0)			# loads the 2nd byte of t0 in t4
	beq $t4, 10, one_digit		# if t4==10(in code ascii 10='\n'), jumps to 'one_digit'

       					# TWO-DIGIT NUMBER
	lb $t2, ($t0)			# loads 1st byte of t0 in t2
	addi $t2, $t2, -48		# converts it into the accordding integer
	mul $t2, $t2, 10		# makes it the 1st digit of a 2-digit number
	addi $t4, $t4, -48		# transforms the 2nd number into the accordding integer
	add $t2, $t2, $t4		# completes the 2-digit number
	move $v0, $t2			# returns the integer that has been stored in v0 (output)
	jr $ra				# return, where it left off

one_digit:  					# ONE-DIGIT NUMBER
	lb $t2, ($t0)			# loads 1st byte of t0 in t2
	addi $t2, $t2, -48		# converts it into the accordding integer
	move $v0, $t2			# returns the integer that has been stored in v0 (output)
	jr $ra				# return, where it left off
		
	
