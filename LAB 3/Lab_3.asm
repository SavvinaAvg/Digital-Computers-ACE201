.data

out_string1: .asciiz "\nPlease Enter your String:\n"  
out_string2: .asciiz "\nThe processed String is:\n"

.align 2
get_input: .space 100 			

print_output: .space 100

.text
##################################################################################################################################################
# $t0 load the word of the string
# $t1 the byte that is being processed
# $t2 counter to take the bytes one at a time
# $t4 we used it to check the character
# $t5 memory address pointer for 'get_input'
# $t6 memory address pointer for 'print_output'
# $t7 address where the memory allocation of print_output ends
# $t8 points to the address of register $t5+4
# $t9 counter tha we use to put space
##################################################################################################################################################
main:
	jal Get_Input				# jumps to label 'Get_Input'
	la $s0, get_input			# loads 'get_input' in global variable $s0
	move $a0, $s0				# $a0 points to string 'get_input'
	la $s1, print_output			# loads 'print_output' in global register $s1
	move $a1, $s1				# $a1 points to string 'print_output'
	
	jal Process				# jumps to label 'Process'
	
	jal Print_Output			# jumps to label 'Print_Output'
	li $v0, 10 				# terminate the program
	syscall
	
Get_Input:

	li $v0, 4				# asks the user for a string		
	la $a0, out_string1			# print the message
	syscall

	li $v0, 8				# stores the string in 'get_input'		
	la $a0, get_input			# $a0 points to 'get_input' again
	li $a1, 100				# memory adress pointer for 'print_output' 					
	syscall
	
	jr $ra					# jumps to the next line of where we last left off in main
								
Process:				
	move $t5, $a0				# $t5 now points to 'get_input'
	move $t6, $a1				# $t6 now points to 'print_output'
	
Loop1:		
	lw $t0, 0($t5)				# load word of t5 register to t0	
	la $t2, ($t5)				# load the address of t5 register into t2
	la $t8, 4($t5)				# load the address of t5+4 register into t8
	la $t7, 100($t6)			# load the address of t6+100 into t7 register
	addi $t5, $t5, 4
		
Loop2:			
	andi $t1, $t0, 0x000000FF		# it makes all the characters 0 except the first and puts it in the t1 register
	srl $t0, $t0, 8				# shift right the bytes of the word so we can take the next character
	beq $t1, 10, LastWord			# check if the its the end of the string
	addi $t2, $t2, 1			# add +1 to the counter
	bgt $t2, $t8, Loop1 			# check i fits the end of the word

#------------- Check if Character it's Number ---------------#

	li $t4, 48				# check for numbers and 48 its the 0 in ascii code
	case_1:
	bgt $t4, 57, Lower_Case			# if the t4 register is reater than 57 = '9' then go to lower case 
	beq $t4, $t1, Control 			# if the t4 register id equal with the t1 then save the byte
	addi $t4, $t4, 1			# change the value of the counter
	j case_1
	
#------------- Check if Character it's LowerCase -----------#

Lower_Case:

	li $t4, 97				# check for low letters and 97 its the 'a' in ascii code
	case_3:
	bgt $t4, 122, Upper_Case		# if the t4 register is reater than 122 = 'z' then go to upper case
	beq $t4, $t1, Control			# if the t4 register id equal with the t1 then save the byte
	addi $t4, $t4, 1			# change the value of the counter
	j case_3
	
#------------- Check if Character it's UpperCase -------------#

Upper_Case:

	li $t4, 65				# check for capital letters and 65 its the 'A' in ascii code
	case_2:
	bgt $t4, 90, Space			# if the t4 register is reater than 90 = 'Z' then put space
	beq $t4, $t1, CapitalCase		# if the t4 register id equal with the t1 then go to capital label
	addi $t4, $t4, 1			# change the value of the counter
	j case_2
	
#------------- Characters it's Capital Letter---------------#

CapitalCase:
	addi $t1, $t1, 32			# if the character its capital then add 32 to change to lower case
	j Control
	
#---------------- Put A Space --------------------#
 
Space:
	li $t1, 32				#check for space and 32 its the 'space' in ascii code
	addi $t9, $t9, 1			# change the value of the counter
	beq $t9, 1, storeSpace			# check if its more than 1 space
	j Loop2 
 
storeSpace:
	sb $t1,($t6)				# Stores a space into the 'print_output'
	addi $t6, $t6,1								
	bgt $t6,$t7,Print_Output		# Checks if its the end of the string and call the procedure to print it
	j Loop2
 
Control:
	li $t9, 0				# we add the number 0 into register t9 to avoid having 2 spaces in a row
	sb $t1, 0($t6)				# Stores the byte into the 'print_output'
	addi $t6, $t6, 1
	bgt $t6, $t7, Print_Output		# Checks if its the end of the string and call the procedure to print it
	j Loop2

#--------------Check if Character is '\n'----------#
	
LastWord:
	addi $t2, $t2, 1
	bgt $t2, $t8, Print_Output
	andi $t1, $t0, 0x000000FF		# it makes all the characters 0 except the first and puts it in the t1 register		
	srl $t0, $t0, 8				# shift right the bytes of the word so we can take the next character
	j LastWord
				
Print_Output:

	li $v0, 4
	la $a0, out_string2			# print the output message
	syscall
	
	li $v0, 4
	la $a0, print_output			# print the processed string
	syscall
	jr $ra					# jumps to the next line of where we last left off in main
