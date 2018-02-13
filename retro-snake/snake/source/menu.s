/**/
.section    .init

.section .text



/*
 * Initialize the main menu
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * This function initalizes the main menu screen at the start of the program,
 * it prints the options and arrow pointing at the options.
 */
.globl init_MainMenu
init_MainMenu:
	push	{lr}   

	bl		drawBackground3

		// prints creators
	ldr		r0, =0x137			// x coordinate
	ldr		r1, =0x30			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Credit		// address of ASCII
	bl		drawText				// print creators

		// prints "START GAME"
	ldr		r0, =0x1DC			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_StartGame	// address of ASCII
	bl		drawText				// print menu option 1

		// prints "QUIT GAME"
	ldr		r0, =0x1E1			// x coordinate
	ldr		r1, =0x19E			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_QuitGame	// address of ASCII
	bl		drawText				// print menu option 2

		// prints title
	ldr		r0, =0x196			// x coordinate
	ldr		r1, =0x4E			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Title			// address of ASCII
	bl		drawText				// print title

		// prints game title
	ldr		r0, =0x1F0			// x coordinate
	ldr		r1, =0x6C			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_GameTitle	// address of ASCII
	bl		drawText				// print game title




	mov 	r0, #9        //passing in pin 9 (latch) parameter        
	mov 	r1, #1        //passing in output parameter   
	bl 		init_GPIO
		
	mov 	r0, #10       //passing in pin 10 (data) parameter
	mov 	r1, #0        //passing in input parameter
	bl 		init_GPIO
	
	mov 	r0, #11       //passing in pin 11 (clock) paramater
	mov 	r1, #1        //passing in output parameter
	bl 		init_GPIO
	
drawMain:
	
	// Initial arrow position points at "START GAME"
	ldr		r0, =0x1A4			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 1

	// Arrow pointing at "QUIT GAME" is blacked out
	ldr		r0, =0x1A4			// x coor
	ldr		r1, =0x19E			// y coor
	ldr		r2, =0x0000			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 2

	readMain:

		bl		Read_SNES		// call to Read_SNES function to return the button pressed

		ldr		r1, =9			// mask for button #9 -- bit[8] -- "A"
		teq		r0, r1			// check if (buttonPressed == "A")
		beq		startGame		// if (buttonPressed == A && ArrowPosition == START)
								//  --> then start the game

		ldr		r1, =6			// mask for button #6 -- bit[5] -- "DOWN"
		teq		r0, r1			// check if (buttonPressed == "DOWN")
		beq		drawMainEndd		// if (buttonPressed == DOWN) --> branch to print arrow at "QUIT GAME"
		b		readMain	// 	--> otherwise read from SNES controller again 	
	
drawMainEndd:
	// Print the arrow pointing at "QUIT GAME"
	ldr		r0, =0x1A4			// x coordinate
	ldr		r1, =0x19E			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 2


	// Arrow pointing at "START GAME" is blacked out
	ldr		r0, =0x1A4			// x coor	
	ldr		r1, =0x180			// y coor
	ldr		r2, =0x0000			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 1

	readMainEndLoopp:

		bl		Read_SNES		// call to Read_SNES function to return the button pressed

		ldr		r1, =9			// mask for button #9 -- bit[8] -- "A"
		teq		r0, r1			// check if (buttonPressed == "A")
		beq		haltLoop			// if (buttonPressed == A && ArrowPosition == QUIT)
								//  --> then exit the program (branch to haltLoop)

		ldr		r1, =5			// mask for button #5 -- bit[4] -- "UP"
		teq		r0, r1			// check if (buttonPressed == "UP")
		beq		drawMain		// if (buttonPressed == UP) --> branch to print arrow at "START GAME"
		b		readMainEndLoopp	//	--> otherwise read from SNES controller again


	startGame:
	//bl 		initGame
	//bl 		gameFunction		// only call from within my function
	bl gameController


	pop		{lr}
	bx		lr

/*************************************************************************/
/*
 * Initialize the in game menu
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * This function prints the in game menu when START is pressed with all its respective options
 */
.globl init_InGameMenu
init_InGameMenu:
	push	{lr}


	cmp		r0, #4				// if buttonPressed == 4 == "START"
	beq		nextPrint				// print the in game menu
	

	nextPrint:
	bl		drawBackground2

		// prints "RESTART GAME"
	ldr		r0, =0x1CD			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_RestartGame	// address of ASCII
	bl		drawText				// print menu option 1

		// prints "QUIT"
	ldr		r0, =0x1F5			// x coordinate
	ldr		r1, =0x19E			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Quit			// address of ASCII
	bl		drawText				// print menu option 2




	// THIS PRINTS THE ARROWS ON THE MENU OPTIONS ACCORDING TO THE BUTTON PRESSED

	mov 	r0, #9        //passing in pin 9 (latch) parameter        
	mov 	r1, #1        //passing in output parameter   
	bl 		init_GPIO
		
	mov 	r0, #10       //passing in pin 10 (data) parameter
	mov 	r1, #0        //passing in input parameter
	bl 		init_GPIO
	
	mov 	r0, #11       //passing in pin 11 (clock) paramater
	mov 	r1, #1        //passing in output parameter
	bl 		init_GPIO



drawMainStart:
	
	// Initial arrow position points at "RESTART GAME"
	ldr		r0, =0x1A4			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 1

	// Arrow pointing at "QUIT" is blacked out
	ldr		r0, =0x1A4			// x coor
	ldr		r1, =0x19E			// y coor
	ldr		r2, =0x0000			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 2

	readMainLoop:

		bl		Read_SNES	// call to Read_SNES function to return the button pressed

		ldr		r1, =9			// mask for button #9 -- bit[8] -- "A"
		teq		r0, r1			// check if (buttonPressed == "A")
		beq		endAll			// if (buttonPressed == A && ArrowPosition == START)
								//  --> then start the game

		ldr		r1, =6			// mask for button #6 -- bit[5] -- "DOWN"
		teq		r0, r1			// check if (buttonPressed == "DOWN")
		beq		drawMainEnd		// if (buttonPressed == DOWN) --> branch to print arrow at "QUIT GAME"
		b		readMainLoop	// 	--> otherwise read from SNES controller again 	
	
drawMainEnd:
	// Print the arrow pointing at "QUIT"
	ldr		r0, =0x1A4			// x coordinate
	ldr		r1, =0x19E			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 2


	// Arrow pointing at "RESTART GAME" is blacked out
	ldr		r0, =0x1A4			// x coor	
	ldr		r1, =0x180			// y coor
	ldr		r2, =0x0000			// colour
	ldr		r3, =fmt_Pointer		// address
	bl		drawText				// print arrow pointing to option 1

	readMainEndLoop:

		bl		Read_SNES	// call to Read_SNES function to return the button pressed

		ldr		r1, =9			// mask for button #9 -- bit[8] -- "A"
		teq		r0, r1			// check if (buttonPressed == "A")
		beq		endAll2			// if (buttonPressed == A && ArrowPosition == QUIT)
								//  --> then exit the program (branch to haltLoop)

		ldr		r1, =5			// mask for button #5 -- bit[4] -- "UP"
		teq		r0, r1			// check if (buttonPressed == "UP")
		beq		drawMainStart	// if (buttonPressed == UP) --> branch to print arrow at "START GAME"
		b		readMainEndLoop	//	--> otherwise read from SNES controller again


	endAll:
	bl 		initGame
	bl 		gameFunction		// only call from within my function

	b			endAll3
	
	endAll2:
	bl			init_MainMenu

	endAll3:

	pop		{lr}
	bx		lr
/*************************************************************************/
/*
 * Game won function
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * This function erases everything from screen once SCORE == 20 and prints a "YOU WON!" message
 */
.globl	init_WonGameMenu
init_WonGameMenu:
	push	{lr}

	bl		drawBackground3

		// prints "YOU WON!"
	ldr		r0, =0x1DC			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_GameWon	// address of ASCII
	bl		drawText				// print menu option 1

		//CONTROLLER GPIO LINES
	mov 	r0, #9        //passing in pin 9 (latch) parameter        
	mov 	r1, #1        //passing in output parameter   
	bl 		init_GPIO
		
	mov 	r0, #10       //passing in pin 10 (data) parameter
	mov 	r1, #0        //passing in input parameter
	bl 		init_GPIO
	
	mov 	r0, #11       //passing in pin 11 (clock) paramater
	mov 	r1, #1        //passing in output parameter
	bl 		init_GPIO

	endGameWon:
		bl		Read_SNES	// call to Read_SNES function to return the button pressed
		mov		r1, #1
		cmp		r0, r1
		bgt		wonGameEnd

		b		endGameWon
	
	wonGameEnd:
	bl			init_MainMenu

	pop		{lr}
	bx		lr
/*************************************************************************/



/*************************************************************************/
/*
 * Game lost function
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * This function erases everything from screen when LIVES == 0 and prints a "YOU LOST!" message
 */
.globl	init_LostGameMenu
init_LostGameMenu:
	push	{lr}

	bl		drawBackground3

		// prints "YOU LOST!"
	ldr		r0, =0x1DC			// x coordinate
	ldr		r1, =0x180			// y coordinate
	ldr		r2, =0xF860			// colour
	ldr		r3, =fmt_GameLost	// address of ASCII
	bl		drawText				// print menu option 1

		//CONTROLLER GPIO LINES

	mov 	r0, #9        //passing in pin 9 (latch) parameter        
	mov 	r1, #1        //passing in output parameter   
	bl 		init_GPIO

	mov 	r0, #10       //passing in pin 10 (data) parameter
	mov 	r1, #0        //passing in input parameter
	bl 		init_GPIO

	mov 	r0, #11       //passing in pin 11 (clock) paramater
	mov 	r1, #1        //passing in output parameter
	bl 		init_GPIO

	endGameLost:
		bl		Read_SNES	// call to Read_SNES function to return the button pressed
		mov		r1, #1
		cmp		r0, r1
		bgt		lostGameEnd

		b		endGameLost
	
	lostGameEnd:
	bl			init_MainMenu

	pop		{lr}
	bx		lr
/*************************************************************************/









/*************************************************************************/
/*************IMPORTANT DRAW FUNCTIONS FOUND IN MY DRAW.S FILE************/


/* 	Description: Improved/efficient version of drawChar to draw text to the screen
 *	Arguments:
 *		r0 - x coordinate
 *		r1 - y coordinate
 *		r2 - colour of text		
 *		r3 - address of text in ASCII (see .data section)
 */
.globl drawText
drawText:
	address	.req	r4
	px		.req	r5
	py		.req r6
	colour	.req	r7
	char	.req	r8
	counter	.req r9

	push	{r4-r9, lr}

	mov		px, r0					// move x coor argument into r5
	mov		py, r1					// move y coor argument into r6
	mov		colour, r2				// move colour argument into r7
	mov		address, r3				// move address of ASCII into r4

	mov		counter, #0				// initialize counter to 0	
	ldrb		char, [address]			// loads byte by byte to print the ASCII character

	next:
		// arguments into drawChar (r0 - r3)
		mov		r0, px				// x coordinate
		mov		r1, py				// y coordinate
		mov		r2, colour			// colour
		mov		r3, char				// character
		bl		drawChar			// call to function

		add		counter, #1			// increment 
		add		px, #10				// increment x coordinate position
		
		ldrb		char, [address, counter]		// load the next byte into "char"
		cmp		char, #0					// check whether all the ASCII chars have been read
		bne		next						// if (allCharacters != read) --> branch to start of loop
	
		.unreq	address
		.unreq	px
		.unreq	py
		.unreq	colour
		.unreq	char
		.unreq	counter

		pop		{r4-r9, lr}
		bx		lr


/* 	Description: Improved/efficient version of drawChar to draw text to the screen
 *	Arguments:
 *		r0 - x coordinate
 *		r1 - y coordinate
 *		r2 - colour of text		
 *		r3 - number ( 100 - 2000 )
 */
.globl drawNumber
drawNumber:
	push		{r4-r9, lr}

	xcoord	.req	r4
	ycoord	.req r5
	colour	.req r6
	number	.req r7

	mov xcoord, r0
	mov ycoord, r1
	mov colour, r2
	mov number, r3	// number

	mov r0, number	// store number in temp reg
	mov r1, #10
	bl divide

	mov r3, r0
	mov r9, #10
	mul r8, r3, r9

	add r3, #48
	mov r0, xcoord	// mov x into arg 0
	mov r1, ycoord	// mov y into arg 1
	mov r2, colour	// mov colour into arg 2

	bl drawChar	// draw char at x, y, colour, least sig dig

	sub number, r8
	add r3, number, #48
	add r0, xcoord, #10
	mov r1, ycoord	// mov y into arg 1
	mov r2, colour	// mov colour into arg 2

	bl drawChar	// draw char at x, y, colour, least sig dig
	
	.unreq	xcoord
	.unreq	ycoord
	.unreq	colour
	.unreq	number

	pop		{r4-r9, lr}
	bx		lr









/* Draw the character in r3 to (r0, r1) with colour r2
 * (see Tutorial 7/8)
 * 	Arguments:
 * 		r0 - x coordinate
 *		r1 - y coordinate
 *		r2 - colour
 *		r3 - character	to draw
 */
.globl drawChar
drawChar:
	push	{r4-r10, lr} 

	chAdr	.req	r4
	px		.req	r5
	py		.req	r6
	row		.req	r7
	mask	.req	r8
	pxinit	.req	r9
	color	.req	r10

	ldr		chAdr, =font			// load the address of the font map
	add		chAdr, r3, lsl #4		// char address = font base + (char * 16)
	
	mov		color, 	r2			// init the color
	mov		py,		r1			// init the Y coordinate (pixel coordinate)
	mov		pxinit, r0				// init the X coordinate

charLoop$:
	mov		px, pxinit				// the X coordinate


	mov		mask,	#0x01		// set the bitmask to 1 in the LSB
	
	ldrb		row,	[chAdr], #1		// load the row byte, post increment chAdr

rowLoop$:
	tst		row,	mask			// test row byte against the bitmask
	beq		noPixel$

	mov		r0, px				// set the x coord
	mov		r1, py				// set the y coord
	mov		r2, color				// set the color
	bl		DrawPixel			// draw pixel at (px, py)

noPixel$:
	add		px, #1				// increment x coordinate by 1
	lsl		mask, #1				// shift bitmask left by 1

	tst		mask, #0x100			// test if the bitmask has shifted 8 times (test 9th bit)
	beq		rowLoop$

	add		py, #1				// increment y coordinate by 1

	tst		chAdr, #0xF
	bne		charLoop$			// loop back to charLoop$, unless address evenly divisibly by 16 (ie: at the next char)

	.unreq	chAdr
	.unreq	px
	.unreq	py
	.unreq	row
	.unreq	mask
	.unreq	pxinit
	.unreq	color
		
	pop		{r4-r10, lr}
	bx		lr

/*************************************************************************/



/*************************************************************************/
			//CONTROLLER FUNCTIONS FROM MY FILE (VERSION 2)
.globl init_GPIO
init_GPIO:  //(parameters - (r0 = pin #) / (r1 = pin function)
	
	mov 		r3, r1
	
	cmp			r0, #9 //check if it's pin 9
	beq			pin9

	cmp			r0, #10 //check if it's pin 10
	beq			pin10

	cmp			r0, #11 //check if it's pin 11    
	beq			pin11

	pin9:	
	
		ldr  		r0, =0x20200000 //address for GPFSEL0 
		ldr		r1, [r0]  //copy GPFSEL into r1
	
		mov 	r2, #7   //create bits for bic
		bic 		r1, r2, lsl #27	//clear pin 9 bits
		
		orr		r1, r3, lsl #27   //set pin 11 to output in r1
		str 		r1, [r0]     //write back to GPFSEL0

		mov 	pc, lr   //return
	
	pin10:
		
		ldr  		r0, =0x20200004 //address for GPFSEL1
		ldr		r1, [r0]  //copy GPFSEL into r1 
	
		mov 	r2, #7   //  create bits for bic
		bic 		r1, r2	// clear pin10 bits  
	
		orr  		r1, r3 //set pin 10 to input in r1       
		str 		r1, [r0] //write back to GPFSEL1
	
		mov 	pc, lr   //return
	
	pin11:
	
		ldr  		r0, =0x20200004 //address for GPFSEL1
		ldr		r1, [r0]  //copy GPFSEL into r1
	
		mov 	r2, #7   // create bits for bic
        	bic 		r1, r2, lsl #3 //clear pin11 bits     
		
       		orr  		r1, r3, lsl #3 //set pin11 to output in r1
       		str 		r1, [r0]   //write back to GPFSEL1

		mov 	pc, lr //return

	
Write_Latch:    // (r0 = parameter for writing {0,1})
	
	ldr			r1, =0x20200000    // address for base GPIO
	mov 		r3, #1    //creating bit for alignment
	lsl			r3, #9    //align bit for pin#9
	teq 			r0, #0    //test to determine write 0 or 1
	streq		r3, [r1, #40]    //GPCLR0    
	strne		r3, [r1, #28]    //GPSET0

	mov 		pc, lr    //return


Write_Clock:    // (r0 = parameter for writing {0,1})
	
	ldr			r1, =0x20200000 //  address for base GPIO    
	mov 		r3, #1    //creating bit for alignment
	lsl			r3, #11   //align bit for pin#11     
	teq 			r0, #0    //test to determine write 0 or 1
	streq		r3, [r1, #40]    //GPCLR0
	strne		r3, [r1, #28]    //GPSET0

	mov 		pc, lr    //return


Read_Data:

	ldr			r1, =0x20200000    // address for base GPIO
	ldr 			r2, [r1, #52]     // GPLEV0
	mov 		r3, #1    //creating bit for alignment
	lsl 			r3, #10   //align bit for pin#10
	and 			r2, r3    //mask eveything else
	teq 			r2, #0    //test
	moveq		r0, #0    //return 0 in r0
	movne		r0, #1    //return 1 in r0

	mov 		pc, lr    //return
	
wait:       	// (r0 = parameter to check for waiting time)
	
	ldr 			r1, =0x20003004   //address of CLO
	ldr			r2, [r1]   //read CLO
	add			r2, r0     //add time to wait

	waitLoop:
		
		ldr		r3,[r1]  //read CLO
		cmp		 r2, r3   //stop when CLO = 1
		bhi		waitLoop 
	
	mov 		pc, lr   //return


.globl Read_SNES
Read_SNES:
	push		{r1-r12}
	mov 		r0, #1		// passing in 1 - write GPIO(CLOCK, #1)
	push		{lr}           	// preserve state
	bl 			Write_Clock        
	pop			{lr}   		//return state
	
	mov			r0, #1		// passing in 1 - write GPIO(LATCH, #1)
	push		{lr}  			//preserve state
	bl 			Write_Latch
	pop			{lr}   		//return state
		
	mov   		r0, #12       	// passing in 12 - (wait 12 microseconds / signal to SNES to sample buttons)
	push		{lr}  			//preserve state
	bl 			wait
	pop			{lr}   		//return state
	
	mov			r0, #0     	// passing in 0 - writeGPIO(LATCH, #0)
	push		{lr}  		//preserve state
	bl 			Write_Latch
	pop			{lr}   		//return state
	
	mov 		r4, #1		//set i to 1
	
	pulseLoop:
		mov 	r0, #6  // passing in 6 to wait function (wait 6 microseconds)
		push	{lr} 	//preserve state
		bl 		wait
		pop		{lr}  	//return state
		
		mov 	r0, #0  // passing in 0 to write clock function - writeGPIO(CLOCK, #0)
		push	{lr} 	//preserve state
		bl 		Write_Clock
		pop		{lr}  	//return state
		
		push	{lr} 	//preserve state
		bl		Read_Data
		pop 		{lr}
		
		teq		r0, #0	//check if button pressed
		moveq	r0, r4
		popeq	{r1-r12}
		moveq	pc, lr
		
		mov 	r0, #1   // rising edge new cycle - writeGPIO(CLOCK, #1)
		push	{lr}	 //preserve state
		bl 		Write_Clock
		pop		{lr}  	 //return state
		add 		r4, #1	//i++
		
		cmp		r4, #16  //if (i < 16) branch pulse loop
		blt		pulseLoop
		
	mov			r4, #0	//i = 0
	mov			r0, r4
	pop			{r1-r12}	
	mov 		pc, lr   //return
	
/*************************************************************************/





.section .data


.align 4
font:			.incbin	"font.bin"


	// Main menu messages and options
.globl fmt_Credit
fmt_Credit:		.asciz	"Created by: Zachary Aries & Muhannad Nouri"

.globl fmt_StartGame
fmt_StartGame:	.asciz	"Start Game"

.globl fmt_QuitGame
fmt_QuitGame:	.asciz	"Quit Game"

.globl fmt_GameTitle
fmt_GameTitle:	.asciz	"Snake"

.globl fmt_Title
fmt_Title:		.asciz	"CPSC 359 - Assignment 4"

.globl fmt_Pointer
fmt_Pointer:		.asciz	">>"


	// In game menu messages and options
.globl fmt_RestartGame
fmt_RestartGame:	.asciz	"Restart Game"

.globl fmt_Quit
fmt_Quit:		.asciz	"Quit"


	// Score message and lives
.globl fmt_Score
fmt_Score:		.asciz	"Score: "

.globl fmt_Lives
fmt_Lives:		.asciz	"Lives: "


	// Game won or lost messages
.globl fmt_GameLost
fmt_GameLost:		.asciz	"You LOST!"

.globl fmt_GameWon
fmt_GameWon:		.asciz	"You WON!"







