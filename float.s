	.file	"float.c"
	.text
	.section	.rodata
.LC0:
	.string	"%lf"
.LC3:
	.string	"%f"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	
	subq	$64, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	
	xorl	%eax, %eax
	leaq	-48(%rbp), %rax  # rax = address of x
	movq	%rax, %rsi  # from rax to rsi
	leaq	.LC0(%rip), %rax  # %lf address into rax
	movq	%rax, %rdi # value from rax to rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	
	movsd	.LC1(%rip), %xmm0  # move from .LC1(%rip) to xmm0 (value of r )
	movsd	%xmm0, -40(%rbp) # r (-40 on stack) = xmm0
	movl	$-1, -52(%rbp)  #  k = -1 (-52 on stack)
	movsd	.LC1(%rip), %xmm0 
	
	movsd	%xmm0, -32(%rbp)  # -32(%rbp)  = value of xmm0 (b)
	movsd	.LC1(%rip), %xmm0 # take value of a 
	movsd	%xmm0, -24(%rbp)  # value from xmm0 to -24 on stack (a)
	jmp	.L2 
.L3:
	movsd	-40(%rbp), %xmm0  # xmm0 = r
	movsd	%xmm0, -16(%rbp)  # -16(%rbp) last = r
	addl	$2, -52(%rbp)   # k += 2
	pxor	%xmm0, %xmm0  # result = 0
	cvtsi2sdl	-52(%rbp), %xmm0 # convert int k to double k and put to xmm0
	movapd	%xmm0, %xmm1  # xmm1 = xmm0 (k)
	mulsd	-32(%rbp), %xmm1  # xmm1 *= b  (k*b)
	movl	-52(%rbp), %eax # eax = k
	addl	$1, %eax  # k+=1
	pxor	%xmm0, %xmm0 # result = 0 
	cvtsi2sdl	%eax, %xmm0 # convert int k in eax to double k and put to xmm0
	mulsd	%xmm1, %xmm0  # xmm0*=xmm1  (xmm1*(k+1) in xmm1 we have result of k*b)
	movsd	%xmm0, -32(%rbp)  # -32(%rbp) is b -> b = b*k*(k+1) = value in xmm0
	movsd	-48(%rbp), %xmm0  # xmm0 = x
	movapd	%xmm0, %xmm1  # xmm1 = xmm0 = x
	mulsd	-24(%rbp), %xmm1   # xmm1*=a (x*a)
	movsd	-48(%rbp), %xmm0  # xmm0 = x
	mulsd	%xmm1, %xmm0  # xmm0*=xmm1 (x*(x*a))
	movsd	%xmm0, -24(%rbp)  # put new value of a to stack from xmm0
	movsd	-24(%rbp), %xmm0  # xmm0 = a
	divsd	-32(%rbp), %xmm0  # xmm0/=b  (xmm0 = a/b)
	movsd	-40(%rbp), %xmm1  #xmm1 = r
	addsd	%xmm1, %xmm0  # xmm0 +=xmm1 -> ( xmm0 = a/b+r)
	movsd	%xmm0, -40(%rbp)  # putnew value of r to stack
.L2:
	movsd	-40(%rbp), %xmm0 # xmm0 = r
	subsd	-16(%rbp), %xmm0  # last is at -16 on stack (xmm0 = xmm0 - last
	movsd	-40(%rbp), %xmm2  # xmm2 = r
	movsd	.LC2(%rip), %xmm1  # xmm1 = 0,0005
	mulsd	%xmm2, %xmm1  # xmm1 = xmm1*xmm2
	comisd	%xmm1, %xmm0  # compare xmm0 with  xmm1
	jnb	.L3  # jump if left is not less than right
	
	
	movq	-40(%rbp), %rax  # put value of r to rax
	movq	%rax, %xmm0  # xmm0 = rax
	leaq	.LC3(%rip), %rax  # rax = address of %f
# preparing arguements for printing result (r)
	movq	%rax, %rdi   
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1072693248
	.align 8
.LC2:
	.long	-755914244
	.long	1061184077
	.ident	"GCC: (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
