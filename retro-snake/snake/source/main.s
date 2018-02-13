/**/
.section    .init
.globl     _start

_start:
    b       main
    
.section .text

main:
    mov     sp, #0x8000
	
	bl 	EnableJTAG
	bl 	InitFrameBuffer
	bl	snesController	

	// from menu when start is pushed call following:
	bl init_MainMenu
	bl haltLoop

/* Halt loop
 *	r0 - number of loop iterations
 * Returns: nothing
 * (Included to end program)
 */
.globl haltLoop
haltLoop:
	
	haltLoop$:
		b	haltLoop$

	bx lr

