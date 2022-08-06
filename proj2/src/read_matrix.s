.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -36
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw ra, 32(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    #open the file.
    mv a1, s0
    # read only.
    li a2, 0
    jal fopen
    li t0, -1
    beq a0, t0, error_50
    # s3: file descriptor
    mv s3, a0

    #fread
    mv a1, s3
    mv a2, s1
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error_51

    #fread
    mv a1, s3
    mv a2, s2
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error_51
    # s1, s2 is the num of rows or cols now.
    lw s1, 0(s1)
    lw s2, 0(s2)

    #malloc
    mul a0, s1, s2
    li t0, 4
    mul a0, a0, t0
    jal malloc
    #pointer to matrix ->need to return. don't use.
    mv s4, a0
    #total size.
    mul s5, s1, s2
    #index.
    li s6, 0
    mv s7, s4

loop_begin:
    #fread
    mv a1, s3
    mv a2, s7
    li a3, 4
    jal fread
    li t0, 4
    bne a0, t0, error_51

    addi s6, s6, 1
    beq s6, s5, loop_end
    addi s7, s7, 4
    j loop_begin
loop_end:
    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, error_52

    mv a0, s4
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    lw ra, 32(sp)
    addi sp, sp, 36
    ret

error_48:
    li a1, 48
    j exit2

error_50:
    li a1, 50
    j exit2

error_51:
    li a1, 51
    j exit2

error_52:
    li a1, 52
    j exit2