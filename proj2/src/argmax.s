.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue

    addi t0, x0, 1
    blt a1, t0, error_7
    addi t0, x0, 1 # t0: index.
    addi t1, x0, 4 # t1: size of int
    lw t2, 0(a0)   # t2: largest element.
    addi t3, x0, 0 # t3: index of largest element.
loop_start:
    bge t0, a1, loop_end
    mul t4, t0, t1
    add t6, a0, t4
    lw t5, 0(t6)
    bge t2, t5, loop_continue
    add t3, x0, t0
    add t2, x0, t5






loop_continue:
    addi t0, t0, 1
    j loop_start


loop_end:
    

    # Epilogue
    addi a0, t3, 0

    ret
error_7:
    addi a0, x0, 17
    addi a1, x0, 7
    ecall