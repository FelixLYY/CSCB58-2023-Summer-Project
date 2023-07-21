#####################################################################
#
# CSCB58 Summer 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Yu Yin, Lee, 1008421968, leeyu23, felixyy.lee@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Score 		(2 marks)
# 2. Fail condition 	(1 marks)
# 3. Win Condition 	(1 marks)
# 4. Moving Object 	(2 marks)
# 5. Moving Platform 	(2 marks)
# 6. Pick-up Effect	(2 marks)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################


# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# Figure 2: The MARS Bitmap Display
# - Base Address for Display: 0x10008000 ($gp)
# 32 x 32 pixel
.eqv BASE_ADDRESS 0x10008000
.text
li $t0, BASE_ADDRESS # $t0 stores the base address for display
li $t1, 0xff0000 # $t1 stores the red colour code
li $t2, 0x00ff00 # $t2 stores the green colour code
li $t3, 0x0000ff # $t3 stores the blue colour code
sw $t1, 0($t0) # paint the first (top-left) unit red.
sw $t2, 4($t0) # paint the second unit on the first row green. Why $t0+4?
#sw $t3, 16380($t0) # paint the first unit on the second row blue. Why +256?
li $t4, 0x10008800
sw $t2, 0($t4)
.globl main
main:
	li $t9, 0xffff0000

Loop:   
	li $v0, 32
	li $a0, 400 # Wait one second (400 milliseconds)
	syscall
	lw $t8, 0($t9)
	beq $t8, 1, keypress_happened
	j Loop

keypress_happened:
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
	li $v0, 1
	move $a0, $t2
	syscall
	j Loop
	
li $v0, 10 # terminate the program gracefully
syscall
