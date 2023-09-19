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
    addi sp sp -32
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2

    # Open the file
    mv a1 s0
    li a2 0

    jal ra fopen
    blt a0 x0 fopen_failed
    mv s3 a0    # s3 is the file discriptor

    # Read nums of rows to s1
    mv a1 s3
    mv a2 s1
    li a3 4

    jal ra fread
    blt a0, x0, fread_failed

    # Read nums of cols to s2
    mv a1 s3
    mv a2 s2
    li a3 4

    jal ra fread
    blt a0, x0, fread_failed

    # malloc matrix
    lw t0 0(s1)
    lw t1 0(s2)

    mul t0 t0 t1
    slli t0 t0 2

    mv a0 t0
    jal ra malloc
    beq a0 x0 malloc_failed
    mv s4 a0    # s4 is the matrix pointer

    # Read matrix to s4
    lw t0 0(s1)
    lw t1 0(s2)
    mul t0 t0 t1
    slli s5 t0 2    # s5 is the number of bytes to read
    li s6 0 # track the number of bytes read

loop_start:
    mv a1 s3
    mv a2 s4
    mv a3 s5
    add a2 a2 s6
    jal ra fread

    add s6 s6 a0
    blt s6 s5 loop_start

loop_end:
    # Close the file
    mv a1 s3

    jal ra fclose
    blt a0 x0 fclose_failed

    mv a0 s4

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    addi sp sp 32

    ret

malloc_failed:
    li a1, 48
    j exit2

fopen_failed:
    li a1, 50
    j exit2

fread_failed:
    li a1, 51
    j exit2

fclose_failed:
    li a1, 52
    j exit2