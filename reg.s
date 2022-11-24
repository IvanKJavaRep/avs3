	.file	"String.c"
	.text
	.globl	str
	.data
	.align 32
	.type	str, @object
	.size	str, 128
str:
	.string	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
	.zero	32
	.text
	.globl	count_chars
	.type	count_chars, @function
count_chars:
	pushq	%rbp
	movq	%rsp, %rbp
	movq	%rdi, %r14  	 ##  -24(%rbp)
	movl	$0, %r8d     	 ##  -12(%rbp) to %r8d 
	movl	$0, %r10d   	 ##  -8(%rbp) %r10d
	jmp	.L2
.L7:
	movl	$0, %r11d    	 ##  -4(%rbp) to %r11d
	jmp	.L3
.L6:
	movl	%r10d, %eax
	movslq	%eax, %rdx
	movq	%r14, %rax
	addq	%rdx, %rax
	movzbl	(%rax), %edx
	movl	%r11d, %eax
	cltq
	leaq	str(%rip), %rcx
	movzbl	(%rax,%rcx), %eax
	cmpb	%al, %dl
	jne	.L4
	addl	$1, %r8d 
	jmp	.L5
.L4:
	addl	$1, %r11d
.L3:
	cmpl	$96, %r11d
	jle	.L6
.L5:
	addl	$1, %r10d
.L2:
	cmpl	$8, %r10d
	jle	.L7
	movl	%r8d , %eax
	popq	%rbp
	ret
	.size	count_chars, .-count_chars
	.section	.rodata
.LC0:
	.string	"%c"
.LC1:
	.string	"%d"
	.text
	.globl	main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %r13d    ##  -28(%rbp) %r13d
	jmp	.L10
.L11:
	leaq	-17(%rbp), %rdx   
	movl	%r13d, %eax
	cltq
	addq	%rdx, %rax
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	addl	$1, %r13d
.L10:
	cmpl	$8, %r13d
	jle	.L11
	leaq	-17(%rbp), %rax
	movq	%rax, %rdi
	call	count_chars
	movl	%eax, %r14d   ## return value of count_chars from eax to r14d
	movl	%r14d, %eax
	movl	%eax, %esi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
