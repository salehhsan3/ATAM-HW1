.global _start

.section .text
_start:
# your code here
movq $array1, %rsi
movq $array2, %rdi
movq $mergedArray, %rax

pick_one_HW1:
movl (%rsi), %ebx
movl (%rdi), %ecx
# when we get to one of the arrays ends we need to copy from the one left
cmpl $0, %ebx
je copy_from_array_left_prep_HW1
cmpl $0, %ecx
je copy_from_array_left_HW1
cmpl %ebx, %ecx
jb check_array1_dup_HW1
ja check_array2_dup_HW1
addq $4, %rsi
jmp pick_one_HW1

check_array1_dup_HW1:
cmpl %ebx, 4(%rsi)
jne copy_from_array1_HW1
addq $4, %rsi
jmp check_array1_dup_HW1

copy_from_array1_HW1:
movl %ebx, (%rax)
addq $4, %rsi
addq $4, %rax
jmp pick_one_HW1

check_array2_dup_HW1:
cmpl %ecx, 4(%rdi)
jne copy_from_array2_HW1
addq $4, %rdi
jmp check_array2_dup_HW1

copy_from_array2_HW1:
movl %ecx, (%rax)
addq $4, %rdi
addq $4, %rax
jmp pick_one_HW1

copy_from_array_left_prep_HW1:
movq %rdi, %rsi
copy_from_array_left_HW1:
movl (%rsi), %ebx
addq $4, %rsi
# got to the end
cmpl $0, %ebx
je exit_merge_copy_HW1
# used to remove duplicates
cmpq $mergedArray, %rax
je prevent_first_time_HW1
cmpl %ebx, -4(%rax)
je copy_from_array_left_HW1
prevent_first_time_HW1:
movl %ebx, (%rax)
addq $4, %rax
jmp copy_from_array_left_HW1
exit_merge_copy_HW1:
movl $0, (%rax)
