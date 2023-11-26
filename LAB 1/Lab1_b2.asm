# Hello, World!  

.data     ## Data declaration section 

text: .asciiz "Give a string: \n"
out_string1: .asciiz "Hello, " ##String to be printed
out_string2: .asciiz " World!"
msg: .space 20

.text  ## Assembly language instructions go in text segment 

main: ## Start of code section 

## give a string
li $v0, 4
la $a0, text
syscall

## enter a string
li $v0, 8
la $a0, msg
li $a1, 20
syscall

## print the 1st string
li $v0, 4
la $a0, out_string1
syscall

## print your string
li $v0, 4
la $a0, msg
syscall

## print the 2nd string
li $v0, 4
la $a0, out_string2
syscall

# syscall takes its arguments from $a0, $a1, ... 
li $v0, 10 # terminate program 
syscall 
