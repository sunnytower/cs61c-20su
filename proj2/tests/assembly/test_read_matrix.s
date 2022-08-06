.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
row: .word 3
col: .word 3

.text
main:
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    # Read matrix into memory
    la s0, file_path
    la s1, row
    la s2, col
    mv a0, s0
    mv a1, s1
    mv a2, s2
    jal read_matrix



    # Print out elements of matrix
    lw t1, 0(s1)
    lw t2, 0(s2)
    mv a1, t1
    mv a2, t2
    jal print_int_array
    # Terminate the program
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    addi sp, sp, 16
    jal exit