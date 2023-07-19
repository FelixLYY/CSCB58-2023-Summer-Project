# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4
# - Unit height in pixels: 4
# - Display width in pixels: 256
# - Display height in pixels: 256
# Figure 2: The MARS Bitmap Display
# - Base Address for Display: 0x10008000 ($gp)
.eqv BASE_ADDRESS 0x10008000
.eqv You_Lose	0x10008080
.eqv You_Win	0x10008080
.eqv Press	0x10008708
.eqv To		0x10008a30
.eqv Restart	0x10008cf8
.eqv Platform1 0x10009d00
.eqv Platform2 0x10009650
.eqv Platform3 0x1000a070
.eqv Platform4 0x100099c0
.eqv Platform5 0x1000a934
.eqv Bottom	0x1000be00
.eqv EndPixel	0x1000c000

.text

main:

	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t2, 0x00ff00 # $t2 stores the green colour code
	li $t3, 0x0000ff # $t3 stores the blue colour code

	li $t0, Platform1
	jal InitPlat

	li $t0, Platform2
	jal InitPlat

	li $t0, Platform3
	jal InitPlat

	li $t0, Platform4
	jal InitPlat


	li $t0, Platform5
	jal InitPlat
	
	j Sea
InitPlat:
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	sw $t2, 28($t0)
	sw  $t2, 32($t0)
	sw $t2, 36($t0)
	sw $t2, 40($t0)	
	jr $ra

Sea: 
	# Fill the bottom line with blue, like the sea
	li $t0, Bottom
	la $t4, EndPixel
	#addi $t4, $t4, 4
LoopSea:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, LoopSea

End:
	li $v0, 10
	syscall
