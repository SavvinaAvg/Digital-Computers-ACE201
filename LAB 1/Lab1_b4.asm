# Hello, World!

.data
## Data declaration section
out_string: .asciiz "\nHello, World!\n" ## String to be printed
msg: .asciiz "Give a character: \n"

.text
## Assembly language instructions go in text segment
main: ## Start of code section

## give a character
li $v0, 4
la $a0, msg
syscall

## enter a character
li $v0, 12
syscall

move $t0, $v0

## print the string
li $v0, 4
la $a0, out_string
syscall

## print your character
li $v0, 11
move $a0, $t0
syscall

li $v0, 10 # terminate program
syscall

