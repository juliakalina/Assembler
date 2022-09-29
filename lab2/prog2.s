	.arch   armv8-a                             
                                              
	.data                                    
	.align  2                                
n:                                           
	.word   7   
m:
	.word   4                             
matrix:                                      
	.byte   1,  9,  7,  5
	.byte   11, 8,  5,  3
	.byte   -9,  5,  4,  6
	.byte   4,  3,  1,  2
	.byte   7,  1,  9,  13
	.byte   2,  16, 23, 8
	.byte   8,  10, -2, 1                     

	.text 
	.align 2
	.global _start 
	.type _start, %function
_start: 
	adr x2, n
	mov x0, #0  
	ldr w0, [x2] 
	adr x2, m 
	mov x1, #0 
	ldr w1, [x2] 
	adr x2, matrix 
	mov x4, #0
_load_first:
	cmp x4, x1
	bge _exit
	mov x11, #0
	lsl x6, x4, #0
	ldrsb w10, [x2, x6]
	add x6, x6, x1, lsl #0
	add x11, x11, #1
_load_next:
	cmp x11, x0
	bge _next_col
	ldrsb w12, [x2, x6, lsl #0]
	mov x5, x6
	add x6, x6, x1, lsl #0
	add x11, x11, #1
	mov x8, x11
	cmp w12, #0
	bmi _negative
_change:	
	cmp x8, #0
	beq _load_next
	sub x8, x8, #1
	sub x3, x5, x1, lsl #0
	cmp x3, #0
	bmi _load_next
	ldrsb w13, [x2, x3, lsl #0]
	cmp w12, w13
.ifdef reverse
	bge _continue
.else
	ble _continue
.endif
	mov x7, x3
	mov x3, x5
	mov x5, x7
	strb w12, [x2, x5, lsl #0]
	strb w13, [x2, x3, lsl #0]
	b _change
_negative:
	cmp x8, #0       
	beq _load_next
	sub x8, x8, #1 
	sub x3, x5, x1, lsl #0
	cmp x3, #0
	bmi _load_next
	ldrsb w13, [x2, x3, lsl #0]
	cmp w12, w13
.ifdef reverse
	bge _continue
.else
	ble _continue
.endif
	mov x7, x3
	mov x3, x5
	mov x5, x7
	strb w12, [x2, x5, lsl #0]
	strb w13, [x2, x3, lsl #0]
	b _negative  
_continue:
	strb w12, [x2, x5, lsl #0]
	b _load_next
_next_col:
	add x4, x4, #1
	b _load_first
_exit:
	mov x0, #0 
	mov x8, #93 
	svc #0
	.size	_start, .-_start
