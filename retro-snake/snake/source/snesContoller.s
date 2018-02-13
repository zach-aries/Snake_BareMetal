/**/
    
.section .text

/*
 * SNES Controller main function
 *	Need to call this function in order to init the GPIO. Controller will not work without it.
 *
 *	arguments:
 *		none
 * 	returns: 
 *		none
 */
.globl snesController
snesController:
	push {lr}

	bl initGPIO			// initialize controller function

	pop {lr}
	bx	lr	

/*
 * Event - Button Pressed
 *	checks to see if button was pressed
 *
 *	arguments:
 *		none
 * 	returns: 
 *		r0 - button pressed mask
 */
.globl event_buttonPressed
event_buttonPressed:

	push {r4, lr}
	
	bl readSNESController	// function to check which buttons were pushed
	mov r0, r1		// move return to r0

	pop {r4, lr}
	bx lr

/*
 * Button Pressed
 *	arguments:
 *		r0 - button mask
 *
 * 	returns: 
 *		r0 - button (int: 0=N, 1=E, 2=S, 3=W, 4=Start )
 *		r1 - button pressed (boolean)
 * Updates map
 */
/*
 * Check which buttons are pressed function
 *	r1 - button mask ( 16 bits long )
 * Returns: nothing
 * Psuedocode for the algorithm:
 *	for(i=0; i<13; i++)
 *		if((buttonMask && 1) == 1)
 *			print buttonArray[i]
 *			if(i == 3) // if "Start" was pressed
 *				System.exit(0)
 *		right shift buttonMask
 */				
.globl buttonPressed
buttonPressed:
	push {lr, r4, r5, r6, r7}	

	mov r7, #0	// direction pressed flag
	
	mov r5, r0	// move mask into r5
	mov r4, #1	// i = 1
	buttonLoop:
		cmp r4, #14		// i < 13
		bgt endButtonLoop	// if i >= 13 end loop

		and r2, r5, #1		// mask button mask with 1
		cmp r2, #1		// if lsb in r1 = 1 print button pressed
		bne skipReturnButton	// otherwise do nothing

		checkForStart:
			cmp r4, #4
			bne checkForUp
			mov r6, #4
			mov r7, #1
			b endButtonLoop	
		checkForUp:
			cmp r4, #5
			bne checkForDown
			mov r6, #0
			mov r7, #1
			b endButtonLoop		

		checkForDown:
			cmp r4, #6
			bne checkForLeft
			mov r6, #2
			mov r7, #1
			b endButtonLoop	

		checkForLeft:
			cmp r4, #7
			bne checkForRight
			mov r6, #3
			mov r7, #1
			b endButtonLoop	
		checkForRight:
			cmp r4, #8
			bne skipReturnButton
			mov r6, #1
			mov r7, #1
			b endButtonLoop	
		
		/* check for start to exit program */

		skipReturnButton:
			lsr r5, #1	// right shift button mask by 1
			add r4, r4, #1	// increment counter
		b buttonLoop		// loop back
		

	endButtonLoop:

	mov r0, r6
	mov r1, r7

	pop {lr, r4, r5, r6, r7}

	bx lr



/*
 * Read SNES Controller function
 *	no arguments
 * Returns: 
 *	r1 - buttons pressed mask
 * (Refer to "ARM 6 - SNES", slide #20 for pseudo-code)
 */
readSNESController:
	push {r4,r5,r6, lr}
	
	mov r4, #0

	// write clock 1
	mov r1, #1
	bl writeClock

	// write latch 1
	mov r1, #1
	bl writeLatch

	// wait 12 mili
	mov r1, #12
	bl wait
	
	// write latch 0
	mov r1, #0
	bl writeLatch
	
	mov r5, #0	// i = 0
	pulseLoop:
		// wait 6 mili
		mov r1, #6
		bl wait

		// write clock 0 (falling edge)
		mov r1, #0
		bl writeClock

		// wait 6 mili
		mov r1, #6
		bl wait

		// read data
		bl readData
		
		cmp r0, #0	// check if button was pressed
		bne buttonSkip	// if not branch to button skip

		mov r2, #1	// make mask
		lsl r2, r5	// align mask to current button
		orr r4, r2	// write button pressed to current button

	buttonSkip:
		// write clock 1 (rising edge / new cycle)
		mov r1, #1
		bl writeClock
		
		add r5, #1
		
		cmp r5, #16
		blt pulseLoop
		
		mov r1, r4

	pop {r4,r5,r6, lr}
	bx lr
		


/*
 * Read Data funtion
 *	no arguments
 * Returns: boolean (0 = button pushed)
 * (Refer to "ARM 6 - SNES", slide #19 for pseudo-code)
 */
readData:
	push {r4}

	mov r0, #10	// pin#10 = DATA line
	ldr r2, =0x20200000	// base GPIO reg
	ldr r1, [r2, #52]	// GPLEV0
	
	mov r3, #1	// create mask
	lsl r3, r0	// align mask to pin10 bit
	and r1, r3	// mask everything else
	
	teq r1, #0
	moveq r4, #0	// return 0
	movne r4, #1	// return 1

	mov r0, r4

	pop {r4}
	bx lr

/*
 * Write Latch funtion
 *	r1 - value to write
 * Returns: nothing
 * (Refer to "ARM 6 - SNES", slide #18 for pseudo-code)
 */
writeLatch:
	mov r0, #9	// pin#9 = LATCH line
	ldr r2, =0x20200000	// base GPIO reg

	mov r3, #1
	lsl r3, r0	// align bit for pin#9

	teq r1, #0
	streq r3, [r2, #40] // GPCLR0
	strne r3, [r2, #28] // GPSET0	

	bx lr

/*
 * Write Clock funtion
 *	r1 - value to write
 * Returns: nothing
 * (Refer to "ARM 6 - SNES", slide #18 for pseudo-code)
 */
writeClock:
	mov r0, #11	// pin#11 = CLOCK line
	ldr r2, =0x20200000	// base GPIO reg

	mov r3, #1
	lsl r3, r0	// align bit for pin#11

	teq r1, #0
	streq r3, [r2, #40] // GPCLR0
	strne r3, [r2, #28] // GPSET0	

	bx lr

/*
 * Wait funtion
 *	r1 - wait time (micro seconds)
 * Returns: nothing
 * (Refer to "ARM 6 - SNES", slide #23 for pseudo-code)
 */
wait:
	ldr r0, =0x20003004	// address of CLOCK
	ldr r2, [r0]	// read CLOCK
	
	add r2, r1	// add 12 micros
	waitLoop:
		ldr r3, [r0]
		cmp r2, r3	// stop when CLOCK = r2
		bhi waitLoop
	
	bx lr

/*
 * Initilize GPIO funtion
 *	no arguments
 * Returns: nothing
 * (Refer to "ARM 6 - SNES", slide #10 for pseudo-code)
 */
initGPIO:
	push {r4}

	/*-------set clock to ouput-------*/
	// init clock
	ldr r0, =0x20200004	// GPFSEL1
	ldr r1, [r0]
	
	// clear bits
	mov r2, #7
	mov r3, #3
	lsl r2, r3
	bic r1, r2
	
	// select output function
	mov r4, #001
	lsl r4, r3
	orr r1, r4
	
	// execute function
	str r1, [r0]

	/*-------set latch to ouput-------*/
	// init latch
	ldr r0, =0x20200000	// GPFSEL0
	ldr r1, [r0]
	
	// clear bits
	mov r2, #7
	mov r3, #27
	lsl r2, r3
	bic r1, r2
	
	// select output function
	mov r4, #001
	lsl r4, r3
	orr r1, r4
	
	// execute function
	str r1, [r0]

	/*-------set data to input-------*/
	// init latch
	ldr r0, =0x20200004	// GPFSEL1
	ldr r1, [r0]
	
	// clear bits
	mov r2, #7
	mov r3, #27
	lsl r2, r3
	bic r1, r2
	
	// select output function
	mov r4, #000
	lsl r4, r3
	orr r1, r4
	
	// execute function
	str r1, [r0]
	
	// return
	pop {r4}
	bx lr	
/*-------------end-------------*/



