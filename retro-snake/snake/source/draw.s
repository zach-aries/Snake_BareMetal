/**/
.section    .init


.section .text

/*
 * Draw Snake Curve
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 *		r2 - direction (int: 0=N, 1=E, 2=S, 3=W )
 * 	returns: 
 *		none
 * Draws snake curve at specified x y
 */
.globl drawSnakeCurve
drawSnakeCurve:
	push {r4, lr}

	mov	r4, r2	// direction
	mov	r2, r0 // x coord
	mov	r3, r1	 // y coord
	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image
	
	cmp 	r4, #0
	bne	curveEast

	ldr	r0, =curve_n // image address
	b	drawCurve
	
	curveEast:
		cmp 	r4, #1
		bne 	curveSouth
		ldr	r0, =curve_e // image address
		b	drawCurve
	curveSouth:
		cmp 	r4, #2
		bne 	curveWest
		ldr	r0, =curve_s // image address
		b	drawCurve
	curveWest:
		ldr	r0, =curve_w // image address
	drawCurve:
		bl 	drawImage	 // draw image

	pop {r4, lr}
	bx lr

/*
 * Draw Snake Body
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 *		r2 - direction (int: 0=N, 1=E, 2=S, 3=W )
 * 	returns: 
		none
 * Draws snake body to the specified x,y coordinate
 */
.globl drawSnakeBody
drawSnakeBody:
	push {r4, lr}

	mov	r4, r2	// direction
	mov	r2, r0 // x coord
	mov	r3, r1	 // y coord
	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image

	cmp 	r4, #0
	bne	bodyEast

	ldr	r0, =body_v // image address
	b	drawBody
	
	bodyEast:
		cmp 	r4, #1
		bne 	bodySouth
		ldr	r0, =body_h // image address
		b	drawBody
	bodySouth:
		cmp 	r4, #2
		bne 	bodyWest
		ldr	r0, =body_v // image address
		b	drawBody
	bodyWest:
		ldr	r0, =body_h // image address
	drawBody:
		bl 	drawImage	 // draw image

	pop {r4, lr}
	bx lr

/*
 * Draw Snake Head
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 *		r2 - direction (int: 0=N, 1=E, 2=S, 3=W )
 * 	returns: 
		none
 * Draws snake head to the specified x,y coordinate
 */
.globl drawSnakeHead
drawSnakeHead:
	push {r4, lr}
	
	mov	r4, r2	// direction
	mov	r2, r0 	// x coord
	mov	r3, r1	// y coord
	mov	r0, #16	// image width
	mov	r1, #16	// image height

	bl	initImageBuffer	// init image

	cmp 	r4, #0
	bne	headEast

	ldr	r0, =head_n // image address
	b	drawHead
	
	headEast:
		cmp 	r4, #1
		bne 	headSouth
		ldr	r0, =head_e // image address
		b	drawHead
	headSouth:
		cmp 	r4, #2
		bne 	headWest
		ldr	r0, =head_s // image address
		b	drawHead
	headWest:
		ldr	r0, =head_w // image address
	drawHead:
		bl 	drawImage	 // draw image

	pop {r4, lr}
	bx lr

/*
 * Draw Snake Tail
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 *		r2 - direction (int: 0=N, 1=E, 2=S, 3=W )
 * 	returns: 
		none
 * Draws snake tail to the specified x,y coordinate
 */
.globl drawSnakeTail
drawSnakeTail:
	push {r4, lr}
	
	mov	r4, r2	// direction
	mov	r2, r0 // x coord
	mov	r3, r1	 // y coord
	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image

	cmp 	r4, #0
	bne	tailEast

	ldr	r0, =tail_n // image address
	b	drawTail
	
	tailEast:
		cmp 	r4, #1
		bne 	tailSouth
		ldr	r0, =tail_e // image address
		b	drawTail
	tailSouth:
		cmp 	r4, #2
		bne 	tailWest
		ldr	r0, =tail_s // image address
		b	drawTail
	tailWest:
		ldr	r0, =tail_w // image address
	drawTail:
		bl 	drawImage	 // draw image

	pop {r4, lr}
	bx lr

/*
 * Draw Clock
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
		none
 * Draws a clock to the specified x,y coordinate
 */
.globl drawClock
drawClock:
	push {r4-r8,lr}

	mov r2, r0
	mov r3, r1

	lsl	r2, r2, #4
	lsl	r3, r3, #4

	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image
	
	ldr	r0, =ClockBuffer // image address
	bl 	drawImage	 // draw image

	pop {r4-r8,lr}
	bx lr

/*
 * Draw Hole
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
		none
 * Draws an hole to the specified x,y coordinate
 */
.globl drawHole
drawHole:
	push {r4-r8,lr}

	mov r2, r0
	mov r3, r1

	lsl	r2, r2, #4
	lsl	r3, r3, #4

	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image
	
	ldr	r0, =HoleBuffer // image address
	bl 	drawImage	 // draw image

	pop {r4-r8,lr}
	bx lr

/*
 * Draw Apple
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
		none
 * Draws an apple to the specified x,y coordinate
 */
.globl drawApple
drawApple:
	push {r4-r8,lr}

	mov r2, r0
	mov r3, r1

	lsl	r2, r2, #4
	lsl	r3, r3, #4

	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image
	
	ldr	r0, =AppleBuffer // image address
	bl 	drawImage	 // draw image

	pop {r4-r8,lr}
	bx lr
/*
 * Draw Rock
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
		none
 * Draws a rock to the specified x,y coordinate
 */
.globl drawRock
drawRock:
	push {lr}

	mov	r2, r0 	 // x coord
	mov	r3, r1	 // y coord
	mov	r0, #16	 // image width
	mov	r1, #16	 // image height
	
	lsl	r2, r2, #4
	lsl	r3, r3, #4

	bl	initImageBuffer	// init image
	
	ldr	r0, =RockBuffer // image address
	bl 	drawImage	 // draw image

	pop {lr}
	bx lr

/*
 * Draw Brick
 *	arguments:
 *		r0 - x coord
 *		r1 - y coord
 * 	returns: 
		none
 * Draws a brick to the specified x,y coordinate
 */
.globl drawBrick
drawBrick:
	push {lr}

	mov	r2, r0 // x coord
	mov	r3, r1	 // y coord
	mov	r0, #16	 // image width
	mov	r1, #16	 // image height

	bl	initImageBuffer	// init image
	
	ldr	r0, =BrickBuffer // image address
	bl 	drawImage	 // draw image

	pop {lr}
	bx lr

/*
 * Initialize Image Buffer
 *	arguments:
 *		r0 - X Resolution (width)
 *		r1 - Y Resolution (height)
 *		r2 - x coord
 *		r3 - y coord
 * 	returns: 
 *		none
 * set up an image for drawing, it is stored in an array with options specified above
 */
.globl initImageBuffer
initImageBuffer:
	push {r4,lr}

	ldr	r4, =ImageBuffer
	
	str r0, [r4, #0]
	str r1, [r4, #4]
	str r2, [r4, #8]
	str r3, [r4, #12]

	pop {r4, lr}
	bx lr

/*
 * Draw Image
 * !!! Must initialize ImageBuffer !!!
 *	arguments:
 *		r0 - image address
 * 	returns: 
 *		none
 */
.globl drawImage
drawImage:
	push {r4, r5, r6, r7, r8, r9,r10, lr}
	
	offset	.req r3
	i	.req r4
	j	.req r5
	x	.req r6
	y	.req r7
	width	.req r8
	height	.req r9
	
	ldr	r10, =ImageBuffer
	ldr	width, [r10, #0]	// load width
	ldr	height, [r10, #4]	// load height
	ldr	x,  [r10, #8]		// load x-coord
	ldr	y,  [r10, #12]		// load x-coord*/

	mov	r10, r0 		// set image address from arg 1

	mov i, #0
	mov j, #0
	brickLoop:
		mov	r0, r6	// x coord
		mov	r1, r7	// y coord
		mul	offset, j, width
		add	offset, offset, i
		
		lsl	offset, offset, #1
		
		add	r0, x, i
		add	r1, y, j
		ldr	r2, [r10, offset]
		bl	DrawPixel

		add 	i, #1				// i++
		cmp 	i, width
		blt 	brickLoop
	
		mov 	i, #0
		add 	j, #1
		cmp 	j, height
		blt 	brickLoop

	.unreq	offset
	.unreq	i
	.unreq	j
	.unreq	x
	.unreq	y
	.unreq 	width
	.unreq 	height
	
	pop		{r4, r5, r6, r7, r8, r9, r10, lr}
	bx		lr


/*
 * Draw Border
 *	arguments:
		none
 * 	returns: 
		none
 * Draws a border around the screen
 */
.globl drawBorder
drawBorder:
	push {r4, r5, r6, r7, r8, r9, lr}
	mov 	r4, #0	// i = 0
	mov	r5, #8	// j = 0 set this number to the start of the top wall ( must also change cmp on line 30
	ldr r6, =GridBuffer

	drawBorderLoop:

		cmp	r5, #8	// match this with starting y
		bgt	drawBorderOutline
		
		drawBrickLine:
			// draw brick line width wise
			mov	r0, r4	 // x
			lsl	r0, r0, #4

			mov	r1, r5	// y
			lsl	r1, r1, #4

			// add to grid buffer
			mov r7, #48		// m
			mul r8, r4, r7		// i * m
			add r8, r5		// + j
			
			mov r7, #4		// Esize
			mul r8, r8, r7		// * Esize

			mov r9, #1
			str r9, [r6, r8]		// place one into ((m*i)+j) * Esize

			bl 	drawBrick
			b	skipDrawOutline

		drawBorderOutline:
			cmp	r5, #47
			beq	drawBrickLine

			// draw brick (@ 0,y)
			mov	r0, #0	 // x
			mov	r1, r5	 // y
			lsl	r1, r1, #4

			// add to grid buffer
			mov r7, #48		// m
			mul r8, r0, r7		// i * m
			add r8, r5		// + j
			
			mov r7, #4		// Esize
			mul r8, r8, r7		// * Esize

			mov r9, #1
			str r9, [r6, r8]		// place one into ((m*i)+j) * Esize
			
			bl 	drawBrick

			// draw brick (@ 64,y)
			mov	r0, #63	 // x
			mov	r4, r0
			lsl	r0, r0, #4
			mov	r1, r5	 // y
			lsl	r1, r1, #4

			// add to grid buffer
			mov r7, #48		// m
			mul r8, r4, r7		// i * m
			add r8, r5		// + j
			
			mov r7, #4		// Esize
			mul r8, r8, r7		// * Esize

			mov r9, #1
			str r9, [r6, r8]		// place one into ((m*i)+j) * Esize
			
			bl 	drawBrick

		skipDrawOutline:

		add	r4, #1
		cmp 	r4, #64
		blt 	drawBorderLoop

		mov	r4, #0
		add	r5, #1
		cmp	r5, #48
		blt	drawBorderLoop

	pop {r4, r5, r6, r7, r8, r9, lr}
	bx lr

/*
 * Clears Unit
 *	arguments:
 *		r0 - x start
 *		r1 - y start
 * 	returns: 
 *		none
 * Draws a green 16x16 unit onto the screen at specified x,y
 */
.globl clearUnit
clearUnit:
	push {r4,r5,r6,r7,r8,r9,lr}

	mov r4, #0;
	mov r5, #0;

	lsl	r0, #4
	lsl	r1, #4

	mov r6, r1	// y start point
	add r7, r6, #16 // y end point

	mov r8, r0	// x start point
	add r9, r8, #16	// x end point

	
	clearUnitLoop:
		cmp r5, r6	// start y
		bge	drawGreenUnit
			b	skipClearPixel

		cmp r4, r8	// start y
		bge	drawGreenUnit
			b	skipClearPixel

		drawGreenUnit:
			ldr	r2,	=0x5568
			mov	r0, r4			// x coord = i
			mov	r1, r5			// y coord			
			bl	DrawPixel

		skipClearPixel:

		add r4, #1				// i++
		cmp r4, r9
		blt clearUnitLoop
	
		mov r4, r8
		add r5, #1
		cmp r5, r7	// cmp y top
		blt clearUnitLoop

	pop		{r4,r5,r6,r7,r8,r9,lr}
	bx		lr

/*
 * Draw Coloured Unit
 *	arguments:
 *		r0 - x start
 *		r1 - y start
 *		r2 - colour
 * 	returns: 
 *		none
 * Draws a coloured area 20x20 at specified x,y and colour
 */
.globl drawColouredUnit
drawColouredUnit:
	push {r4,r5,r6,r7,r8,r9,r10,lr}

	mov r4, #0
	mov r5, #0

	mov r6, r1	// y start point
	add r7, r6, #20 // y end point

	mov r8, r0	// x start point
	add r9, r8, #20	// x end point

	
	clearUnitLoop1:
		cmp r5, r6	// start y
		bge	drawGreenUnit1
			b	skipClearPixel1

		cmp r4, r8	// start y
		bge	drawGreenUnit1
			b	skipClearPixel1

		drawGreenUnit1:
			mov	r0, r4			// x coord = i
			mov	r1, r5			// y coord			
			bl	DrawPixel

		skipClearPixel1:

		add r4, #1				// i++
		cmp r4, r9
		blt clearUnitLoop1
	
		mov r4, r8
		add r5, #1
		cmp r5, r7	// cmp y top
		blt clearUnitLoop1

	pop		{r4,r5,r6,r7,r8,r9,r10,lr}
	bx		lr

/*
 * Draw Background
 *	arguments:
		none
 * 	returns: 
		none
 * Draws a green background to the full screen
 */
.globl drawBackground
drawBackground:
	push {r4,r5, lr}

	x	.req	r4
	y	.req	r5

	mov x, #0;
	mov y, #0;
	loop:
		cmp y, #129
		bgt	drawGreen
			ldr	r2,	=0x5B0B
			mov	r0, x			// x coord = i
			mov	r1, y			// y coord			
			bl	DrawPixel
			
			b	skipGreen

		drawGreen:
			ldr	r2,	=0x5568
			mov	r0, x			// x coord = i
			mov	r1, y			// y coord			
			bl	DrawPixel

		skipGreen:

		add x, #1				// i++
		cmp x, #1024
		blt loop
	
		mov x, #0
		add y, #1
		cmp y, #768
		blt loop
	.unreq x
	.unreq y

	pop		{r4, r5, lr}
	bx		lr


/*
 * Draw Small Background With Border
 *	arguments:
 *		none
 * 	returns: 
 *		none
 * Draws a black background with border for the in game menu
 */
.globl drawBackground2
drawBackground2:
	push {r4,r5, lr}

	x	.req	r4
	y	.req	r5
	top	.req	r6
	bottom	.req	r7
	left	.req	r8
	right	.req	r9

	ldr right, =0x2FA	// 762
	ldr left, =0x106	// 262
	ldr top, =0x25C		// 604
	ldr bottom, =0xA4	// 164

	mov x, left
	mov y, bottom

	loopBlack:

		cmp x, left
		beq drawRedBorder
		cmp x, right
		beq drawRedBorder
		cmp y, top
		beq drawRedBorder
		cmp y, bottom
		beq drawRedBorder

		b fillBlackBack

			drawRedBorder:
			ldr	r2, =0xf860		//red
			mov	r0, x			// x coord = i
			mov	r1, y			// y coord			
			bl	DrawPixel
			b skipFillBlack
		
		fillBlackBack:

		ldr	r2,	=0x0000		//green  == 5568
		mov	r0, x			// x coord = i
		mov	r1, y			// y coord			
		bl	DrawPixel
		
		skipFillBlack:

		add x, #1				// i++
		cmp x, right
		ble loopBlack
	
		mov x, left
		add y, #1
		cmp y, top	
		ble loopBlack

	.unreq x
	.unreq y
	
	pop		{r4, r5, lr}
	bx		lr



/*
 * Draw Background
 *	arguments:
		none
 * 	returns: 
		none
 * Draws a black background to the full screen
 */
.globl drawBackground3
drawBackground3:
	push {r4,r5, lr}

	x	.req	r4
	y	.req	r5

	mov x, #0;
	mov y, #0;
	loopBlackBlack:
		cmp y, #129
		bgt	drawBlackBlack
			ldr	r2,	=0x0000
			mov	r0, x			// x coord = i
			mov	r1, y			// y coord			
			bl	DrawPixel
			
			b	skipBlackBlack

		drawBlackBlack:
			ldr	r2,	=0x0000
			mov	r0, x			// x coord = i
			mov	r1, y			// y coord			
			bl	DrawPixel

		skipBlackBlack:

		add x, #1				// i++
		cmp x, #1024
		blt loopBlackBlack
	
		mov x, #0
		add y, #1
		cmp y, #768
		blt loopBlackBlack
	.unreq x
	.unreq y

	pop		{r4, r5, lr}
	bx		lr



/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */
.globl DrawPixel
DrawPixel:
	push	{r4}


	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1

	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	.unreq offset

	pop		{r4}
	bx		lr

.section .data
.align 4
.globl ImageBuffer
ImageBuffer:
	.int	20		// X Resolution (width)
	.int	20		// Y Resolution (height)
	.int	0		// X coord
	.int	0		// Y coord

