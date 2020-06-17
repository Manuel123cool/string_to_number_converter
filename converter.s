.section .data

.section .text

.global _start
_start:

movl %esp, %ebp

pushl 8(%ebp)
call get_length
addl $4, %esp

movl %eax, %esi #counter
movl $0, %ecx #plus counter
movl $0, %edi #number sum
each_byte:
 cmpl $0, %esi
 je program_exit
 movl 8(%ebp), %edx
 movl $0, %ebx
 movb (%edx, %ecx,1), %bl #from %ebx
 subl $48, %ebx

 pushl %esi
 pushl %ebx
 call calc_num
 addl $8, %esp

 addl %eax, %edi
 decl %esi
 incl %ecx
jmp each_byte

program_exit:
 movl %edi, %ebx
 movl $1, %eax
 int $0x80

.type get_length, @function 
get_length:
 #setup stack frame
 pushl %ebp
 movl %esp, %ebp

 movl 8(%ebp), %ebx #string start
 movb (%ebx), %dl # small of %edx 
 movl $0, %eax #counter

 count_loop:
  cmpb $0, %dl
  je exit_loop
  incl %ebx
  incl %eax
  movb (%ebx), %dl
  jmp count_loop

 exit_loop:
  movl %ebp, %esp
  pop %ebp
  ret

.type calc_num, @function
calc_num:
 #setup stack frame
 pushl %ebp
 movl %esp, %ebp
 subl $4, %esp
 
 movl 8(%ebp), %eax #number multi sum 
 
 movl $1, %ebx #counter
 movl $1, %edx # mult sum
 count:
  cmpl 12(%ebp), %ebx #first arg num is length
  je exit_loop2
  incl %ebx 
  imull $10, %edx 
  jmp count
 
 exit_loop2:
  imull %edx, %eax
  movl %ebp, %esp
  pop %ebp
  ret
