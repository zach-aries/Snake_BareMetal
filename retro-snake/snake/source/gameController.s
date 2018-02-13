/**/
.section    .init
.section .text

.globl gameController
gameController:
	
	push {r4,r5,lr}	

	bl initGame

	bl gameFunction

	//bl resetGame		// only call from within my function
	//bl gameFunction		// only call from within my function

	// gameFunction returns button pressed in r0! Check if buttonPressed == 4

	
	/**********************************/
		// Loop to check if buttonPressed == "4" && optionChosen was "RESTART GAME"
		cmp		r0, #4
		beq		inGameMenuLoop
	inGameMenuLoop:

		bl 		init_InGameMenu

		cmp		r0, #4
		beq		inGameMenuLoop

	skipInGameMenu:
	/**********************************/
	pop {r4,r5,lr}
	bx	lr
/*
 * Win Game Function
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
winGame:
	push {r4-r8,lr}

	bl init_WonGameMenu

	pop {r4-r8,lr}
	bx lr
/*
 * Add Clock
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
addClock:
	push {r4-r8,lr}

	redoAddClock:

	bl randomNumber
	mov r5, r0

	bl randomNumber
	mov r6, r0

	// Checks to make sure that the apple
	// is generated within the bounds of the map
	// if it is not then we generate another apple
	cmp r5, #1
	blt redoAddClock

	cmp r5, #62
	bgt redoAddClock

	cmp r6, #9
	blt redoAddClock

	cmp r6, #46
	bgt redoAddClock

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl getGridState

	cmp r0, #0
	bgt redoAddClock

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl drawClock		// draw the rock to the stage

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	mov r2, #5	// set rock state
	bl setGridState	// r0 = x r 1 = y

	pop {r4-r8,lr}
	bx lr



/*
 * Create Door
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
createDoor:
	push {r4-r8,lr}

	redoCreateDoor:

	bl randomNumber
	mov r5, r0

	bl randomNumber
	mov r6, r0

	// Checks to make sure that the apple
	// is generated within the bounds of the map
	// if it is not then we generate another apple
	cmp r5, #1
	blt redoCreateDoor

	cmp r5, #62
	bgt redoCreateDoor

	cmp r6, #9
	blt redoCreateDoor

	cmp r6, #46
	bgt redoCreateDoor

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl getGridState

	cmp r0, #0
	bgt redoCreateDoor

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl drawHole		// draw the rock to the stage

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	mov r2, #4	// set rock state
	bl setGridState	// r0 = x r 1 = y

	pop {r4-r8,lr}
	bx lr
/*
 * Get Score
 *	arguments:
 *		none
 * 	returns: 
 *		r0 - score
 */
.globl getScore
getScore:
	push {r4-r8,lr}

	// Draw Score
	ldr r4, =snake_size
	ldr r4, [r4]
	sub r0, r4, #3

	pop {r4-r8,lr}
	bx lr

/*
 * Draw Score Board
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
drawScoreBoard:
	push {r4-r8,lr}

	// Score
	mov	r0, #128
	mov	r1, #30
	ldr	r2, =0xFFFF
	ldr	r3, =fmt_Score
	bl	drawText

	mov	r0, #200
	mov	r1, #30
	ldr	r2,	=0x5B0B
	bl  drawColouredUnit

	bl getScore		// get score
	mov r3, r0	// move to r3 for print

	mov	r0, #200
	mov	r1, #30
	ldr	r2, =0xFFFF
	bl	drawNumber

	//Lives
	mov	r0, #128
	mov	r1, #60
	ldr	r2, =0xFFFF
	ldr	r3, =fmt_Lives
	bl	drawText

	mov	r0, #200
	mov	r1, #60
	ldr	r2,	=0x5B0B
	bl  drawColouredUnit

	ldr r3, =lives
	ldr r3, [r3]

	mov	r0, #200
	mov	r1, #60
	ldr	r2, =0xFFFF
	bl	drawNumber

	pop {r4-r8,lr}
	bx lr
/*
 * Game Function
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * Contains the main game loop and game functionality
 */
.globl gameFunction
gameFunction:
	push {r4-r8,lr}

	mov r4, #1

	gameLoop:
		ldr r0, =speed
		ldr r0, [r0]
		bl delay
		
		bl event_buttonPressed
		bl buttonPressed

		cmp r1, #0
		beq skipHeadStore

		cmp r0, #4
		beq exitGameLoop

		ldr r5, =snakeArray
		str r0,[r5, #16]
		mov r4, r0

		skipHeadStore:
		
		mov r0, r4
		bl updateMap

	b	gameLoop

	exitGameLoop:

	pop {r4-r8,lr}
	bx lr
/*
 * Clear Grid 
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * Clears the grid used to store all the states of tiles, sets all tiles to 0
 */
.globl clearGrid
clearGrid:
	push {r4-r8,lr}

	mov r4, #0		// counter
	ldr r5, =0xC00		// set r5 to 3072
	ldr r6, =GridBuffer	// load grid buffer address
	mov r8, #0		// mov clear state to r8

	clearGridLoop:	
		lsl r7, r4, #2		// offset counter by 4
		str r8, [r6, r7]	// store clear state into grid offset by counter
		
		add r4, #1		// inc counter
		cmp r4, r5		// if( counter < 1032 ) continue
		blt clearGridLoop	// branch back to clear grid

	pop {r4-r8,lr}
	bx lr


/*
 * Reset Game
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * Resets game if there are lives left
 */
.globl resetGame
resetGame:
	push {r4-r8,lr}

	ldr r4, =speed		// reset speed of snake
	ldr r5, =0xF4240
	str r5,[r4]

	ldr r5, =lives
	ldr r4, [r5]

	cmp r4, #1
	bgt	continueGameReset
	
	bl init_LostGameMenu

	continueGameReset:

	sub r4, #1
	str r4, [r5]
	
	bl clearGrid

	ldr r4, =snake_size
	mov r5, #0
	str r5, [r4]
	
	bl 	drawBackground	// print background
	bl 	drawBorder	// draw border

	bl	initSnake	// init snake
	bl 	addApple	// add apple

	bl	drawScoreBoard
	
	mov r4, #0
	generateRockLoopReset:
		bl 	addRock
	
		add r4, #1
		cmp r4, #30
		blt generateRockLoopReset

	pop {r4-r8,lr}
	bx lr

/*
 * Initiate Game
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
.globl initGame
initGame:
	push {r4, lr}

	bl clearGrid

	ldr r5, =lives
	mov r4, #3
	str r4, [r5]
	

	ldr r4, =snake_size
	mov r5, #0
	str r5, [r4]

	ldr r4, =speed		// reset speed of snake
	ldr r5, =0xF4240
	str r5,[r4]
	
	bl 	drawBackground	// call print functio
	bl 	drawBorder

	bl	initSnake
	bl 	addApple

	bl	drawScoreBoard
	
	mov r4, #0
	generateRockLoop:
		bl 	addRock
	
		add r4, #1
		cmp r4, #30
		blt generateRockLoop
	

	pop {r4, lr}
	bx lr

/*
 * Initiate Snake
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
.globl initSnake
initSnake:
	push {r4, r5, lr}

	// draw snake head
	mov	r0, #4 	// x
	mov	r1, #28	// y
	mov	r2, #1	// dir
	mov	r3, #0	// body part
	bl 	addSnake

	// draw snake body
	mov	r0, #3
	mov	r1, #28
	mov	r2, #1
	mov	r3, #1
	bl 	addSnake

	// draw snake tail
	mov	r0, #2
	mov	r1, #28
	mov	r2, #1
	mov	r3, #3
	bl 	addSnake

	pop {r4, r5, lr}
	bx lr

/*
 * Get Grid State
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
 *		r0 - grid state
 * Gets the state of the grid at specified x,y coords
 * 0 - grass, 1 - brick, 2 = apple, 3 = snake, 4 = exit, 5 = clock
 */
.globl getGridState
getGridState:
	push {r4,r5,r6,r7,r8,lr}

	mov r4, r0
	mov r5, r1

	ldr r8, =GridBuffer

	// add to grid buffer
	mov r7, #48		// m
	mul r4, r4, r7		// i * m
	add r5, r4		// + j
	
	mov r7, #4		// Esize
	mul r5, r5, r7		// * Esize
	
	ldr r0, [r8, r5]		// store passed in state into grid

	pop {r4,r5,r6,r7,r8,lr}
	bx lr

/*
 * Set Grid State
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 *		r2 - state
 * 	returns: 
 *		none
 * Sets the state of the grid at specified x,y coords
 * 0 - grass, 1 - brick, 2 = apple, 3 = snake, 4 = exit, 5 = clock
 */
.globl setGridState
setGridState:
	push {r4,r5,r6,r7,r8,lr}

	mov r4, r0
	mov r5, r1
	mov r6, r2

	ldr r8, =GridBuffer

	// add to grid buffer
	mov r7, #48		// m
	mul r4, r4, r7		// i * m
	add r5, r4		// + j
	
	mov r7, #4		// Esize
	mul r5, r5, r7		// * Esize
	
	str r6, [r8, r5]		// store passed in state into grid

	pop {r4,r5,r6,r7,r8,lr}
	bx lr

/*
 * Add Rock
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
addRock:
	push {r4,r5,r6,lr}

	redoRockGen:

	bl randomNumber
	mov r5, r0

	bl randomNumber
	mov r6, r0

	// Checks to make sure that the apple
	// is generated within the bounds of the map
	// if it is not then we generate another apple
	cmp r5, #1
	blt redoRockGen

	cmp r5, #62
	bgt redoRockGen

	cmp r6, #9
	blt redoRockGen

	cmp r6, #46
	bgt redoRockGen

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl getGridState

	cmp r0, #0
	bgt redoRockGen

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	bl drawRock		// draw the rock to the stage

	mov r0, r5		// grab generated rock x
	mov r1, r6		// grab generated rock y
	mov r2, #1	// set rock state
	bl setGridState	// r0 = x r 1 = y

	pop {r4,r5,r6,lr}
	bx lr

/*
 * Add Apple
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
addApple:
	push {r4,r5,r6,lr}

	redoAppleGen:

	bl randomNumber
	mov r5, r0

	bl randomNumber
	mov r6, r0

	// Checks to make sure that the apple
	// is generated within the bounds of the map
	// if it is not then we generate another apple

	cmp r5, #1
	blt redoAppleGen

	cmp r5, #62
	bgt redoAppleGen

	cmp r6, #9
	blt redoAppleGen

	cmp r6, #46
	bgt redoAppleGen

	mov r0, r5		// grab generated apple x
	mov r1, r6		// grab generated apple y
	bl getGridState

	cmp r0, #0
	bgt redoAppleGen

	mov r0, r5		// grab generated apple x
	mov r1, r6		// grab generated apple y
	bl drawApple		// draw the apple to the stage

	mov r0, r5		// grab generated apple x
	mov r1, r6		// grab generated apple y
	mov r2, #2		// set apple state
	bl setGridState		// r0 = x r 1 = y

	pop {r4,r5,r6,lr}
	bx lr

/* Divide Function
 * Arguments:
 *	r0 - Numerator
 *	r1 - Denominator
 * Returns: 
 *	r0 - r0/r1
 */
.globl divide 
divide:
	push {r4, r5, r6}
	
	mov r4, r0
	mov r5, r1

    	mov r6, r1             /* r6 ← r1. We keep D in r6 */
	mov r5, r4             /* r1 ← r4. We keep N in r1 */
	
	mov r4, #0             /* r4 ← 0. Set Q = 0 initially */
 
	b divCheck

	divideLoop:
		add r4, r4, #1      /* r4 ← r4 + 1. Q = Q + 1 */
		sub r5, r5, r6      /* r5 ← r5 - r6 */

	divCheck:
		cmp 	r5, r6          /* compute r5 - r6 */
		bhs	divideLoop	/* branch if r5 >= r6 (C=0 or Z=1) */

	mov r0, r4
	mov r1, r5
	
	pop {r4, r5,r6}
	bx lr

/* Random Number Generator
 * Arguments:
 *	r0 - seed
 * Returns: 
 *	r0 - random number
 * Returns a random number between 0 - 99
 */
randomNumber:
	push {r4,r5,r6,r7,r8,r9,r10,lr}

	x	.req	r4
	y	.req	r5
	z	.req	r6
	w	.req	r7
	t	.req	r8

	ldr r9, =seed
	ldr t,[r9]	// uint32_t t = x;
	
	lsl r0, t, #11	// t << 11
	eor t, t, r0	// t ^= t << 11

	lsr r0, t, #8	// t >> 8
	eor t, t, r0	// t ^= t >> 8

	ldr x, [r9, #4]
	ldr y, [r9, #8]
	ldr z, [r9, #12]
	mov w, z

	lsr r0, w, #19
	eor w, w, r0
	eor w, w, t

	

	mov r0, w
	ldr r10, =0xFFF
	testRandom:
	and r0, r0, r10

	str x, [r9, #0]
	str y, [r9, #4]
	str z, [r9, #8]
	str w, [r9, #12]
	
	.unreq	x
	.unreq	y
	.unreq	z
	.unreq	w
	.unreq	t
	
	
	pop {r4,r5,r6,r7,r8,r9,r10,lr}
	bx lr

/* Delay Function
 *	r0 - number of loop iterations
 * Returns: nothing
 */
delay:
	push	{r4, r5}

	mov r5, r0
	
	mov	r4, #0		// Move 0 into counter
		//ldr	r5, =1000000   // Very large delay

		blah:
			add	r4, #1		// Add to counter
			cmp	r4, r5		// Compare to how many times to loop
			blo	blah	// Branch till done the loop r5 times
	
	pop		{r4, r5}
	bx		lr

/* Test For Hit
 * Arguments:
 *	none
 * Returns: 
 *	none
 */
testForHit:
	push	{r4 - r10, lr}

	ldr r7, =snakeArray

	ldr r4, [r7, #4]	// load in head x
	ldr r5, [r7, #8]	// load in head y
	ldr r6, [r7, #12]	// load in head dir	

	mov r0, r4
	mov r1, r5

	bl getGridState
	mov r8, r0

	checkForApple:
		cmp r8, #2
		bne checkForWall

		mov r0, r4		// get x
		mov r1, r5		// get y
		mov r2, #0		// set arg 3 to 0 (ground)
		bl setGridState		// set grid state
		bl clearUnit

		ldr r9, =snakeArray
		ldr r10, =snake_size


		ldr r10, [r10]	// load in snake size
		sub r10, r10, #1 	// snake size - 1
		mov r7, #20		// move 20 into r7
		mul r7, r7, r10		// multiply 20 * ( snakesize -1 )

		add r7, r9, r7		// add offset to snakeArray address
		
		ldr r0, [r7, #4]	// load in tail x
		ldr r1, [r7, #8]	// load in tail y
		ldr r2, [r7, #12]	// load in tail direction

		mov r3, #1		// move body state (1) into r3
		bl drawSnake

		str r3, [r7]		// store body state into tail ( change tail to body )
		
		ldr r0, [r7, #4]	// load in tail x
		ldr r1, [r7, #8]	// load in tail y
		ldr r2, [r7, #12]	// load in tail direction

		mov r3, #3		// set body state to tail

		cmp r2, #0	// check if tail faces north
		bne checkHitTailWest
		add r1, r1, #1		// set new x coord

		checkHitTailWest:
			cmp r2, #1	// check if tail faces west
			bne checkHitTailSouth
			sub r0, r0, #1		// set new x coord

		checkHitTailSouth:
			cmp r2, #2	// check if tail faces south
			bne checkHitTailEast
			sub r1, r1, #1	 // set new x coord

		checkHitTailEast:
			cmp r2, #3	// check if tail faces east
			bne skipCheckHitTailEast
			add r0, r0, #1	 // set new x coord
		skipCheckHitTailEast:
		
		bl addSnake	// add tail to snake
		
		bl getScore	// get score and check to see if 20 apples have been eaten
		cmp r0, #20	// if the score/apples eaten is equal to 20 create a door
		blt checkForValuePack
			bl createDoor
			b skipAddApple
		checkForValuePack:
			cmp r0, #5
			bne continueAddApple
			bl addClock

		continueAddApple:
			ldr r4, =speed		// reset speed of snake
			ldr r5, [r4]
			ldr r6, =0x16E360

			cmp r5, r6
			bne dontRemoveValuePack
			ldr r5, =0xF4240
			str r5,[r4]

		dontRemoveValuePack:
			bl addApple	// add an apple	
		
		skipAddApple:
			bl drawScoreBoard	// draw new score to screen

		
	
	checkForWall:
		mov r0, r4
		mov r1, r5

		bl getGridState
		mov r8, r0

		cmp r8, #1	 		// see if spot in grid is a brick
		bne checkForSnake		// if so interupt, else check for snake

		bl resetGame

	checkForSnake:
		cmp r8, #3	 		// see if spot in grid is a brick
		bne checkForClock		// if so interupt, else check for an apple

		bl resetGame
	checkForClock:
		cmp r8, #5	 		// see if spot in grid is a brick
		bne checkForExit		// if so interupt, else check for an apple
		
		ldr r7, =0x16E360
		ldr r9, =speed
		str r7,[r9]
	checkForExit:
		cmp r8, #4	 		// see if spot in grid is a brick
		bne continueGame 		// if so interupt, else check for an apple

		bl winGame

	continueGame:
		
	pop		{r4 - r10, lr}
	bx		lr

/*
 * Update Map
 *	arguments:
 *		r0 - direction (int: 0=N, 1=E, 2=S, 3=W )
 *
 * 	returns: 
 *		none
 * Updates map
 */
updateMap:
	push {r4,r5,r6,r7,r8,r9,r10,lr}

	

	mov r6, r0

	ldr r4, = snake_size	// load snake size address
	ldr r4, [r4]		// load snake size into r4

	ldr r7, =snakeArray

	sub r9, r4, #1	// r9 = snakesize - 1
	mov r8, #20	// r8 = 20
	mul r9, r8, r9
	add r9, r7

	ldr r0,[r9, #4]
	ldr r1,[r9, #8]

	// clear unit
	bl clearUnit

	mov r5, #0
	updateSnakeLoop:
		
		mov r0, #20
		mul r0, r5, r0
		add r0, r7

		mov r1, r6
		bl moveSnake
		mov r6, r0
	
		add r5, #1
		cmp r5, r4
		blt updateSnakeLoop

	bl testForHit

	pop {r4,r5,r6,r7,r8,r9,r10,lr}
	bx lr

/*
 * Move Snake
 * Moves snake part at offset
 *	arguments:
 *		r0 - snakePart
 *		r1 - previous part address
 * 	returns: 
 *		r0 - direction
 * Animates the snake in the direction which the controller is pressed
 * also used an array to track snake parts in front of eachother and move themeselves accordingly
 */
moveSnake:
	push {r4,r5,r6,r7,r8,r9,lr}
	
	mov r4, r0
	mov r7, r1

	ldr r3, [r4, #0]	// body state = int (0 = head,1 = body,2 = curve,3 = tail)
	ldr r0, [r4, #4]	// x
	ldr r1, [r4, #8]	// y
	ldr r9, [r4, #12]	// current dir
	ldr r5, [r4, #16]	// load next step for execution

	// double over check
	cmp r3, #0
	bne skipDoubleOverCheck
	
	cmp r5, #0	// test if next step is north
	bne testEast
	
	teq r9, #2	// if it is test if direction faceing is south
	moveq r5, #2	// if direction facing is equal to south keep going south
	
	testEast:
		cmp r5, #1	// east
		bne testSouth

		teq r9, #3	// if it is test if direction faceing is south
		moveq r5, #3	// if direction facing is equal to south keep going south

	testSouth:
		cmp r5, #2	// south
		bne testWest

		teq r9, #0	// if it is test if direction faceing is south
		moveq r5, #0	// if direction facing is equal to south keep going south

	testWest:
		cmp r5, #3	// west
		bne skipDoubleOverCheck

		teq r9, #1	// if it is test if direction faceing is south
		moveq r5, #1	// if direction facing is equal to south keep going south

	skipDoubleOverCheck:

	cmp r5, #0	// north
	bne moveEast
	
	sub r1, r1, #1	// move north
	mov r6, r1
	mov r2, r5
	bl drawSnake
	str r6, [r4, #8]	// store y
	str r5, [r4, #12]	// store current direction
	

	moveEast:
		cmp r5, #1	// east
		bne moveSouth
		
		add r0, r0, #1
		mov r6, r0
		mov r2, r5
		bl drawSnake

		str r6, [r4, #4]	// store x
		str r5, [r4, #12]	// store current direction

	moveSouth:
		cmp r5, #2	// south
		bne moveWest
		// move south
		add r1, r1, #1
		mov r6, r1
		mov r2, r5
		bl drawSnake

		str r6, [r4, #8]	// store y
		str r5, [r4, #12]	// store current direction

	moveWest:
		cmp r5, #3	// west
		bne skipWestMove
		// move west

		sub r0, r0, #1
		mov r6, r0
		mov r2, r5
		bl drawSnake

		str r6, [r4, #4]	// store x
		str r5, [r4, #12]	// store current direction

	skipWestMove:
	
	cmp r3, #0
	beq skipNextStepStore

	str r7, [r4, #16]	// store prev part dir execution into current next_step
	
	skipNextStepStore:

	ldr r3, [r4]	// current snake part y
	ldr r0, [r4, #4]	// current snake part x
	ldr r1, [r4, #8]	// current snake part y

	cmp r3, #0
	beq returnMoveSnake

	cmp r3, #3	
	bne setGridAsSnake
		mov r2, #0
		bl setGridState
		b returnMoveSnake

	setGridAsSnake:
		mov r2, #3
		bl setGridState
	
	returnMoveSnake:
		mov r0, r5	// return current parts direction for loop

	pop {r4,r5,r6,r7,r8,r9,lr}
	bx lr


/*
 * Increment Snake
 * Increments snake size by one
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * Increments the stored size of snake
 */
incSnakeSize:
	push {lr}
		
	ldr r0, = snake_size	// load snake size address
	ldr r1, [r0]		// load snake size into r1
	add r1, r1, #1		// incriment r1

	str r1, [r0]		// store r1 into snake size

	pop {lr}
	bx lr

/*
 * Draw Snake
 *	arguments:
 *		r0 - x grid coord
 *		r1 - y grid coord
 *		r2 - direction
 *		r3 - body part
 * 	returns: 
		none
 * Draws snake part at a specific grid location
 */
drawSnake:
	push {r4,r5,lr}
	
	lsl	r0, #4
	lsl	r1, #4
	
	cmp	r3, #0
	bne	addBody
	bl 	drawSnakeHead	// draw head
	b	skipToAddSnakeArray

	addBody:
		cmp r3, #1
		bne	addCurve
		bl 	drawSnakeBody	// draw body
		b	skipToAddSnakeArray
	
	addCurve:
		cmp r3, #2
		bne	addTail
		bl 	drawSnakeCurve	// draw curve
		b	skipToAddSnakeArray
	addTail:
		cmp r3, #3
		bne	skipToAddSnakeArray
		bl 	drawSnakeTail // draw tail

	skipToAddSnakeArray:

	pop {r4,r5,lr}
	bx lr

/*
 * Add Snake
 *	arguments:
 *		r0 - x grid coord
 *		r1 - y grid coord
 *		r2 - direction
 *		r3 - body part
 * 	returns: 
		none
 * adds snake to array and inc snake counter
 */
.globl addSnake
addSnake:
	push {r4,r5,lr}

	ldr r5, = snake_part	// load snake size address ( r5 )
	str	r3, [r5, #0]	// store body state
	str	r0, [r5, #4]	// store x coord
	str	r1, [r5, #8]	// store y coord
	str	r2, [r5, #12]	// store direction
	str	r2, [r5, #16]	// store direction

	bl drawSnake

	ldr r1, = snake_size	// load snake size address
	ldr r0, [r1]		// load snake size into r0

	bl addSnakeArray	// add to snake array at offset r0 ( snake size )

	bl incSnakeSize

	pop {r4,r5,lr}
	bx lr

/*
 * Add Snake Array
 *	arguments:
 *		r0 - snakeArray offset
 * 	returns: 
 *		none
 * Push item into snake array at offset
 */
addSnakeArray:
	push {r4,r5,r6,r7,r8,r9,lr}

	mov r2, #20
	mov r8, r0
	mul r8, r8, r2
	
	ldr r4, = snakeArray	// load snake size address ( r4 )
	ldr r5, = snake_part	// load snake part address ( r5 )
	
	mov r6, #0	// counter for loop
	snakePushLoop:
		lsl r7, r6, #2		// multiply counter by 4
		ldr r0, [r5, r7]	// load snake_part[i]
		
		add r9, r7, r8 		// add snake_part[offset] to snake size offset
		
		str r0, [r4,r9]

		add r6, #1	// inc i

		cmp r6, #5
		blt snakePushLoop

	pop {r4,r5,r6,r7,r8,r9,lr}
	bx lr

.data

/* Speed
 * Stores number of lives
*/
.align 4
speed:
	.int 1000000

/* Lives
 * Stores number of lives
*/
.align 4
.globl lives
lives:
	.int 3

/* Snake Size
 * Stores the size of the snake as an int
*/
.align 4
snake_size:
	.int 0

/* Snake Part
*  Struct
*  properties:
*	body state = int (0 = head,1 = body,2 = curve,3 = tail)
*	x = int
*	y = int
*	direction = int
*	next step = int
*/
.align 4
snake_part: 
	.int 0// body state
	.int 0// x
	.int 0// y
	.int 0// dir
	.int 0// next step

/* Snake Array
*  Contains all possible snake body parts
*  elements:
*	snake_part (struct)
*/
.balign 8
snakeArray: .skip 460

/* Grid Array 
*  64x48 2d array of ints
*  states:
*	0 - empty
*	1 - wall
*	2 - brick
*	3 - apple
*	4 - snake
*	5 - exit
*/

.align 4
.globl GridBuffer
GridBuffer: .skip 12288

/* Seed for random number generator
 * Change number combos for different results
 * ( best used with prime numbers )
 */

.align 4
seed:
	.int 1		// x
	.int 3		// y
	.int 7		// z
	.int 11		// w
