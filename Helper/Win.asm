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
.eqv You_Lose	0x10008828
.eqv You_Win	0x10008828
.eqv Press	0x1000a020
.eqv Restart	0x1000b040


.text

.globl Win



Win:
	li $t0, You_Lose # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t2, 0x00ff00 # $t2 stores the green colour code
	li $t3, 0x0000ff # $t3 stores the blue colour code
	jal DisplayY
	addi $t0, $t0, 28
	jal DisplayO
	addi $t0, $t0, 20
	jal DisplayU
	addi $t0, $t0, 56
	jal DisplayW
	addi $t0, $t0, 32
	jal DisplayI
	addi $t0, $t0, 24
	jal DisplayN

	
ClickRestart:
	li $t0, Press # $t0 stores the base address for display
	li $t1, 0xff0000 # $t1 stores the red colour code
	li $t2, 0x00ff00 # $t2 stores the green colour code
	li $t3, 0x0000ff # $t3 stores the blue colour code
	jal DisplayP
	addi $t0, $t0, 20
	jal DisplayR
	addi $t0, $t0, 20
	jal DisplayE
	addi $t0, $t0, 20
	jal DisplayS
	addi $t0, $t0, 16
	jal DisplayS
	addi $t0, $t0, 36
	jal DisplayP
	addi $t0, $t0, 36
	jal DisplayT
	addi $t0, $t0, 24
	jal DisplayO
	li $t0, Restart
	jal DisplayR
	addi $t0, $t0, 20
	jal DisplayE
	addi $t0, $t0, 20
	jal DisplayS
	addi $t0, $t0, 16
	jal DisplayT
	addi $t0, $t0, 24
	jal DisplayA
	addi $t0, $t0, 20
	jal DisplayR
	addi $t0, $t0, 20
	jal DisplayT
	j End

DisplayY:
	sw $t2, 0($t0)		# Display Y
	sw $t2, 4($t0)
	sw $t2, 260($t0)
	sw $t2, 264($t0)
	sw $t2, 520($t0)
	sw $t2, 524($t0)
	sw $t2, 528($t0)
	sw $t2, 272($t0)
	sw $t2, 276($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	sw $t2, 780($t0)
	sw $t2, 1036($t0)
	sw $t2, 1292($t0)
	jr $ra

DisplayO:
	sw $t2, 4($t0)		# Display O
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 256($t0)
	sw $t2, 272($t0)
	sw $t2, 512($t0)
	sw $t2, 528($t0)
	sw $t2, 768($t0)
	sw $t2, 784($t0)
	sw $t2, 1024($t0)
	sw $t2, 1040($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	sw $t2, 1292($t0)
	jr $ra
	
DisplayU:
	sw $t2, 4($t0)		# Display U
	sw $t2, 260($t0)
	sw $t2, 516($t0)
	sw $t2, 772($t0)
	sw $t2, 1032($t0)
	sw $t2, 1292($t0)
	sw $t2, 1296($t0)
	sw $t2, 1300($t0)
	sw $t2, 1048($t0)
	sw $t2, 796($t0)
	sw $t2, 540($t0)
	sw $t2, 284($t0)
	sw $t2, 28($t0)
	jr $ra
	
DisplayL:
	sw $t2, 0($t0)		# Display L
	sw $t2, 256($t0)
	sw $t2, 512($t0)
	sw $t2, 768($t0)
	sw $t2, 1024($t0)
	sw $t2, 1280($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	sw $t2, 1292($t0)
	sw $t2, 1296($t0)

	jr $ra
	
DisplayS:
	sw $t2, 4($t0)		# Display S
	sw $t2, 256($t0)
	sw $t2, 8($t0)
	sw $t2, 512($t0)
	sw $t2, 772($t0)
	sw $t2, 1032($t0)
	sw $t2, 1288($t0)
	sw $t2, 1284($t0)
	sw $t2, 1280($t0)
	
	jr $ra

DisplayE:
	sw $t2, 0($t0)		# Display E
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 256($t0)
	sw $t2, 512($t0)
	sw $t2, 768($t0)
	sw $t2, 772($t0)
	sw $t2, 776($t0)
	sw $t2, 780($t0)
	sw $t2, 1024($t0)
	sw $t2, 1280($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	sw $t2, 1292($t0)
	jr $ra
	
DisplayP:
	sw $t2, 0($t0)		# Display P
	sw $t2, 4($t0)	
	sw $t2, 8($t0)	
	sw $t2, 516($t0)	
	sw $t2, 520($t0)	
	sw $t2, 256($t0)
	sw $t2, 268($t0)	
	sw $t2, 512($t0)
	sw $t2, 768($t0)		
	sw $t2, 1024($t0)
	sw $t2, 1280($t0)	
	jr $ra		

DisplayR:
	sw $t2, 0($t0)		# Display R
	sw $t2, 4($t0)	
	sw $t2, 8($t0)	
	sw $t2, 516($t0)	
	sw $t2, 520($t0)	
	sw $t2, 256($t0)
	sw $t2, 268($t0)	
	sw $t2, 512($t0)
	sw $t2, 768($t0)		
	sw $t2, 1024($t0)
	sw $t2, 1280($t0)	
	sw $t2, 772($t0)
	sw $t2, 1032($t0)
	sw $t2, 1292($t0)
	jr $ra		

DisplayT:
	sw $t2, 0($t0)		# Display T
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 264($t0)
	sw $t2, 520($t0)
	sw $t2, 776($t0)
	sw $t2, 1032($t0)
	sw $t2, 1288($t0)
	jr $ra
	
DisplayA:
	sw $t2, 4($t0)		# Display A
	sw $t2, 8($t0)	
	sw $t2, 256($t0)
	sw $t2, 268($t0)		
	sw $t2, 512($t0)
	sw $t2, 524($t0)
	sw $t2, 516($t0)
	sw $t2, 520($t0)		
	sw $t2, 768($t0)
	sw $t2, 780($t0)		
	sw $t2, 1024($t0)	
	sw $t2, 1036($t0)		
	sw $t2, 1280($t0)
	sw $t2, 1292($t0)			
	jr $ra
	
DisplayW:
	sw $t2, 0($t0)		# Display W
	sw $t2, 256($t0)
	sw $t2, 512($t0)
	sw $t2, 768($t0)
	sw $t2, 1024($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	sw $t2, 12($t0)		
	sw $t2, 268($t0)
	sw $t2, 524($t0)
	sw $t2, 780($t0)
	sw $t2, 1036($t0)
	sw $t2, 1296($t0)
	sw $t2, 1300($t0)
	sw $t2, 24($t0)
	sw $t2, 280($t0)
	sw $t2, 536($t0)
	sw $t2, 792($t0)
	sw $t2, 1048($t0)
	jr $ra

DisplayI:
	sw $t2, 0($t0)		# Display I
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 264($t0)
	sw $t2, 520($t0)
	sw $t2, 776($t0)
	sw $t2, 1032($t0)
	sw $t2, 1288($t0)
	sw $t2, 1284($t0)
	sw $t2, 1280($t0)
	sw $t2, 1292($t0)
	sw $t2, 1296($t0)
	jr $ra

DisplayN:
	sw $t2, 0($t0)			# Display N
	sw $t2, 256($t0)
	sw $t2, 512($t0)
	sw $t2, 768($t0)
	sw $t2, 1024($t0)
	sw $t2, 1280($t0)
	sw $t2, 20($t0)			
	sw $t2, 276($t0)
	sw $t2, 532($t0)
	sw $t2, 788($t0)
	sw $t2, 1044($t0)
	sw $t2, 1300($t0)
	sw $t2, 260($t0)
	sw $t2, 520($t0)
	sw $t2, 780($t0)
	sw $t2, 1040($t0)

	jr $ra
End: 
	li $v0, 10
	syscall
	
	