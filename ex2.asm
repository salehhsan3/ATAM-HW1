.global _start

.section .text
_start:
# your code here
xorq %rax, %rax
movl (num), %eax
cmpl $0, %eax
je exit_copy_HW1
jg positive_num_HW1
# number is negative:
movq $destination, %rsi
movq $source, %rdi
negl %eax
jmp overlapping_check_HW1
positive_num_HW1:
movq $source, %rsi
movq $destination, %rdi

# in case where some of the bytes of the buffers are being shared
# we have to change the bytes copying method (from the beginning of the buffer or from the end)
overlapping_check_HW1:
cmpq %rsi, %rdi
jge copy_from_end_prep_HW1

copy_from_start_HW1:
decl %eax
movb (%rsi), %dl
movb %dl, (%rdi)
incq %rsi
incq %rdi
cmpl $0, %eax
jne copy_from_start_HW1
jmp exit_copy_HW1

copy_from_end_prep_HW1:
addq %rax, %rdi
addq %rax, %rsi
decq %rdi
decq %rsi
copy_from_end_HW1:
decl %eax
movb (%rsi), %dl
movb %dl, (%rdi)
decq %rsi
decq %rdi
cmpl $0, %eax
jne copy_from_end_HW1
exit_copy_HW1:
