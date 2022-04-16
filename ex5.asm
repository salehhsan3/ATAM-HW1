.global _start

.section .text
_start:
# your code here
# rax - holds src label at first, then the value inside it after doing a check
# rbx - holds dst label at first, then the value inside it after doing a check
# rcx - holds the number of times (src) appeared
# rdx - holds the number of time (dst) appeard
# rdi - hold a pointer to current node
# rsi - hold a pointer to previous node
# r9 - holds a pointer to the node that has the previous appearance of src
# r10 - holds a pointer to the node that has the previous appearance of dst

CHECK_LABELS_HW1:
    movq $src, %rax # rax = src(label)
    movq $dst, %rbx # rax = dst(label)
    movq $head, %rdi
    cmp $0, %rax # rax == NULL 
    je FINISH_HW1
    cmp $0, %rbx # rbx == NULL 
    je FINISH_HW1
    cmp $0, %rdi
    je FINISH_HW1

SET_VALUES_HW1:
    movq (head), %rdi # rdi = head->adress_inside
    movq (src), %rax # rax = src->val
    movq (dst), %rbx # rax = dst->val
    movq $0, %r9 # r9 = NULL
    movq $0, %r10 # r10 = NULL
    movq $0, %rsi # rsi = NULL
    movq $0, %rcx # rcx = 0 this is src_counter
    movq $0, %rdx # rdx = 0 this is dst_counter
    
    cmp %rax, %rbx # rax == rbx (src == dst)
    je FINISH_HW1

    cmp $0, %rdi # rdi == NULL
    je FINISH_HW1 # empty list

SEARCH_HW1:
    cmp $0, %rdi # rdi == NULL
    je CHECK_COUNTERS_HW1 # REACHED THE END OF THE LIST / empty list
    
    cmpq (%rdi), %rax
    je INC_SRC_COUNTER_HW1

    cmpq (%rdi), %rbx
    je INC_DST_COUNTER_HW1

    movq %rdi,%rsi 
    movq 8(%rdi), %rdi
    cmpq $0, %rdi # when we get to end of list current == NULL
    je CHECK_COUNTERS_HW1 # REACHED THE END NEED TO PERFORM THE SWAPS
    jmp SEARCH_HW1
    
INC_SRC_COUNTER_HW1:    
    movq %rsi, %r9 # r9 = rsi (prev)
    add $1, %rcx
    cmpq $1, %rcx
    jg FINISH_HW1

    movq %rdi,%rsi 
    movq 8(%rdi), %rdi
    jmp SEARCH_HW1

INC_DST_COUNTER_HW1:
    movq %rsi, %r10 # r10 = rsi (prev)
    add $1, %rdx
    cmpq $1, %rdx
    jg FINISH_HW1

    movq %rdi,%rsi 
    movq 8(%rdi), %rdi
    jmp SEARCH_HW1

CHECK_COUNTERS_HW1: # I believe it's unnecessary but why not
    cmpq $1, %rcx
    jne FINISH_HW1
    cmpq $1, %rdx
    jne FINISH_HW1

SWAP_HW1:
    movq $head, %r15 # temporarily!
    cmp $0, %r9 # r9 == (head) in this special case
    je SRC_IS_HEAD_HW1

    cmp $0, %r10 # r10 == (head) in this special case
    je DST_IS_HEAD_HW1

    jmp REGULAR_SWAP_HW1 # if got here then neither node is the head

SRC_IS_HEAD_HW1:
    movq (%r15), %r11 # r11 = src
    movq 8(%r10), %r12 # r12 = dst
    movq 8(%r11), %r13 # r13 = src->next
    movq 8(%r12), %r14 # r14 = dst->next
    
    cmp (head),%r10
    je CONSECUTIVE_SRC_HW1

NON_CONSECUTIVE_SRC_HW1:

    movq %r13, 8(%r12) # dst->next = src->next
    movq %r14, 8(%r11) # src->next = dst->next
    movq %r11, 8(%r10) # (dst->prev)->next = src
    movq %r12, (%r15) # head = dst
    
    jmp FINISH_HW1
CONSECUTIVE_SRC_HW1:
    movq %r11, 8(%r12) # dst->next = src v
    movq %r14, 8(%r11) # src->next = dst->next
    movq %r12, (%r15) # head = dst
    jmp FINISH_HW1

DST_IS_HEAD_HW1:
    movq 8(%r9), %r11 # r11 = src
    movq (%r15), %r12 # r12 = dst
    movq 8(%r11), %r13 # r13 = src->next
    movq 8(%r12), %r14 # r14 = dst->next
    
    cmp (head),%r9
    je CONSECUTIVE_DST_HW1

NON_CONSECUTIVE_DST_HW1:
    movq %r13, 8(%r12) # dst->next = src->next
    movq %r14, 8(%r11) # src->next = dst->next
    movq %r12, 8(%r9) # (src->prev)->next = dst
    movq %r11, (%r15) # head = src
    jmp FINISH_HW1

CONSECUTIVE_DST_HW1:
    movq %r12, 8(%r11) # src->next = dst v
    movq %r13, 8(%r12) # dst->next = src->next
    movq %r11, (%r15) # head = src
    jmp FINISH_HW1
    
REGULAR_SWAP_HW1:
    movq 8(%r9), %r11 # r11 = src
    movq 8(%r10), %r12 # r12 = dst
    movq 8(%r11), %r13 # r13 = src->next
    movq 8(%r12), %r14 # r14 = dst->next

    cmp %r13, %r12
    je SRC_THEN_DST_HW1
    cmp %r14, %r11
    je DST_THEN_SRC_HW1
    jmp NON_CONSECUTIVE_NODES_HW1
CONSECUTIVE_NODES_HW1:

SRC_THEN_DST_HW1:
    movq %r11, 8(%r12) # dst->next = src v
    movq %r14, 8(%r11) # src->next = dst->next
    movq %r12, 8(%r9) # (src->prev)->next = dst v
    jmp FINISH_HW1

DST_THEN_SRC_HW1:
    movq %r12, 8(%r11) # src->next = dst v
    movq %r13, 8(%r12) # dst->next = src->next
    movq %r11, 8(%r10) # (dst->prev)->next = src vv
    jmp FINISH_HW1

NON_CONSECUTIVE_NODES_HW1:
    movq %r13, 8(%r12) # dst->next = src->next
    movq %r14, 8(%r11) # src->next = dst->next
    movq %r12, 8(%r9) # (src->prev)->next = dst
    movq %r11, 8(%r10) # (dst->prev)->next = src
    
FINISH_HW1:

