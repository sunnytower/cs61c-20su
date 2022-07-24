.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    # YOUR CODE HERE
    addi s0, x0, 1 #s0:Result.
    addi t0, x0, 1 #t0:acc.
loop:
    blt a0, t0, exit
    mul s0, s0, t0
    addi t0, t0, 1
    jal x0, loop
exit:
    add a0, s0, x0
    jr ra