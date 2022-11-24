// объявлениие глобальных переменных
	.file	"Array.c"
	.text
	.globl	str
	.data
	.align 32
	.type	str, @object
	.size	str, 128
// переменная str
str:
// содержимое строки
	.string	" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~"
	.zero	32

	.text
	.globl	count_chars
	.type	count_chars, @function
// объявлениие функции count_chars
count_chars:
.LFB0:
// подготовка при вызове функции + сдвиг стека
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6

	movq	%rdi, -24(%rbp) // параметр char a[]
	movl	$0, -12(%rbp)  // n = 0 локальная переменная
	movl	$0, -8(%rbp) // i = 0
	jmp	.L2
.L7:
	movl	$0, -4(%rbp) // положим 0 на позицию -4 на стеке
	jmp	.L3
.L6:
	movl	-8(%rbp), %eax // eax = i
	movslq	%eax, %rdx // rdx = eax (move and sign extend command)
	movq	-24(%rbp), %rax // rax = указатель на место перед первым элементом массива
	addq	%rdx, %rax // rax = a[i]
	movzbl	(%rax), %edx // edx = (%rax) (first 8 bits) (a[i])
	movl	-4(%rbp), %eax // eax = c
	cltq
	leaq	str(%rip), %rcx // rcx = address of str
	movzbl	(%rax,%rcx), %eax // eax = str[c]
	cmpb	%al, %dl // if a[i]==str[c] (al - 8 bits of eax, dl - 8 bits of 
	jne	.L4 // if not equals goto L4
	addl	$1, -12(%rbp) // n+=1
	jmp	.L5
.L4:
	addl	$1, -4(%rbp) // c++
.L3:
	cmpl	$95, -4(%rbp) // -4(%rbp)-95>0
	jle	.L6 // if -4(%rbp)-95<=0 goto L6
.L5:
	addl	$1, -8(%rbp) // i++
.L2:
	cmpl	$8, -8(%rbp) // i-8>0
	jle	.L7 // if i-8<=0 goto L7
	movl	-12(%rbp), %eax // eax = n (функция мэйн будет брать возвращаемое значение из этого регистра)
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
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
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6

	subq	$32, %rsp    / канарейка перед инициализацией массива
	movq	%fs:40, %rax \

	movq	%rax, -8(%rbp) // кладем канарейку на стек. А наш массив будет занимать место от -17 байта до канарейки.
	xorl	%eax, %eax    // обнуляем eax
	movl	$0, -28(%rbp) // с = 0 на стеке
	jmp	.L10
.L11:
	leaq	-17(%rbp), %rdx // rdx = позиция перед первым элементом массива (все они будут на стеке) 8+9 =17 байт на стеке, идем вверх, прибавляя 1.
	movl	-28(%rbp), %eax // eax = c
	cltq
// готовим параметры для чтения с помощью scanf
	addq	%rdx, %rax // rax += c (постепенно сдвигаемся в сторону канарейки)
	movq	%rax, %rsi
	leaq	.LC0(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	addl	$1, -28(%rbp) // с++
.L10:
	cmpl	$8, -28(%rbp)  // c-8>0
	jle	.L11   // if c-8<=0 goto L11
	leaq	-17(%rbp), %rax  // rax = позиция перед первым элементом массива
	movq	%rax, %rdi  // rdi = rax (это регистр для 1го параметра при передаче в функцию)

	call	count_chars
	movl	%eax, -24(%rbp)  // положим на позицию -24 на стеке значение eax (воовзрат функции count_chars)
	movl	-24(%rbp), %eax
	movl	%eax, %esi  // esi = eax
	leaq	.LC1(%rip), %rax  // rax = address of "%d"
	movq	%rax, %rdi // rdi = rax
	movl	$0, %eax 
	call	printf@PLT
	movl	$0, %eax  // eax = 0 (for return 0)
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L13
	call	__stack_chk_fail@PLT
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
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
