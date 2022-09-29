	.arch armv8-a
	.data
mes1:
	.string	"Input the number of equations\n"
mes2:
	.string "%f"
mes3:
	.string "%d"
mes4:
	.string "Input coefficients\n"
mes5:
	.string "Input free terms\n" 
mes6:
	.string	"No solutions\n"
mes7:
	.string	"Infinitely many solutions\n"
nx5:
	.string "x5 %.4f\n"
nx6:
	.string "x1 %.4f\n"
answer:
	.string "Your answer: \n"
notanswer:
	.string "Not answ %.4f\n"
errmsg1:
	.string "It must be a number bigger then 0 and less then 20\n"
	.text
	.align 	2
	.global main
	.type   main, %function
	.equ    N, 32
	.equ	buf, 48
	.equ	buf2, 1648
	.equ	buf3, 1728
	.equ    size, 4
main:
	mov	x16, #5028
	sub	sp, sp, x16
	stp	x29, x30, [sp]
	stp	x27, x28, [sp, #16]
	mov	x29, sp
	adr	x0, mes1
	bl 	printf
	adr	x0, mes3
	add	x1, x29, N
	bl 	scanf
	ldr	x0, [x29, N]
	cmp	x0, #1
	blt	writerror
	cmp	x0, #20
	bgt	writerror
	adr	x0, mes4
	bl	printf
	ldr	x5, [x29, N]
	mul	x28, x5, x5
	mov	x27, #0
0:
	ldr	x5, [x29, N]
	cmp	x27, x28
	bge	1f
	adr	x0, mes2
	add	x1, x29, buf
	mov	x6, size
	mul	x4, x27, x6
	add	x1, x1, x4
	bl	scanf
	add	x27, x27, #1
	b 	0b
1:
	adr	x0, mes5
	bl 	printf
	mov	x27, #0
2:
	ldr	x5, [x29, N]
	cmp	x27, x5
	bge	3f
	adr	x0, mes2
	add	x1, x29, buf2
	mov	x6, size
	mul	x4, x27, x6
	add	x1, x1, x4
	add	x27, x27, #1
	bl	scanf
	b	2b
3:
	mov	x1, #0
	ldr	x28, [x29, N]
	mov	x27, #0
	mul	x28, x28, x28
	mov	x5, buf
	b	4f
4:	
	b	work
	mov	w0, #0
L6:
	ldp	x29, x30, [sp]
	ldp	x27, x28, [sp, #16]
	mov	x16, #5028
	add	sp,sp, x16
	ret
writerror:
	adr	x0, errmsg1
	bl	printf
	mov	w0, #1
	b L6
work:
	ldr	x28, [sp, N]
	ldr	s0, [sp, buf]
	mov	x6, size 
	mov	x27, #0 
	mov	x7, #0 
	mul	x5, x28, x6 
0:
	add	x9, x7, #1
	cmp	x9, x28
	beq	5f
	mul	x8, x7, x5
	mul	x17, x7, x6
	add	x8, x8, x17
	add	x8, x8, buf 
	ldr	s0, [sp, x8]//first element
	fcmp	s0, #0.0
	beq	8f
	mov	x4, #0
	b 	2f
8:
	mul	x12, x9, x5
	mul	x13, x7, x5
	mov	x2, #0
	mul	x14, x7, x6
	add	x14, x14, buf2
	ldr	s1, [x29, x14]
	add	x15, x14, x6
	ldr	s2, [x29, x15]
	str	s1, [x29, x15]
	str	s2, [x29, x14]
9:
	cmp	x2, x28
	bge	0b
	mul	x10, x2, x6
	add	x17, x13, x10
	add	x17, x17, buf
	ldr	s1, [x29, x17]
	add	x18, x12, x10
	add	x18, x18, buf
	ldr	s2, [x29, x18]
	str	s1, [x29, x18]
	str	s2, [x29, x17]
	add	x2, x2, #1
	b	9b
2:
	mov	x27, #0
	add	x4, x4, #1
	cmp	x4, x28
	bge	4f
	mul	x2, x4, x5
	add	x2, x2, x8
	ldr	s1, [sp, x2]
	fdiv	s3, s1, s0
	mul	x17, x7, x6
	add	x17, x17, buf2
	ldr	s7, [x29, x17]
	add	x18, x4, x7
	mul	x18, x18, x6
	add	x18, x18, buf2
	ldr	s6, [x29, x18]
	fmul	s7, s7, s3
	fsub	s6, s6, s7
	str	s6, [x29, x18]
3:
	sub	x10, x28, x7
	cmp	x27, x10
	beq	2b
	mul	x1, x27, x6
	add	x3, x2, x1 //addres of secont el
	add	x18, x8, x1//addr of 1 el
	ldr	s2, [x29, x18] //1 el
	fmul	s4, s2, s3 //mul el from the first line
	ldr	s5, [sp, x3]
	fsub	s5, s5, s4
	str	s5, [sp, x3]
	add	x27, x27, #1
	b	3b
4:
	add	x7, x7, #1
	beq 	0b
5:
	mov	x27, #0
	mul	x28, x28, x28
	mov	x5, buf
	mul	x5, x28, x6
	sub	x5, x5, x6
	add	x7, x5, buf
	ldr	s0, [x29, x7]
	fcmp	s0, #0.0
	beq	7f
6:
	cmp	x27, x28
	bge	L0
	adr	x0, nx5
	ldr	s0, [sp, x5]
	fcvt	d0, s0
	add	x27, x27, #1
	mov	x6, size
	mul	x5, x27, x6
	add	x5, x5, buf
	b	6b
7:
	ldr	x28, [x29, N]
	mov	x6, size
	sub	x28, x28, #1
	mul	x28, x28, x6
	add	x28, x28, buf2
	ldr	s1, [x29, x28]
	fcmp	s1, #0.0
	beq	infsol
	b 	nosol
L0:
	ldr	x28, [x29, N]
	mov	x27, x28
	mov	x6, size
	mul	x5, x28, x6
	sub	x1, x28, #1
0:
	sub	x27, x27, #1
	cmp	x27, #0
	blt	3f
	mul	x8, x5, x27
	mul	x7, x27, x6
	add	x7, x7, x8
	add	x7, x7, buf//adres of m element
	ldr	s0, [x29, x7]
	mul	x15, x27, x6
	add	x4, x15, buf2
	ldr	s1, [x29, x4]
	sub	x2, x1, x27
	mov	x3, #0
1:
	cmp	x3, x2
	beq 	2f
	add	x3, x3, #1
	mul	x13, x3, x6
	add	x17, x7, x13
	mul	x14, x27, x6
	add	x14, x14, x13
	add	x14, x14, buf3
	ldr	s3, [x29, x17]//koef
	ldr	s4, [x29, x14]//el was found
	fmul	s5, s3, s4
	fsub	s1, s1, s5
	b	1b
2:
	fdiv	s2, s1, s0
	mul	x15, x27, x6
	add	x4, x15, buf3
	str	s2, [x29, x4]
	b	0b
3:
	ldr	x28, [x29, N]
	mov	x27, #0
	adr	x0, answer
	bl 	printf
4:
	cmp	x27, x28
	bge	8f
	adr	x0, nx6
	mov	x6, size
	mul	x7, x27, x6
	add	x7, x7, buf3
	ldr	s0, [x29, x7]
	fcvt	d0, s0
	bl	printf
	add	x27, x27, #1
	b 	4b

8:
	b 	L6
infsol:
	adr	x0, mes7
	bl	printf
	b 	L6
nosol:
	adr	x0, mes6
	bl	printf
	b 	L6
	.size 	main, .-main
