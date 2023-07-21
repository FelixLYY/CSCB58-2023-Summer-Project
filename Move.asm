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
.eqv Platform1 	0x1000a304
.eqv Platform2 	0x10009d50
.eqv Platform3 	0x1000a880
.eqv Platform4 	0x1000a2c0
.eqv Platform5 	0x1000b234
.eqv Bottom	0x1000be00
.eqv EndPixel	0x1000c000
.eqv Character 	0x1000a210
.eqv Mushroom	0x10009c60
.eqv Potion	0x1000b144
.eqv ExitDoor	0x1000a1d0
.eqv Score	0x10008210
.eqv Keystroke	0xffff0000
# Define Width, Height
.eqv Width		64
.eqv Height 		64

# Define Initial 
.eqv Characterx		4
.eqv Charactery		34
.eqv Mushroomx		24
.eqv Mushroomy		28
.eqv Potionx		17
.eqv Potiony		49
.eqv Initialvalue	0
.eqv PlatformColor	Green
# Character Attribute
.eqv CharacterOri	0
.eqv CharacterWidth	5
.eqv CharacterHeight	6
.eqv JumpHeight		20	
.eqv OriMovingSpeed	1
.eqv DownSpeed		1
.eqv UpSpeed		1
.eqv CharacterBalance	2
.eqv OriginalEye	Green
.eqv OriginalBody	Red
# Sleep time (Refresh rate)
.eqv Sleep		40
# Color
.eqv Red	0xff0000
.eqv Green	0x00ff00
.eqv Blue	0x0000ff
.eqv White	0xffffff
.eqv Yellow	0xffff00
.eqv Brown	0x964b00
# ASCII Value of keyboard input
.eqv ASCIIa	0x61
.eqv ASCIId	0x64
.eqv ASCIIp	0x70
.eqv ASCIIw	0x77

.data 
Value: 		.word	InitialValue
Characterxy: 	.word 	Characterx, Charactery
Mushroomxy: 	.word 	Mushroomx, Mushroomy
Potionxy:	.word	Potionx, Potiony
CharacterColor:	 .word	CharacterOri
RemainJumpDist:	 .word	0
CharacterPivot:	 .word	264
MovingSpeed:	.word	OriMovingSpeed
CharacterHeadPivot:	.word	-1532

.text
.globl Initialize

Initialize:				# Initialize all the value to default
	jal ClearScreen
	jal InitialCharacter
	jal InitialMushroom
	jal InitialPotion
	jal InitialValue
	j main
	li $t0, Blue
	li $t1, 0x1a1110
	sw $t0, 0($t1)
main:
	# Calculate the position of object
	jal CalculateCharacterPos
	jal CalculateMushroomPos
	jal CalculatePotionPos

	# Display 
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
	jal DisplayCharacter
	
	jal Hibernate

	jal ClearCharacter
	jal FetchInput
	jal Gravity
	jal CheckJump
	j main
	j End

CheckJump:
	lw $t1, RemainJumpDist
	beqz $t1, Return
	subi $t1, $t1, 1		# Now the character is jumping
	sw $t1, RemainJumpDist		# Update RemainJumpDist
	la $t0, Characterxy
	lw $t1, 4($t0)			# Check if is on top or hit any platform
	subi $t1, $t1, CharacterHeight
	beqz $t1, Return
	move $t1, $s0
	lw $t2, CharacterHeadPivot
	sub $t1, $t1, $t2
	lw $t2, 0($t1)
	beq $t2, PlatformColor, Return
	j Up

Up:					# Go up by 1 pixel if does not hit anything
	lw $t1, 4($t0)
	subi $t1, $t1, UpSpeed
	sw $t1, 4($t0)
	jr $ra
					

Gravity:				# Check if character fall
	lw $t0, RemainJumpDist
	bnez $t0, Return		# Don't fall if still jumping
	la $t0, Characterxy		# Load Characterxy to do calculation
	lw $t2, CharacterPivot
	add $t2, $s0, $t2		
	lw $t2, 0($t2)			# Check the pixel just under the character balance pivot
	bne $t2, PlatformColor, Down
	jr $ra

Down:					# Suppose t0 store xy coordinate
	lw $t1, 4($t0)			# Get y coordinate
	addi $t1, $t1, DownSpeed
	sw $t1, 4($t0)
	jr $ra
	
FetchInput:				# Check if user input char
	li $t9, Keystroke
	lw $t8, 0($t9)
	beq $t8, 1, Keypress_happened
	jr $ra				# No Input, exit

Keypress_happened:			# Have keyboard input, check which char is it
	lw $t2, 4($t9)
	beq $t2, ASCIIa, MoveLeft	# Input is a, move left
	beq $t2, ASCIId, MoveRight	# Input is d, move right
	beq $t2, ASCIIp, Startover	# Input is p, restart the game
	beq $t2, ASCIIw, Jump		# input is w, jump up
	jr $ra				# No the char we want, exit

MoveLeft:				# Move left if not on leftmost
	la $t0, Characterxy
	lw $t1, 0($t0)
	lw $t2, MovingSpeed
	sub $t1, $t1, $t2
	bgt $t1, 0, Left
	jr $ra

Left:					# Go left by 1 if greater than 0
	lw $t1, 0($t0)
	lw $t2, MovingSpeed
	sub $t1, $t1, $t2
	sw $t1, 0($t0)
	jr $ra

MoveRight:				# Move right if no on rightmost
	la $t0, Characterxy
	lw $t1, 0($t0)
	li $t2, Width
	sub $t2, $t2, CharacterWidth	# Get max width including width of character
	lw $t3, MovingSpeed
	add $t1, $t1, $t3
	blt $t1, $t2, Right 
	jr $ra

Right:					# Plus 1 if less than Width
	lw $t1, 0($t0)
	lw $t2, MovingSpeed
	add $t1, $t1, $t2
	sw $t1, 0($t0)
	jr $ra

Startover:
	j Initialize

Jump:
	lw $t1, RemainJumpDist
	bnez $t1, Return		# Return if you still have jump distance
	lw $t2, CharacterPivot
	add $t2, $s0, $t2		
	lw $t2, 0($t2)			# Check the pixel just under the character balance pivot
	beq $t2, PlatformColor, Fly

	jr $ra

Fly:					# Give jump distance
	li $t0, JumpHeight
	sw $t0, RemainJumpDist
	jr $ra

Hibernate:				# Sleep by a given time
	li $v0, 32
	li $a0, Sleep 
	syscall
	jr $ra

InitialCharacter:
	la $t0, Characterxy
	li $t1, Characterx
	sw $t1, 0($t0)
	li $t1, Charactery
	sw $t1, 4($t0)
	li $t1, CharacterOri
	sw $t1, CharacterColor
	sw $zero, RemainJumpDist	# Reset to no jump
	li $t1, OriMovingSpeed
	sw $t1, MovingSpeed
	j CalculateBalance

CalculateBalance:			# Calculate where to check to see if character fall
	li $t1, Width			# The point to check is (Width + CharacterMiddle) * 4
	addi $t1, $t1, CharacterBalance
	addi $t2, $zero, 4
	mult $t1, $t2
	mflo $t1
	sw $t1, CharacterPivot
	j CalculateHead

CalculateHead:
	li $t1, Width		# The point to check is (Width * CharacterHeight - CharacterMiddle) * 4
	addi $t2, $zero, CharacterHeight
	mult $t1, $t2
	mflo $t1
	subi $t1, $t1, CharacterBalance
	addi $t2, $zero, 4
	mult $t1, $t2
	mflo $t1
	sw $t1, CharacterHeadPivot
	jr $ra
	
InitialMushroom:
	la $t0, Mushroomxy
	li $t1, Mushroomx
	sw $t1, 0($t0)
	li $t1, Mushroomy
	sw $t1, 4($t0)
	jr $ra

InitialPotion:
	la $t0, Potionxy
	li $t1, Potionx
	sw $t1, 0($t0)
	li $t1, Potiony
	sw $t1, 4($t0)
	jr $ra

InitialValue:
	li $t0, Initialvalue
	sw $t0, Value
	jr $ra

CalculatePotionPos:			# Calculate the position of the Potion, Base_Address + (x+y*64)*4
	la $t0, Potionxy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s2, $t0
	jr $ra

CalculateMushroomPos:			# Calculate the position of the Mushroom, Base_Address + (x+y*64)*4
	la $t0, Mushroomxy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s1, $t0
	jr $ra

CalculateCharacterPos:			# Calculate the position of the character, Base_Address + (x+y*64)*4
	la $t0, Characterxy		# Only this function can modify $s0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s0, $t0
	jr $ra
	
Calculate:				# Calculate based on t0 = xy of thing
	lw $t1, 0($t0)			# x
	lw $t2, 4($t0)			# y
	li $t3, Width
	mult $t3, $t2
	mflo $t2
	add $t0, $t2, $t1
	addi $t1, $zero, 4
	mult $t1, $t0
	mflo $t0
	addi $t0, $t0, BASE_ADDRESS

	jr $ra
	

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
	
DisplayCharacter:		# Check to display original or yellow character
	lw $t0, CharacterColor
	bne $t0, CharacterOri, YellowCharacter
	j OriginalCharacter
	
OriginalCharacter:		# Display Original Character
	li $t1, OriginalBody 
	li $t2, OriginalEye

	j CreateCharacter

YellowCharacter:		# Display Yellow Character
	li $t1, Yellow 
	li $t2, Red 

	j CreateCharacter

Exit:				# Display Exit Door
	li $t0, ExitDoor
	li $t1, White
	li $t2, Brown
	j CreateExitDoor

CreateExitDoor:			# Display Door
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
	li $t2, PlatformColor

	j InitPlat

	
CreatePlatform2:
	li $t0, Platform2
	li $t2, PlatformColor

	j InitPlat

CreatePlatform3:
	li $t0, Platform3
	li $t2, PlatformColor

	j InitPlat

CreatePlatform4:
	li $t0, Platform4
	li $t2, PlatformColor

	j InitPlat


CreatePlatform5:
	li $t0, Platform5
	li $t2, PlatformColor

	j InitPlat

	
InitPlat:
	sw $t2, -4($t0)
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
	
Return:
	jr $ra
	
End:
	li $v0, 10
	syscall