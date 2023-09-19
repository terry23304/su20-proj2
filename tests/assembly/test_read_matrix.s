.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "tests/inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    li a0 4
    jal ra malloc
    beq a0 x0 malloc_failed
    mv s0 a0

    li a0 4
    jal ra malloc
    beq a0 x0 malloc_failed
    mv s1 a0

    la a0 file_path
    mv a1 s0
    mv a2 s1

    jal read_matrix

    # Print out elements of matrix
    lw a1 0(s0)
    lw a2 0(s1)
    jal ra print_int_array

    # Terminate the program
    jal exit

malloc_failed:
    li a1, 48
    j exit2
