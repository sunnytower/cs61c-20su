.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    li t0, 1
    blt a2, t0, error_5
    blt a3, t0, error_6
    blt a4, t0, error_6
    # Prologue
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)

    #size of int.
    li t1, 4 
    li t2, 4
    #offset of real op.
    mul t1, t1, a3
    mul t2, t2, a4
    #sum
    li s0, 0
    #index
    li t0, 0
loop_start:
    beq t0, a2, loop_end
    lw s1, 0(a0)
    lw s2, 0(a1)
    mul t3, s1, s2
    add s0, s0, t3
    addi t0, t0, 1
    add a0, a0, t1
    add a1, a1, t2
    j loop_start
loop_end:
    mv a0, s0

    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    ret


error_5:
    li a0, 17
    li a1, 5
    ecall

error_6:
    li a0, 17
    li a1, 6
    ecall