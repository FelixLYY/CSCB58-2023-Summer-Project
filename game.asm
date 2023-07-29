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
.eqv BASE_ADDRESS 0x10008000
.eqv WinningScore 0x10009540
.eqv WinningMark  0x100095c4
.eqv You_Lose	0x10008828
.eqv You_Win	0x10008828
.eqv Press	0x1000a020
.eqv Restart	0x1000b040
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
# .eqv ExitDoor	0x1000a1d0
.eqv Score	0x10008210
.eqv Keystroke	0xffff0000
.eqv Mark	0x10008294
# Define Standard
.eqv Width		64
.eqv Height 		64
.eqv No			0
.eqv Yes		1
.eqv Left 		0
.eqv Right 		1

# Define Initial 
.eqv Characterx		4
.eqv Charactery		34
.eqv Mushroomx		24
.eqv Mushroomy		28
.eqv Potionx		17
.eqv Potiony		49
.eqv Doorx		54
.eqv Doory		33
.eqv Initialvalue	0
.eqv PlatformColor	Green
.eqv LoseColor		Green
.eqv WinColor		Green
.eqv RestartColor	Green
.eqv ScoreColor		White
.eqv Platform2x		20
.eqv Platform2y		29
.eqv Platform3x		32
.eqv Platform3y		40
.eqv Platform5x		13
.eqv Platform5y		50

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
.eqv TransformBody	Yellow
.eqv TransformEye	Red

# Object Attribute
.eqv MushroomRadius	1
.eqv MushroomMovDist	3
.eqv MushroomDirection	Right
.eqv MushroomColor	Yellow
.eqv PotionRadius	1
.eqv PotionEffect	2
.eqv PotionMovDist	3
.eqv PotionDirection	Left
.eqv PotionColor	Blue
.eqv PotionGlassColor 	White
.eqv DoorColor		Brown
.eqv HandleColor	White
.eqv DoorRadius		1
.eqv Platform2Direction Left
.eqv Platform2MovDist	2
.eqv Platform3Direction Left
.eqv Platform3MovDist	8
.eqv Platform5Direction Left
.eqv Platform5MovDist	4
# Sleep time (Refresh rate)
.eqv Sleep		60

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
Value: 			.word	InitialValue
Characterxy: 		.word 	Characterx, Charactery				# s0
Mushroomxy: 		.word 	Mushroomx, Mushroomy, MushroomDirection	# s1
Potionxy:		.word	Potionx, Potiony, PotionDirection		# s2
Doorxy:			.word	Doorx, Doory					# s3
Platform2xy:		.word	Platform2x, Platform2y, Platform2Direction	# s4
Platform3xy:		.word	Platform3x, Platform3y, Platform3Direction	# s5
Platform5xy:		.word	Platform5x, Platform5y, Platform5Direction	# s6
CharacterColor:	 	.word	CharacterOri
RemainJumpDist:	 	.word	0
CharacterPivot:	 	.word	264
MovingSpeed:		.word	OriMovingSpeed
CharacterHeadPivot:	.word	-1532
MushroomCollided:	.word	No
PotionCollided:		.word 	No


.text
.globl Initialize

################ Initialize Display ################ 
Initialize:				# Initialize all the value to default
	jal ClearScreen
	jal InitialCharacter
	jal InitialMushroom
	jal InitialPotion
	jal InitialValue
	jal InitialPlatform2
	jal InitialPlatform3
	jal InitialPlatform5
	jal CalculateDoor
	j main

InitialPlatform2:
	la $t0, Platform2xy
	li $t1, Platform2x
	sw $t1, 0($t0)
	li $t1, Platform2y
	sw $t1, 4($t0)
	li $t1, Platform2Direction
	sw $t1, 8($t0)
	jr $ra
	
InitialPlatform3:
	la $t0, Platform3xy
	li $t1, Platform3x
	sw $t1, 0($t0)
	li $t1, Platform3y
	sw $t1, 4($t0)
	li $t1, Platform3Direction
	sw $t1, 8($t0)
	jr $ra
	
InitialPlatform5:
	la $t0, Platform5xy
	li $t1, Platform5x
	sw $t1, 0($t0)
	li $t1, Platform5y
	sw $t1, 4($t0)
	li $t1, Platform5Direction
	sw $t1, 8($t0)
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

InitialMushroom:
	la $t0, Mushroomxy
	li $t1, Mushroomx
	sw $t1, 0($t0)
	li $t1, Mushroomy
	sw $t1, 4($t0)
	li $t1, MushroomDirection
	sw $t1, 8($t0)
	li $t1, No
	sw $t1, MushroomCollided
	jr $ra

InitialPotion:
	la $t0, Potionxy
	li $t1, Potionx
	sw $t1, 0($t0)
	li $t1, Potiony
	sw $t1, 4($t0)
	li $t1, PotionDirection
	sw $t1, 8($t0)
	li $t1, No
	sw $t1, PotionCollided
	jr $ra

InitialValue:
	li $t0, Initialvalue
	sw $t0, Value
	jr $ra

################ Main Loop ################ 
main:
	# Calculate the position of object
	jal CalculateCharacterPos
	jal CalculateMushroomPos
	jal CalculatePotionPos
	jal CalculatePlatform2Pos
	jal CalculatePlatform3Pos
	jal CalculatePlatform5Pos
	# Display 
	jal CreatePlatform1
	jal CreatePlatform2
	jal CreatePlatform3
	jal CreatePlatform4
	jal CreatePlatform5
	jal Sea
	jal Exit
	jal DisplayScore
	
	jal ColorMushroom
	jal ColorPotion
	jal DisplayCharacter
	
	jal Hibernate
	
	jal FailCondition
	jal WinCondition


	jal FetchInput
	jal Gravity
	jal MovePotion
	jal MoveMushroom
	jal MovePlatform2
	jal MovePlatform3
	jal MovePlatform5
	jal CheckJump
	jal CheckHitMushroom
	jal CheckHitPotion
	
	jal ClearCharacter
	jal ClearPotion
	jal ClearMushroom
	jal ClearPlatform2
	jal ClearPlatform3
	jal ClearPlatform5
	j main

################ Winning Page ################ 
WinCondition:				# Check collision with door
	la $t0, Doorxy
	la $t1, Characterxy
	lw $t2, 4($t0)
	lw $t3, 4($t1)
	bne $t2, $t3, Return		# Check if it is on same horizontal level
	lw $t2, 0($t0)			
	addi $t3, $t2, DoorRadius
	subi $t2, $t2, DoorRadius	# interval of Door size 
	lw $t4, 0($t1)
	addi $t5, $t4, CharacterWidth	# interval of Character size
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)			# Push Door size
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)			# Push Character size
	jal CheckInterval
	j DoorCollideHapp
	
DoorCollideHapp:
	lw $t0, 0($sp)			# Pop the collide flag from stack
	addi $sp, $sp, 4
	beq $t0, No, PopReturn		
	# It collide
	jal ClearScreen
	j Win

Win:					# Display Win Page
	la $t0, You_Win
	li $t2, WinColor
	jal DisplayY			# Display "You Win"
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

	li $t2, ScoreColor
	li $t0, WinningScore
	li $t1, WinningMark
	addi $sp, $sp, -4	# Push Score
	sw $t0, 0($sp)
	addi $sp, $sp, -4	# Push Mark
	sw $t1, 0($sp)
	addi $sp, $sp, -4	# Push ScoreColor
	sw $t2, 0($sp)
	jal DisplayScoreHelp
	j ClickRestart

################ Failing Condition ################ 
FailCondition:
	la $t0, Characterxy
	lw $t1, 4($t0)			# Get y coordinate of Character
	beq $t1, Height, Lose		# You Lose
	j Return			# Did not lose

Lose:
	jal ClearScreen
	li $t0, You_Lose 
	li $t2, LoseColor 

	jal DisplayY
	addi $t0, $t0, 28
	jal DisplayO
	addi $t0, $t0, 20
	jal DisplayU
	addi $t0, $t0, 56
	jal DisplayL
	addi $t0, $t0, 24
	jal DisplayO
	addi $t0, $t0, 24
	jal DisplayS
	addi $t0, $t0, 16
	jal DisplayE
	j ClickRestart

ClickRestart:
	li $t0, Press
	li $t2, RestartColor
	jal DisplayP			# Display "PRESS"
	addi $t0, $t0, 20
	jal DisplayR
	addi $t0, $t0, 20
	jal DisplayE
	addi $t0, $t0, 20
	jal DisplayS
	addi $t0, $t0, 16
	jal DisplayS
	addi $t0, $t0, 36
	jal DisplayP			# Display "P"
	addi $t0, $t0, 36
	jal DisplayT			# Display "TO"
	addi $t0, $t0, 24
	jal DisplayO
	li $t0, Restart			# Display "RESTART"
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
	j WaitForRestart

WaitForRestart:
	jal FetchInput
	j WaitForRestart

################ Calculation ################ 
CalculateDoor:
	la $a0, Doorxy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s3, $v0
	jr $ra

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

CalculatePotionPos:			# Calculate the position of the Potion, Base_Address + (x+y*64)*4
	la $a0, Potionxy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s2, $v0
	jr $ra

CalculatePlatform2Pos:
	la $a0, Platform2xy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s4, $v0
	jr $ra

CalculatePlatform3Pos:
	la $a0, Platform3xy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s5, $v0
	jr $ra

CalculatePlatform5Pos:
	la $a0, Platform5xy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s6, $v0
	jr $ra
	
CalculateMushroomPos:			# Calculate the position of the Mushroom, Base_Address + (x+y*64)*4
	la $a0, Mushroomxy
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s1, $v0
	jr $ra

CalculateCharacterPos:			# Calculate the position of the character, Base_Address + (x+y*64)*4
	la $a0, Characterxy		# Only this function can modify $s0
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal Calculate
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	move $s0, $v0
	jr $ra
	
Calculate:				# Calculate based on t0 = xy of thing, result is on $t0
	move $t0, $a0
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
	move $v0, $t0
	jr $ra
	
################ Display ################ 
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

DisplayScore:			# Display Score
	li $t2, ScoreColor
	li $t0, Score
	li $t1, Mark
	addi $sp, $sp, -4	# Push Score
	sw $t0, 0($sp)
	addi $sp, $sp, -4	# Push Mark
	sw $t1, 0($sp)
	addi $sp, $sp, -4	# Push ScoreColor
	sw $t2, 0($sp)
	j DisplayScoreHelp

DisplayScoreHelp:
	lw $t2, 0($sp)		# Pop ScoreColor
	addi $sp, $sp, 4
	lw $t1, 0($sp)		# Pop Mark
	addi $sp, $sp, 4
	lw $t0, 0($sp)		# Pop Score
	addi $sp, $sp, 4

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
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
	move $t0, $t1
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
	beq $t3, 0, Display0	# Score = 0
	beq $t3, 1, Display1	# Score = 1
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
	bne $t0, CharacterOri, TransformCharacter
	j OriginalCharacter
	
OriginalCharacter:		# Display Original Character
	li $t1, OriginalBody 
	li $t2, OriginalEye

	j CreateCharacter

TransformCharacter:		# Display Yellow Character
	li $t1, TransformBody 
	li $t2, TransformEye

	j CreateCharacter

Exit:				# Display Exit Door
	move $t0, $s3
	li $t1, HandleColor
	li $t2, DoorColor
	j CreateExitDoor

CreateExitDoor:			# Display Door
	sw $t2, -8($t0)
	sw $t2, -4($t0)
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, -264($t0)
	sw $t2, -260($t0)
	sw $t2, -256($t0)
	sw $t2, -252($t0)
	sw $t2, -248($t0)
	sw $t2, -520($t0)
	sw $t2, -516($t0)
	sw $t2, -512($t0)
	sw $t1 -508($t0)
	sw $t2, -504($t0)
	sw $t2, -776($t0)
	sw $t2, -772($t0)
	sw $t2, -768($t0)
	sw $t2, -764($t0)
	sw $t2, -760($t0)
	sw $t2, -1032($t0)
	sw $t2, -1028($t0)
	sw $t2, -1024($t0)
	sw $t2, -1020($t0)
	sw $t2, -1016($t0)
	sw $t2, -1288($t0)
	sw $t2, -1284($t0)
	sw $t2, -1280($t0)
	sw $t2, -1276($t0)
	sw $t2, -1272($t0)
	sw $t2, -1544($t0)
	sw $t2, -1540($t0)
	sw $t2, -1536($t0)
	sw $t2, -1532($t0)
	sw $t2, -1528($t0)
	sw $t2, -1800($t0)
	sw $t2, -1796($t0)
	sw $t2, -1792($t0)
	sw $t2, -1788($t0)
	sw $t2, -1784($t0)
	jr $ra

ColorMushroom:
	lw $t0, MushroomCollided
	bne $t0, No, Return
	li $t2, MushroomColor
	j CreateMushroom

ColorPotion:
	lw $t0, PotionCollided
	bne $t0, No, Return
	li $t2, PotionGlassColor
	li $t1, PotionColor
	j CreatePotion
	
CreatePlatform1:
	li $t0, Platform1
	li $t2, PlatformColor

	j InitPlat

	
CreatePlatform2:
	move $t0, $s4
	li $t2, PlatformColor

	j InitPlat

CreatePlatform3:
	move $t0, $s5
	li $t2, PlatformColor

	j InitPlat

CreatePlatform4:
	li $t0, Platform4
	li $t2, PlatformColor

	j InitPlat


CreatePlatform5:
	move $t0, $s6
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
	sw $t2, 32($t0)
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
	sw $t2, -4($s1)
	sw $t2, 0($s1)
	sw $t2, 4($s1)
	sw $t2, -260($s1)
	sw $t2, -256($s1)
	sw $t2, -252($s1)
	sw $t2, -516($s1)
	sw $t2, -512($s1)
	sw $t2, -508($s1)
	sw $t2, -504($s1)
	sw $t2, -520($s1)
	sw $t2, -772($s1)
	sw $t2, -768($s1)
	sw $t2, -764($s1)
	sw $t2, -1024($s1)
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
	
################ Move ################ 
MoveMushroom:
	la $t0, Mushroomxy
	lw $t1, 0($t0)			# Get x coordinate of Mushroom
	lw $t2, 8($t0)			# Get moving direction
	li $t4, Mushroomx
	li $t5, MushroomMovDist
	beq $t2, Left, CheckLeft	# Go Left if move = left
	j CheckRight			# Go Right if move = right			

CheckLeft:				# Given t0 is xycoord, t1 = x coord, t2 = mov dir
					# t4 = Original x coord, t5 = Mov Dist
	subi $t3, $t1, 1		# Next left pos
	sub $t4, $t4, $t5		# Greatest left
	sw $t3, 0($t0)
	beq $t3, $t4, ChangeRightDir	# Reach greatest left, change dir to right
	j Return			# Does not reach max left, return

CheckRight:				# Given t0 is xycoord, t1 = x coord, t2 = mov dir
					# t4 = Original x coord, t5 = Mov Dist
	addi $t3, $t1, 1		# Next right pos
	add $t4, $t4, $t5		# Greatest right
	sw $t3, 0($t0)
	beq $t3, $t4, ChangeLeftDir	# Reach greatest right, change dir to left
	j Return			# Does not reach max right, return

MovePotion:
	la $t0, Potionxy
	lw $t1, 0($t0)			# Get x coordinate of Potion
	lw $t2, 8($t0)			# Get moving direction
	li $t4, Potionx
	li $t5, PotionMovDist
	beq $t2, Left, CheckLeft	# Go Left if move = left
	j CheckRight			# Go Right if move = right			

MovePlatform2:
	la $t0, Platform2xy
	lw $t1, 0($t0)			# Get x coordinate of Potion
	lw $t2, 8($t0)			# Get moving direction
	li $t4, Platform2x
	li $t5, Platform2MovDist
	beq $t2, Left, CheckLeft	# Go Left if move = left
	j CheckRight			# Go Right if move = right			

MovePlatform3:
	la $t0, Platform3xy
	lw $t1, 0($t0)			# Get x coordinate of Potion
	lw $t2, 8($t0)			# Get moving direction
	li $t4, Platform3x
	li $t5, Platform3MovDist
	beq $t2, Left, CheckLeft	# Go Left if move = left
	j CheckRight			# Go Right if move = right			

MovePlatform5:
	la $t0, Platform5xy
	lw $t1, 0($t0)			# Get x coordinate of Potion
	lw $t2, 8($t0)			# Get moving direction
	li $t4, Platform5x
	li $t5, Platform5MovDist
	beq $t2, Left, CheckLeft	# Go Left if move = left
	j CheckRight			# Go Right if move = right			

ChangeRightDir:				# Change dir to right, assume t0 hold the xycoordinate
	li $t1, Right
	sw $t1, 8($t0)
	j Return

ChangeLeftDir:				# Change dir to left, assume t0 hold the xycoordinate
	li $t1, Left
	sw $t1, 8($t0)
	j Return
	
################ Check Collision ################ 
CheckHitPotion:				# Check if character overlap mushroom
	lw $t1, PotionCollided
	bne $t1, No, Return		# Already Collided
	la $t0, Potionxy
	la $t1, Characterxy
	lw $t2, 4($t0)
	lw $t3, 4($t1)
	bne $t2, $t3, Return		# Check if it is on same horizontal level
	lw $t2, 0($t0)			
	addi $t3, $t2, PotionRadius
	subi $t2, $t2, PotionRadius	# interval of Potion size 
	lw $t4, 0($t1)
	addi $t5, $t4, CharacterWidth	# interval of Character size
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)			# Push Potion size
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)			# Push Character size
	jal CheckInterval
	j PotionCollideHapp


PotionCollideHapp:
	lw $t0, 0($sp)			# Pop the collide flag from stack
	addi $sp, $sp, 4
	beq $t0, No, PopReturn
	sw $t0, PotionCollided		# It collide
	lw $t1, Value
	addi $t1, $t1, 1
	sw $t1, Value
	lw $t1, MovingSpeed
	addi $t1, $t1, PotionEffect
	sw $t1, MovingSpeed
	jal ClearValue
	jal ClearPotion
	j PopReturn

CheckHitMushroom:			# Check if character overlap mushroom
	lw $t1, MushroomCollided
	bne $t1, No, Return		# Already Collided
	la $t0, Mushroomxy
	la $t1, Characterxy
	lw $t2, 4($t0)
	lw $t3, 4($t1)
	bne $t2, $t3, Return		# Check if it is on same horizontal level
	lw $t2, 0($t0)			
	addi $t3, $t2, MushroomRadius
	subi $t2, $t2, MushroomRadius	# interval of Mushroom size 
	lw $t4, 0($t1)
	addi $t5, $t4, CharacterWidth	# interval of Character size
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $sp, $sp, -4
	sw $t2, 0($sp)
	addi $sp, $sp, -4
	sw $t3, 0($sp)			# Push Mushroom size
	addi $sp, $sp, -4
	sw $t4, 0($sp)
	addi $sp, $sp, -4
	sw $t5, 0($sp)			# Push Character size
	jal CheckInterval
	j MushCollideHapp
	
MushCollideHapp:
	lw $t0, 0($sp)			# Pop the collide flag from stack
	addi $sp, $sp, 4
	beq $t0, No, PopReturn		
	sw $t0, MushroomCollided	# It Collide
	lw $t1, Value
	addi $t1, $t1, 1
	sw $t1, Value
	lw $t1, CharacterColor
	addi $t1, $t1, 1
	sw $t1, CharacterColor
	jal ClearValue
	jal ClearMushroom
	j PopReturn
	
CheckInterval:
	lw $t0, 0($sp)			# Greatest character x
	addi $sp, $sp, 4
	lw $t1, 0($sp)			# Least character x
	addi $sp, $sp, 4
	lw $t2, 0($sp)			# Greatest object x
	addi $sp, $sp, 4
	lw $t3, 0($sp)			# Least object x
	addi $sp, $sp, 4
	j CheckLowestx
	jr $ra

CheckLowestx:
	bge $t3, $t1, CheckLowestx2	
	j CheckHighestx

CheckLowestx2:
	ble $t3, $t0, Collided
	j CheckHighestx
	
CheckHighestx:
	bge $t2, $t1, CheckHighestx2
	j NotCollided
	
CheckHighestx2:
	ble $t2, $t0, Collided
	j NotCollided
	
Collided:
	li $t0, Yes
	j PushStack

NotCollided:
	li $t0, No
	j PushStack

################ Jump & Gravity ################ 
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
	
################ KeyInput ################ 
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
	bgt $t1, 0, LeftSpeed
	jr $ra

LeftSpeed:					# Go left by 1 if greater than 0
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
	blt $t1, $t2, RightSpeed
	jr $ra

RightSpeed:					# Plus 1 if less than Width
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
	
################ Sleep  ################ 
Hibernate:				# Sleep by a given time
	li $v0, 32
	li $a0, Sleep 
	syscall
	jr $ra

################ Clear ################ 
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
	li $t0, Mark
	lw $t3, Value 
	subi $t3, $t3, 1
	li $t4, 1
	add $t2, $zero, $zero
	beqz $t3, Display0	# Score = 0
	beq $t3, $t4, Display1	# Score = 1
	j Display2		# Score = 2

ClearPotion:
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	j CreatePotion

ClearMushroom:
	add $t1, $zero, $zero
	add $t2, $zero, $zero
	j CreateMushroom

ClearPlatform2:
	move $t0, $s4
	add $t2, $zero, $zero
	j InitPlat
	
ClearPlatform3:
	move $t0, $s5
	add $t2, $zero, $zero
	j InitPlat
	
ClearPlatform5:
	move $t0, $s6
	add $t2, $zero, $zero
	j InitPlat
	
ClearCharacter:
	add $t1, $zero, $zero
	add $t2, $zero, $zero

	j CreateCharacter

################ Return Method ################ 
PopReturn:				# Pop ra from stack and return
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

PushStack:
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	j Return

Return:
	jr $ra
	
End:
	li $v0, 10
	syscall

