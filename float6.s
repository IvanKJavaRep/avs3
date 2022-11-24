	.file	"float6.c"
	.text
	.globl	printResult
	.type	printResult, @function
printResult:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, -40(%rbp) # put x from xmm0 at -40 position
	movl	%edi, -44(%rbp)  # put k from xmm0 at -44 position
	movsd	%xmm1, -56(%rbp) # put r from xmm0 at -56 position
	movsd	.LC0(%rip), %xmm0  #xmm0 = 1
	movsd	%xmm0, -24(%rbp)  # b at -24 position from xmm0
	movsd	.LC0(%rip), %xmm0
	movsd	%xmm0, -16(%rbp)  # a at -16 position from xmm0
	jmp	.L2
.L3:
	movsd	-56(%rbp), %xmm0  # xmm0 = r
	movsd	%xmm0, -8(%rbp)  # last = r
	addl	$2, -44(%rbp)  # k+=2
	pxor	%xmm0, %xmm0   # result =  0
	cvtsi2sdl	-44(%rbp), %xmm0 # convert int k to double k and put to xmm0
	movapd	%xmm0, %xmm1   # xmm1 = xmm0 (k)
	mulsd	-24(%rbp), %xmm1   # xmm1 *= b  (k*b)
	movl	-44(%rbp), %eax  # eax = k
	addl	$1, %eax   # k+=1
	pxor	%xmm0, %xmm0   # result =  0
	cvtsi2sdl	%eax, %xmm0  # convert int k in eax to double k and put to xmm0
	mulsd	%xmm1, %xmm0  # xmm0 *= xmm1 ((k+1)*k*b)
	movsd	%xmm0, -24(%rbp)  # b = b * k * (k + 1)
	movsd	-16(%rbp), %xmm0  # xmm0 = a
	mulsd	-40(%rbp), %xmm0  # xmm0*=x  (a*x)
	movsd	-40(%rbp), %xmm1  # xmm1 = x
	mulsd	%xmm1, %xmm0  # xmm0*=xmm1 (a*x*x)
	movsd	%xmm0, -16(%rbp)  # a = a*x*x
	movsd	-16(%rbp), %xmm0  # xmm0 = a
	divsd	-24(%rbp), %xmm0  # xmm0/=b
	movsd	-56(%rbp), %xmm1  # xmm1 = r
	addsd	%xmm1, %xmm0  # xmm0+=xmm1 (r+ a/b)
	movsd	%xmm0, -56(%rbp)  # r = r + a/b
.L2:
	movsd	-56(%rbp), %xmm0   # xmm0 = r
	subsd	-8(%rbp), %xmm0  # xmm0-=last (r-last) last = 0
	movsd	-56(%rbp), %xmm2  # xmm2 = r
	movsd	.LC1(%rip), %xmm1  #xmm1 = 0,0005
	mulsd	%xmm2, %xmm1  # xmm1 = xmm1*xmm2
	comisd	%xmm1, %xmm0  # compare xmm0 with  xmm1
	jnb	.L3    # jump if left is not less than right
	
	movsd	-56(%rbp), %xmm0  # xmm0 = r
	movq	%xmm0, %rax  # rax = xmm0 = r
	movq	%rax, %xmm0 
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	printResult, .-printResult
	.section	.rodata
.LC2:
	.string	"%lf"
.LC3:
	.string	"%f"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-24(%rbp), %rax   # rax = address of x
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax  #rax = address of %lf
# prepare arguements for scanf
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	
	movsd	.LC0(%rip), %xmm0 # move from .LC0(%rip) to xmm0 (value of r )
	movsd	%xmm0, -16(%rbp)  # r (-16 on stack) = xmm0
	movl	$-1, -28(%rbp)  # k = -1 (put this value at -28 on stack)
	movq	-24(%rbp), %rax # rax = x
	movsd	-16(%rbp), %xmm0  #xmm0 = r
	movl	-28(%rbp), %edx  # edx = k
	
	movapd	%xmm0, %xmm1  # xmm1 = xmm0 = r
	movl	%edx, %edi  # edi = k 
	movq	%rax, %xmm0  # xmm0 = rax = x (first param)
	call	printResult
	
	
	movq	%xmm0, %rax  # return value in xmm0 and put to rax
	movq	%rax, -16(%rbp)  # r = return value
	movq	-16(%rbp), %rax
# prepare arguements for printf
	movq	%rax, %xmm0
	leaq	.LC3(%rip), %rax  # rax = address of %f
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf@PLT
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L7
	call	__stack_chk_fail@PLT
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC0:
	.long	0
	.long	1072693248
	.align 8
.LC1:
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
