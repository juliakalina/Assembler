	.arch armv8-a 
	.data 
	.align 2 
mes1: 
	.string "No file name\n"
	.equ len1, .-mes1 
mes2: 
	.string "Error opening file\n" 
	.equ len2, .-mes2 
	.equ buf, 10  
buffer: 
	.skip buf 
output_buffer: 
	.skip buf * 2 
	.text 
	.align 2 
	.global _start 
	.type _start, %function 
_start: 
	ldr x0, [sp, 0]  
	add x1, sp, 8 
	cmp x0, #1 
	bne 1f
        
        adr x1, mes1 
	mov x2, len1 
	mov x0, #1 
	mov x8, #64 
	svc #0 
	b exit 
1: 
	add x1, x1, #8  
	ldr x1, [x1] 
	mov x0, -100
	mov x2, 1  
	mov x8, #56 
	svc #0 
	cmp x0, #0 
	bge 1f
        
        adr x1, mes2 
	mov x2, len2 
	mov x0, #1 
	mov x8, #64 
	svc #0 
	b exit 
1: 
	mov x28, x0 
	mov x21, 0  
cycle:
        mov x0, 0  
	adr x1, buffer 
	mov x2, buf 
	mov x8, #63  
	svc #0 
	cbz x0, end
        adr x1, buffer 
	adr x2, output_buffer 
process: 
	ldrb w7, [x1], 1 
check: 
	cmp w7, ' ' 
	beq space 
	cmp w7, '\t' 
	beq space 
	cmp w7, '\n' 
	beq newline 
	
	mov x21, 1 
	mov w8, w7 
	cmp w8, 'A' 
	blt 1f 
	cmp w8, 'Z' 
	bgt 1f
	add w8, w8, 32  
1: 
	cmp w8, 'a' 
	beq glasn
	cmp w8, 'e' 
	beq glasn
	cmp w8, 'o' 
	beq glasn
	cmp w8, 'i' 
	beq glasn
	cmp w8, 'u' 
	beq glasn 
	cmp w8, 'y' 
	beq glasn 
	b output 
glasn: 
	strb w7, [x2], 1 
	b output
space: 
	cbz x21, skip_char  
newline: 
	mov x21, 0 
output: 
	strb w7, [x2], 1 
skip_char:
	sub x0, x0, 1 
	cmp x0, xzr 
	bgt process
        mov x0, x28 
	adr x1, output_buffer 
	sub x2, x2, x1  
	mov x8, #64 
	svc #0  
	b cycle 
end: 
	mov x0, x28  
	mov x8, #57
	svc #0 
exit: 
	mov x0, #0 
	mov x8, #93 
	svc #0
	.size   _start, (. - _start)
