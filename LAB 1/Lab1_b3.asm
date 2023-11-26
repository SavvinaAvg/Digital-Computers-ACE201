# Hello, World!

.data ## Data declaration section

msg: .asciiz "Give a number: \n"
out_string: .asciiz "\nHello, World!\n" ## String to be printed 

.text ## Assembly language instructions go in text segment

main: ## Start of code section

## give a number
li $v0, 4  
la $a0, msg
syscall 

## enter a number
li $v0, 5
syscall

move $t0, $v0
add $t1, $t0, $t0

## print the string
li $v0, 4  
la $a0, out_string
syscall 

## print the number
li $v0, 1
move $a0, $t1
syscall

li $v0, 10 # terminate program
syscall 
