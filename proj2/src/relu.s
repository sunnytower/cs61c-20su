.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue

    addi t0, x0, 1
    blt a1, t0, error_8
    addi t0, x0, 0 # t0: index of the array.
    addi t1, x0, 4 # t1: the size of int.
loop_start:
    bge t0, a1, loop_end
    mul t2, t1, t0
    add t3, t2, a0
    lw t4, 0(t3)
    blt t4, x0, less_than_zero
loop_continue:
    addi t0, t0, 1
    j loop_start

less_than_zero:
    sw x0, 0(t3)
    j loop_continue
loop_end:


    # Epilogue

	ret
error_8:
    addi a0, x0, 17
    addi a1, x0, 8
    ecall