.global _start

.section .text
_start:
# your code here
# rax - holds NULL for comparisons
# rbx - holds current->val
# rcx - holds a pointer to current node 
# rdx - hold the address of the new_node
# rdi - holds the numerical value that we want to insert(new_node->val)

    movq $new_node, %rdx # rdx = new_node
    movq (%rdx), %rdi # rdi = new_node->val 
    movq (root), %rcx # rcx = root
    # cmp $0, %rcx # checking if first node is a NULL pointer
    # je null_case_HW1 # if NULL then deal with it accordingly
    # movq (%rcx), %rbx # rbx = current->val // after checking that current != null

SEARCH_HW1:
    cmp $0, %rcx # rcx == NULL
    je NULL_HW1 # if NULL then deal with it accordingly

    movq (%rcx), %rbx # rbx = current->val 
    cmp %rbx, %rdi # current->val == newnode->val
    #cmp %rdi, %rbx # current->val == newnode->val
    
    je FINISH_HW1 # this value was found in the tree
    
    jl LSON_HW1 # keep looking in left tree
    
    jg RSON_HW1 # keep looking in right tree
    
NULL_HW1:
    movq %rdx, (root)
    jmp FINISH_HW1

LSON_HW1:
    movq 8(%rcx), %rax # rax = current->leftson
    cmp $0, %rax # rsi == NULL
    je ADDL_HW1 # if null then add new_node

    movq %rax, %rcx
    jmp SEARCH_HW1 # if got here then keep going in a loop untill the algorithm terminates

RSON_HW1:
    movq 16(%rcx), %rax  # rax = current->rightson
    cmp $0, %rax # rax == NULL
    je ADDR_HW1 # if null then add new_node

    movq %rax, %rcx
    jmp SEARCH_HW1 # if got here then keep going in a loop untill the algorithm terminates

ADDL_HW1:
    movq %rdx, 8(%rcx)
    jmp FINISH_HW1

ADDR_HW1:
    movq %rdx, 16(%rcx)
    jmp FINISH_HW1

FINISH_HW1:
