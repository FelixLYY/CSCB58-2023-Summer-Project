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
.eqv Platform1 0x1000a300
.eqv Platform2 0x10009d50
.eqv Platform3 0x1000a880
.eqv Platform4 0x1000a2c0
.eqv Platform5 0x1000b234
.eqv Bottom	0x1000be00
.eqv EndPixel	0x1000c000
.eqv Character 0x1000a210
.eqv Mushroom	0x10009c60
.eqv Potion	0x1000b144
.eqv ExitDoor	0x1000a1d0
.eqv Score	0x10008210
# .eqv Mark	0x10008284

# Color
.eqv Red	0xff0000
.eqv Green	0x00ff00
.eqv Blue	0x0000ff
.eqv White	0xffffff
.eqv Yellow	0xffff00
.eqv Brown	0x964b00

.data 
Value: .word	0

.text

main:

	li $t1, Red # $t1 stores the red colour code
	li $t2, Green # $t2 stores the green colour code
	li $t3, Blue # $t3 stores the blue colour code
	li $s0, Character
	li $s1, Mushroom
	li $s2, Potion
	li $t7, 2
	sw $t7, Value

	jal CreatePlatform1
	jal CreatePlatform2
	jal CreatePlatform3
	jal CreatePlatform4
	jal CreatePlatform5
	jal Sea
	jal Exit
	jal DisplayScore
	
	jal YellowMushroom
	jal BluePotion
	jal OriginalCharacter
	
	li $v0, 32
	li $a0, 1000 # Wait one second (1000 milliseconds)
	syscall

	jal ClearCharacter
	jal ClearYellowMushroom
	jal ClearPotion
	jal ClearValue
	
	li $v0, 32
	li $a0, 1000 # Wait one second (1000 milliseconds)
	syscall
	
	jal ClearScreen
	j End

ClearScreen:
	li $t0, BASE_ADDRESS
	add $t3, $zero, $zero
	la $t4, EndPixel
	j LoopClearScreen
LoopClearScreen:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, LoopSea
	jr $ra

ClearValue:
	lw $t3, Value 
	li $t4, 1
	add $t2, $zero, $zero
	beqz $t3, Display0	# Score = 0
	beq $t3, $t4, Display1	# Score = 1
	j Display2		# Score = 2

ClearPotion:
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	j CreatePotion

ClearYellowMushroom:
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	j CreateMushroom

ClearCharacter:
	add $t1, $zero, $zero
	add $t2, $zero, $zero

	j CreateCharacter

DisplayScore:			# Display Score
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	li $t2, White
	li $t0, Score
	
	jal DisplayS
	addi $t0, $t0, 12
	jal DisplayC
	addi $t0, $t0, 24
	jal DisplayO
	addi $t0, $t0, 24
	jal DisplayR
	addi $t0, $t0, 20
	jal DisplayE
	addi $t0, $t0, 24
	jal DisplayColon
	addi $t0, $t0, 24
	jal DisplayValue
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
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

DisplayC:
	sw $t2, 8($t0)		# Display C
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 260($t0)
	sw $t2, 516($t0)
	sw $t2, 772($t0)
	sw $t2, 1028($t0)
	sw $t2, 1288($t0)
	sw $t2, 1292($t0)
	sw $t2, 1296($t0)
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

DisplayColon:			# Display :
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 256($t0)
	sw $t2, 260($t0)
	sw $t2, 1024($t0)
	sw $t2, 1028($t0)
	sw $t2, 1280($t0)
	sw $t2, 1284($t0)
	jr $ra

DisplayValue:
	lw $t3, Value 
	li $t4, 1
	beqz $t3, Display0	# Score = 0
	beq $t3, $t4, Display1	# Score = 1
	j Display2		# Score = 2
	
Display0:
	sw $t2, 4($t0) 		# Display 0
	sw $t2, 8($t0)
	sw $t2, 256($t0)
	sw $t2, 268($t0)
	sw $t2, 512($t0)
	sw $t2, 524($t0)
	sw $t2, 520($t0)
	sw $t2, 768($t0)
	sw $t2, 772($t0)
	sw $t2, 780($t0)
	sw $t2, 1024($t0)
	sw $t2, 1036($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	jr $ra
	
Display1:
	sw $t2, 0($t0)			# Display 1
	sw $t2, 4($t0)
	sw $t2, 260($t0)
	sw $t2, 252($t0)
	sw $t2, 516($t0)
	sw $t2, 772($t0)
	sw $t2, 1028($t0)
	sw $t2, 1284($t0)
	sw $t2, 1280($t0)
	sw $t2, 1288($t0)
	sw $t2, 1276($t0)
	sw $t2, 1292($t0)
	jr $ra
	
Display2:
	sw $t2, 4($t0)		# Display 2
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 256($t0)
	sw $t2, 272($t0)
	sw $t2, 524($t0)
	sw $t2, 776($t0)
	sw $t2, 1028($t0)
	sw $t2, 1280($t0)
	sw $t2, 1284($t0)
	sw $t2, 1288($t0)
	sw $t2, 1292($t0)
	sw $t2, 1296($t0)
	
	jr $ra

OriginalCharacter:
	li $t1, Red # $t1 stores the red colour code
	li $t2, Green # $t2 stores the green colour code

	j CreateCharacter

Exit:
	li $t0, ExitDoor
	li $t1, White
	li $t2, Brown
	j CreateExitDoor

CreateExitDoor:
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, -256($t0)
	sw $t2, -252($t0)
	sw $t2, -248($t0)
	sw $t2, -244($t0)
	sw $t2, -240($t0)
	sw $t2, -512($t0)
	sw $t2, -508($t0)
	sw $t2, -504($t0)
	sw $t1 -500($t0)
	sw $t2, -496($t0)
	sw $t2, -768($t0)
	sw $t2, -764($t0)
	sw $t2, -760($t0)
	sw $t2, -756($t0)
	sw $t2, -752($t0)
	sw $t2, -1024($t0)
	sw $t2, -1020($t0)
	sw $t2, -1016($t0)
	sw $t2, -1012($t0)
	sw $t2, -1008($t0)
	sw $t2, -1280($t0)
	sw $t2, -1276($t0)
	sw $t2, -1272($t0)
	sw $t2, -1268($t0)
	sw $t2, -1264($t0)
	sw $t2, -1536($t0)
	sw $t2, -1532($t0)
	sw $t2, -1528($t0)
	sw $t2, -1524($t0)
	sw $t2, -1520($t0)
	sw $t2, -1792($t0)
	sw $t2, -1788($t0)
	sw $t2, -1784($t0)
	sw $t2, -1780($t0)
	sw $t2, -1776($t0)
	jr $ra

YellowMushroom:
	li $t2, Yellow
	li $t1, Red
	j CreateMushroom

BluePotion:
	li $t2, White
	li $t1, Blue
	j CreatePotion
	
CreatePlatform1:
	li $t0, Platform1
	li $t2, Green

	j InitPlat

	
CreatePlatform2:
	li $t0, Platform2
	li $t2, Green

	j InitPlat

CreatePlatform3:
	li $t0, Platform3
	li $t2, Green

	j InitPlat

CreatePlatform4:
	li $t0, Platform4
	li $t2, Green

	j InitPlat


CreatePlatform5:
	li $t0, Platform5
	li $t2, Green

	j InitPlat

	
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

CreateCharacter: 
	sw $t1, 0($s0)
	sw $t1, 16($s0)
	sw $t1, -252($s0)
	sw $t1, -248($s0)
	sw $t1, -244($s0)
	sw $t1, -508($s0)
	sw $t1, -504($s0)
	sw $t1, -500($s0)
	sw $t1, -764($s0)
	sw $t1, -760($s0)
	sw $t1, -768($s0)
	sw $t1, -756($s0)
	sw $t1, -752($s0)
	sw $t2, -1020($s0)
	sw $t1, -1024($s0)
	sw $t1, -1016($s0)
	sw $t2, -1012($s0)
	sw $t1, -1008($s0)
	sw $t1, -1276($s0)
	sw $t1, -1280($s0)
	sw $t1, -1272($s0)
	sw $t1, -1268($s0)
	sw $t1, -1264($s0)
	jr $ra

Sea: 
	# Fill the bottom line with blue, like the sea
	li $t0, Bottom
	li $t3, Blue
	la $t4, EndPixel
	#addi $t4, $t4, 4
	j LoopSea
LoopSea:
	sw $t3, 0($t0)
	addi $t0, $t0, 4
	bne $t0, $t4, LoopSea
	jr $ra

CreateMushroom:
	sw $t2, 0($s1)
	sw $t2, 4($s1)
	sw $t2, 8($s1)
	sw $t2, -256($s1)
	sw $t2, -252($s1)
	sw $t2, -248($s1)
	sw $t2, -512($s1)
	sw $t2, -508($s1)
	sw $t2, -504($s1)
	sw $t2, -500($s1)
	sw $t2, -516($s1)
	sw $t2, -768($s1)
	sw $t2, -764($s1)
	sw $t2, -760($s1)
	sw $t2, -1020($s1)
	jr $ra

CreatePotion:
	sw $t2, -4($s2)
	sw $t2, 0($s2)
	sw $t2, 4($s2)
	sw $t2, -248($s2)
	sw $t1, -256($s2)
	sw $t1, -252($s2)
	sw $t1, -260($s2)
	sw $t1, -512($s2)
	sw $t2, -264($s2)
	sw $t2, -508($s2)
	sw $t2, -516($s2)
	sw $t2, -764($s2)
	sw $t2, -772($s2)
	sw $t2, -1028($s2)
	sw $t2, -1020($s2)
	sw $t2, -1016($s2)
	sw $t2, -1032($s2)
	jr $ra
End:
	li $v0, 10
	syscall
