.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    # Save arguments
    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3

    # Open file
    mv a1 s0
    li a2 1
    
    jal fopen
    blt a0 x0 fopen_failed
    mv s4 a0    # s4 = file descriptor

    # Write number of rows
    addi sp, sp, -4
    sw s2, 0(sp)

    mv a1, s4
    mv a2, sp   # pointer to buffer
    li a3, 1
    li a4, 4
    
    jal fwrite
    blt a0, x0, fwrite_failed

    sw s3, 0(sp)
    mv a1, s4
    mv a2, sp   # pointer to buffer
    li a3, 1
    li a4, 4

    jal fwrite
    blt a0, x0, fwrite_failed
    addi sp, sp, 4

    # Write matrix
    mul s5 s2 s3    # # of elements
    li s6 0         # write counter

loop_start:
    slli t0 s6 2
    add t0 s1 t0   # t0 = &matrix[write_counter]

    mv a1 s4
    mv a2 t0
    mv a3 s5
    li a4 4

    jal fwrite
    blt a0 x0 fwrite_failed
    add s6 s6 a0
    bne s6 s5 loop_start

    # fflush
    mv a1 s4
    jal fflush
    blt a0 x0 fflush_failed

    # Close file
    mv a1 s4
    jal fclose
    blt a0 x0 fclose_failed

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret

fopen_failed:
    li a1, 53
    j exit2

fwrite_failed:
    li a1, 54
    j exit2

fflush_failed:
    li a1, 55
    j exit2

fclose_failed:
    li a1, 55
    j exit2