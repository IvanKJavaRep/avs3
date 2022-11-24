	.file	"float6.c"
	.text
	.globl	printResult
	.type	printResult, @function
printResult:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, %xmm3  # put x from xmm0 at -40 position
	movl	%edi, %r13d  # put k from xmm0 at -44 position
	movsd	%xmm1, %xmm5  # put r from xmm0 at -56 position
	movsd	.LC0(%rip), %xmm0  #xmm0 = 1
	movsd	%xmm0, %xmm6  # b to -24 position from xmm0
	movsd	.LC0(%rip), %xmm0
	movsd	%xmm0, %xmm4  # a at -16 position from xmm0
	jmp	.L2
.L3:
	movsd	%xmm5, %xmm0  # xmm0 = r
	movsd	%xmm0, %xmm7  # last = r
	addl	$2, %r13d # k+=2
	pxor	%xmm0, %xmm0 # result =  0
	cvtsi2sdl	%r13d, %xmm0  # convert int k to double k and put to xmm0
	movapd	%xmm0, %xmm1  # xmm1 = xmm0 (k)
	mulsd	%xmm6, %xmm1  # xmm1 *= b  (k*b)
	movl	%r13d, %eax  # eax = k
	addl	$1, %eax   # k+=1
	pxor	%xmm0, %xmm0  # result =  0
	cvtsi2sdl	%eax, %xmm0  # convert int k in eax to double k and put to xmm0
	mulsd	%xmm1, %xmm0  # xmm0 *= xmm1 ((k+1)*k*b)
	movsd	%xmm0, %xmm6  # b = b * k * (k + 1)
	movsd	%xmm4, %xmm0  # xmm0 = a
	mulsd	%xmm3, %xmm0  # xmm0*=x  (a*x)
	movsd	%xmm3, %xmm1  # xmm1 = x
	mulsd	%xmm1, %xmm0  # xmm0*=xmm1 (a*x*x)
	movsd	%xmm0, %xmm4  # a = a*x*x
	movsd	%xmm4, %xmm0  # xmm0 = a
	divsd	%xmm6, %xmm0  # xmm0/=b
	movsd	%xmm5, %xmm1  # xmm1 = r
	addsd	%xmm1, %xmm0  # xmm0+=xmm1 (r+ a/b)
	movsd	%xmm0, %xmm5  # r = r + a/b
.L2:
	movsd	%xmm5, %xmm0   # xmm0 = r
	subsd	%xmm7, %xmm0  # xmm0-=last (r-last) last = 0
	movsd	%xmm5, %xmm2  # xmm2 = r
	movsd	.LC1(%rip), %xmm1  #xmm1 = 0,0005
	mulsd	%xmm2, %xmm1  # xmm1 = xmm1*xmm2
	comisd	%xmm1, %xmm0  # compare xmm0 with  xmm1
	jnb	.L3    # jump if left is not less than right
	
	movsd	%xmm5, %xmm0  # xmm0 = r
	movq	%xmm0, %rax  # rax = xmm0 = r
	movq	%rax, %xmm0 
	popq	%rbp
	ret
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
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-24(%rbp), %rax   # rax = address of x no need to change to register
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rax  #rax = address of %lf
# prepare arguements for scanf
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	
	movsd	.LC0(%rip), %xmm0 # move from .LC0(%rip) to xmm0 (value of r )
	movsd	%xmm0, %xmm10  # r (-16 on stack) = xmm0
	movl	$-1, %r10d  # k = -1 (put this value at -28 on stack)
	movq	-24(%rbp), %rax # rax = x
	movsd	%xmm10, %xmm0  #xmm0 = r
	movl	%r10d, %edx  # edx = k
	
	movapd	%xmm0, %xmm1  # xmm1 = xmm0 = r
	movl	%edx, %edi  # edi = k 
	movq	%rax, %xmm0  # xmm0 = rax = x (first param)
	call	printResult
	
	
	movq	%xmm0, %rax  # return value in xmm0 and put to rax
	movq	%rax, %r13  # r = return value
	movq	%r13, %rax
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
	ret
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
