.global _start

.section .text
_start:
# your code here
    movq (num), %rax # put the number at memory address :"num" into a register
    movq $64, %rbx # number of bits in a quad (for loop)
    movq $0, %rcx # counter to count number of bits that contain 1
    movq $0, %rdx # for comparison purposes inside loop
loop_HW1:
    sal $1, %rax # shift left by one bit (the shifted bit goes to CF)
    jc inc_counter_HW1
    jump_cond_HW1:    
        sub $1, %rbx # decrease loop counter by one
        cmp %rdx, %rbx
        jne loop_HW1 # keep going in the loop if havent gone through all iterations
        jmp finish_HW1 # finish the function
inc_counter_HW1:
    add $1, %ecx
    jmp jump_cond_HW1

finish_HW1: 
    movl %ecx, (CountBits) # move the value of 1 bits to the wanted address and finish
    