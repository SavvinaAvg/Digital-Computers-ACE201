.data

out_string1: .asciiz "\nPlease determine operation, entry (E), inquiry (I) or quit (Q): \n"  
out_string2: .asciiz "\nPlease enter last name: \n"
out_string3: .asciiz "\nPlease enter first name: \n"
out_string4: .asciiz "\nPlease enter phone number: \n"
out_string5: .asciiz "\nThank you, the new entry is the following: \n"
out_string6: .asciiz "\nPlease enter the entry number you wish to retrieve: \n"
out_string7: .asciiz "\nThere is no such entry in the phonebook\n"
out_string8: .asciiz "\nThe number is: \n"
out_string9: .asciiz "\nThank you for using our cataloge! \n"


.align 2
katalogos: .space 600
input: .space 20
####################################################################################################
#			REGISTER MAP 
#								
#main:	s0-> load address katalogos								
#	s1-> point to katalogos
#	s2-> counter in code ascii , initialize s2=49=1						
#	s3-> arithmetic counter , initialize s3=1						
#	s4-> user input 'E', 'I' or 'Q'
#
#Input:	
#	t0-> pairnei to a0 mesw ths move
#	t1-> pairnei to a1 mesw ths move
#	t3-> kanei arxikopoiisi me tin timi 600
#	t4-> kanei arxikopoiisj me tin timi 32
#
#Get_entry:											
#	t0-> xrhsimopoeitai gia arxikopoihseis
#	t1-> xrhsimpoeitai gia na paei sthn arxh ths kataxwrhshs kai na dinei ta 3 eisagomena string
#
#Print_Entry:	
#	t0-> xrisimopoieitai gia arxikopoiseis																						#	t0-> xrhsimopoeitai gia arxikopoihseis								
#	t3-> xrhsimopoeitai gia na upologistei o xoros pou pianei oloklhrh h kathe kataxwrhsh									
#	t4-> ston t4 fainetai 								
#	t5-> user integer																			
####################################################################################################
.text
main:
	bne $s3, 1, build_katalogos
	jal Prompt_User
	move $s4, $v0
	jal comparison

	j main
#---------------------------------------------
comparison:
	
	beq $s4, 69, Entry		# if s4 register equals with 'E' in ascii code go to Entry
	beq $s4, 73, PrintEntry		# if s4 register equals with 'I' in ascii code go to PrintEntry
	beq $s4, 81, Exit		# if s4 register equals with 'Q' in ascii code go to exit
	jr $ra
#---------------------------------------------
build_katalogos:
	la $s0, katalogos
        
	addi $s1, $s0, 0		# now $s1 points to katalogos

	li $s2, 49     			# initialize s2==49='1' in code ascii
	li $s3, 1			# initialize s3==1

	j main
#---------------------------------------------
Get_LastName:				# print message for last name
	li $v0, 4
	la $a0, out_string2
	syscall
	
	j continue
	
Get_FirstName:				# print message for first name
	li $v0, 4
	la $a0, out_string3
	syscall
	
	j continue
	
Get_PhoneNumber:			# print message for phone number
	li $v0, 4
	la $a0, out_string4
	syscall

#---------------------------------------------
continue:
	li $v0, 8			
	la $a0, input			# $a0 points to 'input' 
	li $a1, 20			# $a1 points to length 'input'
	syscall
	
	move $a1, $s1
	
	addi $sp, $sp,-4		# desmevw stiba
	sw $ra, ($sp)			#
	
	jal Input			# klhsh sunarthshs Input
	addi $s1 ,$s1, 20		# auksanw tn s1 kata 20 (dld paw stis epomenes 20 8eseis tou katalogou na grapsw to epomeno string) 
	
	lw $ra, ($sp)			# apodesmeuw ton xwro sthn stiba
	addi $sp, $sp, 4		#
	
	jr $ra
	
#---------------------------------------------
Input:
	move $t0, $a0
	move $t1, $a1

	li $t3, 600			# initialize t3==600 dld osos einai o desmeumenos xwros katalogos
	
	add $t3, $t3, $s0
	
loop:
	lb $t4, ($t0) 			# ston t0 exw ta (1,2,3,klp) kai thn '.' ta kanw load byte ston t4
	beq $t4, 10, space		# elegxw an to t3=10 dld me nea grammh an einai paw sto label 'space'
					
	sb $t4, ($t1)			# kanw sb ton t1 ston t4 opou t1 einai to 'input'

	addi $t0, $t0, 1		# auksanw kata 1 tn t0 dld tn pointer tou 'katalogos'
	addi $t1, $t1, 1		# auksanw kata 1 tn t1 dld tn pointer tou 'input'
	j loop

space:	li $t4, 32			# initialize t3==32=space in code ascii
	sb $t4, ($t1)			# kanw sb tn t1 ston t3 opou t1 einai to 'input'
	
	jr $ra

#------------------------------LABELS-------------------------------------------
Entry:					# klhsh sunarthshs Get_Entry
	sw $ra, 0($sp)
	addi $sp, $sp, -4

	jal Get_Entry
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

PrintEntry:				# klhsh sunarthshs Print_Entry
	sw $ra, 0($sp)
	addi $sp, $sp, -4

	jal Print_Entry

	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra

Exit:	
	li $v0, 4			# print message  'Thank you for using our cataloge!'         
	la $a0, out_string9
	syscall	

	li $v0, 10
	syscall
 
##########################  FUNCTION  ################################
#-----------------------PROMPT USER--------------------------------------
Prompt_User:
	li $v0,4  			# print message " Please determine operation, entry (E), inquiry (I) or quit (Q): "
	la $a0, out_string1
	syscall

	li $v0,12			# read character 'E','I' or 'Q'
	syscall
	jr $ra

#---------------------GET ENTRY----------------------------------------
Get_Entry:
	addi $sp, $sp, -8
	sw $v0, 0($sp)
	sw $ra, 4($sp)

	jal Get_LastName		#
	jal Get_FirstName		#  klhsh sunarthsewn
	jal Get_PhoneNumber		#
	

	li $v0, 4			# print message "Thank you, the new entry is the following:"
        la $a0, out_string5
	syscall
 
	li $v0, 11			
	la $a0, ($s2)			# load register s2 in register a0  (s2 counter gia ton code ascii)
	syscall
	
	addi $s2, $s2, 1		# auksanw ton counter s2(counter gia ton code ascii) kata ena
	
	li $t0, 46 			# bazw ston t0 to 46='.' in code ascii

	li $v0, 11			
	la $a0, ($t0)			# load register t1 in register a0
	syscall
	
        li $t0, 32			# dinw ston t0 thn timh 32='space' in code ascii

	li $v0, 11			
	la $a0, ($t0)			# load register t1 in register a0
	syscall
        
        addi $t1, $s1, -60		# meiwnw ton s1 kata 60 gt s1=600-60=t1=540 (ousiastika to 60 einai o xwrospou mporei na piasei h kathe kataxwrhsh) kai to apo9hkeyw sto t1 
        
        li $v0, 4			
        la $a0, ($t1)			# load register t1 in register a0
	syscall
	
	
	addi $t1, $t1, 20		# auksanw ton t1 kata 20 kai ton apo9hkeuw sto t1 (dld paw sto epomeno string)
	
        li $v0, 4			
        la $a0, ($t1)			# load register t1 in register a0
	syscall
	
	addi $t1,$t1,20			# auksanw ton t1 kata 20 kai ton apo9hkeuw ksana sto t1(dld paw sto epomeno stirng)
	
        li $v0, 4			
        la $a0, ($t1)			# load register t1 in register a0
	syscall
	
	addi $sp, $sp, 8
	lw $v0, 0($sp)
	lw $ra, 4($sp)
	
	jr $ra
	
#----------------------------------------------------------------------------
Print_Entry:

	li $t0, 60			# initialize to==60 (epeidh 3*20 dld 60 sunolika xarakthres h ka9e kataxwrhsh )			

	li $v0, 4			# print message for entry number
	la $a0, out_string6
	syscall

	li $v0,5			# read the user integer
	syscall
	move $t3, $v0
#------------------------------------------	
	addi $t5, $t3, 0
	
	addi $t3, $t3, -1    		# meiwnw kata 1 tn t3 (ston t3 eixe mpei o inetger tou user)
	mult $t3, $t0 			# pollaplasiazw to t3*t0 
	mflo $t3 			# apotelesma t panw pollaplasiasmou apo9hkeuetai sto t3(ousiastika einai oi 60 xarakthres ths kataxwrhshs)
	
	add $t4, $s0, $t3		# prosthetw to apotelesma(t3) sto s0 kai apo9hkeuw sto t4 (diladi s0 = 600 - t3 apothikevetai sto t4)

	blt $s2, $t5, termination 	# kanei elegxo an s2(plhthos kataxwrhsewn) me ton t5 (einai o integer t xrhsth) ean s2<t5 tote kanei jump to label ' termination
	
#---------------PRINT STRING THE NUMBER IS:-----------------------

	li $v0, 4			# print message 'The number is:'
        la $a0, out_string8
        syscall

#--------------PRINT THE NUMBER-----------------------------------

	li $v0, 1 			# print the user integer dld to t5
	la $a0, ($t5)			# load register t5 in register a0
	syscall

#-------------PRINT THE DOT '.'------------------------------------

	li $t0, 46 			# initialize t0==46='.' in code ascii
	
	li $v0, 11			# print the character '.'
	la $a0, ($t0)			# load register t0 in register a0
	syscall

#------------PRINT THE SPACE BETWEEN DOT AND NAME------------------

	li $t0, 32 			# initialize t0==32='space' in code ascii
	
	li $v0, 11			# print the character 'space'
	la $a0, ($t0)			# load register t0 in register a0
	syscall

#-----------PRINT LAST NAME THEN FIRST NAME AND PHONE NUMBER--------      
 
        li $v0, 4			# print the last name
        la $a0, ($t4)			# load register t4 in register a0
	syscall
	
	addi $t4, $t4, 20		# auksanw ton t4 kata 20 paei dld stous epomenous 20 xarakthres(first name)
	
        li $v0, 4			# print the first name
        la $a0, ($t4)			# load register t4 in register a0
	syscall
	
	addi $t4, $t4, 20		# auksanw ton t4 kata 20 paei dld stous epomenous 20 xarakthres(phone number)
	
        li $v0, 4			# print the phone number
        la $a0, ($t4)			# load register t4 in register a0
	syscall
	
termination:
	li $v0, 4 			# print message 'There is no such entry in the katalogos'
	la $a0, out_string7
	syscall
	
	j main
	
	jr $ra